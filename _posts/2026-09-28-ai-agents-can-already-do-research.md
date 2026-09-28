---
layout: post
title: "AI Agents Can Already Do Research. Now What?"
description: "What happened when we tried it ourselves, and why our institutions are not ready"
author: "Sergey Gusev and David E. Bernal Neira"
image: assets/images/ideas.webp
date: 2026-09-28 08:00:00 -0400
permalink: /ai-agents-can-already-do-research/
---

<link rel="stylesheet" href="{{ '/assets/css/ai-agents-research.css' | relative_url }}">
<script id="MathJax-script" async src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-chtml.js"></script>

*What happened when we tried it ourselves, and why our institutions are not ready*

**Sergey Gusev and David E. Bernal Neira** · Purdue University · September 2026

[Research inventory](#all-results) · [References](#references)

This summer brought two headline results in mathematics. In August, an Anthropic staff member with no mathematical training asked an unreleased Claude model to “take a real stab” at the Riemann hypothesis, one of the most famous unsolved problems in mathematics. The hypothesis says that certain zeros of a function all lie on one line. The model did not prove that, but it proved that more than 66% of them do, up from the previous best of about 42%, a share that mathematicians had raised only in small steps for decades [\[1\]](#ref-alpoge2026-more-than-two-thirds-of). In September, OpenAI announced that about ten thousand AI agents, working for 88 hours, had produced a proof for a version of another famous open problem, about the equations of fluid flow; independent review is still under way [\[2\]](#ref-openai2026navierstokes). By one outside estimate, that run would have cost a customer several million dollars [\[3\]](#ref-duraisamy2026navierstokescost). OpenAI has since said that the model behind that run has resolved more than 100 further open problems; it has not yet published them [\[4\]](#ref-openai2026advisory).

Both came from inside AI companies, with unreleased models and budgets that no research group has. Can an ordinary research group, with models anyone can buy, get agents to do real research?

We tried it ourselves. It works, on a smaller scale than the AI companies’ runs and at a small fraction of their cost.

Over the past few weeks, we gave groups of AI agents a research area, anywhere from a single topic to a whole field. We gave them papers and computing tools, and told them to make real, correct, useful progress and not to stop. We gave them no ideas.

Within the first day of one run, the agents had written more notes than we could read in a week. Within a few weeks, they had produced material for 45 potential papers in the five areas we gave them: mixed-integer nonlinear programming, quantum interior-point methods, molecular thermodynamics, transport theory, and aggregation kinetics. In a sixth area, catalysis, we asked for experiments instead, and they designed programs of laboratory experiments; nobody has run them, so we cannot yet say how good they are. We have not checked all of it, and we cannot yet say how much is correct or new. But in everything we have checked so far, we have found no error that would invalidate a result, and some results are proved in Lean, software in which a computer checks every step of a proof.

This post explains what we did, why we think it matters, and what we think should happen next. The full paper has the details, the evidence, and the caveats **[TODO: link to paper]**. All of the agents’ output is public at <https://github.com/SECQUOIA/agent-swarm-research> [\[5\]](#ref-gusev2026corpus); this post describes it at [commit `84c6be7`](https://github.com/SECQUOIA/agent-swarm-research/tree/84c6be7aad17d085e5343e789885c1cbcbbd4e07), before any scientific input from us.

<h2 class="unnumbered" id="what-we-did">What we did</h2>

The whole procedure fits in three steps ([Figure 1](#research-setup)).

<figure id="research-setup" class="research-setup">
  <ol class="research-steps">
    <li>
      <span class="step-number" aria-hidden="true">01</span>
      <h3>Describe the problem or field.</h3>
      <p>Enough context to work from; freedom to explore any idea.</p>
    </li>
    <li>
      <span class="step-number" aria-hidden="true">02</span>
      <h3>Provide papers and tools.</h3>
      <p>And permission to get more.</p>
    </li>
    <li>
      <span class="step-number" aria-hidden="true">03</span>
      <h3>Ask a swarm of agents to make progress, and not to stop.</h3>
      <p>Every result reviewed by a fresh agent. Write it up. Verify by proof or by computation where possible.</p>
    </li>
  </ol>
  <figcaption><strong>Figure 1.</strong> The procedure we followed. The paper includes examples of the prompts we used.</figcaption>
</figure>

We used off-the-shelf tools: the coding agents Claude Code and Codex, mostly running Claude Fable 5.1 and GPT-6 Astra, on two Claude and two ChatGPT subscriptions at \$200 a month each. At pay-per-use prices, the same usage would have cost more than \$15,000 in the first four weeks. We wrote no custom software beyond a few instructions for housekeeping. Anyone with access to these models can repeat this today.

Our procedure is not the best way to do research with agents: it is brute force, and we did not tune it. But if something this simple already works, better methods will do more.

We did not expect this to work. For months, we had built tools for close collaboration between people and AI, in which we directed the research and checked the work at every step. They never produced much. When we stepped aside and let the agents do everything, from choosing research directions to checking results, we had results within a day, and a lot of them. In hindsight, the reason is that in theoretical research, agents are getting better at every part of the work, and they are already good at most of it. They can direct the research and check the work themselves, and they read more, compute more, and explore several ideas at once. As the models improve, we can add less and less to solving a given problem, and each time we step in, we mostly slow the work down.

<h2 class="unnumbered" id="what-came-back">What came back</h2>

What came back is not a set of breakthroughs. It is incremental work, the kind of small, sound steps that make up most scientific progress. You do not have to take our word for it. Everything the agents produced is public, and anyone can check it. The tables at the end of this post list every potential paper and proposed experimental program, with what the agents claim and links to their drafts. The results from AI companies are breakthroughs on famous problems. Our runs show the everyday work of research, in several unrelated fields.

Some of this work did not need the newest models. Some of our results, in quantum interior-point methods, came from GPT-5.6 Sol, a model that had been public for almost two months before we tried it. Models could do this work before we noticed, and we suspect the same is true in many other areas of theoretical research.

<h2 class="unnumbered" id="the-bottleneck-has-moved">The bottleneck has moved</h2>

The agents produced results faster than we could review them. At a few days for each potential paper or experimental program, reviewing everything would take one of us more than seven months of full-time work. Producing the results took weeks.

Every publication system assumes that the author has checked the work and answers for it, and that reviewers then take a second look. When one person can produce more than they can review, the author’s own check is missing, and no amount of outside review replaces it. Hiring, promotion, and funding still count papers, and a paper can now be produced for almost nothing.

If the output were noise, anyone could ignore it, and the review backlog would not matter. But the output deserves review.

<h2 class="unnumbered" id="if-you-are-a-skeptic">If you are a skeptic</h2>

These are some of the responses we often hear.

**“The results are not impressive. A good researcher would have found them.”** Maybe. Then why were they not already in the literature? What matters more than whether agents beat the best person in a field is how much of the field’s work they have to match before its institutions have to change. Everyone except the top one percent? Everyone except one person? We think agents already match many working researchers, including us.

**“It is a statistical machine. It can only recombine what it has seen.”** Much of research recombines too: a known technique applied to a new problem, or ideas from two fields joined together. Whether a result is correct, new, and useful can be checked without knowing who or what produced it.

**“It might all be wrong.”** Some of it may be. But in what we have checked so far, we have found no scientific error that would invalidate a result. And we released all of it, so you can check it yourself.

**“I refuse to use these tools on principle.”** That is a legitimate choice. But others in your field will use them, and you will be compared with them in hiring, funding, and promotion.

When a study shows something AI cannot do, check which model it tested and when. Such limits have repeatedly been overtaken within months, on a trend that has itself been measured [\[6\]](#ref-kwa2025-measuring-ai-ability-to-complete). If you can do better than the models today, that tells you only about today’s models, and the models keep improving.

<h2 class="unnumbered" id="if-you-are-an-enthusiast">If you are an enthusiast</h2>

**“Research just got easier. With the newest models and enough computation, anyone can produce results.”** That may well be true, but it raises problems that we cannot answer. If results depend only on the model and the budget, then the researcher is not needed. Anyone who cares about a problem can pay for the computation directly, and the company that runs the model has the newest models first and pays the least for computation. And if results follow budgets, who gets to do research, what should the human contribution be, and what is it worth?

**“Then I will be the reviewer.”** That is not a safe role either. We could not review fast enough. Every error we know of in our corpus was found and fixed by agents before any of us looked at the work; we cannot say whether we would have caught those errors ourselves. Agents can be run as reviewers in large numbers as easily as they are run to produce results. And nobody chooses a research career to sign off on a machine’s output. A system built on human sign-off would fill with reviews that were never really done.

So what, exactly, is the researcher’s role? What would someone pay a person for that they cannot get from the model directly? We do not have a satisfying answer.

<h2 class="unnumbered" id="the-questions-and-where-we-stand">The questions, and where we stand</h2>

We would rather take positions and be wrong than only ask questions. This is where we stand today.

- **How should results be trusted when review, not production, is scarce?** By measurement. Put results in a form a machine can check wherever possible, and build machine-checked libraries of established results in every field whose reasoning is mathematical, such as physics, chemistry, and engineering, not only in mathematics itself. Have experts check a sample of what agent reviewers approve, publish how often they miss errors, and accept results from a process that meets the field’s standard.

- **Which results need a person to understand them?** Decide on purpose, by what is at stake and by measured error rates, and revisit the decision with each new model.

- **What counts as new when agents cannot read much of the literature, because it is behind paywalls?** Open the literature. Work presented as public knowledge should be readable by every person and every agent that does research.

- **What should publication become?** Release claims with their verification status (machine-checked, reviewed by agents, audited by sampling, or reviewed by a person) and with links to the checks.

- **What do credit and paper counts mean when the human input is a prompt?** Stop counting papers. Judge results by whether they are correct, new, useful, and checked, and do not punish people for saying how they were produced. Rules against using AI cannot be enforced; they only push its use into hiding. The current system of credit is already being broken in private, and we think it is better to break it in public, where its replacement can be discussed.

- **Why would anyone pay a researcher?** Less for producing results, and more for understanding them, checking them, and deciding where the work should go. There may also be more demand for researchers, not less, through an effect known as the Jevons paradox: making a resource cheaper to use can increase how much of it is used. In the 19th century, the economist William Stanley Jevons observed that when steam engines began to use coal more efficiently, total coal use rose, because cheaper power made new uses worthwhile [\[7\]](#ref-jevons1865coal). Cheap results could likewise make far more questions worth asking and far more directions worth exploring, and people could be needed to choose among them, steer the agents, and put the results to use.

- **Does the best researcher become the one with the largest budget?** Results will increasingly depend on how much computation a researcher can pay for, and we do not think that can be avoided. Decide openly how to handle it, instead of drifting into it: whether institutions should provide computation as a shared resource, like libraries and laboratories, and whether assessment can separate what a person did from what their budget did.

- **How should people learn a field that machines can already work in?** Teach more, not less, but differently. Aim training at understanding and judgment, and stop drilling students in skills that they now only need to understand. Fund the training of junior researchers on purpose. On a fixed budget, one senior researcher plus computation produces more than a group of students; a field that funds research on that basis will have no senior researchers in a generation.

- **What happens when agents are run over whole fields?** It will happen. Model developers, funders, and governments can afford it, and nobody can stop everyone else from doing it. We think it should happen in the open, with checking funded alongside production. Running agents over a whole field also gives that field a baseline: what agents can do on their own. What people add on top of that baseline is the human contribution.

- **How do people stay in control of research they cannot keep up with?** We expect agents to move far ahead of people in some fields, probably in mathematics first. Keeping up is not a realistic goal; staying in control is. That means people set the goals and can stop the runs, enough people understand each field well enough to audit it, and there are guardrails where a correct result can do harm.

<h2 class="unnumbered" id="what-we-do-not-know">What we do not know</h2>

Two of these answers are weaker than we would like.

We argue for more people, not fewer. We can say why a field needs them. We cannot yet say what they will do. Auditing, steering, and keeping up with results are the roles we can name today, and agents may take over each of them as the models improve.

And the baseline idea assumes that people can follow the baseline. If agents produce more in a month than a field can read in a year, people may not even be able to tell what is already known, let alone add to it. We do not know what the human contribution is then, or how anyone would measure it. We think it is one of the most important questions, and we raise it without an answer.

<h2 class="unnumbered" id="our-institutions-are-not-ready">Our institutions are not ready</h2>

Peer review, paper counts, hiring, promotion, funding, and graduate training were all built for a world in which producing a result is slow and its author has read it. That is no longer the world we are in. We believe our research institutions, and the incentives they create, are not ready for what these systems can already do, let alone for what comes next. The time to start changing them was yesterday.

Institutions change over years, and models improve over months. A curriculum or a review policy designed for today’s models will take effect after those models have been replaced, and their replacements will be replaced in turn. Such policies should be designed for capabilities that keep increasing, not for any one generation of models. Institutions should also plan ahead and decide now how they will respond when agent review is shown to be as reliable as expert review, when agents overtake people in their field, or when automated laboratories make experiments cheap to run. Some AI developers already make commitments of this kind for their own models, tying required safeguards to measured capabilities [\[8\]](#ref-anthropic2026rsp). Research institutions should do the same.

Some responses have begun. More than two dozen Fields medalists, winners of the top prize in mathematics, signed a declaration warning that the push by AI companies to solve mathematical problems as benchmarks harms mathematics, and calling for the problem to be addressed urgently [\[9\]](#ref-fields2026declaration). OpenAI has formed an independent advisory group of mathematicians to advise it on how to assess and communicate new results [\[4\]](#ref-openai2026advisory). We welcome both as first steps, and we share the concern that results announced in a rush can get ahead of understanding. We do not think that aiming AI at famous problems is itself the harm. Anyone can now aim AI at famous problems, so such attempts will happen whether or not anyone approves; what matters is how we prepare for them. And both responses concern mathematics and the AI companies. Our runs were in optimization, thermodynamics, transport, and catalysis, with models anyone can buy. The same questions arise wherever agents can produce results faster than people can review them, and that is already true well beyond mathematics.

<h2 class="unnumbered" id="what-to-do-now">What to do now</h2>

**Run the experiment in your own field.** The paper includes examples of our prompts. Use the best models available when you read this. If you want to compare with us, supply no ideas of your own.

**Report what you find:** what you asked, what came back, what you checked, and what you did not.

**Judge the results against the trend, not only against today’s models.** If the agents fail, report that too, with the model and the date, and repeat the experiment as new models arrive. Capability is uneven, so the same agents may fail on one problem and do remarkable work on the next. The telling comparison is with what agents could do six months or a year ago. Then extend that trend a few years, and ask what your field should be doing now.

**Start preparing now.** Do not wait until AI clears some higher bar, such as producing results better than anyone else can. Discuss with your colleagues, students, institution, and funders what your field should change: how results are reviewed and credited, how students are trained, and what researchers are for. Prepare for capabilities that keep increasing, not only for today’s models.

The sooner many people report, the sooner this conversation rests on evidence instead of opinion. But preparation should not wait for that evidence: it should have started yesterday, and it should start now.

<h2 class="unnumbered" id="all-results">All results</h2>

These tables contain the same research inventory as the paper, grouped by area. Each row is a group of related results that could stand as one paper, whether or not the paper has been written. The contributions are the agents’ claims, as stated in their own write-ups and notes; we have not checked all of them. We left out results that the agents themselves marked as superseded, refuted, or withdrawn, results too small to stand as a paper, and clusters whose main result the agents’ own literature checks found to be already known. In catalysis, the agents proposed experimental programs, and none of the experiments have been run.

The links in the Write-up column go to the drafts at [commit `84c6be7`](https://github.com/SECQUOIA/agent-swarm-research/tree/84c6be7aad17d085e5343e789885c1cbcbbd4e07) (tag `paper-v1`), which holds the agents’ output as of 25 September 2026, before any scientific input from us; the Lean column gives the status on that date. Later versions of the repository may add results and our own scientific input. Rows marked “Notes only” have no draft; their links open the relevant area’s collection of agents’ notes at the same commit.

<h3 class="unnumbered" id="mixed-integer-nonlinear-programming">Mixed-integer nonlinear programming</h3>

<div class="table-wrapper research-inventory" role="region" aria-labelledby="mixed-integer-nonlinear-programming" tabindex="0">
<table class="research-inventory-table">
<caption>Mixed-integer nonlinear programming</caption>
<thead>
<tr>
<th scope="col" style="text-align: left;">ID</th>
<th scope="col" style="text-align: left;">Working title and claimed contribution</th>
<th scope="col" style="text-align: left;">Write-up</th>
<th scope="col" style="text-align: left;">Lean</th>
</tr>
</thead>
<tbody>
<tr id="result-m1">
<th scope="row" style="text-align: left;">M1</th>
<td style="text-align: left;"><strong>Sharp gaps for positive multilinear relaxations.</strong> Disproves the Luedtke–Namazifar–Linderoth conjecture; exact hull gap; worst ratio grows as <span class="math inline">\(\ln d/\ln\ln d\)</span> in degree and <span class="math inline">\(\ln n/\ln\ln n\)</span> in dimension. Builds on <span class="citation" data-cites="luedtke2012multilinear"><a href="#ref-luedtke2012multilinear" role="doc-biblioref">[10]</a></span>.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/minlp-notes/paper-multilinear-gap/main.pdf">Full paper</a></td>
<td style="text-align: left;">Done</td>
</tr>
<tr id="result-m2">
<th scope="row" style="text-align: left;">M2</th>
<td style="text-align: left;"><strong>Verified bounds for positive cubic relaxation gaps.</strong> Brackets the worst cubic termwise-to-hull gap ratio: <span class="math inline">\(1610000/743033 \le R(3) \le 31/12\)</span>.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/minlp-notes/paper-cubic-gap/main.pdf">Full paper</a></td>
<td style="text-align: left;">Done</td>
</tr>
<tr id="result-m3">
<th scope="row" style="text-align: left;">M3</th>
<td style="text-align: left;"><strong>Checkable lower bounds for convex mixed-integer nonlinear optimization through rational outer approximations.</strong> Rational certificates give independently checkable lower bounds; 203 of 289 MINLPLib models pass separate replay; exact audits find invalid proofs accepted by an external proof checker. Builds on <span class="citation" data-cites="halbig2024certificates"><a href="#ref-halbig2024certificates" role="doc-biblioref">[11]</a></span>.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/minlp-notes/paper-certified-minlp/main.pdf">Full paper</a></td>
<td style="text-align: left;">Done</td>
</tr>
<tr id="result-m4">
<th scope="row" style="text-align: left;">M4</th>
<td style="text-align: left;"><strong>Convex relaxation gaps and spatial certificates in nonlinear optimization.</strong> Signed bilinear gaps of the order of the square root of the edge density; exponentially many certified regions for spatial branch-and-bound under specified node oracles. Answers a question of Altschuler and Boix-Adserà negatively, assuming P<span class="math inline">\({}\neq{}\)</span>NP; a counterexample to a published theorem on P-split formulations. Also restates the positive multilinear and cubic gap results of M1 and M2.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/minlp-notes/paper-relaxation-limits/main.pdf">Full paper</a></td>
<td style="text-align: left;">Partial</td>
</tr>
<tr id="result-m5">
<th scope="row" style="text-align: left;">M5</th>
<td style="text-align: left;"><strong>Integer dimension in convex mixed-integer approximation of nonlinear graphs.</strong> For a fixed quadratic system on a box, the minimum number of integer or binary variables for <span class="math inline">\(\varepsilon\)</span>-accurate convex lifts is <span class="math inline">\(\frac{1}{2}\,\mathrm{ncrank}\cdot\log_2(1/\varepsilon)+O(1)\)</span>, where ncrank is the noncommutative rank of the Hessian space; polynomial-time rational constructions. Builds on <span class="citation" data-cites="lubin2022representability beach2022compact"><a href="#ref-lubin2022representability" role="doc-biblioref">[12]</a>, <a href="#ref-beach2022compact" role="doc-biblioref">[13]</a></span>.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/minlp-notes/paper-integer-dimension/build/main.pdf">Full paper</a></td>
<td style="text-align: left;">Partial</td>
</tr>
<tr id="result-m6">
<th scope="row" style="text-align: left;">M6</th>
<td style="text-align: left;"><strong>Rounding switching controls under a hard switch budget: sharp minimax bounds and exact algorithms.</strong> Exact minimax rounding error for up to three switches; disproves a conjecture of Sager and Zeile and corrects a published lower bound; exact finite-grid values and algorithms.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/minlp-notes/paper-switching-control/main.pdf">Full paper</a></td>
<td style="text-align: left;">Partial</td>
</tr>
<tr id="result-m7">
<th scope="row" style="text-align: left;">M7</th>
<td style="text-align: left;"><strong>Sparse convex hulls for network flows coupled to a simplex.</strong> An exact formulation uses one extra coordinate per independent cycle of each unobserved block–label subgraph; exponential coefficient growth on series–parallel graphs.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/minlp-notes/paper-network-simplex/main.pdf">Full paper</a></td>
<td style="text-align: left;">Partial</td>
</tr>
<tr id="result-m8">
<th scope="row" style="text-align: left;">M8</th>
<td style="text-align: left;"><strong>Topology, uncertainty, and precision in passive potential-flow optimization.</strong> Polynomial additive optimization of potential differences at fixed block cycle rank, for balanced nomination boxes and independent coefficient intervals; exact pressure comparison on single-source, single-sink cacti is equivalent to Square-Root Sum.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/minlp-notes/paper-potential-flow/complexity/main.pdf">Full paper</a></td>
<td style="text-align: left;">Partial</td>
</tr>
<tr id="result-m9">
<th scope="row" style="text-align: left;">M9</th>
<td style="text-align: left;"><strong>The complexity of pooling: algebraic barriers and structural algorithms.</strong> The pooling threshold decision is <span class="math inline">\(\exists\mathbb{R}\)</span>-complete; strongly NP-complete with all layer degrees two, and NP-complete with two pools and two products, answering questions of Boland et al. and Haugland; resolves a rank-one cost conjecture; matching tractability boundaries. Builds on <span class="citation" data-cites="haugland2016pooling boland2017pooling dey2020rankone"><a href="#ref-haugland2016pooling" role="doc-biblioref">[14]</a>, <a href="#ref-boland2017pooling" role="doc-biblioref">[15]</a>, <a href="#ref-dey2020rankone" role="doc-biblioref">[16]</a></span>.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/minlp-notes/papers/pooling/main.pdf">Full paper</a></td>
<td style="text-align: left;">Not applicable</td>
</tr>
<tr id="result-m10">
<th scope="row" style="text-align: left;">M10</th>
<td style="text-align: left;"><strong>Exact feasibility of resistive and AC power networks.</strong> Resistive power-flow feasibility is <span class="math inline">\(\exists\mathbb{R}\)</span>-complete even on planar, degree-three, unit-conductance networks; the hardness transfers to AC networks with resistive lines. Related work: <span class="citation" data-cites="bienstock2019acpf lehmann2016acfeasibility"><a href="#ref-bienstock2019acpf" role="doc-biblioref">[17]</a>, <a href="#ref-lehmann2016acfeasibility" role="doc-biblioref">[18]</a></span>.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/minlp-notes/paper-power-flow/build/main.pdf">Full paper</a></td>
<td style="text-align: left;">Not applicable</td>
</tr>
<tr id="result-m11">
<th scope="row" style="text-align: left;">M11</th>
<td style="text-align: left;"><strong>Structured bilevel optimization with many follower variables: global responses, accuracy, and structural boundaries.</strong> A fixed-dimensional description of all global follower responses gives exact polynomial algorithms; rational leaders with error <span class="math inline">\(2^{-B}\)</span> for strictly convex costs; hardness with dense near-identity Hessians.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/minlp-notes/paper-structured-bilevel/paper.pdf">Full paper</a></td>
<td style="text-align: left;">Possible</td>
</tr>
<tr id="result-m12">
<th scope="row" style="text-align: left;">M12</th>
<td style="text-align: left;"><strong>Globally certified measurement selection with correlated errors.</strong> Polynomial approximation sets in relative PSD order, a weighted-trace approximation scheme, and rational log-determinant certificates for correlated measurement selection.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/minlp-notes/paper-correlated-measurements/build/main.pdf">Full paper</a></td>
<td style="text-align: left;">Partial</td>
</tr>
<tr id="result-m13">
<th scope="row" style="text-align: left;">M13</th>
<td style="text-align: left;"><strong>Radial and point separation for perspective outer approximation of convex generalized disjunctive programs.</strong> Matched comparison of two separation policies: radial search gives modest, implementation-specific gains; no new cut family.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/minlp-notes/paper-lbesh/main.pdf">Full paper</a></td>
<td style="text-align: left;">Not applicable</td>
</tr>
<tr id="result-m14">
<th scope="row" style="text-align: left;">M14</th>
<td style="text-align: left;"><strong>Quadratic aggregation: certificates, finite descriptions, and approximation.</strong> Resolves three Blekherman–Dey–Sun conjectures: under hidden hyperplane convexity, a hull is proper exactly when a nonconstant convex aggregation exists; a three-inequality hull needs uncountably many aggregations; four aggregations suffice for three strict quadratics with a positive definite combination, extending a Blekherman–Dunbar bound, and are sharp. Builds on <span class="citation" data-cites="blekherman2024aggregations"><a href="#ref-blekherman2024aggregations" role="doc-biblioref">[19]</a></span>.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/minlp-notes/paper-quadratic-aggregation/paper.pdf">Full paper</a></td>
<td style="text-align: left;">Partial</td>
</tr>
<tr id="result-m15">
<th scope="row" style="text-align: left;">M15</th>
<td style="text-align: left;"><strong>Exact convex hulls for a reciprocal factor shared by many variables.</strong> Explicit hull of <span class="math inline">\((X,1/X,Y_i,XY_i)\)</span> for many leaves, with exact rational separation and decomposition; extends to an integer factor with a binary-encoded range, with separation polynomial in the encoding length.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/tree/84c6be7aad17d085e5343e789885c1cbcbbd4e07/minlp-notes" title="Browse this area’s notes at the cited commit">Notes only</a></td>
<td style="text-align: left;">Done</td>
</tr>
<tr id="result-m16">
<th scope="row" style="text-align: left;">M16</th>
<td style="text-align: left;"><strong>Ill-posed heat-exchanger network instances in MINLPLib.</strong> The <code>heatexch_gen</code> models share an unbounded guarded log-mean-temperature term; for <code>heatexch_gen1</code>, a numerically feasible point improves the listed value by about 30%, and numerical estimates indicate that the infimum is not attained.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/tree/84c6be7aad17d085e5343e789885c1cbcbbd4e07/minlp-notes" title="Browse this area’s notes at the cited commit">Notes only</a></td>
<td style="text-align: left;">Not applicable</td>
</tr>
<tr id="result-m17">
<th scope="row" style="text-align: left;">M17</th>
<td style="text-align: left;"><strong>Convex envelopes of two-variable monomials with real exponents on a wedge.</strong> Extends the hull of a bounded monomial on a wedge from positive exponents to negative and mixed-sign ones, including ratio terms; answers Belotti’s open case of two negative exponents. Builds on <span class="citation" data-cites="belotti2025monomials"><a href="#ref-belotti2025monomials" role="doc-biblioref">[20]</a></span>.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/tree/84c6be7aad17d085e5343e789885c1cbcbbd4e07/minlp-notes" title="Browse this area’s notes at the cited commit">Notes only</a></td>
<td style="text-align: left;">Possible</td>
</tr>
<tr id="result-m18">
<th scope="row" style="text-align: left;">M18</th>
<td style="text-align: left;"><strong>Exact indicator quadratic optimization at low treewidth.</strong> NP-hard at bandwidth two with Hessians arbitrarily close to the identity; with randomly perturbed indicator penalties, exact algorithms in polynomial expected bit time at fixed treewidth.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/tree/84c6be7aad17d085e5343e789885c1cbcbbd4e07/minlp-notes" title="Browse this area’s notes at the cited commit">Notes only</a></td>
<td style="text-align: left;">Not applicable</td>
</tr>
<tr id="result-m19">
<th scope="row" style="text-align: left;">M19</th>
<td style="text-align: left;"><strong>Convex envelopes of univariate functions of a linear form.</strong> For any lower semicontinuous <span class="math inline">\(\sigma\)</span>, the convex envelope of <span class="math inline">\(\sigma(a^\top x+b)\)</span> over a box is a minimum over laws below a comonotone staircase law in convex order, and dually a supremum over concave minorants, each of which gives cuts valid on the whole box; extensions to products of simplices and sign-restricted order polytopes. Builds on <span class="citation" data-cites="mao2015aggregation"><a href="#ref-mao2015aggregation" role="doc-biblioref">[21]</a></span>.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/tree/84c6be7aad17d085e5343e789885c1cbcbbd4e07/minlp-notes" title="Browse this area’s notes at the cited commit">Notes only</a></td>
<td style="text-align: left;">Possible</td>
</tr>
<tr id="result-m20">
<th scope="row" style="text-align: left;">M20</th>
<td style="text-align: left;"><strong>Contraction theory of iterated optimality-based bound tightening.</strong> Near a minimizer, iterated bound tightening follows a monotone, positively homogeneous map on box shapes whose Collatz–Wielandt-type constant bounds the local linear rate; a certificate for when tightening stalls; the exact rate <span class="math inline">\((\sqrt{2a^2+4a}-a)/2\)</span> of simultaneous rounds for <span class="math inline">\(x^2+y^2+axy\)</span>, <span class="math inline">\(0&lt;a&lt;2\)</span>, with McCormick relaxations; a condition under which tightening does nothing, even for strongly convex objectives. Builds on <span class="citation" data-cites="caprara2010domain"><a href="#ref-caprara2010domain" role="doc-biblioref">[22]</a></span>.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/tree/84c6be7aad17d085e5343e789885c1cbcbbd4e07/minlp-notes" title="Browse this area’s notes at the cited commit">Notes only</a></td>
<td style="text-align: left;">Possible</td>
</tr>
<tr id="result-m21">
<th scope="row" style="text-align: left;">M21</th>
<td style="text-align: left;"><strong>Joint relaxation of several nonlinear terms in one variable.</strong> Automatic, certified treatment in a solver: certified curvature and envelope cuts valid for every slope solve all 24 separable quartic test programs, of which native SCIP, Gurobi, and BARON solve 2, 3, and 6; a certified separator for hulls of curves <span class="math inline">\((t,f_1(t),\dots,f_k(t))\)</span>. The hull theory itself is known. Builds on <span class="citation" data-cites="ballerstein2013thesis"><a href="#ref-ballerstein2013thesis" role="doc-biblioref">[23]</a></span>.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/tree/84c6be7aad17d085e5343e789885c1cbcbbd4e07/minlp-notes" title="Browse this area’s notes at the cited commit">Notes only</a></td>
<td style="text-align: left;">Not applicable</td>
</tr>
<tr id="result-m22">
<th scope="row" style="text-align: left;">M22</th>
<td style="text-align: left;"><strong>Separable concave terms on few linear rows.</strong> A binary reformulation that allows at most <span class="math inline">\(\mathrm{rank}(A)\)</span> variables strictly inside their concave pieces is solved in <span class="math inline">\(2n+1\)</span> branch-and-cut nodes on a family where spatial branch-and-bound needs exponentially many (M4); the joint hull of concave terms on one row, which for equal widths is the Padberg–Van Roy–Wolsey flow-cover polyhedron in other variables, extended to inequality rows and to indicators with concave costs. Builds on <span class="citation" data-cites="padberg1985fixedcharge"><a href="#ref-padberg1985fixedcharge" role="doc-biblioref">[24]</a></span>.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/tree/84c6be7aad17d085e5343e789885c1cbcbbd4e07/minlp-notes" title="Browse this area’s notes at the cited commit">Notes only</a></td>
<td style="text-align: left;">Possible</td>
</tr>
</tbody>
</table>
</div>

<h3 class="unnumbered" id="quantum-interior-point-methods">Quantum interior-point methods</h3>

<div class="table-wrapper research-inventory" role="region" aria-labelledby="quantum-interior-point-methods" tabindex="0">
<table class="research-inventory-table">
<caption>Quantum interior-point methods</caption>
<thead>
<tr>
<th scope="col" style="text-align: left;">ID</th>
<th scope="col" style="text-align: left;">Working title and claimed contribution</th>
<th scope="col" style="text-align: left;">Write-up</th>
<th scope="col" style="text-align: left;">Lean</th>
</tr>
</thead>
<tbody>
<tr id="result-q1">
<th scope="row" style="text-align: left;">Q1</th>
<td style="text-align: left;"><strong>Objective sublevels and central-path Hessian conditioning.</strong> For every self-concordant barrier, conditioning is <span class="math inline">\(\Theta((\mathrm{diam}\,L(g)/g)^2)\)</span>; LP spectra have two scales.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/qipm-notes/conditioning-paper/main.pdf">Full paper</a></td>
<td style="text-align: left;">Partial</td>
</tr>
<tr id="result-q2">
<th scope="row" style="text-align: left;">Q2</th>
<td style="text-align: left;"><strong>The cost of following the central path.</strong> Sharp central-path movement tax <span class="math inline">\(\Gamma_r=\Theta(\sqrt{\log r})\)</span> for objectives of rank <span class="math inline">\(r\)</span>; on an explicit sparse LP, primal–dual completion requires <span class="math inline">\(\Theta(r^{3/2})\)</span> bounded steps. Builds on <span class="citation" data-cites="nesterov2008centralpaths"><a href="#ref-nesterov2008centralpaths" role="doc-biblioref">[25]</a></span>.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/qipm-notes/central-path-cost/main.pdf">Full paper</a></td>
<td style="text-align: left;">Partial</td>
</tr>
<tr id="result-q3">
<th scope="row" style="text-align: left;">Q3</th>
<td style="text-align: left;"><strong>Access models and right-hand-side mass in Newton solves.</strong> Degenerate-LP Hessians have two eigenvalue clusters that conjugate gradients handles in polylogarithmic iterations, while plain block access keeps the known <span class="math inline">\(\tilde\Theta(\kappa)\)</span> cost; the right-hand side’s coupling to the small eigenvalues decides when filtering helps.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/qipm-notes/paper/main.pdf">Summary document</a></td>
<td style="text-align: left;">Partial</td>
</tr>
<tr id="result-q4">
<th scope="row" style="text-align: left;">Q4</th>
<td style="text-align: left;"><strong>Winner-take-all condensation in block log-determinant SDPs.</strong> Winner mass controls conditioning; tight holonomy value queries, <span class="math inline">\(\Theta(N\sqrt{G})\)</span> quantum versus <span class="math inline">\(\Theta(NG)\)</span> randomized.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/qipm-notes/paper/main.pdf">Summary document</a></td>
<td style="text-align: left;">Possible</td>
</tr>
<tr id="result-q5">
<th scope="row" style="text-align: left;">Q5</th>
<td style="text-align: left;"><strong>Accuracy curves for hidden-block state conversion.</strong> Tight accuracy-dependent query curves for quantum state conversion on proved domains; notes extend the lower bound to any inner predicate, an open problem of the summary document, and give the exact zero-query error in the range it leaves open.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/qipm-notes/paper/main.pdf">Summary document</a></td>
<td style="text-align: left;">Not applicable</td>
</tr>
<tr id="result-q6">
<th scope="row" style="text-align: left;">Q6</th>
<td style="text-align: left;"><strong>Condition-one linear programs with hard loading and recovery.</strong> Sparse LPs with condition-one reduced Newton systems still need linearly many queries to load and recover states.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/qipm-notes/paper/main.pdf">Summary document</a></td>
<td style="text-align: left;">Not applicable</td>
</tr>
<tr id="result-q7">
<th scope="row" style="text-align: left;">Q7</th>
<td style="text-align: left;"><strong>Limits of parity-gadget lower-bound constructions.</strong> Algebraic identities rule out natural classes of parity-gadget lower-bound constructions; notes rule out bounded local full-KKT parity amplifiers, an open problem of the summary document.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/qipm-notes/paper/main.pdf">Summary document</a></td>
<td style="text-align: left;">Partial</td>
</tr>
<tr id="result-q8">
<th scope="row" style="text-align: left;">Q8</th>
<td style="text-align: left;"><strong>Loading and recovery hardness for semidefinite programs.</strong> Trace-normalized SDPs with condition-one Newton steps still have parity-hard values and solution states; notes give genuinely nonabelian <span class="math inline">\(\Theta(N)\)</span> word hardness with a sparse SDP transfer, an open problem of the summary document.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/qipm-notes/paper/main.pdf">Summary document</a></td>
<td style="text-align: left;">Not applicable</td>
</tr>
<tr id="result-q9">
<th scope="row" style="text-align: left;">Q9</th>
<td style="text-align: left;"><strong>Trade-offs between preconditioning and state interfaces.</strong> A better preconditioned condition number is paid for in normalization, recovery sensitivity, or state preparation.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/qipm-notes/paper/main.pdf">Summary document</a></td>
<td style="text-align: left;">Partial</td>
</tr>
<tr id="result-q10">
<th scope="row" style="text-align: left;">Q10</th>
<td style="text-align: left;"><strong>Conditional speedups for sparse quantum interior-point methods.</strong> Conditional per-step gains from certified refresh, face repair, compressed dual output, and block-angular borders.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/qipm-notes/paper/main.pdf">Summary document</a></td>
<td style="text-align: left;">Partial</td>
</tr>
<tr id="result-q11">
<th scope="row" style="text-align: left;">Q11</th>
<td style="text-align: left;"><strong>A correction to the complexity analysis of the quantum central path method.</strong> Both the simulator-norm bound and the clock analysis of arXiv:2311.03977v2 fail as claimed; corrected norm and speed trade-off. The authors informed us that they already knew of at least one error and are preparing a revision; no correction was public when the agents ran.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/qipm-notes/paper/main.pdf">Summary document</a></td>
<td style="text-align: left;">Done</td>
</tr>
<tr id="result-q12">
<th scope="row" style="text-align: left;">Q12</th>
<td style="text-align: left;"><strong>Curvature, support certificates, and barrier complexity of conic lifts.</strong> An exact lift by definable cones of a body with a strictly curved boundary patch needs <span class="math inline">\(\sum_i\max(\dim K_i-2,0)\ge s-1\)</span>; the least support-certificate rank of an <span class="math inline">\(s\)</span>-dimensional ball is exactly <span class="math inline">\(\lceil (s-1)/B\rceil\)</span>; exact barrier parameters for symmetric-cone balance slices. Also: disk-product instances whose central states need <span class="math inline">\(O(1)\)</span> queries but whose scalar readout needs <span class="math inline">\(\Theta(N)\)</span>; with matched oracles at the fiber center, PSD packing gives no query advantage for reduced Newton solves; compilation of sparse second-order cone constraints to barrier parameter at most <span class="math inline">\(k+1\)</span> with <span class="math inline">\(\Theta(\sqrt{Nk})\)</span> quantum versus <span class="math inline">\(\Theta(N)\)</span> randomized queries.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/qipm-notes/conic-lift-complexity/main.pdf">Full paper</a></td>
<td style="text-align: left;">Possible</td>
</tr>
<tr id="result-q13">
<th scope="row" style="text-align: left;">Q13</th>
<td style="text-align: left;"><strong>Classical and quantum query complexity of scalar Newton quantities.</strong> Relative estimation of <span class="math inline">\(b^*H^{-1}b\)</span> with <span class="math inline">\(\kappa\varepsilon^{-2}(d+1)^{O(\sqrt\kappa\log(2/\varepsilon))}\)</span> classical queries and a lower bound matching the known <span class="math inline">\(\tilde
  O(\alpha\kappa/\varepsilon)\)</span> block-access algorithm up to logarithmic factors on <span class="math inline">\(3\times3\)</span> matrices; statistical-query sampling of Newton steps; one-cone sparse SOCP: <span class="math inline">\(O(1)\)</span> quantum queries versus <span class="math inline">\(\tilde\Omega(N^{1-1/k})\)</span> classical statistical queries.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/qipm-notes/scalar-newton-paper/main.pdf">Full paper</a></td>
<td style="text-align: left;">Not applicable</td>
</tr>
<tr id="result-q14">
<th scope="row" style="text-align: left;">Q14</th>
<td style="text-align: left;"><strong>The quantum cost of unit-normalized spectral shifting.</strong> Answers an open problem of the summary document: a sharp query staircase <span class="math inline">\(\Theta(\delta^{-1+1/(2\ell)})\)</span> for block encodings of <span class="math inline">\(I-H\)</span> with normalization one, and <span class="math inline">\(\Theta(\delta^{-1}\log(1/K))\)</span> at high accuracy; a sparse LP separates normal-matrix from factor access.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/qipm-notes/spectral-shift-paper/main.pdf">Full paper</a></td>
<td style="text-align: left;">Not applicable</td>
</tr>
<tr id="result-q15">
<th scope="row" style="text-align: left;">Q15</th>
<td style="text-align: left;"><strong>Exponential-cone scenario compression for entropic risk.</strong> Compresses <span class="math inline">\(N\)</span> scenarios into <span class="math inline">\(O(1+K+\log)\)</span> exponential cones, independent of <span class="math inline">\(N\)</span>, with certified value bounds; matched <span class="math inline">\(\Theta(e^K/\varepsilon)\)</span> quantum versus <span class="math inline">\(\Theta(e^{2K}/\varepsilon^2)\)</span> classical source queries under the stated access model.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/tree/84c6be7aad17d085e5343e789885c1cbcbbd4e07/qipm-notes" title="Browse this area’s notes at the cited commit">Notes only</a></td>
<td style="text-align: left;">Not applicable</td>
</tr>
</tbody>
</table>
</div>

<h3 class="unnumbered" id="molecular-thermodynamics">Molecular thermodynamics</h3>

<div class="table-wrapper research-inventory" role="region" aria-labelledby="molecular-thermodynamics" tabindex="0">
<table class="research-inventory-table">
<caption>Molecular thermodynamics</caption>
<thead>
<tr>
<th scope="col" style="text-align: left;">ID</th>
<th scope="col" style="text-align: left;">Working title and claimed contribution</th>
<th scope="col" style="text-align: left;">Write-up</th>
<th scope="col" style="text-align: left;">Lean</th>
</tr>
</thead>
<tbody>
<tr id="result-td1">
<th scope="row" style="text-align: left;">TD1</th>
<td style="text-align: left;"><strong>Finite reservoirs at phase coexistence: full-state accuracy and phase correlations.</strong> When finite baths reproduce canonical laws; an <span class="math inline">\(N^{3/2}\)</span> threshold for the two-phase systems studied under stated phase-tail conditions; a shared bath of intermediate size drives two copies into opposite phases while each copy alone stays canonical. Builds on <span class="citation" data-cites="riera2012thermalization"><a href="#ref-riera2012thermalization" role="doc-biblioref">[26]</a></span>.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/thermo-notes/paper-finite-reservoirs/main.pdf">Full paper</a></td>
<td style="text-align: left;">Not applicable</td>
</tr>
<tr id="result-td2">
<th scope="row" style="text-align: left;">TD2</th>
<td style="text-align: left;"><strong>Survival-conditioned thermodynamic integration.</strong> Endpoint-survivor force integration is path-dependent, with error of second order in weak killing; interior survivors admit an exact potential.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/tree/84c6be7aad17d085e5343e789885c1cbcbbd4e07/thermo-notes" title="Browse this area’s notes at the cited commit">Notes only</a></td>
<td style="text-align: left;">Possible</td>
</tr>
<tr id="result-td3">
<th scope="row" style="text-align: left;">TD3</th>
<td style="text-align: left;"><strong>Interfacial tension from bulk response in nonlocal double-parabola models.</strong> Exact tension certificates from bulk response; fourth-order moment matching leaves the tension undetermined.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/tree/84c6be7aad17d085e5343e789885c1cbcbbd4e07/thermo-notes" title="Browse this area’s notes at the cited commit">Notes only</a></td>
<td style="text-align: left;">Not applicable</td>
</tr>
<tr id="result-td4">
<th scope="row" style="text-align: left;">TD4</th>
<td style="text-align: left;"><strong>Capacity certificates for reversible nucleation kinetics.</strong> Capacity lower bounds from conditional transport; paired finite-field bounds on nucleation-rate response.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/tree/84c6be7aad17d085e5343e789885c1cbcbbd4e07/thermo-notes" title="Browse this area’s notes at the cited commit">Notes only</a></td>
<td style="text-align: left;">Not applicable</td>
</tr>
</tbody>
</table>
</div>

<h3 class="unnumbered" id="transport-theory">Transport theory</h3>

<div class="table-wrapper research-inventory" role="region" aria-labelledby="transport-theory" tabindex="0">
<table class="research-inventory-table">
<caption>Transport theory</caption>
<thead>
<tr>
<th scope="col" style="text-align: left;">ID</th>
<th scope="col" style="text-align: left;">Working title and claimed contribution</th>
<th scope="col" style="text-align: left;">Write-up</th>
<th scope="col" style="text-align: left;">Lean</th>
</tr>
</thead>
<tbody>
<tr id="result-tp1">
<th scope="row" style="text-align: left;">TP1</th>
<td style="text-align: left;"><strong>Designing surface transport under uncertain kinetics: moment thresholds and measurement precision.</strong> For a small surface-mobility budget <span class="math inline">\(M\)</span>, the best fixed placement raises the disorder-moment order at which rare merging defects dominate from <span class="math inline">\(4/3\)</span> to <span class="math inline">\(8/5\)</span>; observing the defects improves the mean from <span class="math inline">\(M^{-1/4}\)</span> to <span class="math inline">\(M^{-1/5}\)</span>, and resolution of order <span class="math inline">\(M^{1/5}\)</span> suffices. Builds on <span class="citation" data-cites="buttazzo2011randomshape"><a href="#ref-buttazzo2011randomshape" role="doc-biblioref">[27]</a></span>.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/transport-notes/paper-uncertain-mobility/main.pdf">Full paper</a></td>
<td style="text-align: left;">Not applicable</td>
</tr>
<tr id="result-tp2">
<th scope="row" style="text-align: left;">TP2</th>
<td style="text-align: left;"><strong>Kinetic defects in adsorbing channels.</strong> Weak surface diffusion <span class="math inline">\(D_s\)</span> at a quadratic kinetic minimum gives a <span class="math inline">\(D_s^{-1/4}\)</span> dispersion divergence with an explicit crossover to a rate floor; when the minimum’s location is known, optimal placement of a mobility budget <span class="math inline">\(M\)</span> improves the divergence from <span class="math inline">\(M^{-1/4}\)</span> to <span class="math inline">\(M^{-1/5}\)</span>, the known-defect case behind TP1; an exactly solvable placement transition.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/tree/84c6be7aad17d085e5343e789885c1cbcbbd4e07/transport-notes" title="Browse this area’s notes at the cited commit">Notes only</a></td>
<td style="text-align: left;">Not applicable</td>
</tr>
</tbody>
</table>
</div>

<h3 class="unnumbered" id="aggregation-kinetics">Aggregation kinetics</h3>

<div class="table-wrapper research-inventory" role="region" aria-labelledby="aggregation-kinetics" tabindex="0">
<table class="research-inventory-table">
<caption>Aggregation kinetics</caption>
<thead>
<tr>
<th scope="col" style="text-align: left;">ID</th>
<th scope="col" style="text-align: left;">Working title and claimed contribution</th>
<th scope="col" style="text-align: left;">Write-up</th>
<th scope="col" style="text-align: left;">Lean</th>
</tr>
</thead>
<tbody>
<tr id="result-ak1">
<th scope="row" style="text-align: left;">AK1</th>
<td style="text-align: left;"><strong>Sampling-law separation and finite nonlinear corrections in additive coagulation–fragmentation.</strong> Sharp number–mass separation bounds, a finite log-size correction, finite-population breakdown, Fourier identification. Builds on <span class="citation" data-cites="escobedo2002gelation"><a href="#ref-escobedo2002gelation" role="doc-biblioref">[28]</a></span>.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/aggregation-kinetics-notes/paper-additive-coagulation/main.pdf">Full paper</a></td>
<td style="text-align: left;">Not applicable</td>
</tr>
<tr id="result-ak2">
<th scope="row" style="text-align: left;">AK2</th>
<td style="text-align: left;"><strong>Survival under unobserved sister-type dependence in multitype branching.</strong> Uniform near-critical error bounds for extinction over unobserved daughter couplings, with an exact optimal coupling and a rule for tied reproductive values; the basic sharp envelopes follow from known branching and rearrangement results.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/tree/84c6be7aad17d085e5343e789885c1cbcbbd4e07/aggregation-kinetics-notes" title="Browse this area’s notes at the cited commit">Notes only</a></td>
<td style="text-align: left;">Possible</td>
</tr>
</tbody>
</table>
</div>

<h3 class="unnumbered" id="heterogeneous-catalysis-proposed-experimental-programs">Heterogeneous catalysis: proposed experimental programs</h3>

<div class="table-wrapper research-inventory" role="region" aria-labelledby="heterogeneous-catalysis-proposed-experimental-programs" tabindex="0">
<table class="research-inventory-table">
<caption>Heterogeneous catalysis: proposed experimental programs</caption>
<thead>
<tr>
<th scope="col" style="text-align: left;">ID</th>
<th scope="col" style="text-align: left;">Working title and claimed contribution</th>
<th scope="col" style="text-align: left;">Write-up</th>
<th scope="col" style="text-align: left;">Lean</th>
</tr>
</thead>
<tbody>
<tr id="result-ca1">
<th scope="row" style="text-align: left;">CA1</th>
<td style="text-align: left;"><strong>Physical water management in Fischer–Tropsch synthesis.</strong> Tests whether late hydrophobic-polymer addition protects conditioned cobalt; re-analysis of published data finds a product output about 1.9 times that of the reference with the polymer.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/catalysis-notes/manuscript/main.pdf">Program document</a></td>
<td style="text-align: left;">Not applicable</td>
</tr>
<tr id="result-ca2">
<th scope="row" style="text-align: left;">CA2</th>
<td style="text-align: left;"><strong>Steam compatibility of cyclic oxides in chemical looping.</strong> Tests whether steam purges, assumed by a published process model but not tested, change ethylene output from coated LSF; compares CO<span class="math inline">\(_2\)</span> supplied with the steam (protection) and afterwards (recovery).</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/catalysis-notes/manuscript/main.pdf">Program document</a></td>
<td style="text-align: left;">Not applicable</td>
</tr>
<tr id="result-ca3">
<th scope="row" style="text-align: left;">CA3</th>
<td style="text-align: left;"><strong>Catalyst demand in polymer ethenolysis.</strong> Tests whether lower ethylene pressure can replace part of the fresh Na/alumina catalyst when reused catalyst converts polyethylene to propylene.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/catalysis-notes/manuscript/main.pdf">Program document</a></td>
<td style="text-align: left;">Not applicable</td>
</tr>
<tr id="result-ca4">
<th scope="row" style="text-align: left;">CA4</th>
<td style="text-align: left;"><strong>Nickel and the useful life of promoted silver epoxidation catalysts.</strong> Tests whether nickel adds ethylene oxide output beyond chloride policies; a 1995 patent already reports a retention benefit.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/catalysis-notes/manuscript/main.pdf">Program document</a></td>
<td style="text-align: left;">Not applicable</td>
</tr>
<tr id="result-ca5">
<th scope="row" style="text-align: left;">CA5</th>
<td style="text-align: left;"><strong>Tungsten coordination and retention in sugar conversion.</strong> Tests whether a controllable anchoring or feed variable links productive sugar coordination, tungsten loss, and glycol output.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/tree/84c6be7aad17d085e5343e789885c1cbcbbd4e07/catalysis-notes" title="Browse this area’s notes at the cited commit">Notes only</a></td>
<td style="text-align: left;">Not applicable</td>
</tr>
<tr id="result-ca6">
<th scope="row" style="text-align: left;">CA6</th>
<td style="text-align: left;"><strong>Product-rich liquid Ti-zeolite epoxidation.</strong> Tests whether a reaction network calibrated on dilute kinetics predicts epoxide output and peroxide loss once products accumulate.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/tree/84c6be7aad17d085e5343e789885c1cbcbbd4e07/catalysis-notes" title="Browse this area’s notes at the cited commit">Notes only</a></td>
<td style="text-align: left;">Not applicable</td>
</tr>
<tr id="result-ca7">
<th scope="row" style="text-align: left;">CA7</th>
<td style="text-align: left;"><strong>Oxygen fate and self-cleaning in zirconia-catalyzed styrene production.</strong> Tests whether an oxygen-removal pathway predicts sustained styrene output and a feed policy.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/tree/84c6be7aad17d085e5343e789885c1cbcbbd4e07/catalysis-notes" title="Browse this area’s notes at the cited commit">Notes only</a></td>
<td style="text-align: left;">Not applicable</td>
</tr>
<tr id="result-ca8">
<th scope="row" style="text-align: left;">CA8</th>
<td style="text-align: left;"><strong>Acid-site assays and zeolite aging.</strong> Tests whether repeated NH<span class="math inline">\(_3\)</span> and water assays change the hydrothermal aging of H-CHA.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/tree/84c6be7aad17d085e5343e789885c1cbcbbd4e07/catalysis-notes" title="Browse this area’s notes at the cited commit">Notes only</a></td>
<td style="text-align: left;">Not applicable</td>
</tr>
</tbody>
</table>
</div>

Status values:

- **Write-up.** *Full paper*: a complete, compiled manuscript. *Summary document*: part of the long document that collects the quantum interior-point results, which we asked for instead of separate papers. *Program document*: a chapter of the document that ranks the proposed catalysis programs. *Notes only*: the results exist only as the agents’ notes and checks.

- **Lean.** *Done*: the main mathematical results are proved in Lean, with no unproved steps; software and experiments are not covered. *Partial*: some of the results are proved in Lean, but not all. *Possible*: not done, but the main claims are mathematical statements that could be formalized with current libraries; this is a judgement, not a check. *Not applicable*: the main claims rest on numerical evidence, experiments, or modelling assumptions, or require a framework that current formal libraries do not provide, such as complexity classes, quantum query models, or limit theorems for stochastic processes.

<h2 class="unnumbered" id="references">References</h2>

<div id="refs" class="references csl-bib-body" data-entry-spacing="0" role="list">
<div id="ref-alpoge2026-more-than-two-thirds-of" class="csl-entry" role="listitem">
<div class="csl-left-margin">[1] </div><div class="csl-right-inline">L. Alpöge and R. Furman, <span>“<span class="nocase">More than two thirds of the zeta zeros are simple and on the critical line</span>.”</span> 2026. doi: <a href="https://doi.org/10.48550/arxiv.2608.13637">10.48550/arxiv.2608.13637</a>.</div>
</div>
<div id="ref-openai2026navierstokes" class="csl-entry" role="listitem">
<div class="csl-left-margin">[2] </div><div class="csl-right-inline">OpenAI, <span>“On the <span>N</span>avier–<span>S</span>tokes <span>M</span>illennium <span>P</span>rize <span>P</span>roblem.”</span> <a href="https://openai.com/index/navier-stokes-solution/" class="uri">https://openai.com/index/navier-stokes-solution/</a>, Sep. 08, 2026.</div>
</div>
<div id="ref-duraisamy2026navierstokescost" class="csl-entry" role="listitem">
<div class="csl-left-margin">[3] </div><div class="csl-right-inline">K. Duraisamy, <span>“<span>N</span>avier–<span>S</span>tokes regularity, what does the computation cost.. And a cartoon on the state of affairs.”</span> <a href="https://karthik-duraisamy.blogspot.com/2026/09/navier-stokes-regularity-what-does.html" class="uri">https://karthik-duraisamy.blogspot.com/2026/09/navier-stokes-regularity-what-does.html</a>, Sep. 08, 2026.</div>
</div>
<div id="ref-openai2026advisory" class="csl-entry" role="listitem">
<div class="csl-left-margin">[4] </div><div class="csl-right-inline">OpenAI, <span>“Advisory <span>G</span>roup on <span>M</span>athematics and <span>A</span>rtificial <span>I</span>ntelligence.”</span> <a href="https://openai.com/index/advisory-group-on-mathematics-and-ai/" class="uri">https://openai.com/index/advisory-group-on-mathematics-and-ai/</a>, Sep. 21, 2026.</div>
</div>
<div id="ref-gusev2026corpus" class="csl-entry" role="listitem">
<div class="csl-left-margin">[5] </div><div class="csl-right-inline">S. Gusev and D. E. Bernal Neira, <span>“Agent-swarm-research: Notes, drafts, code, and formal proofs produced by <span>AI</span> agent swarms.”</span> <a href="https://github.com/SECQUOIA/agent-swarm-research/tree/84c6be7aad17d085e5343e789885c1cbcbbd4e07" class="uri">https://github.com/SECQUOIA/agent-swarm-research/tree/84c6be7aad17d085e5343e789885c1cbcbbd4e07</a>, 2026.</div>
</div>
<div id="ref-kwa2025-measuring-ai-ability-to-complete" class="csl-entry" role="listitem">
<div class="csl-left-margin">[6] </div><div class="csl-right-inline">T. Kwa <em>et al.</em>, <span>“<span class="nocase">Measuring AI Ability to Complete Long Software Tasks</span>,”</span> in <em>Advances in neural information processing systems 38 (NeurIPS 2025)</em>, 2025. doi: <a href="https://doi.org/10.52202/085713-3086">10.52202/085713-3086</a>.</div>
</div>
<div id="ref-jevons1865coal" class="csl-entry" role="listitem">
<div class="csl-left-margin">[7] </div><div class="csl-right-inline">W. S. Jevons, <em>The coal question: An inquiry concerning the progress of the nation, and the probable exhaustion of our coal-mines</em>. London: Macmillan, 1865.</div>
</div>
<div id="ref-anthropic2026rsp" class="csl-entry" role="listitem">
<div class="csl-left-margin">[8] </div><div class="csl-right-inline">Anthropic, <span>“Anthropic’s responsible scaling policy, version 3.4.”</span> <a href="https://www.anthropic.com/responsible-scaling-policy" class="uri">https://www.anthropic.com/responsible-scaling-policy</a>, Jul. 08, 2026.</div>
</div>
<div id="ref-fields2026declaration" class="csl-entry" role="listitem">
<div class="csl-left-margin">[9] </div><div class="csl-right-inline"><span class="nocase">A. Avila <em>et al.</em></span>, <span>“A severe misalignment of <span>AI</span> in mathematics.”</span> <a href="https://mathandai.org" class="uri">https://mathandai.org</a>, Sep. 11, 2026.</div>
</div>
<div id="ref-luedtke2012multilinear" class="csl-entry" role="listitem">
<div class="csl-left-margin">[10] </div><div class="csl-right-inline">J. Luedtke, M. Namazifar, and J. Linderoth, <span>“Some results on the strength of relaxations of multilinear functions,”</span> <em>Mathematical Programming</em>, vol. 136, no. 2, pp. 325–351, 2012, doi: <a href="https://doi.org/10.1007/s10107-012-0606-z">10.1007/s10107-012-0606-z</a>.</div>
</div>
<div id="ref-halbig2024certificates" class="csl-entry" role="listitem">
<div class="csl-left-margin">[11] </div><div class="csl-right-inline">K. Halbig, L. Hümbs, F. Rösel, L. Schewe, and D. Weninger, <span>“Computing optimality certificates for convex mixed-integer nonlinear problems,”</span> <em>INFORMS Journal on Computing</em>, vol. 36, no. 6, pp. 1579–1610, 2024, doi: <a href="https://doi.org/10.1287/ijoc.2022.0099">10.1287/ijoc.2022.0099</a>.</div>
</div>
<div id="ref-lubin2022representability" class="csl-entry" role="listitem">
<div class="csl-left-margin">[12] </div><div class="csl-right-inline">M. Lubin, J. P. Vielma, and I. Zadik, <span>“Mixed-integer convex representability,”</span> <em>Mathematics of Operations Research</em>, vol. 47, no. 1, pp. 720–749, 2022, doi: <a href="https://doi.org/10.1287/moor.2021.1146">10.1287/moor.2021.1146</a>.</div>
</div>
<div id="ref-beach2022compact" class="csl-entry" role="listitem">
<div class="csl-left-margin">[13] </div><div class="csl-right-inline">B. Beach, R. Hildebrand, and J. Huchette, <span>“Compact mixed-integer programming formulations in quadratic optimization,”</span> <em>Journal of Global Optimization</em>, vol. 84, no. 4, pp. 869–912, 2022, doi: <a href="https://doi.org/10.1007/s10898-022-01184-6">10.1007/s10898-022-01184-6</a>.</div>
</div>
<div id="ref-haugland2016pooling" class="csl-entry" role="listitem">
<div class="csl-left-margin">[14] </div><div class="csl-right-inline">D. Haugland, <span>“The computational complexity of the pooling problem,”</span> <em>Journal of Global Optimization</em>, vol. 64, no. 2, pp. 199–215, 2016, doi: <a href="https://doi.org/10.1007/s10898-015-0335-y">10.1007/s10898-015-0335-y</a>.</div>
</div>
<div id="ref-boland2017pooling" class="csl-entry" role="listitem">
<div class="csl-left-margin">[15] </div><div class="csl-right-inline">N. Boland, T. Kalinowski, and F. Rigterink, <span>“A polynomially solvable case of the pooling problem,”</span> <em>Journal of Global Optimization</em>, vol. 67, no. 3, pp. 621–630, 2017, doi: <a href="https://doi.org/10.1007/s10898-016-0432-6">10.1007/s10898-016-0432-6</a>.</div>
</div>
<div id="ref-dey2020rankone" class="csl-entry" role="listitem">
<div class="csl-left-margin">[16] </div><div class="csl-right-inline">S. S. Dey, B. Kocuk, and A. Santana, <span>“Convexifications of rank-one-based substructures in <span>QCQPs</span> and applications to the pooling problem,”</span> <em>Journal of Global Optimization</em>, vol. 77, no. 2, pp. 227–272, 2020, doi: <a href="https://doi.org/10.1007/s10898-019-00844-4">10.1007/s10898-019-00844-4</a>.</div>
</div>
<div id="ref-bienstock2019acpf" class="csl-entry" role="listitem">
<div class="csl-left-margin">[17] </div><div class="csl-right-inline">D. Bienstock and A. Verma, <span>“Strong <span>NP</span>-hardness of <span>AC</span> power flows feasibility,”</span> <em>Operations Research Letters</em>, vol. 47, no. 6, pp. 494–501, 2019, doi: <a href="https://doi.org/10.1016/j.orl.2019.08.009">10.1016/j.orl.2019.08.009</a>.</div>
</div>
<div id="ref-lehmann2016acfeasibility" class="csl-entry" role="listitem">
<div class="csl-left-margin">[18] </div><div class="csl-right-inline">K. Lehmann, A. Grastien, and P. Van Hentenryck, <span>“<span>AC</span>-feasibility on tree networks is <span>NP</span>-hard,”</span> <em>IEEE Transactions on Power Systems</em>, vol. 31, no. 1, pp. 798–801, 2016, doi: <a href="https://doi.org/10.1109/TPWRS.2015.2407363">10.1109/TPWRS.2015.2407363</a>.</div>
</div>
<div id="ref-blekherman2024aggregations" class="csl-entry" role="listitem">
<div class="csl-left-margin">[19] </div><div class="csl-right-inline">G. Blekherman, S. S. Dey, and S. Sun, <span>“Aggregations of quadratic inequalities and hidden hyperplane convexity,”</span> <em>SIAM Journal on Optimization</em>, vol. 34, no. 1, pp. 98–126, 2024, doi: <a href="https://doi.org/10.1137/22M1528215">10.1137/22M1528215</a>.</div>
</div>
<div id="ref-belotti2025monomials" class="csl-entry" role="listitem">
<div class="csl-left-margin">[20] </div><div class="csl-right-inline">P. Belotti, <span>“Convex envelopes of bounded monomials on two-variable cones,”</span> <em>Mathematical Programming</em>, vol. 211, no. 1–2, pp. 93–123, 2025, doi: <a href="https://doi.org/10.1007/s10107-025-02212-5">10.1007/s10107-025-02212-5</a>.</div>
</div>
<div id="ref-mao2015aggregation" class="csl-entry" role="listitem">
<div class="csl-left-margin">[21] </div><div class="csl-right-inline">T. Mao and R. Wang, <span>“On aggregation sets and lower-convex sets,”</span> <em>Journal of Multivariate Analysis</em>, vol. 138, pp. 170–181, 2015.</div>
</div>
<div id="ref-caprara2010domain" class="csl-entry" role="listitem">
<div class="csl-left-margin">[22] </div><div class="csl-right-inline">A. Caprara and M. Locatelli, <span>“Global optimization problems and domain reduction strategies,”</span> <em>Mathematical Programming</em>, vol. 125, no. 1, pp. 123–137, 2010, doi: <a href="https://doi.org/10.1007/s10107-008-0263-4">10.1007/s10107-008-0263-4</a>.</div>
</div>
<div id="ref-ballerstein2013thesis" class="csl-entry" role="listitem">
<div class="csl-left-margin">[23] </div><div class="csl-right-inline">M. Ballerstein, <span>“Convex relaxations for mixed-integer nonlinear programs,”</span> PhD thesis, ETH Zurich, 2013. doi: <a href="https://doi.org/10.3929/ethz-a-009959194">10.3929/ethz-a-009959194</a>.</div>
</div>
<div id="ref-padberg1985fixedcharge" class="csl-entry" role="listitem">
<div class="csl-left-margin">[24] </div><div class="csl-right-inline">M. W. Padberg, T. J. Van Roy, and L. A. Wolsey, <span>“Valid linear inequalities for fixed charge problems,”</span> <em>Operations Research</em>, vol. 33, no. 4, pp. 842–861, 1985, doi: <a href="https://doi.org/10.1287/opre.33.4.842">10.1287/opre.33.4.842</a>.</div>
</div>
<div id="ref-nesterov2008centralpaths" class="csl-entry" role="listitem">
<div class="csl-left-margin">[25] </div><div class="csl-right-inline">Y. Nesterov and A. Nemirovski, <span>“Primal central paths and <span>Riemannian</span> distances for convex sets,”</span> <em>Foundations of Computational Mathematics</em>, vol. 8, no. 5, pp. 533–560, 2008, doi: <a href="https://doi.org/10.1007/s10208-007-9019-4">10.1007/s10208-007-9019-4</a>.</div>
</div>
<div id="ref-riera2012thermalization" class="csl-entry" role="listitem">
<div class="csl-left-margin">[26] </div><div class="csl-right-inline">A. Riera, C. Gogolin, and J. Eisert, <span>“Thermalization in nature and on a quantum computer,”</span> <em>Physical Review Letters</em>, vol. 108, no. 8, p. 080402, 2012, doi: <a href="https://doi.org/10.1103/PhysRevLett.108.080402">10.1103/PhysRevLett.108.080402</a>.</div>
</div>
<div id="ref-buttazzo2011randomshape" class="csl-entry" role="listitem">
<div class="csl-left-margin">[27] </div><div class="csl-right-inline">G. Buttazzo and F. Maestre, <span>“Optimal shape for elliptic problems with random perturbations,”</span> <em>Discrete and Continuous Dynamical Systems</em>, vol. 31, no. 4, pp. 1115–1128, 2011, doi: <a href="https://doi.org/10.3934/dcds.2011.31.1115">10.3934/dcds.2011.31.1115</a>.</div>
</div>
<div id="ref-escobedo2002gelation" class="csl-entry" role="listitem">
<div class="csl-left-margin">[28] </div><div class="csl-right-inline">M. Escobedo, S. Mischler, and B. Perthame, <span>“Gelation in coagulation and fragmentation models,”</span> <em>Communications in Mathematical Physics</em>, vol. 231, no. 1, pp. 157–188, 2002, doi: <a href="https://doi.org/10.1007/s00220-002-0680-9">10.1007/s00220-002-0680-9</a>.</div>
</div>
</div>
