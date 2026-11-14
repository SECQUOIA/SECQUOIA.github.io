---
layout: page
title: Research
image: assets/images/ideas.webp
description: 'Research Themes, Representative Works, and Sponsors'
nav-menu: true
banner_color: style5
---

<!-- markdownlint-disable MD033 -->

<style>
.research-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(min(100%, 28rem), 1fr));
  gap: 1.75rem;
  margin-top: 1.5rem;
}

.research-card {
  background: var(--fill);
  border: 1px solid var(--border);
  border-radius: 6px;
  padding: 1.75rem;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.research-card header.major {
  margin-bottom: 1rem;
}

.research-card h3 {
  margin-bottom: 0.4rem;
}

.research-evidence {
  margin-top: 1rem;
  padding-top: 0.9rem;
  border-top: 1px solid var(--border);
  font-size: 0.92rem;
}

.research-evidence p {
  margin: 0 0 0.5rem;
}

.research-evidence p:last-child {
  margin-bottom: 0;
}

.sponsors-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(min(100%, 22rem), 1fr));
  gap: 1.25rem;
  margin-top: 1.25rem;
}

.sponsor-card {
  background: var(--fill);
  border: 1px solid var(--border);
  border-radius: 6px;
  padding: 1.35rem 1.5rem;
}

.sponsor-card h3 {
  margin-bottom: 0.5rem;
}

.sponsor-card ul {
  margin-bottom: 0;
}
</style>

