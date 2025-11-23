-- ===============================================
-- 1. CRIAÇÃO DAS TABELAS 
-- ===============================================

CREATE TABLE medico (
    crm VARCHAR(10) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20),
    especialidade VARCHAR(100) NOT NULL
);

CREATE TABLE paciente (
    cpf VARCHAR(11) PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    telefone VARCHAR(20),
    endereco VARCHAR(200),
    cidade VARCHAR(50),
    estado VARCHAR(2),
    rua VARCHAR(100),
    data_nascimento DATE NOT NULL
);

CREATE TABLE sala (
    n_sala INT PRIMARY KEY,
    descricao VARCHAR(200)
);

CREATE TABLE convenio (
    cnpj VARCHAR(14) PRIMARY KEY,
    nome_operadora VARCHAR(120) NOT NULL,
    plano VARCHAR(80) NOT NULL
);

CREATE TABLE paciente_convenio (
    cpf VARCHAR(11),
    cnpj VARCHAR(14),
    PRIMARY KEY (cpf, cnpj),
    FOREIGN KEY (cpf) REFERENCES paciente(cpf) ON DELETE CASCADE,
    FOREIGN KEY (cnpj) REFERENCES convenio(cnpj) ON DELETE CASCADE
);

CREATE TABLE consulta (
    id_consulta SERIAL PRIMARY KEY,
    data DATE NOT NULL,
    hora TIME NOT NULL,
    status VARCHAR(20) CHECK (status IN ('marcada', 'concluída', 'cancelada')),
    valor NUMERIC(10,2),
    anamnese TEXT,

    crm VARCHAR(10) REFERENCES medico(crm) ON DELETE CASCADE,
    cpf VARCHAR(11) REFERENCES paciente(cpf) ON DELETE CASCADE,
    n_sala INT REFERENCES sala(n_sala) ON DELETE CASCADE,
    cnpj VARCHAR(14) REFERENCES convenio(cnpj) ON DELETE CASCADE
);

-- REGRA: impedir médico de ter duas consultas no mesmo horário.


-- ===============================================
-- 2. INSERÇÕES
-- ===============================================

INSERT INTO medico VALUES
('12345', 'Dr. João Lima', '27999990000', 'Cardiologia'),
('54321', 'Dra. Maria Souza', '27988880000', 'Pediatria');

INSERT INTO paciente VALUES
('11111111111', 'Carlos Mendes', '27977770000', 'Av Brasil', 'Vitória', 'ES', 'Rua A', '1990-05-10'),
('22222222222', 'Ana Paula', '27966660000', 'Rua Sete', 'Vila Velha', 'ES', 'Rua B', '1985-12-20');

INSERT INTO sala VALUES
(1, 'Sala de atendimento geral'),
(2, 'Sala de exames');

INSERT INTO convenio VALUES
('12345678000190', 'Unimed', 'Premium'),
('99887766000155', 'SulAmérica', 'Gold');

INSERT INTO paciente_convenio VALUES
('11111111111', '12345678000190'),
('22222222222', '99887766000155');

INSERT INTO consulta (data, hora, status, valor, anamnese, crm, cpf, n_sala, cnpj) VALUES
('2025-11-25', '14:00', 'marcada', 300, '---', '12345', '11111111111', 1, '12345678000190'),
('2025-11-25', '15:00', 'marcada', 250, '---', '54321', '22222222222', 2, '99887766000155');


-- ===============================================
-- 3. CONSULTAS 
-- ===============================================

SELECT c.id_consulta, c.data, c.hora, c.status, c.valor,
       m.nome AS medico, p.nome AS paciente, s.descricao AS sala
FROM consulta c
JOIN medico m ON c.crm = m.crm
JOIN paciente p ON c.cpf = p.cpf
JOIN sala s ON c.n_sala = s.n_sala;

SELECT p.nome, p.cpf, c.nome_operadora, c.plano
FROM paciente p
JOIN paciente_convenio pc ON p.cpf = pc.cpf
JOIN convenio c ON pc.cnpj = c.cnpj;


-- ===============================================
-- 4. UPDATE
-- ===============================================

UPDATE consulta
SET valor = 350
WHERE id_consulta = 1;

UPDATE consulta
SET status = 'concluída'
WHERE id_consulta = 2;


-- ===============================================
-- 5. DELETE 
-- ===============================================

DELETE FROM paciente
WHERE cpf = '22222222222';


-- ===============================================
-- 6. TRIGGER PARA IMPEDIR CONSULTA DUPLICADA
-- ===============================================
-- Esta trigger foi criada para impedir que um mesmo médico tenha duas consultas
-- marcadas no mesmo dia e horário. Assim que uma nova consulta é inserida ou
-- quando uma consulta existente é atualizada, a função impedir_consulta_duplicada()
-- verifica automaticamente se já existe outra consulta cadastrada para o mesmo
-- médico, na mesma data e no mesmo horário. Se existir, o sistema interrompe a
-- operação e exibe uma mensagem de erro, evitando conflitos de agenda e
-- garantindo a integridade do sistema de marcação de consultas.

CREATE OR REPLACE FUNCTION impedir_consulta_duplicada()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS(
        SELECT 1 FROM consulta
        WHERE crm = NEW.crm
        AND data = NEW.data
        AND hora = NEW.hora
        AND id_consulta <> COALESCE(NEW.id_consulta, -1)
    ) THEN
        RAISE EXCEPTION 'O médico já possui uma consulta neste horário!';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_impedir_consulta_duplicada
BEFORE INSERT OR UPDATE ON consulta
FOR EACH ROW
EXECUTE PROCEDURE impedir_consulta_duplicada();


-- ===============================================
-- 7. CONSULTA FINAL PARA DEMONSTRAR QUE FUNCIONOU
-- ===============================================

SELECT * FROM consulta;

-- FIM DO ARQUIVO
