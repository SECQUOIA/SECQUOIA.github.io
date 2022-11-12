---
layout: mdpage
title: Random Field Optimization
image: assets/images/random_field.jpg
description: 'Decision-Making under Uncertainty for Space-time'
nav-menu: false
show_tile: false
banner_color: style5
---

# Background
Many systems in engineering and science are modeled using variables that live on <b>continuous domains</b> (e.g., space-time), making them infinite-dimensional (i.e., variables are functions). Specific engineering applications include REE-CM supply chains, wildfire simulations, process systems, climate modeling, reaction surfaces, microbial communities, complex fluid flows, and molecular dynamics. My [unifying abstraction](/research/infiniteopt.md) (InfiniteOpt) enables simultaneous innovation across these areas. Here, incorporating \textbf{random phenomena} (e.g., wind, porosity, random particle trajectories) is vital in many applications, but this is rarely done in practice due to the difficulty in representing/solving such problems. 

<b>Random field theory</b> provides a powerful mathematical abstraction for characterizing uncertainty over space-time. Random fields generalize of the stochastic processes and Gaussian processes that are at the forefront of current research in the fields of spatio-temporal modeling, machine learning, topological data analysis, and Bayesian optimization. Here, application areas have included functional brain imaging, computer-generated imagery, weather forecasting, structural topological design, and robotic modeling. However, random field theory has not been incorporated into optimization theory. 

# My Innovation
<img src="../assets/images/rfo.png" style="max-width:900px;width:100%">

Using my unifying abstraction, I proposed a new optimization framework called <b>random field optimization</b> that incorporates random field uncertainty into mathematical decision-making problems. This enables us to better capture <b>real-world behavior</b> and tackle emergent applications. Building upon this foundation, we will develop tractable <b>high-fidelity solution</b> approaches by potentially adapting PDE-constrained optimization decomposition techniques. 

