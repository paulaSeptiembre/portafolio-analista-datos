-- Plantilla BigQuery: retención mensual por cohorte.
-- Reemplaza `proyecto.dataset.actividad_clientes` por una tabla pública o sintética.
WITH actividad AS (
  SELECT
    cliente_id,
    DATE_TRUNC(fecha_evento, MONTH) AS mes_actividad,
    DATE_TRUNC(MIN(fecha_evento) OVER (PARTITION BY cliente_id), MONTH) AS mes_cohorte
  FROM `proyecto.dataset.actividad_clientes`
), cohortes AS (
  SELECT
    mes_cohorte,
    DATE_DIFF(mes_actividad, mes_cohorte, MONTH) AS meses_desde_alta,
    COUNT(DISTINCT cliente_id) AS clientes_activos
  FROM actividad
  GROUP BY 1, 2
)
SELECT *
FROM cohortes
ORDER BY mes_cohorte, meses_desde_alta;
