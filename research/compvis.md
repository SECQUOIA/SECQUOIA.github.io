---
layout: mdpage
title: Computer Vision for Process Control
image: assets/images/compvis_sensor.png
description: 'Designing Robust Computer Vision Sensors'
nav-menu: false
show_tile: false
banner_color: style5
---

# Background
Computer vision sensors can <b>rapidly interpret photo/video data</b> signals (increasingly available in manufacturing facilities) to inform automated decision-making/control workflows (e.g., optimizing production and detecting anomalies) which promote the <b>increased safety, efficiency, sustainability, and reliability</b> of process systems. Illustrative applications include flare stack control, conveyor belt monitoring, temperature distribution control, and quality control. However, such computer vision aided control paradigms have seen limited investigation in process systems engineering and are only starting to generally emerge in industrial applications (despite significant industrial interest). Here, key challenges include <b>validating</b> control architecture robustness, designing computer vision strategies with <b>limited data</b>, and <b>assessing sensor health</b> in real-time.

# Real-Time Monitoring via SAFE-OCC
A key vulnerability computer vision sensors introduce is <b>erroneous measurement</b> when subjected to uncertain visual disturbances, which can incur severe safety/profitability consequences. In close collaboration with ExxonMobil, I used my data-science expertise to develop a <b>tailored novelty detection framework</b> to rapidly assess the sensor prediction quality in real-time. Exploiting unique aspects of the CNN architecture, my approach incurs a significantly <b>lower overhead and higher accuracy</b> than off-the-shelf methods; moreover, it is part of a <b>pending U.S. patent</b>. Recently, to generalize this work I proposed the Sensor Activated Feature Extraction One-Class Classification (SAFE-OCC) novelty detection framework for general computer vision sensors.

# Simulation for Verification
my group will develop computational methods to <b>design, validate, and operate computer vision aided process control systems</b>. This work will entail 3 deliverables: (1) a computer vision process simulator, (2) <b>optimization-based validation</b> strategies that integrate with (1), and (3) a SAFE-OCC novelty detection framework with <b>uncertainty quantification</b>. Establishing (1) will enable us to generate large synthetic datasets, test sensor configuration designs, access a wide scenario envelope in (2), and <b>accelerate future research</b>. Moreover, (2) and (3) will enable us to assess computer vision <b>sensor robustness</b> both offline and online. My experience in this area coupled with my expertise in software development, data-science, decision-making, and process control puts my group in a unique position to tackle (1)-(3).