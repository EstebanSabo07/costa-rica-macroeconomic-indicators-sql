# Análisis de Indicadores Macroeconómicos de Costa Rica

Análisis de la evolución reciente de tres indicadores clave de la economía costarricense — inflación (IPC), tipo de cambio del dólar y tasa básica pasiva — usando datos públicos del Banco Central de Costa Rica (BCCR).

## Motivación

Con formación en economía (Capital Markets & Risk) y en curso del Bachillerato en Ingeniería en Ciencia de Datos, este proyecto combina ambos campos: usar SQL para explorar datos macroeconómicos reales y Excel para comunicar los hallazgos de forma clara, como se haría en un reporte para un equipo de análisis o tesorería.

## Preguntas de negocio

1. ¿Cómo ha evolucionado la inflación interanual en los últimos meses? ¿Se mantiene dentro del rango meta del BCCR (3% ± 1 punto porcentual)?
2. ¿Cuáles fueron los meses con mayor alza y mayor baja mensual del IPC?
3. ¿Qué tan volátil ha sido el tipo de cambio del dólar mes a mes (promedio, máximo, mínimo)?
4. ¿Cómo varía el tipo de cambio promedio de un mes al siguiente, en colones y en porcentaje?
5. ¿Cómo se ha movido la Tasa Básica Pasiva semana a semana?
6. ¿Existe alguna relación visible entre la inflación interanual y el nivel del tipo de cambio en el mismo mes?

## Fuente de los datos

Todos los datos provienen directamente del Banco Central de Costa Rica (BCCR), a través de su portal de Indicadores Económicos:

- **IPC** (Índice de Precios al Consumidor): Cuadro 6011, base junio 2015 = 100.
- **Tipo de cambio MONEX**: Cuadro 748, promedio ponderado del mercado mayorista MONEX, en colones por dólar.
- **Tasa Básica Pasiva (TBP)**: Cuadro 6718, promedio ponderado semanal.

Portal: https://gee.bccr.fi.cr/indicadoreseconomicos

## Estructura del proyecto

```
├── data/
│   ├── ipc_mensual.csv                  # Nivel y variaciones del IPC, mensual
│   ├── tipo_cambio_monex_diario.csv     # Tipo de cambio MONEX, diario (días hábiles)
│   └── tasa_basica_pasiva_semanal.csv   # TBP, semanal
├── sql/
│   ├── 01_crear_tablas.sql              # Definición del esquema
│   └── 02_consultas_analisis.sql        # Consultas que responden las preguntas de negocio
├── db/
│   └── indicadores_cr.db                # Base de datos SQLite ya cargada con los datos
└── excel/
    └── Reporte_Indicadores_Macroeconomicos_CR.xlsx   # Reporte final con tablas y gráficos
```

## Cómo reproducirlo

1. Crear la base de datos y cargar los datos (con `sqlite3` instalado):

   ```bash
   sqlite3 db/indicadores_cr.db < sql/01_crear_tablas.sql
   sqlite3 db/indicadores_cr.db
   .mode csv
   .import --skip 1 data/ipc_mensual.csv ipc
   .import --skip 1 data/tipo_cambio_monex_diario.csv tipo_cambio
   .import --skip 1 data/tasa_basica_pasiva_semanal.csv tasa_basica_pasiva
   ```

   (También se incluye la base de datos ya construida en `db/indicadores_cr.db` por si se prefiere usarla directamente.)

2. Ejecutar las consultas de `sql/02_consultas_analisis.sql` sobre la base de datos para reproducir cada resultado.

3. El archivo `excel/Reporte_Indicadores_Macroeconomicos_CR.xlsx` contiene los resultados de esas consultas ya organizados en tablas y gráficos, listos para revisar sin necesidad de correr nada.

## Hallazgos principales

- La inflación interanual se ha mantenido **por debajo de la meta del BCCR** (2%-4%) durante la mayor parte del período analizado, llegando a mínimos cercanos a -2.7% a inicios de 2026.
- El tipo de cambio del dólar mostró una tendencia de **depreciación del dólar frente al colón** a lo largo de 2025 y el primer semestre de 2026, pasando de niveles cercanos a 510 colones a inicios de 2025 hasta rondar los 453-455 colones a mediados de 2026.
- La Tasa Básica Pasiva se movió de forma **gradual y descendente** en el período semanal analizado, de 3.84% a 3.72%, consistente con la tendencia a la baja del tipo de cambio y de la inflación.

## Herramientas utilizadas

SQL (SQLite): consultas con `JOIN`, `GROUP BY`, funciones de ventana (`RANK`, `LAG`), `CASE WHEN` y CTEs.
Excel: tablas dinámicas y gráficos de línea para comunicar la tendencia de cada indicador.

## Próximos pasos

Este es el primero de una serie de proyectos de portafolio. Los siguientes extienden este mismo análisis con Python (limpieza y exploración de datos) y Power BI (dashboard interactivo con DAX), usando esta misma fuente de datos del BCCR.
