-- ============================================================
-- Analisis de Indicadores Macroeconomicos de Costa Rica
-- Script: 02_consultas_analisis.sql
-- Descripcion: consultas que responden a las preguntas de negocio
--              del proyecto (ver README.md).
-- ============================================================

-- ------------------------------------------------------------
-- Pregunta 1
-- ¿Como ha evolucionado la inflacion interanual en los ultimos
-- meses y esta dentro del rango meta del BCCR (3% +/- 1 punto
-- porcentual, es decir entre 2% y 4%)?
-- ------------------------------------------------------------
SELECT
    fecha,
    variacion_interanual,
    CASE
        WHEN variacion_interanual BETWEEN 2 AND 4 THEN 'Dentro de la meta'
        WHEN variacion_interanual < 2            THEN 'Por debajo de la meta'
        ELSE 'Por encima de la meta'
    END AS estado_meta_bccr
FROM ipc
ORDER BY fecha;


-- ------------------------------------------------------------
-- Pregunta 2
-- Ranking de los meses con mayor alza y mayor baja mensual del IPC
-- (funcion de ventana RANK)
-- ------------------------------------------------------------
SELECT
    fecha,
    variacion_mensual,
    RANK() OVER (ORDER BY variacion_mensual DESC) AS ranking_mayor_alza,
    RANK() OVER (ORDER BY variacion_mensual ASC)  AS ranking_mayor_baja
FROM ipc
ORDER BY variacion_mensual DESC
LIMIT 5;


-- ------------------------------------------------------------
-- Pregunta 3
-- Promedio, maximo, minimo y rango de volatilidad del tipo de
-- cambio por mes
-- ------------------------------------------------------------
SELECT
    strftime('%Y-%m', fecha)                              AS mes,
    ROUND(AVG(tipo_cambio_monex), 2)                        AS promedio,
    MAX(tipo_cambio_monex)                                  AS maximo,
    MIN(tipo_cambio_monex)                                  AS minimo,
    ROUND(MAX(tipo_cambio_monex) - MIN(tipo_cambio_monex),2) AS rango_volatilidad
FROM tipo_cambio
GROUP BY mes
ORDER BY mes;


-- ------------------------------------------------------------
-- Pregunta 4
-- Variacion mes a mes del tipo de cambio promedio (funcion de
-- ventana LAG, mas CTE para dejar la consulta legible)
-- ------------------------------------------------------------
WITH promedio_mensual AS (
    SELECT
        strftime('%Y-%m', fecha) AS mes,
        ROUND(AVG(tipo_cambio_monex), 2) AS promedio
    FROM tipo_cambio
    GROUP BY mes
)
SELECT
    mes,
    promedio,
    LAG(promedio) OVER (ORDER BY mes)                                          AS promedio_mes_anterior,
    ROUND(promedio - LAG(promedio) OVER (ORDER BY mes), 2)                     AS variacion_colones,
    ROUND(100.0 * (promedio - LAG(promedio) OVER (ORDER BY mes))
          / LAG(promedio) OVER (ORDER BY mes), 2)                              AS variacion_porcentual
FROM promedio_mensual
ORDER BY mes;


-- ------------------------------------------------------------
-- Pregunta 5
-- Evolucion semanal de la Tasa Basica Pasiva y su cambio respecto
-- a la semana anterior, en puntos porcentuales
-- ------------------------------------------------------------
SELECT
    fecha_inicio,
    fecha_fin,
    tbp,
    ROUND(tbp - LAG(tbp) OVER (ORDER BY fecha_inicio), 4) AS cambio_semanal_pp
FROM tasa_basica_pasiva
ORDER BY fecha_inicio;


-- ------------------------------------------------------------
-- Pregunta 6
-- Comparacion cruzada: tipo de cambio promedio del mes frente a
-- la inflacion interanual del mismo mes (JOIN entre dos tablas)
-- ------------------------------------------------------------
SELECT
    i.fecha,
    i.variacion_interanual AS inflacion_interanual,
    tc.promedio_tc
FROM ipc i
JOIN (
    SELECT strftime('%Y-%m-01', fecha) AS mes,
           ROUND(AVG(tipo_cambio_monex), 2) AS promedio_tc
    FROM tipo_cambio
    GROUP BY mes
) tc ON strftime('%Y-%m-01', i.fecha) = tc.mes
ORDER BY i.fecha;
