-- Criação da base de dados
DROP DATABASE IF EXISTS plataforma_reservas;
CREATE DATABASE plataforma_reservas;
\c plataforma_reservas;

-- Tabela Localizacao
CREATE TABLE Localizacao (
    id SERIAL PRIMARY KEY,
    cep VARCHAR(10) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    estado VARCHAR(100) NOT NULL,
    pais VARCHAR(100) NOT NULL,
    bairro VARCHAR(100)
);

-- Tabela Usuario
CREATE TABLE Usuario (
    cpf VARCHAR(14) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    sobrenome VARCHAR(100) NOT NULL,
    nascimento DATE NOT NULL,
    endereco VARCHAR(255) NOT NULL,
    sexo CHAR(1) CHECK (sexo IN ('M', 'F')), -- (M para masculino, F para feminino)
    telefone VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    senha VARCHAR(100) NOT NULL,
    tipo VARCHAR(50) NOT NULL CHECK (tipo IN ('locador', 'hospede', 'ambos')),
    id_localizacao INT NOT NULL REFERENCES Localizacao(id),
    CONSTRAINT unique_nome_sobrenome_telefone UNIQUE (nome, sobrenome, telefone)
);

-- Tabela Propriedade
CREATE TABLE Propriedade (
    id SERIAL PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL CHECK (tipo IN ('casa inteira', 'quarto individual', 'quarto compartilhado')),
    nome VARCHAR(100) NOT NULL,
    num_quartos INT NOT NULL CHECK (num_quartos > 0),
    num_banheiros INT NOT NULL CHECK (num_banheiros > 0),
    preco_noite DECIMAL(10,2) NOT NULL CHECK (preco_noite > 0),
    max_hospedes INT NOT NULL CHECK (max_hospedes > 0),
    min_noites INT NOT NULL CHECK (min_noites > 0),
    max_noites INT NOT NULL CHECK (max_noites >= min_noites),
    taxa_limpeza DECIMAL(10,2) CHECK (taxa_limpeza >= 0),
    horario_entrada TIME NOT NULL,
    horario_saida TIME NOT NULL,
    id_localizacao INT NOT NULL REFERENCES Localizacao(id),
    cpf VARCHAR(14) NOT NULL REFERENCES Usuario(cpf)
);

-- Tabela Reserva
CREATE TABLE Reserva (
    id SERIAL PRIMARY KEY,
    cpf_hospede VARCHAR(14) NOT NULL REFERENCES Usuario(cpf),
    id_propriedade INT NOT NULL REFERENCES Propriedade(id),
    data_reserva DATE NOT NULL DEFAULT CURRENT_DATE,
    checkin DATE NOT NULL,
    checkout DATE NOT NULL,
    num_hospedes INT NOT NULL CHECK (num_hospedes > 0),
    imposto DECIMAL(10,2) CHECK (imposto >= 0),
    preco_total DECIMAL(10,2) NOT NULL CHECK (preco_total > 0),
    preco_total_imposto DECIMAL(10,2) CHECK (preco_total_imposto >= preco_total),
    taxa_limpeza DECIMAL(10,2) CHECK (taxa_limpeza >= 0),
    status VARCHAR(50) NOT NULL CHECK (status IN ('pendente', 'confirmada', 'cancelada')),
    CONSTRAINT check_dates CHECK (checkout > checkin)
); 

-- Tabela Avaliacao
CREATE TABLE Avaliacao (
    id_avaliacao SERIAL PRIMARY KEY,
    fotos TEXT,
    nota_limpeza DECIMAL(3,1) CHECK (nota_limpeza BETWEEN 0 AND 5),
    nota_estrutura DECIMAL(3,1) CHECK (nota_estrutura BETWEEN 0 AND 5),
    nota_comunicacao DECIMAL(3,1) CHECK (nota_comunicacao BETWEEN 0 AND 5),
    nota_localizacao DECIMAL(3,1) CHECK (nota_localizacao BETWEEN 0 AND 5),
    nota_valor DECIMAL(3,1) CHECK (nota_valor BETWEEN 0 AND 5),
    cpf VARCHAR(14) NOT NULL REFERENCES Usuario(cpf),
    id_propriedade INT NOT NULL REFERENCES Propriedade(id)
);

-- Tabela Conta_Bancaria
CREATE TABLE Conta_Bancaria (
    numero_conta VARCHAR(20),
    agencia VARCHAR(10),
    tipo_conta VARCHAR(20) NOT NULL CHECK (tipo_conta IN ('corrente', 'poupança', 'salário')),
    cpf VARCHAR(14) NOT NULL REFERENCES Usuario(cpf),
    PRIMARY KEY (numero_conta, agencia)
);

-- Tabela Mensagem
CREATE TABLE Mensagem (
    id SERIAL PRIMARY KEY,
    timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    texto TEXT NOT NULL,
    cpf_remetente VARCHAR(14) NOT NULL REFERENCES Usuario(cpf),
    cpf_destinatario VARCHAR(14) NOT NULL REFERENCES Usuario(cpf), 
    id_avaliacao INT REFERENCES Avaliacao(id_avaliacao),
    CHECK (cpf_remetente != cpf_destinatario)
);

-- Tabela Quarto
CREATE TABLE Quarto (
    id_quarto SERIAL PRIMARY KEY,
    num_camas INT NOT NULL CHECK (num_camas > 0),
    tipo_cama VARCHAR(50) NOT NULL,
    banheiro_priv BOOLEAN NOT NULL DEFAULT FALSE,
    id_propriedade INT NOT NULL REFERENCES Propriedade(id)
);

-- Tabela Disponibilidade
CREATE TABLE Disponibilidade (
    id SERIAL PRIMARY KEY,
    data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL,
    id_propriedade INT NOT NULL REFERENCES Propriedade(id),
    CONSTRAINT check_disponibilidade_dates CHECK (data_fim > data_inicio)
);

-- Tabela Comodidade
CREATE TABLE Comodidade (
    id SERIAL PRIMARY KEY,
    descricao TEXT NOT NULL,
    id_propriedade INT NOT NULL REFERENCES Propriedade(id)
);

-- Tabela Regra
CREATE TABLE Regra (
    id SERIAL PRIMARY KEY,
    descricao TEXT NOT NULL,
    id_propriedade INT NOT NULL REFERENCES Propriedade(id)
);