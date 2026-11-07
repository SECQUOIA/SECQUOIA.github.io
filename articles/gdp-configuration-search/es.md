---
layout: post
title: "Encontrar mejores diseños de procesos sin evaluarlos todos"
description: "Cómo la optimización sin derivadas conecta modelos de procesos, simuladores y decisiones de diseño difíciles"
author: "Albert Joon Lee, Woosik Kim y David E. Bernal Neira"
image: assets/images/gdp-configuration-search/cover-es.webp
social_image: /assets/images/gdp-configuration-search/cover-es.png
social_image_alt: "Portada de SECQUOIA: tres diagramas de flujo de procesos candidatos, con el diseño central resaltado en dorado para su evaluación."
methodology_image_alt: "Proponer una configuración. Evaluar el diseño seleccionado. Elegir la siguiente configuración."
social_image_width: 1200
social_image_height: 630
date: 2026-11-07 08:00:00 -0500
permalink: /es/gdp-configuration-search/
lang: es
translation_key: gdp-configuration-search
nav-menu: false
show_tile: false
---

<link rel="stylesheet" href="{{ '/assets/css/ai-agents-research.css' | relative_url }}">
<script defer src="{{ '/assets/js/reference-previews.js' | relative_url }}"></script>

*Cómo la optimización sin derivadas conecta modelos de procesos, simuladores y decisiones de diseño difíciles*

**Albert Joon Lee, Woosik Kim y David E. Bernal Neira** · Universidad Purdue · noviembre de 2026

<p class="article-cover">
  <a href="{{ '/assets/images/gdp-configuration-search/cover-es.png' | relative_url }}" aria-label="Abrir la portada a tamaño completo" title="Abrir la portada a tamaño completo">
    <img src="{{ '/assets/images/gdp-configuration-search/cover-es.webp' | relative_url }}" alt="{{ page.social_image_alt | escape }}" width="1200" height="630" decoding="async">
  </a>
</p>