<section id="overview">
  <div class="inner">
    <header class="major">
      <h2>Research Overview</h2>
    </header>
    <p>
      SECQUOIA's research unifies mathematical optimization, process systems engineering, quantum and emerging computing architectures, privacy-preserving machine learning, and open-source scientific software. Across these connected pillars, we develop rigorous models, scalable algorithms, and curated benchmark suites that translate theory into deployable tools for chemical, energy, materials, and biomedical systems. Read our <a href="/mission/">Mission &amp; Vision</a> or explore opportunities on <a href="/join/">Join Us</a>.
    </p>

    <div id="projects" class="research-grid">
      <article class="research-card" id="optimization">
        <div>
          <header class="major">
            <h3>Mathematical Optimization, GDP, and MINLP</h3>
          </header>
          <p>
            We develop theory, convexification and hull reformulations, decomposition algorithms, and derivative-free configuration search methods for Generalized Disjunctive Programming (GDP) and Mixed-Integer Nonlinear Programming (MINLP). Representative directions include regularized outer approximation, logic-based discrete steepest descent, quadratic disjunctive programming, and hybrid branch-and-bound methods.
          </p>
        </div>
        <div class="research-evidence">
          <p><strong>Representative works:</strong> <a href="https://doi.org/10.1016/j.ejor.2025.07.016" target="_blank" rel="noopener noreferrer">50 Years of MINLP &amp; GDP (<em>EJOR</em>, 2026)</a> · <a href="https://doi.org/10.1021/acs.iecr.5c03172" target="_blank" rel="noopener noreferrer">Reaggregated Hull Reformulation (<em>IECR</em>, 2026)</a> · <a href="https://doi.org/10.1007/s10898-022-01178-4" target="_blank" rel="noopener noreferrer">Regularized OA (<em>J. Glob. Optim.</em>, 2022)</a></p>
          <p><strong>Software &amp; articles:</strong> <a href="/6-software.html#mindtpy">MindtPy</a> · <a href="/6-software.html#pyomo-gdp">Pyomo.GDP</a> · <a href="{{ '/gdp-configuration-search/' | relative_url }}">Derivative-Free GDP Search</a></p>
        </div>
      </article>

      <article class="research-card" id="pse">
        <div>
          <header class="major">
            <h3>Process Systems Engineering and Sustainable Operations</h3>
          </header>
          <p>
            Our optimization frameworks address core synthesis, design, and operational challenges in process systems engineering—spanning catalytic distillation and process intensification, reverse electrodialysis and water-energy networks, refinery scheduling, bio-based chemical manufacturing, and resilient supply chains.
          </p>
        </div>
        <div class="research-evidence">
          <p><strong>Representative works:</strong> <a href="https://doi.org/10.1016/j.compchemeng.2024.108993" target="_blank" rel="noopener noreferrer">Logic-Based Discrete-Steepest Descent (<em>Comput. Chem. Eng.</em>, 2025)</a> · <a href="https://doi.org/10.1002/aic.70656" target="_blank" rel="noopener noreferrer">Ising Solvers for Process Optimization (<em>AIChE J.</em>, 2026)</a> · <a href="https://doi.org/10.1021/acs.iecr.7b04205" target="_blank" rel="noopener noreferrer">Simultaneous Design &amp; Control (<em>IECR</em>, 2018)</a></p>
          <p><strong>Software &amp; articles:</strong> <a href="/6-software.html#gdplib">GDPLib</a> · <a href="{% post_url 2026-08-19-hda-revisited %}">Revisiting the HDA Process Synthesis Problem</a></p>
        </div>
      </article>

      <article class="research-card" id="quantum">
        <div>
          <header class="major">
            <h3>Quantum Optimization, Simulation, and Benchmarking</h3>
          </header>
          <p>
            We investigate how gate-model quantum processors, quantum annealers, coherent Ising machines, and GPU-accelerated tensor networks tackle structured discrete optimization and Hamiltonian simulation problems. Work spans hybrid quantum-classical decomposition, QUBO/Ising encodings, circuit transpilation, and utility-scale hardware evaluation.
          </p>
        </div>
        <div class="research-evidence">
          <p><strong>Representative works:</strong> <a href="https://doi.org/10.1038/s43588-026-00991-1" target="_blank" rel="noopener noreferrer">QOBLIB (<em>Nat. Comput. Sci.</em>, 2026)</a> · <a href="https://doi.org/10.1103/PhysRevApplied.23.014045" target="_blank" rel="noopener noreferrer">Superconducting Max-Cut Benchmark (<em>Phys. Rev. Appl.</em>, 2025)</a> · <a href="https://doi.org/10.22331/q-2024-12-11-1559" target="_blank" rel="noopener noreferrer">HamLib (<em>Quantum</em>, 2024)</a></p>
          <p><strong>Software &amp; tutorials:</strong> <a href="/6-software.html#qubo-jl">QUBO.jl &amp; ToQUBO.jl</a> · <a href="/6-software.html#benchmarks">QOBLIB &amp; HamLib</a> · <a href="/cbctq2026-tutorial/">Quantum OR Tutorial</a></p>
        </div>
      </article>

      <article class="research-card" id="ai-ml">
        <div>
          <header class="major">
            <h3>Scientific AI, Federated Learning, and Autonomous Research</h3>
          </header>
          <p>
            We design machine learning and AI methodologies that respect physical constraints, distributed data ownership, and scientific verification—covering privacy-preserving federated and quantum-federated learning across chemical engineering and healthcare, surrogate/Bayesian circuit optimization, and multi-agent AI research workflows.
          </p>
        </div>
        <div class="research-evidence">
          <p><strong>Representative works:</strong> <a href="https://doi.org/10.1021/acs.iecr.4c03805" target="_blank" rel="noopener noreferrer">Federated Learning in ChE (<em>IECR</em>, 2025)</a> · <a href="https://doi.org/10.1088/2632-2153/ad8c11" target="_blank" rel="noopener noreferrer">Tensor-Network Federated Learning (<em>Mach. Learn.: Sci. Technol.</em>, 2024)</a> · <a href="https://arxiv.org/abs/2609.35719" target="_blank" rel="noopener noreferrer">AI Agent Swarms as Researchers (2026)</a></p>
          <p><strong>Articles &amp; courses:</strong> <a href="{{ '/ai-agents-can-already-do-research/' | relative_url }}">AI Agents Can Already Do Research</a> · <a href="/teaching/courses.html">CHE 597 Data Science in ChE</a></p>
        </div>
      </article>

      <article class="research-card" id="software-benchmarks">
        <div>
          <header class="major">
            <h3>Open-Source Software, Problem Libraries, and Reproducibility</h3>
          </header>
          <p>
            Reproducible open-source software is a first-class scholarly output of our group. We build and maintain algebraic modeling extensions, MINLP/GDP decomposition solvers, problem reformulation compilers, and community benchmark suites across the Python (<code>Pyomo</code>) and Julia (<code>JuMP</code> / <code>JuliaQUBO</code>) ecosystems.
          </p>
        </div>
        <div class="research-evidence">
          <p><strong>Representative works:</strong> <a href="https://doi.org/10.1080/10556788.2026.2702926" target="_blank" rel="noopener noreferrer">QUBO.jl (<em>Optim. Methods Softw.</em>, 2026)</a> · <a href="https://doi.org/10.1007/s11081-021-09601-7" target="_blank" rel="noopener noreferrer">Pyomo.GDP (<em>Optim. Eng.</em>, 2022)</a> · <a href="https://doi.org/10.1016/B978-0-444-64241-7.50144-0" target="_blank" rel="noopener noreferrer">MindtPy (<em>PSE</em>, 2018)</a></p>
          <p><strong>Explore packages:</strong> <a href="/6-software.html">All SECQUOIA Software &amp; Benchmarks</a> · <a href="https://github.com/SECQUOIA" target="_blank" rel="noopener noreferrer">SECQUOIA GitHub</a></p>
        </div>
      </article>
    </div>
  </div>
