---
layout: post
title: "Los agentes de IA ya pueden investigar. ¿Y ahora qué?"
description: "Qué pasó cuando lo intentamos nosotros mismos y por qué nuestras instituciones no están preparadas"
author: "Sergey Gusev y David E. Bernal Neira"
image: assets/images/ai-agents-research/cover-es.webp
social_image: /assets/images/ai-agents-research/cover-es.png
social_image_alt: "Portada de SECQUOIA para «Los agentes de IA ya pueden investigar. ¿Y ahora qué?»: figuras de agentes de IA trabajan con notas de investigación y una computadora."
methodology_image_alt: "Tres pasos: describir el problema o el campo; proporcionar artículos y herramientas; pedir a un enjambre de agentes que avance sin detenerse, con revisión por un agente nuevo, redacción y verificación."
social_image_width: 1200
social_image_height: 630
date: 2026-09-28 08:00:00 -0400
permalink: /es/ai-agents-can-already-do-research/
lang: es
translation_key: ai-agents-research
nav-menu: false
show_tile: false
---

<link rel="stylesheet" href="{{ '/assets/css/ai-agents-research.css' | relative_url }}">
<script id="MathJax-script" async src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-chtml.js"></script>
<script defer src="{{ '/assets/js/reference-previews.js' | relative_url }}"></script>

*Qué pasó cuando lo intentamos nosotros mismos y por qué nuestras instituciones no están preparadas*

**Sergey Gusev y David E. Bernal Neira** · Universidad Purdue · septiembre de 2026

<p class="article-cover">
  <a href="{{ '/assets/images/ai-agents-research/cover-es.png' | relative_url }}" aria-label="Abrir la portada a tamaño completo" title="Abrir la portada a tamaño completo">
    <img src="{{ '/assets/images/ai-agents-research/cover-es.webp' | relative_url }}" alt="{{ page.social_image_alt | escape }}" width="1200" height="630" decoding="async">
  </a>
</p>

