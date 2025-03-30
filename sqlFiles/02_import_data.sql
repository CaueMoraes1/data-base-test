-- Importar os dados das operadoras
DO $$
DECLARE
    file_path TEXT := current_setting('import.operadoras_file_path'); -- Variável de ambiente para o arquivo de operadoras
BEGIN
    -- Criar uma tabela temporária para importar os dados das operadoras
    CREATE TEMP TABLE temp_operadoras (
        registro_ans TEXT,
        cnpj TEXT,
        razao_social TEXT,
        nome_fantasia TEXT,
        modalidade TEXT,
        logradouro TEXT,
        numero TEXT,
        complemento TEXT,
        bairro TEXT,
        cidade TEXT,
        uf TEXT,
        cep TEXT,
        ddd TEXT,
        telefone TEXT,
        fax TEXT,
        endereco_eletronico TEXT,
        representante TEXT,
        cargo_representante TEXT,
        regiao_de_comercializacao TEXT,
        data_registro_ans TEXT
    );

    -- Importar os dados do arquivo CSV para a tabela temporária
    EXECUTE format(
        'COPY temp_operadoras(
            registro_ans, 
            cnpj, 
            razao_social, 
            nome_fantasia, 
            modalidade, 
            logradouro, 
            numero, 
            complemento, 
            bairro, 
            cidade, 
            uf, 
            cep, 
            ddd, 
            telefone, 
            fax, 
            endereco_eletronico, 
            representante, 
            cargo_representante, 
            regiao_de_comercializacao, 
            data_registro_ans
        )
        FROM %L
        DELIMITER %L CSV HEADER',
        file_path,
        ';'
    );

    -- Inserir os dados diretamente na tabela final
    INSERT INTO operadoras (
        registro_ans, 
        cnpj, 
        razao_social, 
        nome_fantasia, 
        modalidade, 
        logradouro, 
        numero, 
        complemento, 
        bairro, 
        cidade, 
        uf, 
        cep, 
        ddd, 
        telefone, 
        fax, 
        endereco_eletronico, 
        representante, 
        cargo_representante, 
        regiao_de_comercializacao, 
        data_registro_ans
    )
    SELECT 
        registro_ans::INTEGER,
        cnpj,
        razao_social,
        nome_fantasia,
        modalidade,
        logradouro,
        numero,
        complemento,
        bairro,
        cidade,
        uf,
        cep,
        ddd,
        telefone,
        fax,
        endereco_eletronico,
        representante,
        cargo_representante,
        regiao_de_comercializacao::INTEGER,
        TO_DATE(data_registro_ans, 'YYYY-MM-DD')
    FROM temp_operadoras;

    -- Limpar a tabela temporária após a importação
    DROP TABLE temp_operadoras;

END $$;

-- Importar os dados financeiros
DO $$
DECLARE
    file_paths TEXT[] := ARRAY[
        current_setting('import.demonstracoes_file_path_1'), -- Variável de ambiente para o primeiro arquivo
        current_setting('import.demonstracoes_file_path_2')  -- Variável de ambiente para o segundo arquivo
    ];
    file_path TEXT;
BEGIN
    -- Criar uma tabela temporária para importar os dados financeiros
    CREATE TEMP TABLE temp_demonstracoes_contabeis (
        data TEXT,
        reg_ans TEXT,
        cd_conta_contabil TEXT,
        descricao TEXT,
        vl_saldo_inicial TEXT,
        vl_saldo_final TEXT
    );

    -- Iterar sobre a lista de arquivos
    FOREACH file_path IN ARRAY file_paths LOOP
        -- Importar o arquivo atual para a tabela temporária
        EXECUTE format(
            'COPY temp_demonstracoes_contabeis(
                data, 
                reg_ans, 
                cd_conta_contabil, 
                descricao, 
                vl_saldo_inicial, 
                vl_saldo_final
            )
            FROM %L
            DELIMITER %L CSV HEADER',
            file_path,
            ';'
        );

        -- Inserir os dados na tabela final
        INSERT INTO demonstracoes_contabeis (
            data, 
            reg_ans, 
            cd_conta_contabil, 
            descricao, 
            vl_saldo_inicial, 
            vl_saldo_final
        )
        SELECT 
            CASE 
                WHEN data ~ '^\d{2}/\d{2}/\d{4}$' THEN TO_DATE(data, 'DD/MM/YYYY')
                WHEN data ~ '^\d{4}-\d{2}-\d{2}$' THEN data::DATE
                ELSE NULL
            END,
            reg_ans::INT,
            cd_conta_contabil,
            descricao,
            REPLACE(vl_saldo_inicial, ',', '.')::NUMERIC,
            REPLACE(vl_saldo_final, ',', '.')::NUMERIC
        FROM temp_demonstracoes_contabeis
        WHERE reg_ans::INT IN (SELECT registro_ans FROM operadoras);

        -- Limpar a tabela temporária
        TRUNCATE temp_demonstracoes_contabeis;
    END LOOP;

END $$;