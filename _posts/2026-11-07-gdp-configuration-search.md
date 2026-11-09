---
layout: post
title: "Finding Better Process Designs Without Evaluating Them All"
description: "Using derivative-free optimization to compare equipment choices in process models and simulators"
author: "Albert Joon Lee, Woosik Kim, and David E. Bernal Neira"
image: assets/images/gdp-configuration-search/cover-en.webp
social_image: /assets/images/gdp-configuration-search/cover-en.png
social_image_alt: "SECQUOIA cover: three candidate process flowsheets, with the middle design highlighted in gold for evaluation."
methodology_image_alt: "Propose a configuration. Evaluate the selected design. Choose the next configuration."
social_image_width: 1200
social_image_height: 630
date: 2026-11-07 08:00:00 -0500
permalink: /gdp-configuration-search/
lang: en
translation_key: gdp-configuration-search
---

<link rel="stylesheet" href="{{ '/assets/css/ai-agents-research.css' | relative_url }}">
<script defer src="{{ '/assets/js/reference-previews.js' | relative_url }}"></script>

*Using derivative-free optimization to compare equipment choices in process models and simulators*

**Albert Joon Lee, Woosik Kim, and David E. Bernal Neira** · Purdue University · November 2026

<p class="article-cover">
  <a href="{{ '/assets/images/gdp-configuration-search/cover-en.png' | relative_url }}" aria-label="Open the cover at full size" title="Open the cover at full size">
    <img src="{{ '/assets/images/gdp-configuration-search/cover-en.webp' | relative_url }}" alt="{{ page.social_image_alt | escape }}" width="1200" height="630" decoding="async">
  </a>
</p>