[Lo que produjeron los agentes (hasta el 25 de septiembre de 2026)](#all-results) · [Referencias](#references)

Este verano hubo dos resultados matemáticos que acapararon titulares.
En agosto, una persona de Anthropic sin formación matemática le pidió a un modelo de Claude aún no publicado que «intentara en serio» resolver la hipótesis de Riemann, uno de los problemas abiertos más famosos de las matemáticas.
La hipótesis afirma que ciertos ceros de una función están todos sobre una misma recta.
El modelo no demostró eso, pero sí demostró que más del 66 % de ellos lo están, frente al mejor resultado anterior, de alrededor del 42 %: una proporción que los matemáticos llevaban décadas aumentando solo en pequeños pasos [\[1\]](#ref-alpoge2026-more-than-two-thirds-of).
En septiembre, OpenAI anunció que unos diez mil agentes de inteligencia artificial (IA), trabajando durante 88 horas, habían producido una demostración de una versión de otro famoso problema abierto, relacionado con las ecuaciones de Navier–Stokes del movimiento de fluidos; la revisión independiente sigue en curso [\[2\]](#ref-openai2026navierstokes).
Según una estimación externa, esa ejecución le habría costado a un cliente externo varios millones de dólares [\[3\]](#ref-duraisamy2026navierstokescost).
OpenAI ha afirmado desde entonces que el modelo utilizado en esa ejecución ha resuelto más de 100 problemas abiertos adicionales, aunque todavía no los ha publicado [\[4\]](#ref-openai2026advisory).

Ambos resultados surgieron dentro de empresas de IA, con modelos aún no publicados y presupuestos que ningún grupo de investigación tiene.
¿Puede un grupo de investigación ajeno a esas empresas, con modelos que cualquiera puede adquirir, conseguir que los agentes hagan investigación de verdad?

Lo intentamos nosotros mismos.
Funciona, a una escala menor que las ejecuciones de las empresas de IA y por una pequeña fracción de su costo.

Durante las últimas semanas, les dimos a grupos de agentes de IA un área de investigación, desde un tema específico hasta un campo completo.
Les proporcionamos artículos y herramientas de cómputo, y les dijimos que lograran avances reales, correctos y útiles, y que no se detuvieran.
No les dimos ninguna idea extra.

Durante el primer día de una de las ejecuciones, los agentes habían escrito más notas de las que podíamos leer en una semana.
En pocas semanas, habían producido material para 45 posibles artículos científicos en las cinco áreas que les asignamos: programación no lineal entera mixta, métodos cuánticos de punto interior, termodinámica molecular, teoría del transporte y cinética de agregación.
En una sexta área, la catálisis heterogénea, les pedimos experimentos, y diseñaron experimentos de laboratorio; nadie los ha realizado aún, así que todavía no podemos decir qué tan buenos son.
No lo hemos revisado todo y aún no podemos decir cuánto es correcto o novedoso.
Pero en todo lo que hemos revisado hasta ahora no hemos encontrado ningún error que invalide un resultado, y algunos resultados están demostrados en [Lean](https://lean-lang.org/), un software con el que una computadora verifica cada paso de una demostración.

Esta entrada explica qué hicimos, por qué creemos que importa y qué pensamos que debería pasar ahora.
El [artículo completo](https://arxiv.org/abs/2609.35719) contiene los detalles, las pruebas y las salvedades.
Todo lo que produjeron los agentes es público en <https://github.com/SECQUOIA/agent-swarm-research> [\[5\]](#ref-gusev2026corpus); esta entrada lo describe en el [commit 84c6be7](https://github.com/SECQUOIA/agent-swarm-research/tree/84c6be7aad17d085e5343e789885c1cbcbbd4e07), antes de cualquier aporte científico de nuestra parte.

<h2 class="unnumbered" id="what-we-did">Qué hicimos</h2>

El procedimiento completo cabe en tres pasos ([Figura 1](#research-setup)).

<figure id="research-setup" class="research-setup">
  <a class="research-diagram" href="{{ '/assets/images/ai-agents-research/methodology-es.png' | relative_url }}" aria-label="Abrir el diagrama a tamaño completo" title="Abrir el diagrama a tamaño completo">
    <img src="{{ '/assets/images/ai-agents-research/methodology-es.webp' | relative_url }}" alt="{{ page.methodology_image_alt | escape }}" width="1200" height="630" loading="lazy" decoding="async">
  </a>
  <ol class="research-steps">
    <li>
      <span class="step-number" aria-hidden="true">01</span>
      <h3>Describir el problema.</h3>
      <p>Dar al enjambre un problema o campo, contexto suficiente para empezar y libertad para explorar cualquier idea.</p>
    </li>
    <li>
      <span class="step-number" aria-hidden="true">02</span>
      <h3>Equipar y poner en marcha el enjambre.</h3>
      <p>Proporcionar artículos y herramientas, con permiso para conseguir más.
      Pedir a los agentes que avancen y que no se detengan.</p>
    </li>
    <li>
      <span class="step-number" aria-hidden="true">03</span>
      <h3>Revisar, redactar y verificar.</h3>
      <p>Que un agente nuevo revise cada resultado.
      Redactarlo.
      Verificarlo mediante una demostración o mediante cálculos siempre que sea posible.</p>
    </li>
  </ol>
  <figcaption><strong>Figura 1.</strong> El procedimiento que seguimos.
  El artículo incluye ejemplos de las instrucciones que usamos.</figcaption>
</figure>

Usamos herramientas disponibles comercialmente: los agentes de programación Claude Code y Codex, principalmente con Claude Fable 5.1 y GPT-6 Astra, mediante dos suscripciones a Claude y dos a ChatGPT, de 200 dólares al mes cada una.
Con tarifas de pago por uso, el mismo consumo habría costado más de 15.000 dólares durante las primeras cuatro semanas.
No escribimos software propio, salvo unas pocas instrucciones para tareas de organización.
Cualquiera que tenga acceso a estos modelos puede repetirlo hoy.

Nuestro procedimiento no es la mejor manera de investigar con agentes: usa la fuerza bruta y decidimos no ajustarlo.
Pero si algo tan sencillo ya funciona, mejores métodos lograrán más.

No esperábamos que funcionara.
Durante meses habíamos construido herramientas para una colaboración estrecha entre personas e IA, en la que dirigíamos la investigación y verificábamos el trabajo en cada paso.
Nunca produjeron gran cosa.
Cuando nos hicimos a un lado y dejamos que los agentes lo hicieran todo, desde elegir líneas de investigación hasta verificar los resultados, obtuvimos resultados en un día, y muchos.
En retrospectiva, la razón es que, en la investigación teórica, los agentes están mejorando en cada etapa del proceso de investigación, y ya son suficientemente buenos en la mayoría de ellas.
Pueden dirigir la investigación y verificar el trabajo por sí mismos, y leen más que los investigadores humanos, calculan más que los investigadores humanos y exploran varias ideas a la vez.
A medida que mejoran los modelos, podemos aportar cada vez menos a la resolución de un problema concreto y, cada vez que intervenimos, principalmente ralentizamos el trabajo.

<h2 class="unnumbered" id="what-came-back">Qué obtuvimos</h2>

Lo que obtuvimos no es un conjunto de avances revolucionarios.
Es trabajo incremental: esos pequeños pasos sólidos que constituyen la mayor parte del progreso científico.
No hace falta que nos crea.
Todo lo que produjeron los agentes es público y cualquiera puede comprobarlo.
Las tablas al final de este blog enumeran cada posible artículo y cada programa experimental propuesto, con las afirmaciones de los agentes y enlaces a sus borradores.
Los resultados de las empresas de IA son grandes avances en problemas famosos.
Nuestras ejecuciones muestran el trabajo cotidiano de la investigación, en varios campos que no están relacionados entre sí.

Parte de este trabajo no necesitó los modelos más recientes.
Algunos de nuestros resultados, en métodos cuánticos de punto interior, provinieron de GPT-5.6 Sol, un modelo que llevaba casi dos meses disponible públicamente cuando lo probamos.
Los modelos podían hacer este trabajo antes de que nos diéramos cuenta, y sospechamos que lo mismo ocurre en muchas otras áreas de la investigación teórica.

<h2 class="unnumbered" id="the-bottleneck-has-moved">El cuello de botella se ha desplazado</h2>

Los agentes produjeron resultados más rápido de lo que podíamos revisarlos.
A razón de unos días por cada posible artículo o programa experimental, revisarlo todo le llevaría a uno de nosotros más de siete meses de trabajo a tiempo completo.
Producir los resultados tomó semanas.

Todo sistema de publicación supone que el autor ha verificado el trabajo y responde por él, y que los revisores lo examinan después.
Cuando una persona puede producir más de lo que puede revisar, enviar ese trabajo directamente a publicación implicaría omitir la verificación del propio autor, y ninguna cantidad de revisión externa la sustituye.
Las decisiones de contratación, ascenso y financiación dentro del sistema académico siguen basándose en el número de artículos, y ahora un artículo puede producirse por casi nada.

Si todo ese material fuera ruido, cualquiera podría ignorarlo y la acumulación de trabajo pendiente de revisión no importaría.
Pero los resultados merecen ser revisados.

<h2 class="unnumbered" id="if-you-are-a-skeptic">Para los escépticos</h2>

Estas son algunas de las respuestas que escuchamos a menudo.

<div class="objection" markdown="1">
**«Los resultados no impresionan.
Un buen investigador los habría encontrado».**
Tal vez.
Si ese es el caso, ¿por qué no estaban ya en la literatura?
Que los agentes superen al mejor investigador de un campo es solo una parte de la cuestión.
¿A cuántos investigadores deben poder igualar antes de que las instituciones de ese campo tengan que cambiar?
¿A todos salvo al uno por ciento más destacado?
¿A todos salvo a una persona?
Creemos que los agentes ya están al nivel de muchos investigadores en activo, incluidos nosotros.
</div>

<div class="objection" markdown="1">
**«Es una máquina estadística.
Solo puede recombinar lo que ha visto».**
Buena parte de la investigación también recombina: una técnica conocida aplicada a un problema nuevo, o ideas de dos campos que se unen.
Se puede verificar si un resultado es correcto, novedoso y útil sin saber quién o qué lo produjo.
</div>

<div class="objection" markdown="1">
**«Podría estar todo mal».**
Parte podría estarlo.
Pero en lo que hemos revisado hasta ahora no hemos encontrado ningún error científico que invalide un resultado.
Y hemos publicado todo, para que cualquiera pueda comprobarlo por su cuenta.
</div>

<div class="objection" markdown="1">
**«Me niego a usar estas herramientas por principios».**
Es una decisión legítima.
Pero otras personas en su campo las usarán, y con ellas se le comparará a la hora de contratar, financiar y ascender.
</div>

Cuando un estudio muestre algo que la IA no puede hacer, compruebe qué modelo probó y cuándo.
Esos límites se han superado una y otra vez en cuestión de meses, siguiendo una tendencia que también se ha medido [\[6\]](#ref-kwa2025-measuring-ai-ability-to-complete).
Si hoy puede hacer algo mejor que los modelos, eso solo dice algo sobre los modelos de hoy, y los modelos siguen mejorando.

<h2 class="unnumbered" id="if-you-are-an-enthusiast">Para los entusiastas</h2>

<div class="objection" markdown="1">
**«Investigar acaba de volverse más fácil.
Con los modelos más recientes y suficiente capacidad de cómputo, cualquiera puede producir resultados».**
Puede ser cierto, pero plantea problemas que no sabemos resolver.
Si los resultados dependen solo del modelo y del presupuesto, el investigador no hace falta.
Cualquiera a quien le importe un problema puede pagar directamente por el cómputo, y la empresa que opera el modelo tiene primero los modelos más recientes y paga menos por el cómputo.
Y si los resultados dependen del presupuesto, ¿quién puede investigar, cuál debería ser la aportación humana y cuánto vale?
</div>

<div class="objection" markdown="1">
**«Entonces seré quien revise».**
Tampoco es una función segura.
No pudimos revisar con suficiente rapidez.
Todos los errores que conocemos en nuestro conjunto de trabajos fueron encontrados y corregidos por agentes antes de que cualquiera de nosotros los examinara; no podemos decir si los habríamos detectado por nuestra cuenta.
Se pueden poner grandes cantidades de agentes a revisar con la misma facilidad con la que se los pone a producir resultados.
Y nadie elige una carrera de investigación para dar el visto bueno al trabajo de una máquina.
Un sistema basado en la aprobación humana se llenaría de revisiones que nunca se hicieron de verdad.
</div>

Entonces, ¿cuál es exactamente la función del investigador?
¿Por qué le pagaría alguien a una persona, si puede obtener lo mismo directamente del modelo?
No tenemos una respuesta satisfactoria.

<h2 class="unnumbered" id="the-questions-and-where-we-stand">Las preguntas y nuestra postura</h2>

Preferimos tomar posición y equivocarnos a limitarnos a hacer preguntas.
Esta es nuestra postura, hoy.

<div class="positions" markdown="1">

- **¿Cómo podemos confiar en los resultados cuando lo escaso es la revisión y no la producción?**
  <span class="position">Mediante mediciones.</span>
  Siempre que sea posible, presentemos los resultados de forma que puedan verificarse automáticamente y construyamos bibliotecas de resultados establecidos y verificados por computadora en todos los campos cuyo razonamiento sea matemático, como la física, la química y la ingeniería, no solo en las matemáticas en sí.
  Hagamos que expertos revisen una muestra de lo que aprueban los agentes revisores, publiquemos con qué frecuencia estos pasan por alto errores y aceptemos resultados de un proceso que cumpla el estándar del campo.

- **¿Qué resultados necesitan que una persona los entienda?**
  <span class="position">Decidámoslo de forma deliberada</span>, según lo que esté en juego y las tasas de error medidas, y revisemos la decisión con cada nuevo modelo.

- **¿Qué cuenta como novedoso cuando los agentes no pueden leer buena parte de la literatura porque está detrás de barreras de pago?**
  <span class="position">Abramos la literatura.</span>
  El trabajo presentado como conocimiento público debería poder leerlo cualquier agente, humano o artificial, que investigue.

- **¿En qué debería convertirse la publicación científica?**
  <span class="position">Publiquemos las afirmaciones con su estado de verificación</span> (verificadas por computadora, revisadas por agentes, auditadas mediante muestreo o revisadas por una persona) y con enlaces a las comprobaciones.

- **¿Qué significan el reconocimiento y el número de artículos cuando la aportación humana es una instrucción?**
  <span class="position">Dejemos de contar artículos.</span>
  Juzguemos los resultados por si son correctos, novedosos, útiles y verificados, y no castiguemos a quienes expliquen cómo se produjeron.
  Las reglas contra el uso de IA no pueden hacerse cumplir; solo empujan su uso a la clandestinidad.
  El sistema actual de reconocimiento ya se está rompiendo en privado, y creemos que es mejor romperlo en público, donde se pueda discutir qué lo reemplazará.

- **¿Por qué alguien le pagaría a un investigador?**
  <span class="position">Menos por producir resultados y más por entenderlos, verificarlos y decidir hacia dónde debe avanzar el trabajo.</span>
  También podría haber más demanda de investigadores, no menos, por un efecto conocido como la paradoja de Jevons: abaratar el uso de un recurso puede aumentar cuánto se utiliza.
  En el siglo XIX, el economista William Stanley Jevons observó que, cuando las máquinas de vapor empezaron a usar el carbón con más eficiencia, el consumo total de carbón aumentó, porque la energía más barata hizo rentables nuevos usos [\[7\]](#ref-jevons1865coal).
  Del mismo modo, resultados baratos podrían hacer que valga la pena plantear muchas más preguntas y explorar muchas más direcciones, y podrían necesitarse personas para elegir entre ellas, orientar a los agentes y poner los resultados en práctica.

- **¿El mejor investigador pasa a ser el que tiene el mayor presupuesto?**
  Los resultados dependerán cada vez más de cuánto cómputo pueda pagar un investigador, y no creemos que eso pueda evitarse.
  <span class="position">Decidamos abiertamente cómo manejarlo</span>, en vez de dejarnos llevar: si las instituciones deberían proporcionar cómputo como recurso compartido, igual que las bibliotecas y los laboratorios, y si la evaluación puede separar lo que hizo una persona de lo que hizo su presupuesto.

- **¿Cómo deberíamos aprender un campo en el que las máquinas ya pueden trabajar?**
  <span class="position">Enseñemos más, no menos, pero de otra manera.</span>
  Orientemos la formación hacia la comprensión y el criterio, y dejemos de entrenar a los estudiantes en destrezas que ahora solo necesitan entender.
  Financiemos de manera deliberada la formación de investigadores jóvenes.
  Con un presupuesto fijo, un investigador experimentado más cómputo produce más que un grupo de estudiantes; un campo que financie la investigación con ese criterio no tendrá investigadores experimentados dentro de una generación.

- **¿Qué pasa cuando se ponen agentes a trabajar en campos enteros?**
  Pasará.
  Los desarrolladores de modelos, las entidades financiadoras y los gobiernos pueden permitírselo, y nadie puede impedir que todos los demás lo hagan.
  Creemos que <span class="position">deberíamos hacerlo de forma abierta, financiando la verificación junto con la producción</span>.
  Poner agentes a trabajar en todo un campo también le da a ese campo un punto de referencia: lo que los agentes pueden hacer por sí solos.
  Lo que las personas añadan por encima de ese punto de referencia será la aportación humana.

- **¿Cómo podemos mantener el control de una investigación cuyo ritmo no podemos seguir?**
  Esperamos que los agentes superen ampliamente a las personas en algunos campos, probablemente primero en matemáticas.
  <span class="position">Seguirles el ritmo no es un objetivo realista; mantener el control sí.</span>
  Eso significa que fijamos los objetivos y podemos detener las ejecuciones, que suficientes personas entienden cada campo como para auditarlo y que hay salvaguardas cuando un resultado correcto puede causar daño.

</div>

<h2 class="unnumbered" id="what-we-do-not-know">Lo que no sabemos</h2>

Dos de estas respuestas son menos sólidas de lo que nos gustaría.

Defendemos que haya más personas, no menos.
Podemos explicar por qué un campo las necesita.
Todavía no podemos decir qué harán.
Auditar, orientar y mantenerse al día con los resultados son las funciones que podemos nombrar hoy, y los agentes podrían asumir cada una a medida que mejoren los modelos.

Y la idea del punto de referencia supone que las personas pueden seguirlo.
Si los agentes producen en un mes más de lo que un campo puede leer en un año, quizá las personas ni siquiera puedan saber qué se conoce ya, mucho menos aportar algo nuevo.
No sabemos cuál sería entonces el aporte humano ni cómo podría medirse.
Creemos que es una de las preguntas más importantes y la planteamos sin tener una respuesta.

<h2 class="unnumbered" id="our-institutions-are-not-ready">Nuestras instituciones no están preparadas</h2>

La revisión por pares, el conteo de artículos, la contratación, los ascensos, la financiación y la formación de posgrado se diseñaron para un mundo en el que producir un resultado es lento y su autor ha leído el trabajo.
Ese ya no es el mundo en el que vivimos.
Creemos que nuestras instituciones científicas y los incentivos que generan no están preparados para lo que estos sistemas ya pueden hacer, y mucho menos para lo que viene.
El mejor momento de empezar a cambiarlas era ayer.
El segundo mejor momento es ahora.

Las instituciones cambian a lo largo de años, y los modelos mejoran en meses.
Un plan de estudios o una política de revisión diseñados para los modelos de hoy entrará en vigor cuando esos modelos ya hayan sido reemplazados, y sus sustitutos también serán reemplazados.
Esas políticas deberían diseñarse para capacidades que siguen aumentando, no para una generación concreta de modelos.
Las instituciones también deberían anticiparse y decidir ahora cómo responderán cuando se demuestre que la revisión por agentes es tan fiable como la revisión por expertos, cuando los agentes superen a las personas de su campo o cuando los laboratorios automatizados abaraten los experimentos.
Algunos desarrolladores de IA ya asumen compromisos de este tipo para sus propios modelos, vinculando las salvaguardas exigidas a capacidades medidas [\[8\]](#ref-anthropic2026rsp).
Las instituciones científicas deben hacer lo mismo.

Ya ha habido algunas respuestas.
Más de dos docenas de ganadores de la Medalla Fields, el máximo galardón de las matemáticas, firmaron una declaración que advierte que el afán de las empresas de IA por resolver problemas matemáticos como pruebas de rendimiento perjudica a las matemáticas y pide atender el problema con urgencia [\[9\]](#ref-fields2026declaration).
OpenAI ha formado un grupo asesor independiente de matemáticos para orientarla sobre cómo evaluar y comunicar nuevos resultados [\[4\]](#ref-openai2026advisory).
Recibimos ambas iniciativas como primeros pasos y compartimos la preocupación de que los resultados anunciados con prisa puedan adelantarse a su comprensión.
No creemos que el daño esté en dirigir la IA hacia problemas famosos en sí.
Ahora cualquiera puede hacerlo, así que habrá tales intentos, los apruebe alguien o no; lo que importa es cómo nos preparamos para ellos.
Y ambas respuestas se centran en las matemáticas y en las empresas de IA.
Nuestras ejecuciones abarcaron optimización, termodinámica, transporte y catálisis, con modelos que cualquiera puede adquirir.
Las mismas preguntas surgen dondequiera que los agentes puedan producir resultados más rápido de lo que las personas pueden revisarlos, y eso ya ocurre mucho más allá de las matemáticas.

<h2 class="unnumbered" id="what-to-do-now">Qué hacer ahora</h2>

<div class="action-steps" markdown="1">

1. **Haga el experimento en su propio campo.**
   El artículo incluye ejemplos de nuestras instrucciones.
   Use los mejores modelos disponibles cuando lea esto.
   Si quiere compararse con nosotros, no aporte ideas propias.

1. **Reporte sus resultados:** qué pidió, qué obtuvo, qué verificó y qué no.

1. **Juzgue los resultados teniendo en cuenta la tendencia, no solo los modelos de hoy.**
   Si los agentes fallan, repórtelo también, indicando el modelo y la fecha, y repita el experimento conforme aparezcan modelos nuevos.
   Sus capacidades son desiguales, así que los mismos agentes pueden fallar en un problema y hacer un trabajo extraordinario en el siguiente.
   La comparación reveladora es con respecto a lo que podían hacer los agentes hace seis meses o un año.
   Luego proyecte esa tendencia unos años hacia adelante y pregúntese qué debería estar haciendo su campo ahora.

1. **Empiece a prepararse ya.**
   No espere a que la IA supere una barrera más alta, como producir resultados mejores que los de cualquier persona.
   Hable con sus colegas, estudiantes, instituciones y financiadores sobre qué debería cambiar en su campo: cómo se revisan y reconocen los resultados, cómo se forma a los estudiantes y para qué están los investigadores.
   Prepárese para capacidades que siguen aumentando, no solo para los modelos actuales.

</div>

Cuanto antes cuenten muchas personas lo que encuentran, antes se apoyará esta conversación en pruebas en vez de opiniones.
Pero la preparación no debería esperar a esas pruebas: debería haber empezado ayer y debe empezar ahora.

<h2 class="unnumbered" id="all-results">Lo que produjeron los agentes</h2>

Estas tablas contienen el mismo inventario de investigación que el artículo, agrupado por áreas.
Cada fila es un conjunto de resultados relacionados que podrían constituir un artículo, esté escrito o no.
Las contribuciones son lo que afirman los agentes en sus propios documentos y notas; no las hemos revisado todas.
Excluimos los resultados que los propios agentes marcaron como superados, refutados o retirados, los demasiado pequeños para constituir un artículo y los grupos cuyos resultados principales, según las propias comprobaciones bibliográficas de los agentes, ya se conocían.
En catálisis, los agentes propusieron programas experimentales y no se ha realizado ninguno de los experimentos.

Los enlaces de la columna «Documento» llevan a los borradores del [commit 84c6be7](https://github.com/SECQUOIA/agent-swarm-research/tree/84c6be7aad17d085e5343e789885c1cbcbbd4e07) (etiqueta <code>paper-v1</code>), que contiene lo producido por los agentes hasta el 25 de septiembre de 2026, antes de cualquier aportación científica nuestra; la columna «Lean» indica el estado en esa fecha.
Versiones posteriores del repositorio pueden añadir resultados y aportaciones científicas nuestras.
Las filas marcadas «Solo notas» no tienen borrador; sus enlaces abren la colección de notas de los agentes del área correspondiente en el mismo commit.

<h3 class="unnumbered" id="mixed-integer-nonlinear-programming">Programación no lineal entera mixta</h3>

<div class="table-wrapper research-inventory" role="region" aria-labelledby="mixed-integer-nonlinear-programming" tabindex="0">
<table class="research-inventory-table">
<caption>Programación no lineal entera mixta</caption>
<thead>
<tr>
<th scope="col" style="text-align: left;">ID</th>
<th scope="col" style="text-align: left;">Título provisional y contribución declarada</th>
<th scope="col" style="text-align: left;">Documento</th>
<th scope="col" style="text-align: left;">Lean</th>
</tr>
</thead>
<tbody>
<tr id="result-m1">
<th scope="row" style="text-align: left;">M1</th>
<td style="text-align: left;"><strong>Cotas ajustadas para las brechas de las relajaciones multilineales positivas.</strong>
Refuta la conjetura de Luedtke–Namazifar–Linderoth; brecha exacta respecto de la envolvente convexa; la peor razón crece como <span class="math inline">\(\ln d/\ln\ln d\)</span> en el grado y como <span class="math inline">\(\ln n/\ln\ln n\)</span> en la dimensión.
Se basa en <span class="citation" data-cites="luedtke2012multilinear"><a href="#ref-luedtke2012multilinear" role="doc-biblioref">[10]</a></span>.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/minlp-notes/paper-multilinear-gap/main.pdf">Artículo completo</a></td>
<td style="text-align: left;">Demostrado</td>
</tr>
<tr id="result-m2">
<th scope="row" style="text-align: left;">M2</th>
<td style="text-align: left;"><strong>Cotas verificadas para las brechas de las relajaciones cúbicas positivas.</strong>
Acota la peor razón cúbica entre la brecha de la relajación término a término y la de la envolvente convexa: <span class="math inline">\(1610000/743033 \le R(3) \le 31/12\)</span>.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/minlp-notes/paper-cubic-gap/main.pdf">Artículo completo</a></td>
<td style="text-align: left;">Demostrado</td>
</tr>
<tr id="result-m3">
<th scope="row" style="text-align: left;">M3</th>
<td style="text-align: left;"><strong>Cotas inferiores verificables para la optimización no lineal entera mixta convexa mediante aproximaciones exteriores racionales.</strong>
Los certificados racionales proporcionan cotas inferiores verificables de forma independiente; 203 de 289 modelos de MINLPLib superan una verificación independiente; auditorías exactas encuentran demostraciones inválidas aceptadas por un verificador externo.
Se basa en <span class="citation" data-cites="halbig2024certificates"><a href="#ref-halbig2024certificates" role="doc-biblioref">[11]</a></span>.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/minlp-notes/paper-certified-minlp/main.pdf">Artículo completo</a></td>
<td style="text-align: left;">Demostrado</td>
</tr>
<tr id="result-m4">
<th scope="row" style="text-align: left;">M4</th>
<td style="text-align: left;"><strong>Brechas de relajación convexa y certificados espaciales en optimización no lineal.</strong>
Brechas bilineales con signo del orden de la raíz cuadrada de la densidad de aristas; un número exponencial de regiones certificadas para ramificación y acotación espacial bajo los oráculos de nodo especificados.
Responde negativamente a una pregunta de Altschuler y Boix-Adserà, suponiendo P<span class="math inline">\({}\neq{}\)</span>NP; un contraejemplo a un teorema publicado sobre formulaciones P-split.
También reformula los resultados sobre brechas multilineales positivas y cúbicas de M1 y M2.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/minlp-notes/paper-relaxation-limits/main.pdf">Artículo completo</a></td>
<td style="text-align: left;">Parcial</td>
</tr>
<tr id="result-m5">
<th scope="row" style="text-align: left;">M5</th>
<td style="text-align: left;"><strong>Dimensión entera en la aproximación convexa entera mixta de gráficas no lineales.</strong>
Para un sistema cuadrático fijo sobre una caja, el número mínimo de variables enteras o binarias de una representación convexa extendida con precisión <span class="math inline">\(\varepsilon\)</span> es <span class="math inline">\(\frac{1}{2}\,\mathrm{ncrank}\cdot\log_2(1/\varepsilon)+O(1)\)</span>, donde ncrank es el rango no conmutativo del espacio de Hessianas; construcciones racionales en tiempo polinómico.
Se basa en <span class="citation" data-cites="lubin2022representability beach2022compact"><a href="#ref-lubin2022representability" role="doc-biblioref">[12]</a>, <a href="#ref-beach2022compact" role="doc-biblioref">[13]</a></span>.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/minlp-notes/paper-integer-dimension/build/main.pdf">Artículo completo</a></td>
<td style="text-align: left;">Parcial</td>
</tr>
<tr id="result-m6">
<th scope="row" style="text-align: left;">M6</th>
<td style="text-align: left;"><strong>Redondeo de controles conmutados con un límite estricto de conmutaciones: cotas minimax ajustadas y algoritmos exactos.</strong>
Error minimax exacto de redondeo para hasta tres conmutaciones; refuta una conjetura de Sager y Zeile y corrige una cota inferior publicada; valores y algoritmos exactos sobre mallas finitas.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/minlp-notes/paper-switching-control/main.pdf">Artículo completo</a></td>
<td style="text-align: left;">Parcial</td>
</tr>
<tr id="result-m7">
<th scope="row" style="text-align: left;">M7</th>
<td style="text-align: left;"><strong>Envolventes convexas dispersas para flujos en redes acoplados a un símplex.</strong>
Una formulación exacta usa una coordenada adicional por ciclo independiente de cada subgrafo bloque–etiqueta no observado; crecimiento exponencial de los coeficientes en grafos serie-paralelo.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/minlp-notes/paper-network-simplex/main.pdf">Artículo completo</a></td>
<td style="text-align: left;">Parcial</td>
</tr>
<tr id="result-m8">
<th scope="row" style="text-align: left;">M8</th>
<td style="text-align: left;"><strong>Topología, incertidumbre y precisión en la optimización de flujos potenciales pasivos.</strong>
Optimización aditiva polinómica de diferencias de potencial con rango cíclico de bloques fijo, para cajas de nominaciones equilibradas e intervalos independientes de coeficientes; la comparación exacta de presiones en grafos cactus con una fuente y un sumidero equivale al problema de la suma de raíces cuadradas.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/minlp-notes/paper-potential-flow/complexity/main.pdf">Artículo completo</a></td>
<td style="text-align: left;">Parcial</td>
</tr>
<tr id="result-m9">
<th scope="row" style="text-align: left;">M9</th>
<td style="text-align: left;"><strong>Complejidad del problema de mezclas: barreras algebraicas y algoritmos estructurales.</strong>
La decisión sobre el umbral de mezclas es <span class="math inline">\(\exists\mathbb{R}\)</span>-completa; es fuertemente NP-completa cuando todos los grados por capa son dos, y NP-completa con dos depósitos de mezcla y dos productos, lo que responde a preguntas de Boland y colaboradores y de Haugland; resuelve una conjetura de costos de rango uno; fronteras de tratabilidad coincidentes.
Se basa en <span class="citation" data-cites="haugland2016pooling boland2017pooling dey2020rankone"><a href="#ref-haugland2016pooling" role="doc-biblioref">[14]</a>, <a href="#ref-boland2017pooling" role="doc-biblioref">[15]</a>, <a href="#ref-dey2020rankone" role="doc-biblioref">[16]</a></span>.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/minlp-notes/papers/pooling/main.pdf">Artículo completo</a></td>
<td style="text-align: left;">No aplica</td>
</tr>
<tr id="result-m10">
<th scope="row" style="text-align: left;">M10</th>
<td style="text-align: left;"><strong>Factibilidad exacta de redes eléctricas resistivas y de corriente alterna.</strong>
La factibilidad del flujo de potencia resistivo es <span class="math inline">\(\exists\mathbb{R}\)</span>-completa incluso en redes planas, de grado tres y conductancia unitaria; la dificultad se transfiere a redes de corriente alterna con líneas resistivas.
Trabajos relacionados: <span class="citation" data-cites="bienstock2019acpf lehmann2016acfeasibility"><a href="#ref-bienstock2019acpf" role="doc-biblioref">[17]</a>, <a href="#ref-lehmann2016acfeasibility" role="doc-biblioref">[18]</a></span>.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/minlp-notes/paper-power-flow/build/main.pdf">Artículo completo</a></td>
<td style="text-align: left;">No aplica</td>
</tr>
<tr id="result-m11">
<th scope="row" style="text-align: left;">M11</th>
<td style="text-align: left;"><strong>Optimización binivel estructurada con muchas variables del seguidor: respuestas globales, precisión y fronteras estructurales.</strong>
Una descripción de dimensión fija de todas las respuestas globales del seguidor proporciona algoritmos polinómicos exactos; líderes racionales con error <span class="math inline">\(2^{-B}\)</span> para costos estrictamente convexos; dificultad con Hessianas densas cercanas a la identidad.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/minlp-notes/paper-structured-bilevel/paper.pdf">Artículo completo</a></td>
<td style="text-align: left;">Posible</td>
</tr>
<tr id="result-m12">
<th scope="row" style="text-align: left;">M12</th>
<td style="text-align: left;"><strong>Selección de mediciones con certificación global y errores correlacionados.</strong>
Conjuntos de aproximación polinómicos en el orden semidefinido positivo relativo, un esquema de aproximación de traza ponderada y certificados racionales del logaritmo del determinante para seleccionar mediciones correlacionadas.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/minlp-notes/paper-correlated-measurements/build/main.pdf">Artículo completo</a></td>
<td style="text-align: left;">Parcial</td>
</tr>
<tr id="result-m13">
<th scope="row" style="text-align: left;">M13</th>
<td style="text-align: left;"><strong>Separación radial y puntual para la aproximación exterior por perspectiva de programas disyuntivos generalizados convexos.</strong>
Comparación en condiciones equivalentes de dos políticas de separación: la búsqueda radial ofrece mejoras modestas que dependen de la implementación; no hay una nueva familia de cortes.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/minlp-notes/paper-lbesh/main.pdf">Artículo completo</a></td>
<td style="text-align: left;">No aplica</td>
</tr>
<tr id="result-m14">
<th scope="row" style="text-align: left;">M14</th>
<td style="text-align: left;"><strong>Agregación cuadrática: certificados, descripciones finitas y aproximación.</strong>
Resuelve tres conjeturas de Blekherman–Dey–Sun: bajo convexidad oculta de hiperplanos, una envolvente es propia exactamente cuando existe una agregación convexa no constante; la envolvente de tres desigualdades requiere una cantidad no numerable de agregaciones; cuatro agregaciones bastan para tres desigualdades cuadráticas estrictas con una combinación definida positiva, extendiendo una cota de Blekherman–Dunbar, y esa cota es ajustada.
Se basa en <span class="citation" data-cites="blekherman2024aggregations"><a href="#ref-blekherman2024aggregations" role="doc-biblioref">[19]</a></span>.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/minlp-notes/paper-quadratic-aggregation/paper.pdf">Artículo completo</a></td>
<td style="text-align: left;">Parcial</td>
</tr>
<tr id="result-m15">
<th scope="row" style="text-align: left;">M15</th>
<td style="text-align: left;"><strong>Envolventes convexas exactas para un factor recíproco compartido por muchas variables.</strong>
Envolvente explícita de <span class="math inline">\((X,1/X,Y_i,XY_i)\)</span> para muchas hojas, con separación y descomposición racionales exactas; se extiende a un factor entero con un rango codificado en binario, con separación polinómica en la longitud de la codificación.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/tree/84c6be7aad17d085e5343e789885c1cbcbbd4e07/minlp-notes" title="Ver las notas de esta área en el commit citado">Solo notas</a></td>
<td style="text-align: left;">Demostrado</td>
</tr>
<tr id="result-m16">
<th scope="row" style="text-align: left;">M16</th>
<td style="text-align: left;"><strong>Instancias mal planteadas de redes de intercambiadores de calor en MINLPLib.</strong>
Los modelos <code>heatexch_gen</code> comparten un término no acotado de temperatura media logarítmica sujeto a salvaguardas; para <code>heatexch_gen1</code>, un punto numéricamente factible mejora el valor publicado en aproximadamente un 30 %, y las estimaciones numéricas indican que el ínfimo no se alcanza.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/tree/84c6be7aad17d085e5343e789885c1cbcbbd4e07/minlp-notes" title="Ver las notas de esta área en el commit citado">Solo notas</a></td>
<td style="text-align: left;">No aplica</td>
</tr>
<tr id="result-m17">
<th scope="row" style="text-align: left;">M17</th>
<td style="text-align: left;"><strong>Envolventes convexas de monomios de dos variables con exponentes reales sobre una cuña.</strong>
Extiende la envolvente de un monomio acotado sobre una cuña, de exponentes positivos a exponentes negativos y de signos mixtos, incluidos términos de cociente; resuelve el caso abierto de Belotti de dos exponentes negativos.
Se basa en <span class="citation" data-cites="belotti2025monomials"><a href="#ref-belotti2025monomials" role="doc-biblioref">[20]</a></span>.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/tree/84c6be7aad17d085e5343e789885c1cbcbbd4e07/minlp-notes" title="Ver las notas de esta área en el commit citado">Solo notas</a></td>
<td style="text-align: left;">Posible</td>
</tr>
<tr id="result-m18">
<th scope="row" style="text-align: left;">M18</th>
<td style="text-align: left;"><strong>Optimización cuadrática exacta con indicadores y ancho de árbol bajo.</strong>
NP-difícil con ancho de banda dos y Hessianas arbitrariamente cercanas a la identidad; con penalizaciones de indicadores perturbadas aleatoriamente, algoritmos exactos con tiempo esperado polinómico en operaciones de bits para ancho de árbol fijo.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/tree/84c6be7aad17d085e5343e789885c1cbcbbd4e07/minlp-notes" title="Ver las notas de esta área en el commit citado">Solo notas</a></td>
<td style="text-align: left;">No aplica</td>
</tr>
<tr id="result-m19">
<th scope="row" style="text-align: left;">M19</th>
<td style="text-align: left;"><strong>Envolventes convexas de funciones univariantes de una forma lineal.</strong>
Para cualquier <span class="math inline">\(\sigma\)</span> semicontinua inferiormente, la envolvente convexa de <span class="math inline">\(\sigma(a^\top x+b)\)</span> sobre una caja es un mínimo sobre distribuciones situadas por debajo de una distribución escalonada comonótona en el orden convexo y, dualmente, un supremo sobre minorantes cóncavas, cada una de las cuales proporciona cortes válidos en toda la caja; extensiones a productos de símplexes y politopos de orden con restricciones de signo.
Se basa en <span class="citation" data-cites="mao2015aggregation"><a href="#ref-mao2015aggregation" role="doc-biblioref">[21]</a></span>.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/tree/84c6be7aad17d085e5343e789885c1cbcbbd4e07/minlp-notes" title="Ver las notas de esta área en el commit citado">Solo notas</a></td>
<td style="text-align: left;">Posible</td>
</tr>
<tr id="result-m20">
<th scope="row" style="text-align: left;">M20</th>
<td style="text-align: left;"><strong>Teoría de contracción del ajuste iterado de cotas basado en optimalidad.</strong>
Cerca de un minimizador, el ajuste iterado de cotas sigue una aplicación monótona y positivamente homogénea sobre las formas de las cajas, cuya constante de tipo Collatz–Wielandt acota la tasa lineal local; un certificado de estancamiento del ajuste; la tasa exacta <span class="math inline">\((\sqrt{2a^2+4a}-a)/2\)</span> de rondas simultáneas para <span class="math inline">\(x^2+y^2+axy\)</span>, <span class="math inline">\(0&lt;a&lt;2\)</span>, con relajaciones de McCormick; una condición bajo la cual el ajuste no produce ningún cambio, incluso para objetivos fuertemente convexos.
Se basa en <span class="citation" data-cites="caprara2010domain"><a href="#ref-caprara2010domain" role="doc-biblioref">[22]</a></span>.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/tree/84c6be7aad17d085e5343e789885c1cbcbbd4e07/minlp-notes" title="Ver las notas de esta área en el commit citado">Solo notas</a></td>
<td style="text-align: left;">Posible</td>
</tr>
<tr id="result-m21">
<th scope="row" style="text-align: left;">M21</th>
<td style="text-align: left;"><strong>Relajación conjunta de varios términos no lineales de una variable.</strong>
Tratamiento automático y certificado en un solucionador: la curvatura certificada y los cortes de envolvente válidos para toda pendiente resuelven los 24 programas cuárticos separables de prueba, de los cuales las versiones nativas de SCIP, Gurobi y BARON resuelven 2, 3 y 6; un separador certificado para envolventes de curvas <span class="math inline">\((t,f_1(t),\dots,f_k(t))\)</span>.
La teoría de la envolvente en sí ya se conoce.
Se basa en <span class="citation" data-cites="ballerstein2013thesis"><a href="#ref-ballerstein2013thesis" role="doc-biblioref">[23]</a></span>.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/tree/84c6be7aad17d085e5343e789885c1cbcbbd4e07/minlp-notes" title="Ver las notas de esta área en el commit citado">Solo notas</a></td>
<td style="text-align: left;">No aplica</td>
</tr>
<tr id="result-m22">
<th scope="row" style="text-align: left;">M22</th>
<td style="text-align: left;"><strong>Términos cóncavos separables sobre pocas filas lineales.</strong>
Una reformulación binaria que permite como máximo <span class="math inline">\(\mathrm{rank}(A)\)</span> variables estrictamente dentro de sus tramos cóncavos se resuelve en <span class="math inline">\(2n+1\)</span> nodos de ramificación y cortes en una familia donde la ramificación y acotación espacial necesita un número exponencial (M4); la envolvente conjunta de términos cóncavos sobre una fila, que para anchos iguales es el poliedro de cobertura de flujo de Padberg–Van Roy–Wolsey expresado en otras variables, se extiende a filas de desigualdad y a indicadores con costos cóncavos.
Se basa en <span class="citation" data-cites="padberg1985fixedcharge"><a href="#ref-padberg1985fixedcharge" role="doc-biblioref">[24]</a></span>.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/tree/84c6be7aad17d085e5343e789885c1cbcbbd4e07/minlp-notes" title="Ver las notas de esta área en el commit citado">Solo notas</a></td>
<td style="text-align: left;">Posible</td>
</tr>
</tbody>
</table>
</div>

<h3 class="unnumbered" id="quantum-interior-point-methods">Métodos cuánticos de punto interior</h3>

<div class="table-wrapper research-inventory" role="region" aria-labelledby="quantum-interior-point-methods" tabindex="0">
<table class="research-inventory-table">
<caption>Métodos cuánticos de punto interior</caption>
<thead>
<tr>
<th scope="col" style="text-align: left;">ID</th>
<th scope="col" style="text-align: left;">Título provisional y contribución declarada</th>
<th scope="col" style="text-align: left;">Documento</th>
<th scope="col" style="text-align: left;">Lean</th>
</tr>
</thead>
<tbody>
<tr id="result-q1">
<th scope="row" style="text-align: left;">Q1</th>
<td style="text-align: left;"><strong>Subniveles del objetivo y condicionamiento de la Hessiana de la trayectoria central.</strong>
Para toda barrera autoconcordante, el condicionamiento es <span class="math inline">\(\Theta((\mathrm{diam}\,L(g)/g)^2)\)</span>; los espectros de los programas lineales tienen dos escalas.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/qipm-notes/conditioning-paper/main.pdf">Artículo completo</a></td>
<td style="text-align: left;">Parcial</td>
</tr>
<tr id="result-q2">
<th scope="row" style="text-align: left;">Q2</th>
<td style="text-align: left;"><strong>El costo de seguir la trayectoria central.</strong>
Costo de desplazamiento ajustado <span class="math inline">\(\Gamma_r=\Theta(\sqrt{\log r})\)</span> sobre la trayectoria central para objetivos de rango <span class="math inline">\(r\)</span>; en un programa lineal disperso explícito, completar la trayectoria primal-dual requiere <span class="math inline">\(\Theta(r^{3/2})\)</span> pasos acotados.
Se basa en <span class="citation" data-cites="nesterov2008centralpaths"><a href="#ref-nesterov2008centralpaths" role="doc-biblioref">[25]</a></span>.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/qipm-notes/central-path-cost/main.pdf">Artículo completo</a></td>
<td style="text-align: left;">Parcial</td>
</tr>
<tr id="result-q3">
<th scope="row" style="text-align: left;">Q3</th>
<td style="text-align: left;"><strong>Modelos de acceso y masa del lado derecho en la resolución de sistemas de Newton.</strong>
Las Hessianas de programas lineales degenerados tienen dos grupos de valores propios que el método de gradientes conjugados maneja en un número polilogarítmico de iteraciones, mientras que el acceso simple por bloques conserva el costo conocido <span class="math inline">\(\tilde\Theta(\kappa)\)</span>; el acoplamiento del lado derecho con los valores propios pequeños determina cuándo ayuda el filtrado.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/qipm-notes/paper/main.pdf">Documento de resumen</a></td>
<td style="text-align: left;">Parcial</td>
</tr>
<tr id="result-q4">
<th scope="row" style="text-align: left;">Q4</th>
<td style="text-align: left;"><strong>Condensación en la que un ganador concentra toda la masa en programas semidefinidos de log-determinante por bloques.</strong>
La masa del ganador controla el condicionamiento; cotas ajustadas para consultas del valor de holonomía: <span class="math inline">\(\Theta(N\sqrt{G})\)</span> cuánticas frente a <span class="math inline">\(\Theta(NG)\)</span> aleatorizadas.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/qipm-notes/paper/main.pdf">Documento de resumen</a></td>
<td style="text-align: left;">Posible</td>
</tr>
<tr id="result-q5">
<th scope="row" style="text-align: left;">Q5</th>
<td style="text-align: left;"><strong>Curvas de precisión para conversión de estados con bloques ocultos.</strong>
Curvas ajustadas del número de consultas en función de la precisión para la conversión de estados cuánticos en dominios demostrados; las notas extienden la cota inferior a cualquier predicado interno, un problema abierto del documento de resumen, y dan el error exacto sin consultas en el intervalo que aquel deja abierto.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/qipm-notes/paper/main.pdf">Documento de resumen</a></td>
<td style="text-align: left;">No aplica</td>
</tr>
<tr id="result-q6">
<th scope="row" style="text-align: left;">Q6</th>
<td style="text-align: left;"><strong>Programas lineales con número de condición uno y carga y recuperación difíciles.</strong>
Los programas lineales dispersos con sistemas de Newton reducidos de número de condición uno siguen necesitando un número lineal de consultas para cargar y recuperar estados.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/qipm-notes/paper/main.pdf">Documento de resumen</a></td>
<td style="text-align: left;">No aplica</td>
</tr>
<tr id="result-q7">
<th scope="row" style="text-align: left;">Q7</th>
<td style="text-align: left;"><strong>Límites de las construcciones de cotas inferiores mediante dispositivos de paridad.</strong>
Identidades algebraicas descartan clases naturales de construcciones de cotas inferiores mediante dispositivos de paridad; las notas descartan amplificadores locales acotados de paridad en el sistema KKT completo, un problema abierto del documento de resumen.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/qipm-notes/paper/main.pdf">Documento de resumen</a></td>
<td style="text-align: left;">Parcial</td>
</tr>
<tr id="result-q8">
<th scope="row" style="text-align: left;">Q8</th>
<td style="text-align: left;"><strong>Dificultad de carga y recuperación en programas semidefinidos.</strong>
Los programas semidefinidos normalizados por la traza y con pasos de Newton de número de condición uno siguen teniendo valores y estados solución tan difíciles como la paridad; las notas prueban dificultad para palabras de <span class="math inline">\(\Theta(N)\)</span> de naturaleza genuinamente no abeliana, con transferencia a un programa semidefinido disperso, un problema abierto del documento de resumen.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/qipm-notes/paper/main.pdf">Documento de resumen</a></td>
<td style="text-align: left;">No aplica</td>
</tr>
<tr id="result-q9">
<th scope="row" style="text-align: left;">Q9</th>
<td style="text-align: left;"><strong>Compromisos entre precondicionamiento e interfaces de estados.</strong>
Mejorar el número de condición precondicionado se paga en normalización, sensibilidad de la recuperación o preparación del estado.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/qipm-notes/paper/main.pdf">Documento de resumen</a></td>
<td style="text-align: left;">Parcial</td>
</tr>
<tr id="result-q10">
<th scope="row" style="text-align: left;">Q10</th>
<td style="text-align: left;"><strong>Aceleraciones condicionales para métodos cuánticos dispersos de punto interior.</strong>
Mejoras condicionales por paso mediante actualización certificada, reparación de caras, salida dual comprimida y bordes de estructura angular por bloques.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/qipm-notes/paper/main.pdf">Documento de resumen</a></td>
<td style="text-align: left;">Parcial</td>
</tr>
<tr id="result-q11">
<th scope="row" style="text-align: left;">Q11</th>
<td style="text-align: left;"><strong>Corrección del análisis de complejidad del método cuántico de la trayectoria central.</strong>
Ni la cota de la norma del simulador ni el análisis del reloj de arXiv:2311.03977v2 son válidos tal como se afirman; corrección de la relación entre norma y velocidad.
Los autores nos informaron que ya conocían al menos un error y están preparando una revisión; no había ninguna corrección pública cuando se ejecutaron los agentes.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/qipm-notes/paper/main.pdf">Documento de resumen</a></td>
<td style="text-align: left;">Demostrado</td>
</tr>
<tr id="result-q12">
<th scope="row" style="text-align: left;">Q12</th>
<td style="text-align: left;"><strong>Curvatura, certificados de soporte y complejidad de barrera de representaciones cónicas extendidas.</strong>
Una representación extendida exacta mediante conos definibles de un cuerpo con una porción de frontera estrictamente curva requiere <span class="math inline">\(\sum_i\max(\dim K_i-2,0)\ge s-1\)</span>; el rango mínimo de un certificado de soporte de una bola de dimensión <span class="math inline">\(s\)</span> es exactamente <span class="math inline">\(\lceil (s-1)/B\rceil\)</span>; parámetros de barrera exactos para secciones de equilibrio de conos simétricos.
Además: instancias de productos de discos cuyos estados centrales necesitan <span class="math inline">\(O(1)\)</span> consultas pero cuya lectura escalar necesita <span class="math inline">\(\Theta(N)\)</span>; con oráculos equivalentes en el centro de la fibra, el empaquetamiento semidefinido positivo no ofrece ventaja en consultas para resolver sistemas de Newton reducidos; compilación de restricciones dispersas de cono de segundo orden a un parámetro de barrera de como máximo <span class="math inline">\(k+1\)</span>, con <span class="math inline">\(\Theta(\sqrt{Nk})\)</span> consultas cuánticas frente a <span class="math inline">\(\Theta(N)\)</span> aleatorizadas.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/qipm-notes/conic-lift-complexity/main.pdf">Artículo completo</a></td>
<td style="text-align: left;">Posible</td>
</tr>
<tr id="result-q13">
<th scope="row" style="text-align: left;">Q13</th>
<td style="text-align: left;"><strong>Complejidad clásica y cuántica de consultas para cantidades escalares de Newton.</strong>
Estimación relativa de <span class="math inline">\(b^*H^{-1}b\)</span> con <span class="math inline">\(\kappa\varepsilon^{-2}(d+1)^{O(\sqrt\kappa\log(2/\varepsilon))}\)</span> consultas clásicas y una cota inferior que coincide, salvo factores logarítmicos, con el algoritmo conocido de acceso por bloques <span class="math inline">\(\tilde
  O(\alpha\kappa/\varepsilon)\)</span> en matrices <span class="math inline">\(3\times3\)</span>; muestreo de pasos de Newton mediante consultas estadísticas; programa disperso de cono de segundo orden con un cono: <span class="math inline">\(O(1)\)</span> consultas cuánticas frente a <span class="math inline">\(\tilde\Omega(N^{1-1/k})\)</span> consultas estadísticas clásicas.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/qipm-notes/scalar-newton-paper/main.pdf">Artículo completo</a></td>
<td style="text-align: left;">No aplica</td>
</tr>
<tr id="result-q14">
<th scope="row" style="text-align: left;">Q14</th>
<td style="text-align: left;"><strong>El costo cuántico del desplazamiento espectral con normalización unitaria.</strong>
Responde a un problema abierto del documento de resumen: una escalera ajustada de consultas <span class="math inline">\(\Theta(\delta^{-1+1/(2\ell)})\)</span> para codificaciones por bloques de <span class="math inline">\(I-H\)</span> con normalización uno, y <span class="math inline">\(\Theta(\delta^{-1}\log(1/K))\)</span> a alta precisión; un programa lineal disperso separa el acceso a la matriz normal del acceso al factor.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/qipm-notes/spectral-shift-paper/main.pdf">Artículo completo</a></td>
<td style="text-align: left;">No aplica</td>
</tr>
<tr id="result-q15">
<th scope="row" style="text-align: left;">Q15</th>
<td style="text-align: left;"><strong>Compresión de escenarios con conos exponenciales para riesgo entrópico.</strong>
Comprime <span class="math inline">\(N\)</span> escenarios en <span class="math inline">\(O(1+K+\log)\)</span> conos exponenciales, independientemente de <span class="math inline">\(N\)</span>, con cotas de valor certificadas; cotas coincidentes de <span class="math inline">\(\Theta(e^K/\varepsilon)\)</span> consultas cuánticas frente a <span class="math inline">\(\Theta(e^{2K}/\varepsilon^2)\)</span> consultas clásicas a la fuente bajo el modelo de acceso indicado.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/tree/84c6be7aad17d085e5343e789885c1cbcbbd4e07/qipm-notes" title="Ver las notas de esta área en el commit citado">Solo notas</a></td>
<td style="text-align: left;">No aplica</td>
</tr>
</tbody>
</table>
</div>

<h3 class="unnumbered" id="molecular-thermodynamics">Termodinámica molecular</h3>

<div class="table-wrapper research-inventory" role="region" aria-labelledby="molecular-thermodynamics" tabindex="0">
<table class="research-inventory-table">
<caption>Termodinámica molecular</caption>
<thead>
<tr>
<th scope="col" style="text-align: left;">ID</th>
<th scope="col" style="text-align: left;">Título provisional y contribución declarada</th>
<th scope="col" style="text-align: left;">Documento</th>
<th scope="col" style="text-align: left;">Lean</th>
</tr>
</thead>
<tbody>
<tr id="result-td1">
<th scope="row" style="text-align: left;">TD1</th>
<td style="text-align: left;"><strong>Reservorios finitos en coexistencia de fases: precisión del estado completo y correlaciones entre fases.</strong>
Determina cuándo los baños finitos reproducen distribuciones canónicas; un umbral <span class="math inline">\(N^{3/2}\)</span> para los sistemas de dos fases estudiados bajo las condiciones indicadas sobre las colas de las fases; un baño compartido de tamaño intermedio lleva dos copias a fases opuestas mientras cada copia por separado sigue siendo canónica.
Se basa en <span class="citation" data-cites="riera2012thermalization"><a href="#ref-riera2012thermalization" role="doc-biblioref">[26]</a></span>.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/thermo-notes/paper-finite-reservoirs/main.pdf">Artículo completo</a></td>
<td style="text-align: left;">No aplica</td>
</tr>
<tr id="result-td2">
<th scope="row" style="text-align: left;">TD2</th>
<td style="text-align: left;"><strong>Integración termodinámica condicionada a la supervivencia.</strong>
La integración de fuerzas para trayectorias que sobreviven hasta el extremo final depende del camino, con error de segundo orden para una eliminación débil; las que sobreviven en el interior admiten un potencial exacto.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/tree/84c6be7aad17d085e5343e789885c1cbcbbd4e07/thermo-notes" title="Ver las notas de esta área en el commit citado">Solo notas</a></td>
<td style="text-align: left;">Posible</td>
</tr>
<tr id="result-td3">
<th scope="row" style="text-align: left;">TD3</th>
<td style="text-align: left;"><strong>Tensión interfacial a partir de la respuesta del volumen en modelos no locales de doble parábola.</strong>
Certificados exactos de tensión a partir de la respuesta del volumen; igualar los momentos hasta cuarto orden deja la tensión indeterminada.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/tree/84c6be7aad17d085e5343e789885c1cbcbbd4e07/thermo-notes" title="Ver las notas de esta área en el commit citado">Solo notas</a></td>
<td style="text-align: left;">No aplica</td>
</tr>
<tr id="result-td4">
<th scope="row" style="text-align: left;">TD4</th>
<td style="text-align: left;"><strong>Certificados de capacidad para cinética de nucleación reversible.</strong>
Cotas inferiores de capacidad a partir del transporte condicional; cotas pareadas a campo finito sobre la respuesta de la tasa de nucleación.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/tree/84c6be7aad17d085e5343e789885c1cbcbbd4e07/thermo-notes" title="Ver las notas de esta área en el commit citado">Solo notas</a></td>
<td style="text-align: left;">No aplica</td>
</tr>
</tbody>
</table>
</div>

<h3 class="unnumbered" id="transport-theory">Teoría del transporte</h3>

<div class="table-wrapper research-inventory" role="region" aria-labelledby="transport-theory" tabindex="0">
<table class="research-inventory-table">
<caption>Teoría del transporte</caption>
<thead>
<tr>
<th scope="col" style="text-align: left;">ID</th>
<th scope="col" style="text-align: left;">Título provisional y contribución declarada</th>
<th scope="col" style="text-align: left;">Documento</th>
<th scope="col" style="text-align: left;">Lean</th>
</tr>
</thead>
<tbody>
<tr id="result-tp1">
<th scope="row" style="text-align: left;">TP1</th>
<td style="text-align: left;"><strong>Diseño del transporte superficial bajo cinética incierta: umbrales de momentos y precisión de medición.</strong>
Para un presupuesto pequeño de movilidad superficial <span class="math inline">\(M\)</span>, la mejor distribución fija eleva de <span class="math inline">\(4/3\)</span> a <span class="math inline">\(8/5\)</span> el orden del momento del desorden a partir del cual dominan los defectos raros que se fusionan; observar los defectos mejora la media de <span class="math inline">\(M^{-1/4}\)</span> a <span class="math inline">\(M^{-1/5}\)</span>, y basta una resolución de orden <span class="math inline">\(M^{1/5}\)</span>.
Se basa en <span class="citation" data-cites="buttazzo2011randomshape"><a href="#ref-buttazzo2011randomshape" role="doc-biblioref">[27]</a></span>.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/transport-notes/paper-uncertain-mobility/main.pdf">Artículo completo</a></td>
<td style="text-align: left;">No aplica</td>
</tr>
<tr id="result-tp2">
<th scope="row" style="text-align: left;">TP2</th>
<td style="text-align: left;"><strong>Defectos cinéticos en canales con adsorción.</strong>
Una difusión superficial débil <span class="math inline">\(D_s\)</span> en un mínimo cinético cuadrático produce una divergencia de dispersión <span class="math inline">\(D_s^{-1/4}\)</span> con una transición explícita hacia una tasa mínima positiva; cuando se conoce la ubicación del mínimo, la distribución óptima de un presupuesto de movilidad <span class="math inline">\(M\)</span> mejora la divergencia de <span class="math inline">\(M^{-1/4}\)</span> a <span class="math inline">\(M^{-1/5}\)</span>, el caso de defecto conocido que sustenta TP1; una transición de distribución que se resuelve exactamente.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/tree/84c6be7aad17d085e5343e789885c1cbcbbd4e07/transport-notes" title="Ver las notas de esta área en el commit citado">Solo notas</a></td>
<td style="text-align: left;">No aplica</td>
</tr>
</tbody>
</table>
</div>

<h3 class="unnumbered" id="aggregation-kinetics">Cinética de agregación</h3>

<div class="table-wrapper research-inventory" role="region" aria-labelledby="aggregation-kinetics" tabindex="0">
<table class="research-inventory-table">
<caption>Cinética de agregación</caption>
<thead>
<tr>
<th scope="col" style="text-align: left;">ID</th>
<th scope="col" style="text-align: left;">Título provisional y contribución declarada</th>
<th scope="col" style="text-align: left;">Documento</th>
<th scope="col" style="text-align: left;">Lean</th>
</tr>
</thead>
<tbody>
<tr id="result-ak1">
<th scope="row" style="text-align: left;">AK1</th>
<td style="text-align: left;"><strong>Separación entre leyes de muestreo y correcciones no lineales finitas en coagulación–fragmentación aditiva.</strong>
Cotas ajustadas de separación entre número y masa, una corrección finita del logaritmo del tamaño, ruptura de la aproximación en poblaciones finitas e identificación de Fourier.
Se basa en <span class="citation" data-cites="escobedo2002gelation"><a href="#ref-escobedo2002gelation" role="doc-biblioref">[28]</a></span>.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/aggregation-kinetics-notes/paper-additive-coagulation/main.pdf">Artículo completo</a></td>
<td style="text-align: left;">No aplica</td>
</tr>
<tr id="result-ak2">
<th scope="row" style="text-align: left;">AK2</th>
<td style="text-align: left;"><strong>Supervivencia con dependencia no observada entre tipos hermanos en ramificación multitipo.</strong>
Cotas uniformes del error cerca de la criticidad para la extinción bajo acoplamientos no observados entre descendientes, con un acoplamiento óptimo exacto y una regla para valores reproductivos empatados; las envolventes básicas ajustadas se deducen de resultados conocidos de ramificación y reordenamiento.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/tree/84c6be7aad17d085e5343e789885c1cbcbbd4e07/aggregation-kinetics-notes" title="Ver las notas de esta área en el commit citado">Solo notas</a></td>
<td style="text-align: left;">Posible</td>
</tr>
</tbody>
</table>
</div>

<h3 class="unnumbered" id="heterogeneous-catalysis-proposed-experimental-programs">Catálisis heterogénea: programas experimentales propuestos</h3>

<div class="table-wrapper research-inventory" role="region" aria-labelledby="heterogeneous-catalysis-proposed-experimental-programs" tabindex="0">
<table class="research-inventory-table">
<caption>Catálisis heterogénea: programas experimentales propuestos</caption>
<thead>
<tr>
<th scope="col" style="text-align: left;">ID</th>
<th scope="col" style="text-align: left;">Título provisional y contribución declarada</th>
<th scope="col" style="text-align: left;">Documento</th>
<th scope="col" style="text-align: left;">Lean</th>
</tr>
</thead>
<tbody>
<tr id="result-ca1">
<th scope="row" style="text-align: left;">CA1</th>
<td style="text-align: left;"><strong>Gestión física del agua en la síntesis de Fischer–Tropsch.</strong>
Prueba si añadir un polímero hidrófobo en una etapa tardía protege el cobalto acondicionado; un nuevo análisis de datos publicados encuentra, con el polímero, una producción de aproximadamente 1.9 veces la de referencia.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/catalysis-notes/manuscript/main.pdf">Documento del programa</a></td>
<td style="text-align: left;">No aplica</td>
</tr>
<tr id="result-ca2">
<th scope="row" style="text-align: left;">CA2</th>
<td style="text-align: left;"><strong>Compatibilidad de óxidos cíclicos con vapor en procesos de ciclo químico.</strong>
Prueba si las purgas de vapor, supuestas pero no probadas en un modelo de proceso publicado, cambian la producción de etileno de LSF recubierto; compara el CO<span class="math inline">\(_2\)</span> suministrado junto con el vapor (protección) y después (recuperación).</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/catalysis-notes/manuscript/main.pdf">Documento del programa</a></td>
<td style="text-align: left;">No aplica</td>
</tr>
<tr id="result-ca3">
<th scope="row" style="text-align: left;">CA3</th>
<td style="text-align: left;"><strong>Demanda de catalizador en la etenólisis de polímeros.</strong>
Prueba si una menor presión de etileno puede sustituir parte del catalizador fresco de Na/alúmina cuando un catalizador reutilizado convierte polietileno en propileno.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/catalysis-notes/manuscript/main.pdf">Documento del programa</a></td>
<td style="text-align: left;">No aplica</td>
</tr>
<tr id="result-ca4">
<th scope="row" style="text-align: left;">CA4</th>
<td style="text-align: left;"><strong>Níquel y vida útil de catalizadores de epoxidación de plata promovida.</strong>
Prueba si el níquel aumenta la producción de óxido de etileno más allá de las políticas de dosificación de cloruros; una patente de 1995 ya informa un beneficio de retención.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/blob/84c6be7aad17d085e5343e789885c1cbcbbd4e07/catalysis-notes/manuscript/main.pdf">Documento del programa</a></td>
<td style="text-align: left;">No aplica</td>
</tr>
<tr id="result-ca5">
<th scope="row" style="text-align: left;">CA5</th>
<td style="text-align: left;"><strong>Coordinación y retención del tungsteno en la conversión de azúcares.</strong>
Prueba si una variable controlable de anclaje o alimentación relaciona la coordinación productiva del azúcar, la pérdida de tungsteno y la producción de glicol.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/tree/84c6be7aad17d085e5343e789885c1cbcbbd4e07/catalysis-notes" title="Ver las notas de esta área en el commit citado">Solo notas</a></td>
<td style="text-align: left;">No aplica</td>
</tr>
<tr id="result-ca6">
<th scope="row" style="text-align: left;">CA6</th>
<td style="text-align: left;"><strong>Epoxidación en fase líquida rica en productos con zeolitas de titanio.</strong>
Prueba si una red de reacción calibrada con cinéticas en condiciones diluidas predice la producción de epóxido y la pérdida de peróxido cuando se acumulan los productos.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/tree/84c6be7aad17d085e5343e789885c1cbcbbd4e07/catalysis-notes" title="Ver las notas de esta área en el commit citado">Solo notas</a></td>
<td style="text-align: left;">No aplica</td>
</tr>
<tr id="result-ca7">
<th scope="row" style="text-align: left;">CA7</th>
<td style="text-align: left;"><strong>Destino del oxígeno y autolimpieza en la producción de estireno catalizada por zirconia.</strong>
Prueba si una ruta de eliminación de oxígeno predice una producción sostenida de estireno y una política de alimentación.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/tree/84c6be7aad17d085e5343e789885c1cbcbbd4e07/catalysis-notes" title="Ver las notas de esta área en el commit citado">Solo notas</a></td>
<td style="text-align: left;">No aplica</td>
</tr>
<tr id="result-ca8">
<th scope="row" style="text-align: left;">CA8</th>
<td style="text-align: left;"><strong>Ensayos de sitios ácidos y envejecimiento de zeolitas.</strong>
Prueba si los ensayos repetidos con NH<span class="math inline">\(_3\)</span> y agua cambian el envejecimiento hidrotérmico de H-CHA.</td>
<td style="text-align: left;"><a href="https://github.com/SECQUOIA/agent-swarm-research/tree/84c6be7aad17d085e5343e789885c1cbcbbd4e07/catalysis-notes" title="Ver las notas de esta área en el commit citado">Solo notas</a></td>
<td style="text-align: left;">No aplica</td>
</tr>
</tbody>
</table>
</div>

Significado de los estados:

- **Documento.** *Artículo completo*: manuscrito completo y compilado.
  *Documento de resumen*: parte del documento extenso que reúne los resultados de métodos cuánticos de punto interior, que solicitamos en lugar de artículos separados.
  *Documento del programa*: capítulo del documento que clasifica los programas de catálisis propuestos.
  *Solo notas*: los resultados existen únicamente como notas y comprobaciones de los agentes.

- **Lean.** *Demostrado*: los resultados matemáticos principales están demostrados en Lean, sin pasos pendientes de demostrar; no abarca software ni experimentos.
  *Parcial*: algunos resultados están demostrados en Lean, pero no todos.
  *Posible*: aún no se ha hecho, pero las afirmaciones principales son enunciados matemáticos que podrían formalizarse con las bibliotecas actuales; es una valoración, no una comprobación.
  *No aplica*: las afirmaciones principales se apoyan en evidencia numérica, experimentos o supuestos de modelado, o requieren un marco que las bibliotecas formales actuales no proporcionan, como clases de complejidad, modelos de consultas cuánticas o teoremas límite para procesos estocásticos.

<h2 class="unnumbered" id="references">Referencias</h2>

<div id="refs" lang="en" class="references csl-bib-body" data-entry-spacing="0" role="list">
<div id="ref-alpoge2026-more-than-two-thirds-of" class="csl-entry" role="listitem">
<div class="csl-left-margin">[1] </div><div class="csl-right-inline">L. Alpöge and R. Furman, <span>“<span class="nocase">More than two thirds of the zeta zeros are simple and on the critical line</span>.”</span>
2026.
doi: <a href="https://doi.org/10.48550/arxiv.2608.13637">10.48550/arxiv.2608.13637</a>.</div>
</div>
<div id="ref-openai2026navierstokes" class="csl-entry" role="listitem">
<div class="csl-left-margin">[2] </div><div class="csl-right-inline">OpenAI, <span>“On the <span>N</span>avier–<span>S</span>tokes <span>M</span>illennium <span>P</span>rize <span>P</span>roblem.”</span>
<a href="https://openai.com/index/navier-stokes-solution/" class="uri">https://openai.com/index/navier-stokes-solution/</a>, Sep. 08, 2026.</div>
</div>
<div id="ref-duraisamy2026navierstokescost" class="csl-entry" role="listitem">
<div class="csl-left-margin">[3] </div><div class="csl-right-inline">K. Duraisamy, <span>“<span>N</span>avier–<span>S</span>tokes regularity, what does the computation cost..
And a cartoon on the state of affairs.”</span>
<a href="https://karthik-duraisamy.blogspot.com/2026/09/navier-stokes-regularity-what-does.html" class="uri">https://karthik-duraisamy.blogspot.com/2026/09/navier-stokes-regularity-what-does.html</a>, Sep. 08, 2026.</div>
</div>
<div id="ref-openai2026advisory" class="csl-entry" role="listitem">
<div class="csl-left-margin">[4] </div><div class="csl-right-inline">OpenAI, <span>“Advisory <span>G</span>roup on <span>M</span>athematics and <span>A</span>rtificial <span>I</span>ntelligence.”</span>
<a href="https://openai.com/index/advisory-group-on-mathematics-and-ai/" class="uri">https://openai.com/index/advisory-group-on-mathematics-and-ai/</a>, Sep. 21, 2026.</div>
</div>
<div id="ref-gusev2026corpus" class="csl-entry" role="listitem">
<div class="csl-left-margin">[5] </div><div class="csl-right-inline">S. Gusev and D. E. Bernal Neira, <span>“Agent-swarm-research: Notes, drafts, code, and formal proofs produced by <span>AI</span> agent swarms.”</span>
<a href="https://github.com/SECQUOIA/agent-swarm-research/tree/84c6be7aad17d085e5343e789885c1cbcbbd4e07" class="uri">https://github.com/SECQUOIA/agent-swarm-research/tree/84c6be7aad17d085e5343e789885c1cbcbbd4e07</a>, 2026.</div>
</div>
<div id="ref-kwa2025-measuring-ai-ability-to-complete" class="csl-entry" role="listitem">
<div class="csl-left-margin">[6] </div><div class="csl-right-inline">T. Kwa <em>et al.</em>, <span>“<span class="nocase">Measuring AI Ability to Complete Long Software Tasks</span>,”</span> in <em>Advances in neural information processing systems 38 (NeurIPS 2025)</em>, 2025.
doi: <a href="https://doi.org/10.52202/085713-3086">10.52202/085713-3086</a>.</div>
</div>
<div id="ref-jevons1865coal" class="csl-entry" role="listitem">
<div class="csl-left-margin">[7] </div><div class="csl-right-inline">W. S. Jevons, <em>The coal question: An inquiry concerning the progress of the nation, and the probable exhaustion of our coal-mines</em>.
London: Macmillan, 1865.</div>
</div>
<div id="ref-anthropic2026rsp" class="csl-entry" role="listitem">
<div class="csl-left-margin">[8] </div><div class="csl-right-inline">Anthropic, <span>“Anthropic’s responsible scaling policy, version 3.4.”</span>
<a href="https://www.anthropic.com/responsible-scaling-policy" class="uri">https://www.anthropic.com/responsible-scaling-policy</a>, Jul. 08, 2026.</div>
</div>
<div id="ref-fields2026declaration" class="csl-entry" role="listitem">
<div class="csl-left-margin">[9] </div><div class="csl-right-inline"><span class="nocase">A. Avila <em>et al.</em></span>, <span>“A severe misalignment of <span>AI</span> in mathematics.”</span>
<a href="https://mathandai.org" class="uri">https://mathandai.org</a>, Sep. 11, 2026.</div>
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
<div class="csl-left-margin">[23] </div><div class="csl-right-inline">M. Ballerstein, <span>“Convex relaxations for mixed-integer nonlinear programs,”</span> PhD thesis, ETH Zurich, 2013.
doi: <a href="https://doi.org/10.3929/ethz-a-009959194">10.3929/ethz-a-009959194</a>.</div>
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
