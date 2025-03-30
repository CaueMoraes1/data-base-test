-- Top 10 operadoras com maiores despesas no último trimestre de 2024
SELECT 
    o.razao_social AS operadora,
    TO_CHAR(SUM(d.vl_saldo_final - d.vl_saldo_inicial), 'L9G999G999G990D99') AS total_despesa -- Formatar como moeda em reais
FROM 
    demonstracoes_contabeis d
JOIN 
    operadoras o 
ON 
    d.reg_ans = o.registro_ans
WHERE 
    d.descricao ILIKE '%eventos/sinistros%' -- Descrição contém "eventos/sinistros"
    AND d.data >= '2024-10-01' -- Início do último trimestre de 2024
    AND d.data <= '2024-12-31' -- Fim do último trimestre de 2024
GROUP BY 
    o.razao_social
ORDER BY 
    SUM(d.vl_saldo_final - d.vl_saldo_inicial) DESC
LIMIT 10;

-- Top 10 operadoras com maiores despesas no ano de 2024
SELECT 
    o.razao_social AS operadora,
    TO_CHAR(SUM(d.vl_saldo_final - d.vl_saldo_inicial), 'L9G999G999G990D99') AS total_despesa -- Formatar como moeda em reais
FROM 
    demonstracoes_contabeis d
JOIN 
    operadoras o 
ON 
    d.reg_ans = o.registro_ans
WHERE 
    d.descricao ILIKE '%eventos/sinistros%' -- Descrição contém "eventos/sinistros"
    AND d.data >= '2024-01-01' -- Início do ano de 2024
    AND d.data <= '2024-12-31' -- Fim do ano de 2024
GROUP BY 
    o.razao_social
ORDER BY 
    SUM(d.vl_saldo_final - d.vl_saldo_inicial) DESC
LIMIT 10;