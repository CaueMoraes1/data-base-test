# **Data Base Test Project**

Este projeto contém scripts SQL para criar, importar e analisar dados relacionados a operadoras e demonstrações contábeis. Ele utiliza arquivos CSV localizados na pasta `preparationFiles`.


## **Pré-requisitos**

1. **Banco de Dados**:
   - Certifique-se de que você tem um banco de dados PostgreSQL configurado e rodando.
   - Crie um banco de dados vazio para o projeto (ex.: `data_base_test`).

     ```sql
     CREATE DATABASE data_base_test;
     ```

2 **Arquivos CSV**:
   - Certifique-se de que os arquivos `Relatorio_cadop.csv`, `4T2023.csv` e `4T2024.csv` estão na pasta `preparationFiles`.

4. **Permissões**:
   - O usuário do PostgreSQL deve ter permissão para acessar os arquivos CSV e a pasta `preparationFiles`.


## **Configuração**

1. **Configurar os Caminhos dos Arquivos**:
   - Edite o arquivo `sqlFiles/00_config.sql` e configure os caminhos dos arquivos CSV, se necessário:
     ```sql
     -- Caminho para o arquivo de operadoras
     SET import.operadoras_file_path TO '../preparationFiles/Relatorio_cadop.csv';

     -- Caminhos para os arquivos financeiros
     SET import.demonstracoes_file_path_1 TO '../preparationFiles/4T2023.csv';
     SET import.demonstracoes_file_path_2 TO '../preparationFiles/4T2024.csv';
     ```

2. **Executar o Arquivo de Configuração**:
   - Antes de rodar os scripts de importação, execute o arquivo `00_config.sql` no PostgreSQL:
     ```bash
     psql -U seu_usuario -d data_base_test -f sqlFiles/00_config.sql
     ```


## **Execução**

1. **Criar as Tabelas**:
   - Execute o script `01_create_tables.sql` para criar as tabelas necessárias:
     ```bash
     psql -U seu_usuario -d data_base_test -f sqlFiles/01_create_tables.sql
     ```

2. **Importar os Dados**:
   - Execute o script `02_import_data.sql` para importar os dados dos arquivos CSV:
     ```bash
     psql -U seu_usuario -d data_base_test -f sqlFiles/02_import_data.sql
     ```

3. **Executar Consultas Analíticas**:
   - Use o script `03_analytical_queries.sql` para rodar as análises:
     ```bash
     psql -U seu_usuario -d data_base_test -f sqlFiles/03_analytical_queries.sql
     ```


## **Problemas Comuns**

1. **Erro: "No such file or directory"**:
   - Certifique-se de que os arquivos CSV estão no diretório correto (`preparationFiles`) e que o caminho no `00_config.sql` está correto.

2. **Erro de Permissão**:
   - Verifique se o usuário do PostgreSQL tem permissão para acessar os arquivos CSV e a pasta.