</section>

<section id="sponsors">
  <div class="inner">
    <header class="major">
      <h2>Sponsors &amp; Acknowledgments</h2>
    </header>
    <p>
      Research in SECQUOIA has been generously supported by federal agencies, industry partners, multi-university quantum centers, and institutional awards:
    </p>
    <div class="sponsors-grid">
      <div class="sponsor-card">
        <h3>Federal Research Grants</h3>
        <ul>
          <li><strong>National Science Foundation (NSF)</strong> — Award <code>2430617</code>, <em>Hybrid Quantum Algorithms for Structured Optimization Problems in PSE</em>.</li>
          <li><strong>NSF Center for Quantum Technologies (CQT)</strong> — Award <code>2224960</code>, <em>Decomposition-Based Approaches for Practical Quantum Optimization</em>.</li>
          <li><strong>National Science Foundation (NSF)</strong> — Award <code>2234175</code> (supplement to <code>2132142</code>), <em>Enabling Quantum Computing Platform Access</em>.</li>
        </ul>
      </div>
      <div class="sponsor-card">
        <h3>Industry &amp; Consortium Partners</h3>
        <ul>
          <li><strong>Allstate</strong> — <em>Quantum Machine Learning for Insurance Prediction</em>.</li>
          <li><strong>Quantum Computing Inc. (QCi)</strong> — <em>Decomposition Algorithms for Entropy Quantum Computers</em>.</li>
          <li><strong>Quantum Collaborative</strong> (Arizona State University) — Summit Seed Award on Qudit-Based Quadratic Integer Programming.</li>
        </ul>
      </div>
      <div class="sponsor-card">
        <h3>Institutional Support</h3>
        <ul>
          <li><strong>Purdue University</strong> — Mitchel Papanicolas Family / Del Ray Glass Company Rising Star Assistant Professorship in Chemical Engineering.</li>
          <li><strong>Purdue College of Engineering &amp; College of Science</strong> — Joint Quantum Optimization Seed Grant.</li>
        </ul>
      </div>
    </div>
  </div>
</section>

<section>
  <div class="inner">
    <ul class="actions">
      <li><a href="/4-publications.html" class="button special">Browse Publications</a></li>
      <li><a href="/6-software.html" class="button">Open-Source Software</a></li>
      <li><a href="/2-members.html" class="button">Meet the Team</a></li>
      <li><a href="/join/" class="button">Join Us / Collaborate</a></li>
      <li><a href="/#launch" class="button icon fa-arrow-left">Go back to launch page</a></li>
    </ul>
  </div>
</section>