[The approach](#model-and-search) · [The experiments](#what-we-tested) · [Practical lessons](#choosing-a-method) · [References](#references)

Before engineers can optimize a process, they must decide what process to build.
Which reactors should it contain?
How many separation stages?
Where should the feeds enter?
These choices determine which equations describe the plant, which operating conditions are possible, and how well the process can perform.

Evaluating a single design can require solving an optimization problem of its own.
To compare two reactor arrangements, for example, we may need to optimize the temperatures, flow rates, and equipment sizes of each.
When a simulator models the process, finding the best operating conditions for just one design can require many simulation runs.
As discrete choices about equipment types and counts, stage numbers, and feed or recycle locations combine, the alternatives quickly multiply into hundreds or thousands of possible configurations, making it too expensive to evaluate them all.

Our new preprint, [*Generalized Disjunctive Programming with Derivative-Free Configuration Search*](https://arxiv.org/abs/2611.05508) [[1]](#ref-lee2026gdp), studies how to find good designs with fewer evaluations.
On several test problems, the search methods we evaluated reached the best recorded designs after exploring only a small part of the configuration space.
The same approach also worked with a pharmaceutical process simulator and with a catalytic distillation model where conventional optimization formulations failed to find competitive designs.

<h2 class="unnumbered" id="model-and-search">The model and the search</h2>

We describe the design choices using generalized disjunctive programming, or GDP.
GDP describes alternatives and their logical relationships: selecting a piece of equipment activates its equations; excluding it removes those equations from the selected design.
Rules can express which choices require one another and which combinations are forbidden.
An engineer can use these rules to specify which equipment arrangements are allowed.

Conventional methods solve these models by combining the alternatives into a mixed-integer nonlinear programming (MINLP) problem or by decomposing the model into smaller problems.
They require access to the equations describing every alternative, however, and a simulator may not expose those equations.
Even when all the equations are available, the combined formulation can be numerically difficult.

We use a representation developed in our earlier work [[2]](#ref-linan2020optimal), [[3]](#ref-ovalle2025logic) in which external integer variables identify the design choices.
A configuration becomes a point in an integer coordinate system.
Once that point is selected, we fix the equipment choices and optimize the remaining operating variables.

The search proceeds in three steps:

<figure id="research-setup" class="research-setup">
  <a class="research-diagram" href="{{ '/assets/images/gdp-configuration-search/methodology-en.png' | relative_url }}" aria-label="Open the diagram at full size" title="Open the diagram at full size">
    <img src="{{ '/assets/images/gdp-configuration-search/methodology-en.webp' | relative_url }}" alt="{{ page.methodology_image_alt | escape }}" width="1200" height="630" loading="lazy" decoding="async">
  </a>
  <ol class="research-steps">
    <li>
      <span class="step-number" aria-hidden="true">01</span>
      <h3>Propose a configuration.</h3>
      <p>Select equipment choices for the model to evaluate.</p>
    </li>
    <li>
      <span class="step-number" aria-hidden="true">02</span>
      <h3>Evaluate the selected design.</h3>
      <p>Optimize or simulate that configuration and return its performance.</p>
    </li>
    <li>
      <span class="step-number" aria-hidden="true">03</span>
      <h3>Choose the next configuration.</h3>
      <p>Use the results so far to choose which design to evaluate next.</p>
    </li>
  </ol>
  <figcaption><strong>Figure 1.</strong> GDP describes the alternatives and their logic.
  The search uses evaluation results to choose which design to try next.</figcaption>
</figure>

This connection is the central contribution of our work [[1]](#ref-lee2026gdp): by separating the logical model from the search strategy through external integer variables, we pair GDP with derivative-free optimization (DFO) methods.
The GDP model continues to describe the alternatives, their logic, and how each design is evaluated, while the outer search needs only the results of those evaluations.
Any derivative-free optimization method capable of handling integer variables can therefore explore these configurations.

Some methods explore nearby designs and move toward improvements.
Others build surrogate models: computationally inexpensive approximations of the relationship between design choices and performance.
The algorithm can use these approximations to choose between testing designs near a good result and exploring designs elsewhere.
“Derivative-free” refers here to the outer configuration search; optimizing the operating conditions within each configuration can still use derivatives.

<h2 class="unnumbered" id="what-we-tested">What we tested</h2>

We compared the discrete local-descent algorithm ([D-SDA](https://github.com/SECQUOIA/dsda-gdp)) developed in our earlier work [[2]](#ref-linan2020optimal), [[3]](#ref-ovalle2025logic), direct search ([NOMAD](https://github.com/bbopt/nomad)), several surrogate methods ([RBFOpt](https://github.com/coin-or/rbfopt), [MISO](https://pypi.org/project/soogo/), [BAM](https://pypi.org/project/bam-solver/), and [FMQA-SA](https://github.com/SECQUOIA/bbo_via_fmqa)), and uniform sampling, alongside conventional GDP methods ([GDPopt](https://pyomo.readthedocs.io/en/6.10.0/explanation/solvers/gdpopt.html) and MINLP reformulations) and full enumeration.
The experiments included nine process models, 21 mathematical test functions, a pharmaceutical manufacturing simulation, and a catalytic distillation column.
The three cases below show how the methods compare when evaluations are expensive, a simulator supplies the model, or conventional solvers have difficulty.

<h2 class="unnumbered" id="reactor-network">Fewer solves for a reactor network</h2>

The first is a series of continuous stirred-tank reactors (CSTRs) that we had studied in earlier work [[2]](#ref-linan2020optimal), [[3]](#ref-ovalle2025logic).
Its design decisions include how many reactors to use and where streams enter or recycle.
This superstructure serves as a useful test problem because reactor design theory tells us beforehand what the solution should be: to minimize total volume, the cascade should approximate a plug-flow reactor (PFR) by using all available reactors in series without recycle.
The largest network in our study has 465 admissible configurations.
Evaluating them all requires solving 465 continuous optimization subproblems.

The surrogate methods [MISO](https://pypi.org/project/soogo/) and [RBFOpt](https://github.com/coin-or/rbfopt) reached the reference objective in ten and nine of ten runs, respectively, with median workloads of about 30 subproblem solves.
That is roughly 6–7% of the work required for enumeration.

The records of which designs each method evaluated help explain the difference.
On the larger networks, local descent ([D-SDA](https://github.com/SECQUOIA/dsda-gdp)) repeatedly settled at the same inferior configuration.
Nearby changes offered no improvement, even though a better design existed elsewhere.
On the largest network, this local minimum was about 13% worse than the reference.
Giving a descent more evaluation budget did little once it had stopped there.

[RBFOpt](https://github.com/coin-or/rbfopt) and [MISO](https://pypi.org/project/soogo/) could propose configurations far from their current best design.
They could therefore test designs that local descent would not reach through a sequence of improving moves.

<figure id="reactor-results" class="paper-results">
  <a href="{{ '/assets/images/gdp-configuration-search/cstr30-results-en.png' | relative_url }}" aria-label="Open the reactor-network results at full size" title="Open the reactor-network results at full size">
    <img src="{{ '/assets/images/gdp-configuration-search/cstr30-results-en.webp' | relative_url }}" alt="Log-scale comparison of total NLP solves for CSTR30. RBFOpt reaches the reference in 9 of 10 runs and MISO in all 10, with median workloads near 30 solves, compared with 465 for enumeration." width="1600" height="1216" loading="lazy" decoding="async">
  </a>
  <figcaption><strong>Figure 2.</strong> Largest reactor network (CSTR30), adapted from the paper.
  Each marker shows the total nonlinear programming (NLP) subproblems solved in a completed run.
  RBFOpt and MISO reach the reference in nine and ten of ten runs, with median workloads of 31.5 and 29.5 solves; evaluating every admissible configuration requires 465.
  The upper seven rows have ten runs each; the bottom three GDPopt rows have one run each.
  Gray bars show the middle 50%, with a black median tick.
  The candidate budget is 43; rejected configurations need no NLP solve.
  <a href="{{ '/assets/images/gdp-configuration-search/cstr30-results-en.png' | relative_url }}">Full-size chart</a> · <a href="{{ '/assets/pdf/gdp-configuration-search/process-nlp-solves.pdf' | relative_url }}">Full original figure (PDF)</a>.</figcaption>
</figure>

<h2 class="unnumbered" id="process-simulator">Working with a process simulator</h2>

The second example is a manufacturing process for the anticancer drug lomustine.
In our previous work on this process [[4]](#ref-park2026ising), we even applied Ising-based solvers and quantum annealing to help solve the discrete design problem.
Here, different combinations of reactors and crystallizers define 36 possible flowsheets.
Their behavior is evaluated using the [PharmaPy](https://pharmapy.readthedocs.io/en/latest/) process simulator.

For this problem, the simulator provides the results of operating a design, while the explicit equations required by conventional algebraic GDP solvers are unavailable.
Configuration search can still proceed: choose the equipment, optimize its operation through simulation, and return the resulting performance.

With a budget of 20 configuration evaluations, [RBFOpt](https://github.com/coin-or/rbfopt) and [MISO](https://pypi.org/project/soogo/) found the best recorded configuration in all ten runs.
Each configuration’s operating optimization took minutes, making the cost of choosing the next design small relative to the cost of evaluating it.

Engineers can use an existing process simulator to compare equipment alternatives without translating its equations into an algebraic GDP formulation.

<h2 class="unnumbered" id="catalytic-column">A column with more than 100,000 configurations</h2>

The third example combines chemical reaction and separation in a catalytic distillation column for producing ethyl *tert*-butyl ether (ETBE).
We have worked on this system since David E. Bernal Neira’s MSc thesis at Universidad de los Andes [[5]](#ref-bernal2016etbe) and the PhD thesis of his advisor there, Jorge Mario Gómez, as well as in later studies on design, control, and superstructure optimization [[6]](#ref-bernal2018simultaneous), [[7]](#ref-linan2020optimalII).
Its design includes decisions about feed locations, catalytic stages, and column structure.
The full GDP model contains 100,947 configurations.
We searched a restricted domain containing 54,159 admissible configurations, large enough that evaluating every design would remain expensive.

With a budget of 100 evaluations, [D-SDA](https://github.com/SECQUOIA/dsda-gdp) and [MISO](https://pypi.org/project/soogo/) each reached the best known design in three of ten runs.
Reaching that reference was uncommon, but many runs finished close.
The median results of [D-SDA](https://github.com/SECQUOIA/dsda-gdp), [NOMAD](https://github.com/bbopt/nomad), and [MISO](https://pypi.org/project/soogo/) were within 0.14% of the best known objective after evaluating about 0.2% of the search domain.

Local descent was competitive in this case because changes to nearby configurations often led to good designs.
In the reactor networks, by contrast, local descent repeatedly stopped at an inferior design with no improving neighbor.

The conventional mixed-integer nonlinear formulations encountered more serious difficulties.
From the published starting point, none of the tested solvers found a design within 15% of the reference under the reported conditions.
Additional checks produced infeasibility claims contradicted by feasible designs and global optimality certificates contradicted by better solutions.

One plausible explanation is the numerical burden of retaining equations for every possible stage and catalyst position in a combined formulation.
Equations associated with absent equipment can still create difficulties in the solver’s relaxations.
Evaluating a fixed configuration allows us to solve only the equations belonging to that design.
In these experiments, individual designs could be evaluated successfully even when the combined formulations proved unreliable.

<h2 class="unnumbered" id="choosing-a-method">Choosing a search method</h2>

The cost of an evaluation affects which search method is worth using.
Building and updating a surrogate takes time.
If a configuration can be evaluated almost instantly, that overhead may outweigh the evaluations saved.
For small algebraic models in our study, enumeration or a conventional reformulation was often the simpler and faster option.
If each evaluation takes minutes, the extra time spent choosing the next design can be small compared with the time saved by avoiding evaluations.

The way equipment choices are numbered also affects the search.
Integer coordinates define which configurations appear close to one another.
For naturally ordered decisions, such as the number of stages, neighboring coordinates represent physically similar designs; exploiting that ordered structure was the central idea of the external-variable reformulation introduced by Ovalle et al. [[3]](#ref-ovalle2025logic).
For categories such as reactor types, the assigned order can be arbitrary.
Reordering those alternatives changed the behavior of several methods in the lomustine experiments.
The ordering of categorical choices should therefore be checked when comparing search methods.

The number of runs that reach a reference objective is only one measure of performance.
A method can miss a strict target while consistently producing designs close enough for an engineering study.
Comparing methods should include the quality and variability of their final designs, their evaluation counts, and their total computational cost.

<h2 class="unnumbered" id="limits">Limits of the comparison</h2>

Most benchmarks used stored configuration responses to compare search strategies; the catalytic column evaluated newly requested configurations during the search.
The continuous optimization of a configuration can return a local solution.
Our comparisons used a limited number of repeated runs, and the catalytic reference is the best design found, without a reliable proof of global optimality.

<h2 class="unnumbered" id="next-steps">What to try next</h2>

These experiments give us reasons to choose different methods for different process models.
When the number of configurations is small and evaluations are cheap, start with enumeration or a conventional reformulation.
When nearby changes lead to good designs, local descent can work well.
When each evaluation is expensive and local descent repeatedly stops at inferior designs, consider a surrogate method that can test configurations farther away.

A simulator can supply the evaluations without exposing all its equations.
If a combined formulation is difficult to solve, evaluating selected configurations separately may still produce useful designs.
In either case, compare the quality of the designs found and the total time spent finding them.

<h2 class="unnumbered" id="aiche-presentations">Related AIChE presentations</h2>

AIChE lists the earlier GDP/DFO presentation and two related talks by Albert Lee in its annual meeting programs:

- [Integration of Derivative Free Optimization with Logic-Based Solutions of Generalized Disjunctive Programming](https://proceedings.aiche.org/conferences/aiche-annual-meeting/2025/proceeding/paper/integration-derivative-free) — 2025 Annual Meeting, presentation 531b.
- [Discrete Nonlinear Algorithms for Process Design and Operations](https://studio.m-anage.com/aiche/2026/meetingapp.cgi/Paper/738217) — 2026 Annual Meeting, presentation 484a.
- [Generalized Disjunctive Programming Via Factorization Machines and Quantum Annealers](https://studio.m-anage.com/aiche/2026/meetingapp.cgi/Paper/738252) — 2026 Annual Meeting, presentation 608g.

<h2 class="unnumbered" id="references">References</h2>

<div id="refs" class="references csl-bib-body" data-entry-spacing="0" role="list" lang="en">
<div id="ref-lee2026gdp" class="csl-entry" role="listitem">
<div class="csl-left-margin">[1] </div><div class="csl-right-inline">A. J. Lee, W. Kim, and D. E. Bernal Neira, <span>“Generalized Disjunctive Programming with Derivative-Free Configuration Search,”</span> arXiv preprint <a href="https://arxiv.org/abs/2611.05508">arXiv:2611.05508</a>, 2026.</div>
</div>
<div id="ref-linan2020optimal" class="csl-entry" role="listitem">
<div class="csl-left-margin">[2] </div><div class="csl-right-inline">D. A. Liñán, D. E. Bernal, L. A. Ricardez-Sandoval, and J. M. Gómez, <span>“Optimal design of superstructures for placing units and streams with multiple and ordered available locations. Part I: A new mathematical framework,”</span> <em>Computers &amp; Chemical Engineering</em>, vol. 137, p. 106794, 2020, doi: <a href="https://doi.org/10.1016/j.compchemeng.2020.106794">10.1016/j.compchemeng.2020.106794</a>.</div>
</div>
<div id="ref-ovalle2025logic" class="csl-entry" role="listitem">
<div class="csl-left-margin">[3] </div><div class="csl-right-inline">D. Ovalle, D. A. Liñán, A. Lee, J. M. Gómez, L. Ricardez-Sandoval, I. E. Grossmann, and D. E. Bernal Neira, <span>“Logic-Based Discrete-Steepest Descent: A solution method for process synthesis Generalized Disjunctive Programs,”</span> <em>Computers &amp; Chemical Engineering</em>, vol. 195, p. 108993, 2025, doi: <a href="https://doi.org/10.1016/j.compchemeng.2024.108993">10.1016/j.compchemeng.2024.108993</a>.</div>
</div>
<div id="ref-park2026ising" class="csl-entry" role="listitem">
<div class="csl-left-margin">[4] </div><div class="csl-right-inline">Y. Park and D. E. Bernal Neira, <span>“A computational study of Ising-based solvers for discrete landscape exploration in process optimization,”</span> <em>AIChE Journal</em>, p. e70656, 2026, doi: <a href="https://doi.org/10.1002/aic.70656">10.1002/aic.70656</a>.</div>
</div>
<div id="ref-bernal2016etbe" class="csl-entry" role="listitem">
<div class="csl-left-margin">[5] </div><div class="csl-right-inline">D. E. Bernal Neira, <em>Optimal design and control of a catalytic distillation column—case study: Ethyl tert-butyl ether (ETBE) synthesis column</em>, MSc thesis, Universidad de los Andes, 2016.</div>
</div>
<div id="ref-bernal2018simultaneous" class="csl-entry" role="listitem">
<div class="csl-left-margin">[6] </div><div class="csl-right-inline">D. E. Bernal, C. Carrillo-Diaz, J. M. Gómez, and L. A. Ricardez-Sandoval, <span>“Simultaneous design and control of catalytic distillation columns using comprehensive rigorous dynamic models,”</span> <em>Industrial &amp; Engineering Chemistry Research</em>, vol. 57, no. 7, pp. 2587–2608, 2018, doi: <a href="https://doi.org/10.1021/acs.iecr.7b04205">10.1021/acs.iecr.7b04205</a>.</div>
</div>
<div id="ref-linan2020optimalII" class="csl-entry" role="listitem">
<div class="csl-left-margin">[7] </div><div class="csl-right-inline">D. A. Liñán, D. E. Bernal, L. A. Ricardez-Sandoval, and J. M. Gómez, <span>“Optimal design of superstructures for placing units and streams with multiple and ordered available locations. Part II: Rigorous design of catalytic distillation columns,”</span> <em>Computers &amp; Chemical Engineering</em>, vol. 139, p. 106845, 2020, doi: <a href="https://doi.org/10.1016/j.compchemeng.2020.106845">10.1016/j.compchemeng.2020.106845</a>.</div>
</div>
</div>
