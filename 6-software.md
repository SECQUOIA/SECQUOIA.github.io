---
layout: page
title: Software
image: assets/images/software.webp
description: 'Open-Source Solvers, Modeling Ecosystems, and Benchmark Libraries'
nav-menu: true
banner_color: style4
---

<!-- markdownlint-disable MD033 -->

<style>
.software-meta {
  font-size: 0.92rem;
  color: var(--fg-light);
  margin-bottom: 1rem;
}

.software-citation {
  font-size: 0.92rem;
  padding: 0.85rem 1.1rem;
  background: var(--fill);
  border-left: 3px solid var(--highlight);
  border-radius: 4px;
  margin: 1rem 0 1.25rem;
}
</style>

<section id="overview">
  <div class="inner">
    <header class="major">
      <h2>Open-Source Software &amp; Benchmarks</h2>
    </header>
    <p>
      SECQUOIA develops and maintains open-source solvers, algebraic reformulation packages, and curated benchmark suites across Python (<code>Pyomo</code>) and Julia (<code>JuMP</code> / <code>JuliaQUBO</code>). Each tool below includes repository links, documentation, licensing, and reference papers for scholarly citation.
    </p>
  </div>
</section>

<section id="mindtpy">
  <div class="inner">
    <header class="major">
      <h2>MindtPy</h2>
    </header>
    <p class="software-meta">
      <strong>Ecosystem:</strong> Python / Pyomo · <strong>License:</strong> BSD-3-Clause · <strong>Role:</strong> Originator &amp; Core Developer
    </p>
    <p>
      The Mixed-Integer Nonlinear Decomposition Toolbox in Pyomo (<strong>MindtPy</strong>) is an open-source solver for Mixed-Integer Nonlinear Programming (MINLP) integrated directly into the <a href="https://github.com/Pyomo/pyomo" target="_blank" rel="noopener noreferrer">Pyomo</a> modeling ecosystem. MindtPy implements modular decomposition strategies that coordinate MILP and NLP subproblem solvers:
    </p>
    <ul>
      <li>Outer Approximation (OA) and Regularized Outer Approximation (ROA)</li>
      <li>LP/NLP-based Single-Tree Branch-and-Bound (LP/NLP BB)</li>
      <li>Global Outer Approximation (GOA) and Extended Cutting Plane (ECP)</li>
      <li>Feasibility Pump (FP) primal heuristics</li>
    </ul>
    <p class="software-citation">
      <strong>Reference papers:</strong> Bernal et al., &ldquo;Mixed-Integer Nonlinear Decomposition Toolbox for Pyomo (MindtPy),&rdquo; <em>Computer Aided Chemical Engineering</em> 44, 895&ndash;900 (2018), <a href="https://doi.org/10.1016/B978-0-444-64241-7.50144-0" target="_blank" rel="noopener noreferrer">doi:10.1016/B978-0-444-64241-7.50144-0</a>; Bernal et al., <em>Journal of Global Optimization</em> 84, 807&ndash;842 (2022), <a href="https://doi.org/10.1007/s10898-022-01178-4" target="_blank" rel="noopener noreferrer">doi:10.1007/s10898-022-01178-4</a>.
    </p>
    <ul class="actions">
      <li><a href="https://pyomo.readthedocs.io/en/stable/explanation/solvers/mindtpy.html" class="button special" target="_blank" rel="noopener noreferrer">Documentation</a></li>
      <li><a href="https://github.com/Pyomo/pyomo/tree/main/pyomo/contrib/mindtpy" class="button" target="_blank" rel="noopener noreferrer">GitHub Source</a></li>
    </ul>
  </div>
</section>

