SELECT
  r.id                AS id_locacao,       -- chave da reserva
  r.cpf_hospede,                            -- chave do hóspede
  p.cpf               AS cpf_proprietario, -- chave do proprietário
  (r.checkout - r.checkin) AS total_dias,   -- total de dias locados
  u_prop.nome        AS nome_proprietario,
  u_hosp.nome        AS nome_hospede,
  p.preco_noite      AS valor_diaria
FROM reserva r
JOIN propriedade p    ON r.id_propriedade = p.id
JOIN usuario u_hosp   ON r.cpf_hospede     = u_hosp.cpf
JOIN usuario u_prop   ON p.cpf             = u_prop.cpf
WHERE r.status = 'confirmada'
  AND r.checkin >= DATE '2025-04-24';