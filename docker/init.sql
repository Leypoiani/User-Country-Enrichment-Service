-- =====================================================
-- Script de Inicialização do Banco de Dados
-- Projeto: User Country Service
-- Descrição: Cria a estrutura inicial do banco de dados
-- =====================================================

-- Usar o banco de dados criado
USE usuario_db;

-- =====================================================
-- Tabela: usuarios
-- Descrição: Armazena informações dos usuários
-- =====================================================
CREATE TABLE IF NOT EXISTS usuarios (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador único do usuário',
    nome VARCHAR(255) NOT NULL COMMENT 'Nome completo do usuário',
    email VARCHAR(255) NOT NULL UNIQUE COMMENT 'Email do usuário (único)',
    genero VARCHAR(50) COMMENT 'Gênero do usuário (M, F, Outro)',
    idade INT COMMENT 'Idade do usuário',
    telefone VARCHAR(20) COMMENT 'Telefone de contato',
    nacionalidade VARCHAR(100) COMMENT 'Nacionalidade do usuário',
    cidade VARCHAR(100) COMMENT 'Cidade de residência',
    estado VARCHAR(100) COMMENT 'Estado/Província de residência',
    pais VARCHAR(100) COMMENT 'País de residência',
    foto_url VARCHAR(500) COMMENT 'URL da foto de perfil',
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação do registro',
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data da última atualização',
    
    -- Índices para melhor performance
    INDEX idx_email (email),
    INDEX idx_nacionalidade (nacionalidade),
    INDEX idx_pais (pais),
    INDEX idx_data_criacao (data_criacao)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tabela de usuários do sistema';

-- =====================================================
-- Dados de Exemplo (opcional)
-- =====================================================
INSERT INTO usuarios (nome, email, genero, idade, telefone, nacionalidade, cidade, estado, pais, foto_url) 
VALUES 
    ('João Silva', 'joao.silva@example.com', 'M', 28, '11987654321', 'Brasileira', 'São Paulo', 'SP', 'Brasil', 'https://example.com/photo1.jpg'),
    ('Maria Santos', 'maria.santos@example.com', 'F', 32, '11912345678', 'Brasileira', 'Rio de Janeiro', 'RJ', 'Brasil', 'https://example.com/photo2.jpg');

-- =====================================================
-- Fim da inicialização
-- =====================================================
