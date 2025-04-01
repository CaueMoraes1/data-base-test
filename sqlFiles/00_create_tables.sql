-- Criar tabela para armazenar os dados das operadoras
CREATE TABLE IF NOT EXISTS operadoras (
    registro_ans INT PRIMARY KEY, -- Chave primária
    cnpj VARCHAR(20), 
    razao_social VARCHAR(255),
    nome_fantasia VARCHAR(255),
    modalidade VARCHAR(100),
    logradouro VARCHAR(255),
    numero VARCHAR(50),
    complemento VARCHAR(255),
    bairro VARCHAR(100),
    cidade VARCHAR(100),
    uf CHAR(2), 
    cep VARCHAR(8), 
    ddd VARCHAR(3), 
    telefone VARCHAR(20),
    fax VARCHAR(20),
    endereco_eletronico VARCHAR(255),
    representante VARCHAR(255),
    cargo_representante VARCHAR(100),
    regiao_de_comercializacao INT,
    data_registro_ans DATE
);

-- Criar tabela para armazenar os dados financeiros
CREATE TABLE IF NOT EXISTS demonstracoes_contabeis (
    id SERIAL PRIMARY KEY, -- Chave primária
    data DATE NOT NULL, 
    reg_ans INT NOT NULL, 
    cd_conta_contabil VARCHAR(9) NOT NULL, 
    descricao VARCHAR(150) NOT NULL,
    vl_saldo_inicial NUMERIC(15, 2) NOT NULL, 
    vl_saldo_final NUMERIC(15, 2) NOT NULL,
    CONSTRAINT demonstracoes_contabeis_reg_ans_fk FOREIGN KEY (reg_ans) REFERENCES operadoras (registro_ans) ON DELETE CASCADE
);