[El enfoque](#model-and-search) · [Los experimentos](#what-we-tested) · [Lecciones prácticas](#choosing-a-method) · [Artículo](#references)

Antes de optimizar un proceso químico, los ingenieros deben decidir qué proceso construir.
¿Qué reactores debe contener?
¿Cuántas etapas de separación?
¿Dónde deben entrar las alimentaciones?
Estas decisiones determinan las ecuaciones que describen la planta, las condiciones de operación que puede alcanzar y, en última instancia, su desempeño.

La dificultad es que evaluar un diseño ya puede ser un problema de optimización considerable.
Para comparar dos configuraciones de reactores, puede ser necesario optimizar las temperaturas, los caudales y los tamaños de los equipos de cada una.
Si el proceso se describe mediante un simulador, una evaluación puede requerir muchas ejecuciones de simulación.
Explorar exhaustivamente un gran conjunto de alternativas de diseño puede volverse demasiado costoso en poco tiempo.

Nuestro nuevo artículo, [*Generalized Disjunctive Programming with Derivative-Free Configuration Search*](https://arxiv.org/abs/2611.05508), estudia cómo elegir esas evaluaciones de manera más eficaz.
En nuestros experimentos, métodos de búsqueda establecidos encontraron diseños de alta calidad utilizando una pequeña fracción de las evaluaciones necesarias para examinar todas las configuraciones.
El mismo enfoque también funcionó con un simulador de procesos farmacéuticos y con un modelo de destilación catalítica cuyas formulaciones convencionales de optimización resultaron difíciles de resolver.

<h2 class="unnumbered" id="model-and-search">El modelo y la búsqueda</h2>

El punto de partida es la programación disyuntiva generalizada, o GDP por sus siglas en inglés.
La GDP describe las alternativas y sus relaciones lógicas: seleccionar un equipo activa sus ecuaciones; excluirlo elimina esas ecuaciones del diseño seleccionado.
Las reglas permiten expresar qué decisiones requieren otras y qué combinaciones están prohibidas.
Esto brinda a los ingenieros una manera natural de describir un proceso con muchas configuraciones posibles.

Los métodos convencionales resuelven estos modelos combinando las alternativas en un problema de optimización no lineal entera mixta o descomponiendo el modelo en problemas más pequeños.
Estos enfoques tienen una larga trayectoria en la optimización de procesos.
Sin embargo, requieren acceso a las ecuaciones que describen cada alternativa, y un simulador puede no exponer esas ecuaciones.
Incluso cuando todas las ecuaciones están disponibles, la formulación combinada puede presentar dificultades numéricas.

Nuestro enfoque se basa en una representación existente en la que las variables enteras identifican las decisiones de diseño.
Una configuración se convierte en un punto en un sistema de coordenadas enteras.
Una vez seleccionado ese punto, fijamos las decisiones sobre los equipos y optimizamos las variables de operación restantes.

Esto crea una interfaz sencilla entre el modelo del proceso y la búsqueda:

<figure id="research-setup" class="research-setup">
  <a class="research-diagram" href="{{ '/assets/images/gdp-configuration-search/methodology-es.png' | relative_url }}" aria-label="Abrir el diagrama a tamaño completo" title="Abrir el diagrama a tamaño completo">
    <img src="{{ '/assets/images/gdp-configuration-search/methodology-es.webp' | relative_url }}" alt="{{ page.methodology_image_alt | escape }}" width="1200" height="630" loading="lazy" decoding="async">
  </a>
  <ol class="research-steps">
    <li>
      <span class="step-number" aria-hidden="true">01</span>
      <h3>Proponer una configuración.</h3>
      <p>Seleccionar las alternativas de equipos que el modelo evaluará.</p>
    </li>
    <li>
      <span class="step-number" aria-hidden="true">02</span>
      <h3>Evaluar el diseño seleccionado.</h3>
      <p>Optimizar o simular esa configuración y devolver su desempeño.</p>
    </li>
    <li>
      <span class="step-number" aria-hidden="true">03</span>
      <h3>Elegir la siguiente configuración.</h3>
      <p>Usar los resultados acumulados para orientar la siguiente propuesta.</p>
    </li>
  </ol>
  <figcaption><strong>Figura 1.</strong> La GDP describe las alternativas y su lógica.
  La búsqueda usa los resultados de las evaluaciones para elegir qué diseño probar a continuación.</figcaption>
</figure>

El modelo GDP sigue describiendo las alternativas, su lógica y la forma en que se evalúa cada diseño.
La búsqueda externa solo necesita los resultados de las evaluaciones.
Por lo tanto, cualquier método adecuado de optimización sin derivadas que maneje variables enteras puede explorar estas configuraciones.

Algunos métodos exploran diseños cercanos y avanzan hacia mejoras.
Otros construyen modelos sustitutos: aproximaciones de bajo costo de la relación entre las decisiones de diseño y el desempeño.
Estas aproximaciones ayudan al algoritmo a decidir si conviene refinar una región prometedora o explorar otra.
Aquí, «sin derivadas» se refiere a la búsqueda externa de configuraciones; la optimización dentro de cada configuración puede seguir utilizando derivadas.

<h2 class="unnumbered" id="what-we-tested">Qué probamos</h2>

Comparamos el descenso local, la búsqueda directa, varios métodos con modelos sustitutos y el muestreo uniforme, junto con métodos convencionales de GDP y la enumeración completa.
Los experimentos incluyeron nueve modelos de procesos, 21 funciones matemáticas de prueba, una simulación de fabricación farmacéutica y una columna de destilación catalítica.
Tres casos ilustran las distintas razones por las que la búsqueda de configuraciones puede ser útil.

<h2 class="unnumbered" id="reactor-network">Menos resoluciones para una red de reactores</h2>

El primero es una red de reactores.
Sus decisiones de diseño incluyen cuántos reactores usar y dónde entran o se recirculan las corrientes.
La red más grande de nuestro estudio tiene 465 configuraciones admisibles.
Evaluarlas todas requiere resolver 465 subproblemas de optimización continua.

Los métodos con modelos sustitutos MISO y RBFOpt alcanzaron el valor de referencia de la función objetivo en las diez ejecuciones y en nueve de las diez, respectivamente, con una mediana de aproximadamente 30 subproblemas resueltos.
Eso representa aproximadamente el 6–7% del trabajo necesario para la enumeración.

Las trayectorias de búsqueda ayudan a explicar la diferencia.
En las redes más grandes, el descenso local se estancó repetidamente en la misma configuración de menor calidad.
Los cambios cercanos no ofrecían mejoras, aunque existía un diseño mejor en otra parte.
En la red más grande, este mínimo local era aproximadamente un 13% peor que la referencia.
Dar a un método de descenso un mayor presupuesto de evaluaciones tuvo poco efecto una vez que se había detenido allí.

RBFOpt y MISO podían proponer configuraciones alejadas de su mejor diseño hasta ese momento.
En este caso, esa capacidad les ayudó a alcanzar una región que la búsqueda local a menudo no encontraba.
La ventaja provino de elegir una secuencia diferente de diseños para evaluar.

<h2 class="unnumbered" id="process-simulator">Trabajar con un simulador de procesos</h2>

El segundo ejemplo es un proceso de fabricación del fármaco anticancerígeno lomustina.
Aquí, distintas combinaciones de reactores y cristalizadores definen 36 diagramas de flujo de proceso posibles.
Su comportamiento se evalúa con el simulador de procesos PharmaPy.

Para este problema, el simulador proporciona los resultados de operar un diseño, mientras que las ecuaciones explícitas que requieren los solucionadores algebraicos convencionales de GDP no están disponibles.
La búsqueda de configuraciones puede continuar de todos modos: elegir los equipos, optimizar su operación mediante simulación y devolver el desempeño resultante.

Con un presupuesto de 20 evaluaciones de configuraciones, RBFOpt y MISO encontraron la mejor configuración registrada en las diez ejecuciones.
La optimización de la operación de cada configuración tomó minutos, por lo que el costo de elegir el siguiente diseño fue pequeño en relación con el de evaluarlo.

Este ejemplo es relevante porque quienes diseñan procesos a menudo ya cuentan con un simulador en el que confían.
Conectar ese simulador con una búsqueda externa permite explorar alternativas de equipos y conservar el entorno de modelado existente.

<h2 class="unnumbered" id="catalytic-column">Una columna con más de 100,000 configuraciones</h2>

El tercer ejemplo combina reacción química y separación en una columna de destilación catalítica.
Su diseño incluye decisiones sobre las ubicaciones de las alimentaciones, las etapas catalíticas y la estructura de la columna.
El modelo GDP completo contiene 100,947 configuraciones.
Realizamos la búsqueda en un dominio restringido con 54,159 configuraciones admisibles, lo suficientemente grande como para que evaluar cada diseño siguiera siendo costoso.

Con un presupuesto de 100 evaluaciones, D-SDA y MISO alcanzaron cada uno el mejor diseño conocido en tres de las diez ejecuciones.
Las coincidencias exactas fueron poco frecuentes, pero muchas ejecuciones terminaron cerca.
Las medianas de los resultados de D-SDA, NOMAD y MISO quedaron dentro de un margen del 0.14% respecto del mejor valor conocido de la función objetivo tras evaluar aproximadamente el 0.2% del dominio de búsqueda.

El descenso local fue competitivo en este caso.
Los buenos diseños ocupaban una región que a menudo podía alcanzar y refinar.
Esto ofrece un contrapunto útil a las redes de reactores: el valor de un método de búsqueda depende de cómo se distribuyen los diseños buenos y malos.

Las formulaciones convencionales no lineales enteras mixtas encontraron dificultades más graves.
Desde el punto inicial publicado, ninguno de los solucionadores probados encontró un diseño a menos del 15% de la referencia en las condiciones reportadas.
Las comprobaciones adicionales produjeron declaraciones de infactibilidad contradichas por diseños factibles y certificados de optimalidad global contradichos por soluciones mejores.

Una explicación plausible es la carga numérica de mantener las ecuaciones de todas las etapas y posiciones de catalizador posibles en una formulación combinada.
Las ecuaciones asociadas con equipos ausentes pueden seguir generando dificultades en las relajaciones del solucionador.
Evaluar una configuración fija nos permite resolver únicamente las ecuaciones que pertenecen a ese diseño.
En estos experimentos, los diseños individuales pudieron evaluarse con éxito incluso cuando las formulaciones combinadas resultaron poco confiables.

<h2 class="unnumbered" id="choosing-a-method">Elegir un método de búsqueda</h2>

De estos casos se desprenden varias lecciones prácticas.

La primera es que el costo de una evaluación debe influir en la elección del método de búsqueda.
Construir y actualizar un modelo sustituto toma tiempo.
Si una configuración puede evaluarse casi al instante, ese costo adicional puede superar el ahorro de evaluaciones.
Para los modelos algebraicos pequeños de nuestro estudio, la enumeración o una reformulación convencional solía ser la opción más sencilla y rápida.
Cuando las evaluaciones requieren una optimización o una simulación costosa, vale la pena dedicar más esfuerzo a elegir la siguiente.

La segunda es que la representación de las decisiones importa.
Las coordenadas enteras definen qué configuraciones parecen cercanas entre sí.
Para decisiones con un orden natural, como el número de etapas, esa relación es intuitiva.
Para categorías como los tipos de reactores, el orden asignado puede ser arbitrario.
Reordenar esas alternativas cambió el comportamiento de varios métodos en los experimentos de lomustina.
La interfaz entre el modelo y la búsqueda merece atención, al igual que el propio algoritmo.

La tercera es que alcanzar exactamente un valor de referencia de la función objetivo ofrece una visión incompleta.
Un método puede no alcanzar un objetivo estricto y, aun así, producir de manera consistente diseños lo suficientemente cercanos para un estudio de ingeniería.
La comparación de métodos debe incluir la calidad y la variabilidad de sus diseños finales, el número de evaluaciones y el costo computacional total.

<h2 class="unnumbered" id="limits">Qué establecen estos resultados</h2>

Estos experimentos también tienen límites en cuanto a lo que permiten establecer.
La mayoría de los problemas de prueba utilizaron respuestas de configuraciones almacenadas para comparar estrategias de búsqueda; en el caso de la columna catalítica, las configuraciones nuevas solicitadas se evaluaron durante la búsqueda.
La optimización continua de una configuración puede devolver una solución local.
Nuestras comparaciones utilizaron un número limitado de ejecuciones repetidas, y la referencia de la columna catalítica es el mejor diseño encontrado, sin una prueba confiable de optimalidad global.

<h2 class="unnumbered" id="next-steps">Qué probar a continuación</h2>

Los experimentos respaldan un papel más amplio de la GDP como marco de modelado.
Una vez que sus decisiones de diseño se conectan con un procedimiento de evaluación, podemos elegir una estrategia de búsqueda adecuada para el problema: enumeración para un dominio pequeño, descenso local cuando el espacio de búsqueda es favorable o búsqueda con modelos sustitutos cuando las evaluaciones son costosas y los mínimos locales causan dificultades.

Para los ingenieros que trabajan con un simulador costoso o una formulación combinada difícil, esto proporciona otra vía para pasar de un modelo de las alternativas a un diseño de proceso útil.
La siguiente configuración puede elegirse utilizando lo aprendido en las evaluaciones anteriores, lo que permite explorar con mayor eficacia con un presupuesto computacional limitado.

<h2 class="unnumbered" id="references">Artículo</h2>

1. <span id="ref-lee2026gdp"></span> Albert Joon Lee, Woosik Kim y David E. Bernal Neira.
   *Generalized Disjunctive Programming with Derivative-Free Configuration Search*.
   arXiv:2611.05508, 2026.
   [Leer el artículo y el material suplementario](https://arxiv.org/abs/2611.05508).