<section id="qubo-jl">
  <div class="inner">
    <header class="major">
      <h2>QUBO.jl &amp; ToQUBO.jl</h2>
    </header>
    <p class="software-meta">
      <strong>Ecosystem:</strong> Julia / JuMP (<a href="https://github.com/JuliaQUBO" target="_blank" rel="noopener noreferrer">JuliaQUBO</a>) · <strong>License:</strong> MIT · <strong>Role:</strong> Co-Creator &amp; Lead Maintainer
    </p>
    <p>
      <strong>QUBO.jl</strong> and <strong>ToQUBO.jl</strong> provide a unified Julia ecosystem for automatically reformulating, analyzing, benchmarking, and solving mathematical optimization models as Quadratic Unconstrained Binary Optimization (QUBO) and Ising instances via <code>MathOptInterface.jl</code> and <code>JuMP.jl</code>:
    </p>
    <ul>
      <li>Automatic compiler from constrained integer, continuous, and disjunctive JuMP models to QUBO (<code>ToQUBO.jl</code>) with tunable variable encodings and penalty tightening</li>
      <li>Standardized file I/O, instance analysis, and visualization tools (<code>QUBOTools.jl</code>)</li>
      <li>Unified solver wrappers for quantum annealers (D-Wave), coherent/classical heuristics, Simulated Bifurcation, and exact baselines (<code>QUBODrivers.jl</code>)</li>
    </ul>
    <p class="software-citation">
      <strong>Reference papers:</strong> Maciel Xavier et al., &ldquo;QUBO.jl: A Julia Ecosystem for Quadratic Unconstrained Binary Optimization,&rdquo; <em>Optimization Methods and Software</em> (2026), <a href="https://doi.org/10.1080/10556788.2026.2702926" target="_blank" rel="noopener noreferrer">doi:10.1080/10556788.2026.2702926</a>; Maciel Xavier et al., &ldquo;Disjunctive Programming meets QUBO,&rdquo; <em>Computer Aided Chemical Engineering</em> 53, 3433&ndash;3438 (2024), <a href="https://doi.org/10.1016/B978-0-443-28824-1.50573-1" target="_blank" rel="noopener noreferrer">doi:10.1016/B978-0-443-28824-1.50573-1</a>.
    </p>
    <ul class="actions">
      <li><a href="https://github.com/JuliaQUBO/QUBO.jl" class="button special" target="_blank" rel="noopener noreferrer">QUBO.jl Repository</a></li>
      <li><a href="https://juliaqubo.github.io/QUBO.jl/" class="button" target="_blank" rel="noopener noreferrer">QUBO.jl Docs</a></li>
      <li><a href="https://github.com/JuliaQUBO/ToQUBO.jl" class="button" target="_blank" rel="noopener noreferrer">ToQUBO.jl Repository</a></li>
      <li><a href="https://juliaqubo.github.io/ToQUBO.jl/stable/" class="button" target="_blank" rel="noopener noreferrer">ToQUBO.jl Docs</a></li>
    </ul>
  </div>
</section>

<section id="gdplib">
  <div class="inner">
    <header class="major">
      <h2>GDPLib</h2>
    </header>
    <p class="software-meta">
      <strong>Ecosystem:</strong> Python / Pyomo.GDP · <strong>License:</strong> BSD-3-Clause · <strong>Role:</strong> Maintainer (SECQUOIA)
    </p>
    <p>
      <strong>GDPLib</strong> is an open-source benchmark collection of Generalized Disjunctive Programming (GDP) models implemented in Pyomo. Covering process superstructure synthesis (such as HDA, catalytic distillation, Kaibel columns, membrane cascades, and heat-exchanger networks), scheduling, and logic-constrained engineering design, GDPLib supports reproducible benchmarking of logic-based solvers and reformulations.
    </p>
    <p class="software-citation">
      <strong>Reference works:</strong> Ovalle et al., &ldquo;Logic-Based Discrete-Steepest Descent: A solution method for process synthesis Generalized Disjunctive Programs,&rdquo; <em>Computers &amp; Chemical Engineering</em> 195, 108993 (2025), <a href="https://doi.org/10.1016/j.compchemeng.2024.108993" target="_blank" rel="noopener noreferrer">doi:10.1016/j.compchemeng.2024.108993</a>; Lee, Kim &amp; Bernal Neira, <a href="https://arxiv.org/abs/2611.05508" target="_blank" rel="noopener noreferrer">arXiv:2611.05508</a> (2026).
    </p>
    <ul class="actions">
      <li><a href="https://github.com/SECQUOIA/gdplib" class="button special" target="_blank" rel="noopener noreferrer">GDPLib GitHub</a></li>
      <li><a href="https://gdplib.readthedocs.io/" class="button" target="_blank" rel="noopener noreferrer">Documentation</a></li>
    </ul>
  </div>
</section>

