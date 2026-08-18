---
layout: post
title: Revisiting the HDA Process Synthesis Problem
description: 'A decade-long road from a GAMS internship to the certified global optimum of one of process synthesis'' founding models'
image: assets/images/hda-superstructure.png
date: 2026-08-16 08:00:00 -0400
---

<!-- markdownlint-disable MD033 -->

<script id="MathJax-script" async src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-chtml.js"></script>
<style>.math { overflow-x: auto; }</style>

*A decade with the hydrodealkylation process: from a visit to GAMS within a visit to CMU and a feasibility pump for convex MINLP, through a disjunctive reformulation, to the global optimum that the canonical model file never mentioned.*

```text
--- the whole story, as a solver log ---
gamslib hda, DICOPT (1989-2026):      4322.55  integer optimal (OA)
2020, GDP port + logic-based OA:      5966.51  (in a slide deck)
2026, gdplib port, global solvers:    INFEASIBLE
2026, local solvers:                  "optimal" (violations up to 1.8e-2)
after the fix, 64-way enumeration:    5965.85  feasible, residual 1e-8
same flowsheet, pristine hda.gms:     5964.53
minlplib.org/hda, BARON dual bound:   5964.534  certified global
```

## An impromptu internship

I started working on MINLP in 2015, in an impromptu "internship" at [GAMS](https://www.gams.com) during a visit to [Prof. Ignacio Grossmann's research group](https://egon.cheme.cmu.edu/) at [CMU](https://www.cmu.edu), the beginning of my PhD, a relationship with the company and its people that I remain grateful for, from that first project to the support that has powered my and my group's research ever since.
The internship turned into my first solver work: adding a feasibility pump to [DICOPT](https://www.gams.com/latest/docs/S_DICOPT.html) for convex MINLP, eventually published with Stefan Vigerske, Francisco Trespalacios, and Ignacio Grossmann in [*Optimization Methods and Software* (2020)](https://doi.org/10.1080/10556788.2019.1641498).
My test problems came from [MINLPLib](https://minlplib.org), where I first ran into `hda`, the hydrodealkylation of toluene, one of the founding examples of process synthesis.
It appears in Douglas's 1988 *Conceptual Design of Chemical Processes*, became an MINLP superstructure in Kocis and Grossmann's 1989 paper, and has shipped with every GAMS distribution since [documented solution](https://www.gams.com/latest/gamslib_ml/libhtml/gamslib_hda.html): profit 4322.55, reported by DICOPT as integer-optimal.

I heard early on that something was off about `hda.gms`.
But everything I was building lived in the convex world: outer approximation, feasibility pumps, methods whose optimality arguments lean on convexity.
And `hda` is aggressively nonconvex.
Pointed at `hda`, my tools would still hand back a feasible flowsheet; what they could not hand back was a guarantee that it was the best one.
That is the status of the 4322.55 recorded in the model file, and it is why I left `hda` alone.
The model went on a mental shelf labeled *someday*.

![HDA process superstructure](assets/images/hda-superstructure.png)

*The HDA superstructure (figure from Yunshan Liu's 2020 presentation): 72 streams and six discrete decisions (hydrogen feed purification, reactor type, hydrogen recovery, methane recovery, and two liquid-separation choices), embedded in one flowsheet with every alternative piped in parallel.*

## Where the nonconvexity lives

If you are a chemical engineer, you have seen every equation in this model.
That is exactly why it is hard.
MINLPLib classifies the instance as indefinite, with 71 quadratic, 13 signomial, and 45 general nonlinear constraints, and each of those has a familiar face:

- **Arrhenius kinetics**, `k = 6.3e10 * exp(-Ea/(R*T))`: an exponential in temperature, multiplied into rate expressions.
- **Vapor pressure** via Antoine / Clausius-Clapeyron, `ln(pvap) = A - B/(T + C)`: a logarithm on one side, a pole in temperature on the other.
- **Flash equilibrium**: recoveries multiplying vapor pressures, giving bilinear and trilinear products.
- **Energy balances**, `Q = F * cp * dT`: flow times temperature, the classic bilinearity of every superstructure model.
- **Valves**: isentropic relations with fractional pressure powers, `T / p^((gamma-1)/gamma)`.
- **Reactor selectivity**, `1 - s = 0.0036 * (1 - X)^(-1.544)`: a signomial with a negative fractional power.
- **Shortcut distillation** (Fenske, Underwood) and the **Kremser equation** for absorption, `(1 - A^(N*eta)) / (1 - A)`: logarithms of flow ratios and an exponential in the tray count.

![Two nonlinear correlations from the HDA model](assets/images/hda-nonlinear-correlations.png)

*Two of the model's own correlations, drawn over the model's own variable ranges.
Each enters the model as an equality, so the feasible operating points are the curve itself: the average of two feasible points is infeasible (left), and a linearization at any one point misses the curve everywhere else (right).
Feasible sets like these have no convex description, which is exactly where the convex toolbox stops.*

A second, sneakier consequence of the superstructure idea follows.
These correlations describe *operating* equipment,  but the optimizer must also evaluate them on flowsheets where the equipment is switched *off* and every flow through it is zero.
`ln(0)`, divisions by zero flow, `0^(-1.544)`: the physics never goes there, but relaxations and reformulations do.
This is why formulations of such models often include small epsilon constants inside logarithms and denominators: guards that keep the functions evaluable at the zero-flow points the algorithms visit.
Hold that thought; one of those guards is the villain of this story.

## A model everyone has met

HDA is not an obscure test case; it is closer to a rite of passage.
Beyond Douglas's book and the [Kocis and Grossmann (1989)](https://doi.org/10.1016/0098-1354(89)85008-2) MINLP, it served among the computational experience for DICOPT's development, became a flagship example in [Türkay and Grossmann's (1996)](https://doi.org/10.1016/0098-1354(95)00219-7) logic-based MINLP algorithms for process networks, the direct ancestor of the methods in this story, and runs through the textbook literature descended from Douglas's treatment, such as Biegler, Grossmann, and Westerberg's *Systematic Methods of Chemical Process Design*.
In the modern era, it lives on as `hda` in [MINLPLib](https://minlplib.org/hda.html), appears in our own [Pyomo.GDP paper](https://doi.org/10.1007/s11081-021-09601-7) ecosystem, and anchors the [gdplib](https://github.com/SECQUOIA/gdplib) benchmark library.
Generations of algorithms have been graded against this flowsheet.
That is precisely what makes its documented solution worth getting right.

## 2020: the disjunctive port

At [Carnegie Mellon](https://www.cmu.edu), [Yunshan Liu](https://www.linkedin.com/in/yunshan-liu/), then an MS student I was advising, implemented HDA as a Generalized Disjunctive Program in [Pyomo.GDP](https://www.pyomo.org), turning the six discrete decisions into proper disjunctions instead of big-M constraints tangled through the algebra.
The results we obtained together in October 2020 were already remarkable, and in hindsight, prophetic:

- [ANTIGONE](https://www.gams.com/latest/docs/S_ANTIGONE.html) on the monolithic MINLP: **4048.39**, below even DICOPT's documented 4322.55.
- The same model rebuilt from the GDP via big-M: **4908.34**.
  Same problem, different formulation, different answer.
- Logic-based outer approximation on the GDP: **5966.51**, with a flowsheet nobody had recorded before: no hydrogen purification, adiabatic reactor, hydrogen recycle, methane recovered by membrane, and both separations done in columns.
- And the decisive step: enumerating all 2^6 flowsheets and solving each NLP with [BARON](https://www.gams.com/latest/docs/S_BARON.html) after eight minutes of computation *certified that solution as globally optimal*.

![The optimal HDA flowsheet highlighted on the superstructure](assets/images/hda-optimal-flowsheet.png)

*The six decisions of the optimal flowsheet, numbered as in the 2020 presentation: (1) hydrogen feed taken straight, no membrane purification; (2) adiabatic reactor; (3) methane recovered with the second membrane; (4) vapor stream recycled; (5) stabilizing column; (6) toluene column.*

![Logic-based outer approximation loop](assets/images/hda-loa-diagram.png)

*The logic-based outer approximation loop: an MILP master proposes a flowsheet, a reduced NLP evaluates only the equipment that flowsheet uses, sidestepping the zero-flow singularities entirely, and OA cuts close the loop (diagram from the 2020 presentation, after our [Pyomo.GDP paper](https://doi.org/10.1007/s11081-021-09601-7)).*

The concluding slide of that deck said it plainly: "Different solution methods yield different solutions… Enumeration should be done in testing phase."
We knew, in 2020, that the documented answer was not the best one.
The result lived in a slide deck, the model went into our benchmark library [gdplib](https://github.com/SECQUOIA/gdplib), and then the result did what results in slide decks do.
It decayed.

## 2026: the model that could not be solved, or falsified

This year, a benchmark-health campaign across gdplib found the HDA port in a strange state: global solvers (BARON, [Gurobi](https://www.gurobi.com)) declared it *infeasible* in seconds, while local solvers returned "optimal" solutions whose constraints, re-evaluated directly, were violated by up to 1.8e-2.
Every recorded HDA benchmark result was an artifact.
The model had drifted into infeasibility, and no one had noticed, because no one had asked a solution to certify itself.

The diagnosis used a trick the port's fidelity made possible: it kept the original's stream numbering.
Solve the pristine `gamslib` model, transplant its solution into the port variable by variable, rank our constraints by violation.
Everything held except one equation: an Antoine correlation whose defensive epsilon inside the logarithm demanded a vapor pressure 1.3e-8 *below* its own Antoine-derived lower bound.
The zero-flow guard, colliding with a bound computed from the unguarded equation: unsatisfiable by one part in 10^8.
Large enough for global solvers to prove infeasibility; small enough for local solvers to smear over.

The repair replaced every removable guard with an exact reformulation, so the correlations stay evaluable at zero flow *without* perturbing the physics.
Concretely, with temperatures in kelvin:

**Antoine vapor pressure.** The guarded logarithm

<div class="math">
\[ \ln\left( 7500.6168\, p^{vap} + \varepsilon \right) = A - \frac{B}{T + C} \]
</div>

became a bilinear equation defining a bounded, shifted logarithmic auxiliary, plus a bounded exponential recovering the vapor pressure:

<div class="math">
\[ \left( \ell + S \right)\left( T + C \right) = A \left( T + C \right) - B, \qquad 7500.6168\, p^{vap} = e^{S} e^{\ell} \]
</div>

where the constant shift *S* keeps the auxiliary nonpositive, so no exponential can overflow anywhere a relaxation looks.

**Arrhenius rate constant.** The guarded division

<div class="math">
\[ k = 6.3 \times 10^{10} \exp\left( \frac{-26167}{T + \varepsilon} \right) \]
</div>

became a cancellation-free bilinear in the log of the rate constant, with the huge prefactor folded into the exponent:

<div class="math">
\[ \left( \kappa - \ln\left( 6.3 \times 10^{10} \right) \right) T = -26167, \qquad k = e^{\kappa} \]
</div>

**Benzene selectivity.** The guarded negative power

<div class="math">
\[ 1 - s = 0.0036 \left( 1 - X + \varepsilon \right)^{-1.544} \]
</div>

was multiplied through, so the exponent is positive and the equation is exact and evaluable at zero:

<div class="math">
\[ \left( 1 - s \right) \left( 1 - X \right)^{1.544} = 0.0036 \]
</div>

**Membrane flux.** The regularized flow ratios

<div class="math">
\[ \frac{f_{c} + \varepsilon}{f + \varepsilon} \]
</div>

became mole-fraction variables with an exact bilinear definition:

<div class="math">
\[ f_{c} = y f, \qquad 0 \leq y \leq 1 \]
</div> "Pole-free" is shorthand rather
than standard vocabulary: it means no denominator in these equations can reach zero anywhere the algorithms evaluate them, because the offending equations are multiplied through by their denominators before any solver sees them.
The few epsilons that remain guard true singularities (Fenske ratios as key-component flows vanish, the Kremser expression at zero trays) and are documented as such.
Along the way we also collected three different "optimal" certificates at three different values from global solves of the intermediate models, each refuted by a feasible point we could verify to 1e-10; certificates, it turns out, deserve witnesses of their own.

## Enumerate everything, again

With the model feasible, we re-ran our 2020 playbook with 2026 tooling: all 64 flowsheets, each fixed-configuration NLP solved with [POUNCE](https://github.com/jkitchin/pounce), a pure-Rust NLP solver initially designed as a port of [Ipopt](https://github.com/coin-or/Ipopt) and now ahead of it in independent benchmarks, driven from Pyomo over the AMPL NL interface.
Running the sweep through an independent solver stack complements the [CONOPT](https://www.gams.com/latest/docs/S_CONOPT.html) and BARON validations from 2020, and every code agrees on the answer.
Minutes of computation.

| Flowsheet | Profit |
| :--- | ---: |
| **No H2 purification, adiabatic reactor, H2 recycle, methane membrane, two columns** | **5965.85** |
| Same, with H2 purification | 5801.63 |
| Same as best, isothermal reactor | 5762.01 |
| … ten flowsheets later … | |
| The flowsheet DICOPT chose in `gamslib` | 4322.4 |

![Sorted profits of all feasible HDA flowsheets](assets/images/hda-enumeration.png)

*All 30 feasible flowsheets from the complete 64-configuration enumeration, sorted by locally optimal profit.
The documented `gamslib` flowsheet sits mid-pack.*

The winner is the flowsheet we found in 2020, to within the small differences between the formulations.
And an old mystery dissolved on the spot: our README had carried a best-known value of 5801.27 for years with unreconstructible provenance.
The runner-up flowsheet, the same design with hydrogen purification, lands at 5801.63.
The number had a provenance all along; it was the optimum of the second-best flowsheet.

## Checking against the sources

Fixing the winning flowsheet's binaries in the untouched `gamslib` file, thirteen `y.fx` statements, gives profit **5964.534**, feasible, zero infeasibilities.
And here is the part that makes this a story about scientific memory rather than a single bug: [MINLPLib's page for `hda`](https://minlplib.org/hda.html) (the same library I mined for the feasibility-pump paper a decade ago) reports a primal bound of -5964.534084 against a BARON dual bound of -5964.534089.
In its minimization convention, that is exactly the solution above, *globally certified*, sitting in public view.
We also handed the point to [GAMS/Examiner](https://www.gams.com/latest/docs/S_EXAMINER.html), GAMS's own independent solution auditor: primal and dual constraints and variable bounds check out at a 1e-6 tolerance, and complementary slackness at 1e-7, so the point passes not just feasibility but the full local-optimality conditions.
In a fitting coda, the largest constraint-matrix entry Examiner flags sits on the Antoine equation for diphenyl on stream 19, the very equation where this story's infeasibility began.

One scoping note, because the two models are siblings rather than twins.
The certificate belongs to the original MINLP, with the GAMS file's cost data.
The gdplib port follows the *paper's* cost data, which differs in a few coefficients from the port's own comments inventory (the absorber's fixed cost, compressor costs, the electricity price), so its 5965.85 is a verified feasible solution and an exhaustive-over-flowsheets best, but not itself globally certified.
What transfers between the two is the thing a designer cares about: *the same flowsheet wins in both*, and on that flowsheet, which uses no absorber and sidesteps the largest cost difference, the two objectives agree to 0.02%.

None of this is a flaw in GAMS or in DICOPT.
In 1989, an outer-approximation code promised a good integer-feasible solution, and that is what it delivered; 4322.55 faithfully records what computation could do then.
The certificate that settles the question today comes from the same community, through MINLPLib, and nearly every experiment in this story ran through GAMS-interfaced solvers.
We are sharing the certified value with the GAMS team so the library documentation can reflect it, a small return on a toolchain that this investigation, and my career, have leaned on for a decade.

## What I take away

- **Convex-MINLP certificates don't generalize to nonconvex problems.** An outer-approximation "proof" on a nonconvex model is a local claim wearing a global costume.
  That was why my convex tools could produce a solution for this model in 2015 but never settle it, and why its documented answer stood unquestioned for three decades.
- **Results decay unless they live in artifacts.** Our 2020 enumeration proved the global optimum and then evaporated, because it lived in slides rather than in the model's README, its tests, and its documented solution.
  This time, everything went into the repository with the certificates attached.
- **Benchmarks need feasibility witnesses.** A solver log is testimony; a point you can re-evaluate against the constraints is evidence, and tools like GAMS/Examiner exist precisely to institutionalize that check.
  Every "optimal" HDA result in our benchmark was fiction until we started checking residuals ourselves.
- **Numerical guards are model changes.** Every epsilon in a superstructure model deserves the same scrutiny as a constraint.
  Several of ours were removable by exact reformulation, and one of them, colliding with a bound derived from the unguarded equation, was the bug.
- **Enumeration is cheap only while the problem is small.** Sixty-four NLPs were eight BARON minutes in 2020 and a coffee break with an open-source Rust interior-point code in 2026, but only because HDA has just six discrete decisions.
  The count of flowsheets doubles with every disjunction you add: a model with thirty choices has over a billion of them, and this same benchmark library holds models in exactly that range.
  For superstructures small enough to sweep, exhaustive enumeration should be routine testing-phase hygiene, exactly as our 2020 slides suggested; at scale, it is precisely the combinatorial wall that branch-and-bound and logic-based methods exist to climb.

The full trail, every experiment, false lead, and fix, is public in [gdplib PR #130](https://github.com/SECQUOIA/gdplib/pull/130).

## Where this goes next

It would be a mistake to end on the number.
HDA is a beautiful problem, but it is not the ultimate one: the models we can now write for chemical processes are far more sophisticated than a 1988 superstructure, and getting them right, feasible, well-scaled, and accurately documented, is where the work lies.
The solvers keep getting better; the certified bound on this problem was unthinkable when the model was written.
And the models can get better too, because the model and solver are not independent: how you write a correlation determines what a solver can prove about it, and understanding that relationship lets us push the boundary.
The nonlinearity in these models is necessary; it *is* the physics, but it is tricky, and we have work underway to simplify and tame it within Generalized Disjunctive Programming.
HDA took thirty-seven years to give up its answer.
The next models should not have to wait that long.

*Thanks to Stefan Vigerske and Steven Dirkse of GAMS for their comments on a draft of this post.*

**Timeline, for the curious:**

- **1988**: Douglas publishes the HDA conceptual design problem.
- **1989**: Kocis & Grossmann formulate the MINLP superstructure; it enters the GAMS model library with DICOPT's 4322.55.
- **2015**: An impromptu internship at GAMS starts the DICOPT feasibility-pump work; MINLPLib supplies the test set, HDA included.
- **2020**: The feasibility-pump paper appears in *Optimization Methods and Software*.
  At CMU, working with Yunshan Liu, we port HDA to GDP; logic-based outer approximation finds the 5966.51 flowsheet and our enumeration certifies it, in a slide deck.
- **2026**: A benchmark-health sweep finds the port infeasible; the diagnosis, the fix, the re-enumeration, and the reconciliation with MINLPLib follow in a single week.

*Tools: [Pyomo](https://www.pyomo.org) and Pyomo.GDP, [GAMS](https://www.gams.com) with CONOPT, DICOPT, and BARON, Gurobi, ANTIGONE (2020), and POUNCE with its [`pyomo-pounce`](https://pypi.org/project/pyomo-pounce/) plugin.
Figure from Yunshan Liu, "HDA Process Synthesis Implementation in GDP.Pyomo," CMU, October 2020.
Verification discipline borrowed from the oldest trick in numerical analysis: when in doubt, evaluate the residuals yourself.*

[Back to News](/3-news.html){: .button .icon .fa-arrow-left }
