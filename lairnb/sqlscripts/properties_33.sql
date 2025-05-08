-- 1) Mostrar a relação inteira (todas as colunas e tuplas)
SELECT *
FROM propriedade;


-- 2) Contar quantas propriedades existem de cada categoria (tipo)
SELECT
  tipo,
  COUNT(*) AS qtd_por_tipo
FROM propriedade
GROUP BY tipo;


-- 3) Contar quantas propriedades existem em cada cidade
SELECT
  l.cidade,
  COUNT(*) AS qtd_por_cidade
FROM propriedade p
JOIN localizacao l
  ON p.id_localizacao = l.id
GROUP BY l.cidade;