<section id="pyomo-gdp">
  <div class="inner">
    <header class="major">
      <h2>Pyomo.GDP &amp; GDPOpt</h2>
    </header>
    <p class="software-meta">
      <strong>Ecosystem:</strong> Python / Pyomo · <strong>License:</strong> BSD-3-Clause · <strong>Role:</strong> Co-Author &amp; Contributor
    </p>
    <p>
      <strong>Pyomo.GDP</strong> extends Pyomo with native algebraic representations of logical disjunctions and Boolean propositions, paired with automatic Big-M, Hull, and cutting-plane transformations as well as the <strong>GDPOpt</strong> logic-based outer-approximation (LOA), global logic-based (GLOA), and discrete-steepest-descent (LDSA) solver suite.
    </p>
    <p class="software-citation">
      <strong>Reference paper:</strong> Chen et al., &ldquo;Pyomo.GDP: an ecosystem for logic based modeling and optimization development,&rdquo; <em>Optimization and Engineering</em> 23, 607&ndash;642 (2022), <a href="https://doi.org/10.1007/s11081-021-09601-7" target="_blank" rel="noopener noreferrer">doi:10.1007/s11081-021-09601-7</a>.
    </p>
    <ul class="actions">
      <li><a href="https://pyomo.readthedocs.io/en/stable/modeling_extensions/gdp/index.html" class="button special" target="_blank" rel="noopener noreferrer">Pyomo.GDP Docs</a></li>
      <li><a href="https://pyomo.readthedocs.io/en/stable/explanation/solvers/gdpopt.html" class="button" target="_blank" rel="noopener noreferrer">GDPOpt Docs</a></li>
      <li><a href="https://github.com/Pyomo/pyomo/tree/main/pyomo/gdp" class="button" target="_blank" rel="noopener noreferrer">GitHub Source</a></li>
    </ul>
  </div>
</section>

<section id="benchmarks">
  <div class="inner">
    <header class="major">
      <h2>Benchmark Libraries &amp; Additional Solvers</h2>
    </header>
    <ul>
      <li>
        <strong><a href="https://git.zib.de/qopt/qoblib-quantum-optimization-benchmarking-library" target="_blank" rel="noopener noreferrer">QOBLIB — Quantum Optimization Benchmarking Library</a></strong> (CC-BY-4.0, Co-Author): Curated, hard combinatorial optimization benchmark suite with standardized instance formats and verified classical reference bounds. Cite Koch et al., <em>Nature Computational Science</em> (2026), <a href="https://doi.org/10.1038/s43588-026-00991-1" target="_blank" rel="noopener noreferrer">doi:10.1038/s43588-026-00991-1</a>.
      </li>
      <li>
        <strong><a href="https://portal.nersc.gov/cfs/m888/dcamps/hamlib/" target="_blank" rel="noopener noreferrer">HamLib — Library of Hamiltonians</a></strong> (CC-BY-4.0, Co-Author): Large-scale dataset of condensed-matter, chemistry, and discrete-optimization Hamiltonians for benchmarking quantum simulation and optimization hardware. Cite Sawaya et al., <em>Quantum</em> 8, 1559 (2024), <a href="https://doi.org/10.22331/q-2024-12-11-1559" target="_blank" rel="noopener noreferrer">doi:10.22331/q-2024-12-11-1559</a>.
      </li>
      <li>
        <strong><a href="https://github.com/nasa/PySA" target="_blank" rel="noopener noreferrer">PySA</a> &amp; <a href="https://github.com/usra-riacs/stochastic-benchmark" target="_blank" rel="noopener noreferrer">Stochastic-Benchmark</a></strong> (Open Source, Contributor / Developer): High-performance simulated annealing / parallel tempering in Python (NASA) and statistical solver-evaluation framework (USRA-RIACS / NASA QuAIL).
      </li>
      <li>
        <strong><a href="https://www.gams.com/latest/docs/S_DICOPT.html" target="_blank" rel="noopener noreferrer">DICOPT</a></strong> (GAMS Commercial MINLP Solver, Contributor): Feasibility-pump enhancements for convex and nonconvex MINLP; cite Bernal et al., <em>Optimization Methods and Software</em> 35(1), 171&ndash;190 (2020), <a href="https://doi.org/10.1080/10556788.2019.1641498" target="_blank" rel="noopener noreferrer">doi:10.1080/10556788.2019.1641498</a>.
      </li>
    </ul>
    <ul class="actions">
      <li><a href="https://github.com/SECQUOIA" class="button special" target="_blank" rel="noopener noreferrer">SECQUOIA GitHub Organization</a></li>
      <li><a href="/5-research.html" class="button">Research Themes</a></li>
      <li><a href="/4-publications.html" class="button">Publications</a></li>
      <li><a href="/#launch" class="button icon fa-arrow-left">Go back to launch page</a></li>
    </ul>
  </div>
</section>
