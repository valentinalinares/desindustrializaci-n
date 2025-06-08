# Práctica de Visualización de Datos: Desindustrialización

---
Autor: Durga Valentina Linares Herrera
---
Este repositorio contiene la resolución del ejercicio práctico sobre desindustrialización, como parte de la **Diplomatura Problemáticas actuales de la economía, el empleo y el comercio desde la perspectiva de la medición** del Centro de Estudios sobre Población, Empleo y Desarrollo (CEPED) de la Facultad de Ciencias Económicas UBA.
El objetivo de este análisis es visualizar y comprender los cambios en la estructura del empleo industrial a nivel global. El análisis busca responder a la pregunta: **¿Cómo ha cambiado la contribución de cada región al empleo industrial total de la muestra a lo largo del tiempo?**

### Data Source

El análisis se basa en el archivo `empleo_industrial.csv`, que contiene datos del trabajo de investigación de **Graña, J. M., & Terranova, L. (2022)**. Para el análisis, se excluyó el año 1999 debido a la falta de datos para China, siguiendo las indicaciones de la consigna.

---

## Contenido del Repositorio

* `analisis_empleo.R`: El script principal de R que contiene todo el código para el preprocesamiento de datos, los cálculos de participación y la generación del gráfico final.
* `datos_empleo.csv`: El conjunto de datos original utilizado para el análisis.
* `grafico_empleo_vertical.png`: El archivo de imagen del gráfico final, generado y guardado por el script.
* `.gitignore`: Archivo de configuración para que Git ignore archivos temporales de R y las salidas generadas.
* `README.md`: Este mismo archivo, que documenta el proyecto.

---

## Análisis y Metodología

El script `analisis_empleo.R` realiza los siguientes pasos para llegar a la visualización final:

1.  **Filtrado de Datos:** Se carga la base de datos y se filtra para el período 1991-2018, excluyendo el año 1999.
2.  **Agregación por Región:** Se agrupan los datos por año y por región económica para calcular el total de empleo industrial de cada región (`Total_Ocup_Industria_Region`).
3.  **Cálculo de Participación:** Se calcula la participación de cada región en el empleo industrial total de la muestra para cada año. Esto se logra creando un total general para cada año y dividiendo el total de cada región por este total general.
4.  **Generación del Gráfico** 

---

## Referencias

Graña, J. M., & Terranova, L. (2022). *Neither mechanical nor premature: deindustrialization and the New International Division of Labour (1970-2019)*. Department of Economic History and Institutions, Policy and World Economy.