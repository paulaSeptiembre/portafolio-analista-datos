-- Plantilla BigQuery: métricas RFM para segmentación de clientes.
WITH metricas AS (
  SELECT
    cliente_id,
    DATE_DIFF(CURRENT_DATE(), MAX(fecha_compra), DAY) AS recencia_dias,
    COUNT(DISTINCT pedido_id) AS frecuencia_pedidos,
    SUM(monto) AS valor_monetario
  FROM `proyecto.dataset.pedidos`
  GROUP BY cliente_id
)
SELECT
  *,
  NTILE(4) OVER (ORDER BY recencia_dias DESC) AS puntaje_recencia,
  NTILE(4) OVER (ORDER BY frecuencia_pedidos) AS puntaje_frecuencia,
  NTILE(4) OVER (ORDER BY valor_monetario) AS puntaje_valor
FROM metricas;
