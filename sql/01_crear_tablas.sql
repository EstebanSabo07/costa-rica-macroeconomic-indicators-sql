-- ============================================================
-- Analisis de Indicadores Macroeconomicos de Costa Rica
-- Script: 01_crear_tablas.sql
-- Descripcion: define el esquema de la base de datos.
-- Fuente de los datos: Banco Central de Costa Rica (BCCR)
-- ============================================================

DROP TABLE IF EXISTS ipc;
DROP TABLE IF EXISTS tipo_cambio;
DROP TABLE IF EXISTS tasa_basica_pasiva;

-- Indice de Precios al Consumidor, nivel mensual y variaciones
-- Fuente: BCCR con base en datos del INEC (Cuadro 6011)
CREATE TABLE ipc (
    fecha                 DATE PRIMARY KEY,   -- primer dia del mes
    nivel                 DECIMAL(10,2) NOT NULL,
    variacion_mensual     DECIMAL(6,2),       -- % respecto al mes anterior
    variacion_interanual  DECIMAL(6,2)        -- % respecto al mismo mes del anio anterior
);

-- Tipo de cambio promedio ponderado del mercado mayorista MONEX
-- Fuente: BCCR (Cuadro 748)
CREATE TABLE tipo_cambio (
    fecha              DATE PRIMARY KEY,
    tipo_cambio_monex  DECIMAL(10,2) NOT NULL  -- colones por dolar
);

-- Tasa Basica Pasiva, promedio ponderado semanal
-- Fuente: BCCR (Cuadro 6718)
CREATE TABLE tasa_basica_pasiva (
    fecha_inicio  DATE PRIMARY KEY,
    fecha_fin     DATE NOT NULL,
    tbp           DECIMAL(6,4) NOT NULL   -- en porcentaje
);
