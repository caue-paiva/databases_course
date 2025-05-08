
-- 3.5. Diversas estatísticas de usuários, anfitriões e locatários

-- 3.5.a) Usuários que são tanto anfitriões (possuem propriedade) quanto locatários (fizeram reserva)
SELECT 
  u.cpf, u.nome
FROM usuario u
WHERE u.cpf IN (SELECT cpf FROM propriedade)
  AND u.cpf IN (SELECT cpf_hospede FROM reserva);

-- 3.5.b) Anfitriões com pelo menos 5 locações
--     mostrando nome, cidade, qtd imóveis e total de locações
SELECT
  u.cpf,
  u.nome,
  l.cidade,
  COUNT(DISTINCT p.id)       AS qtd_imoveis,
  COUNT(r.id)                AS total_locacoes
FROM usuario u
JOIN propriedade p ON u.cpf = p.cpf
JOIN localizacao l ON u.id_localizacao = l.id
LEFT JOIN reserva r ON p.id = r.id_propriedade
GROUP BY u.cpf, u.nome, l.cidade
HAVING COUNT(r.id) >= 5;

-- 3.5.c) Valor médio das diárias por mês:
--   - de todas as locações
--   - das locações confirmadas
SELECT
  TO_CHAR(DATE_TRUNC('month', r.checkin), 'YYYY-MM') AS mes,
  AVG(p.preco_noite)                                   AS media_geral,
  AVG(p.preco_noite) FILTER (WHERE r.status = 'confirmada') AS media_confirmadas
FROM reserva r
JOIN propriedade p ON r.id_propriedade = p.id
GROUP BY DATE_TRUNC('month', r.checkin)
ORDER BY mes;

-- 3.5.d) Locatários mais jovens do que algum anfitrião
SELECT DISTINCT
  lt.cpf, lt.nome
FROM usuario lt                                   -- lt = locatário
JOIN reserva r ON lt.cpf = r.cpf_hospede
JOIN usuario an ON an.cpf IN (SELECT cpf FROM propriedade)  -- an = anfitrião
WHERE lt.nascimento > an.nascimento;

-- 3.5.e) Locatários mais jovens do que todos os anfitriões
SELECT
  lt.cpf, lt.nome
FROM usuario lt
WHERE lt.cpf IN (SELECT cpf_hospede FROM reserva)
  AND NOT EXISTS (
    SELECT 1
    FROM usuario an
    JOIN propriedade p ON an.cpf = p.cpf
    WHERE lt.nascimento >= an.nascimento
  );