📌 Clínica Médica – Banco de Dados (PostgreSQL)

Este projeto implementa o banco de dados clinica_medica, seguindo o modelo lógico desenvolvido na Faculdade . O objetivo do Trabalho  é transformar esse modelo em tabelas reais no PostgreSQL, criar operações CRUD completas e implementar uma trigger funcional que automatize uma regra do sistema.

1. Objetivo do Projeto

O propósito deste trabalho é realizar a implementação prática do banco de dados de uma clínica médica, incluindo:

Criação estruturada de tabelas com todas as restrições necessárias.

Inserção, consulta, atualização e exclusão de dados (CRUD).

Criação de uma trigger para garantir regras automáticas no banco.

Aplicação de relacionamentos, chaves primárias e estrangeiras conforme o MER.

2. Estrutura Geral do Banco

O banco de dados contém as principais entidades relacionadas ao funcionamento de uma clínica médica:

Tabelas implementadas

medico – Informações dos médicos (CRM, nome, especialidade, telefone).

paciente – Dados pessoais dos pacientes (CPF, nome, endereço, telefone, data de nascimento).

convenio – Convênios cadastrados (CNPJ, operadora, nome do plano).

paciente_convenio – Relação entre pacientes e convênios.

sala – Salas disponíveis para atendimento.

consulta – Agendamentos vinculando médico, paciente e sala.

Foram utilizados tipos de dados adequados como VARCHAR, DATE, NUMERIC, TIME, além de restrições como:

PRIMARY KEY

FOREIGN KEY

NOT NULL

UNIQUE

CHECK

DEFAULT

3. Operações CRUD Implementadas

Cada tabela possui:

INSERTs de exemplo.

SELECTs simples e com JOIN (incluindo consultas completas envolvendo médico, paciente e sala).

UPDATEs alterando informações reais.

DELETEs controlados, incluindo o ajuste necessário para exclusão segura em tabelas com FK (ex.: paciente + paciente_convenio).

Também foi utilizada a opção ON DELETE CASCADE para evitar erros de referência.

4. Trigger Implementada

O sistema inclui uma trigger funcional chamada:

tg_status_consulta_expirada

Ela executa uma função que atualiza automaticamente o campo status das consultas:

➤ O que ela faz?

Ao inserir ou atualizar uma consulta, a trigger executa uma verificação:

Se a data da consulta for anterior ao dia atual,
→ o status é atualizado automaticamente para 'Expirada'.

Isso evita que o sistema mantenha consultas antigas com status incorreto e garante integridade e automação sem depender do usuário.


5. Conclusão

Este trabalho realiza a implementação completa do banco da clínica médica, com:

Tabelas estruturadas conforme o MER.

Operações CRUD completas e funcionais.

Trigger automatizando uma regra realista do sistema.

Relacionamentos consistentes e operações testadas.

O código está organizado, comentado e pronto para uso acadêmico ou como base para aplicação maior.
