# Proyecto Final Microeconomía I  
## Oferta laboral en la gig economy dominicana (2020–2025)

Este repositorio contiene el código y los datos necesarios para replicar el análisis empírico del proyecto final de Microeconomía I (INTEC).

El estudio analiza la oferta laboral en plataformas digitales en República Dominicana, con énfasis en la dependencia del ingreso, la intensidad de trabajo, la respuesta a incentivos monetarios y diferencias temporales.

---

## Estructura del proyecto

- `codigo/`  
  Scripts en R para la preparación de datos y el análisis econométrico.
  
- `datos/`  
  Base de datos de la encuesta y versión limpia utilizada para el análisis.
  
- `resultados/`  
  Figuras y tablas generadas automáticamente por los scripts.

---

## Scripts principales

- `01_preparacion_datos.R`  
  Importa la encuesta original, limpia los datos y construye las variables utilizadas en el análisis.

- `02_modelos_y_tablas.R`  
  Genera estadísticas descriptivas, gráficos, pruebas de hipótesis, modelos econométricos y exporta tablas de resultados.

---

## Software y paquetes utilizados

El análisis fue realizado en R.  
Paquetes principales:
- tidyverse  
- readxl  
- janitor  
- skimr  
- stargazer  
- lmtest  
- sandwich  

---

## Outputs principales

- Figuras:
  - Distribución de horas semanales trabajadas
  - Boxplot de horas trabajadas según ingreso principal

- Tablas:
  - Modelo 1: Determinantes de las horas trabajadas
  - Modelo 2: Probabilidad de que la plataforma sea ingreso principal
  - Modelo 4: Diferencias por período de inicio

---

## Replicación

Para instrucciones detalladas de replicación, consultar el archivo `REPLICATION_GUIDE.txt`.
