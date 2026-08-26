-- =========================================
-- MV.Delivery - Etapa 3 (VERSÃO FINAL)
-- =========================================

CREATE DATABASE IF NOT EXISTS mv_delivery;
USE mv_delivery;


SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS feedback;
DROP TABLE IF EXISTS historico_status;
DROP TABLE IF EXISTS pedido;
DROP TABLE IF EXISTS entregador;
DROP TABLE IF EXISTS cliente;
SET FOREIGN_KEY_CHECKS = 1;



CREATE TABLE cliente (
  id_cliente INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(20) NOT NULL,
  telefone VARCHAR(20) NOT NULL,
  endereco VARCHAR(200) NOT NULL,
  observacoes VARCHAR(255),
  PRIMARY KEY (id_cliente)
) ENGINE=InnoDB;

CREATE TABLE entregador (
  id_entregador INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(100) NOT NULL,
  contato VARCHAR(20) NOT NULL,
  placa_moto VARCHAR(10) NOT NULL,
  disponivel TINYINT(1) NOT NULL,
  PRIMARY KEY (id_entregador),
  UNIQUE (placa_moto)
) ENGINE=InnoDB;

CREATE TABLE pedido (
  id_pedido INT NOT NULL AUTO_INCREMENT,
  id_cliente INT NOT NULL,
  id_entregador INT NULL,
  data_pedido DATETIME NOT NULL,
  valor DECIMAL(10,2) NOT NULL,
  status VARCHAR(20) NOT NULL,
  endereco_entrega VARCHAR(200) NOT NULL,
  PRIMARY KEY (id_pedido),
  CONSTRAINT fk_pedido_cliente
    FOREIGN KEY (id_cliente) REFERENCES cliente (id_cliente),
  CONSTRAINT fk_pedido_entregador
    FOREIGN KEY (id_entregador) REFERENCES entregador (id_entregador)
) ENGINE=InnoDB;

CREATE TABLE historico_status (
  id_hist INT NOT NULL AUTO_INCREMENT,
  id_pedido INT NOT NULL,
  status VARCHAR(20) NOT NULL,
  data_hora DATETIME NOT NULL,
  observacoes VARCHAR(255),
  PRIMARY KEY (id_hist),
  CONSTRAINT fk_hist_pedido
    FOREIGN KEY (id_pedido) REFERENCES pedido (id_pedido)
) ENGINE=InnoDB;

CREATE TABLE feedback (
  id_feedback INT NOT NULL AUTO_INCREMENT,
  id_pedido INT NOT NULL,
  nota INT NOT NULL,
  comentario VARCHAR(255),
  data_hora DATETIME NOT NULL,
  PRIMARY KEY (id_feedback),
  UNIQUE (id_pedido),
  CONSTRAINT fk_feedback_pedido
    FOREIGN KEY (id_pedido) REFERENCES pedido (id_pedido)
) ENGINE=InnoDB;

--  INSERÇÃO DE DADOS 

INSERT INTO cliente (nome, telefone, endereco, observacoes) VALUES
('Ana',   '31999990001', 'Rua A, 10 - BH', 'Cliente recorrente'),
('Bruno', '31999990002', 'Rua B, 20 - BH', NULL),
('Carla', '31999990003', 'Rua C, 30 - BH', 'Prefere WhatsApp'),
('Diego', '31999990004', 'Rua D, 40 - BH', NULL),
('Elisa', '31999990005', 'Rua E, 50 - BH', 'Entregar no portão');

INSERT INTO entregador (nome, contato, placa_moto, disponivel) VALUES
('João Motoboy',   '31988880001', 'ABC1D23', 1),
('Marcos Rider',   '31988880002', 'DEF4G56', 1),
('Paulo Entregas', '31988880003', 'HIJ7K89', 0),
('Rafa Courier',   '31988880004', 'LMN1O23', 1),
('Bia Flash',      '31988880005', 'PQR4S56', 1);

INSERT INTO pedido (id_cliente, id_entregador, data_pedido, valor, status, endereco_entrega) VALUES
(1, 1, '2026-02-10 10:00:00', 25.50, 'PENDENTE', 'Rua A, 10 - BH'),
(2, 2, '2026-02-10 10:30:00', 40.00, 'EM_ROTA',  'Rua B, 20 - BH'),
(3, 2, '2026-02-10 11:00:00', 18.90, 'ENTREGUE', 'Rua C, 30 - BH'),
(4, NULL, '2026-02-10 11:15:00', 55.00, 'PENDENTE', 'Rua D, 40 - BH'),
(5, 4, '2026-02-10 12:00:00', 12.00, 'CANCELADO','Rua E, 50 - BH');

INSERT INTO historico_status (id_pedido, status, data_hora, observacoes) VALUES
(1, 'PENDENTE', '2026-02-10 10:00:00', 'Pedido criado'),
(2, 'PENDENTE', '2026-02-10 10:30:00', 'Pedido criado'),
(2, 'EM_ROTA',  '2026-02-10 10:45:00', 'Saiu para entrega'),
(3, 'EM_ROTA',  '2026-02-10 11:05:00', 'Saiu para entrega'),
(3, 'ENTREGUE', '2026-02-10 11:40:00', 'Entregue ao cliente');

INSERT INTO feedback (id_pedido, nota, comentario, data_hora) VALUES
(1, 5, 'Chegou muito rápido.', '2026-02-10 13:00:00'),
(2, 4, 'Tava gostoso, só atrasou um pouco.', '2026-02-10 13:10:00'),
(3, 5, 'Amei o atendimento da loja.', '2026-02-10 13:20:00'),
(4, 2, 'Demorou demais para despachar o pedido.', '2026-02-10 13:30:00'),
(5, 1, 'A loja cancelou o pedido e não avisou nem justificou.', '2026-02-10 13:40:00');

--  EXIBIÇÃO 

SELECT * FROM cliente;
SELECT * FROM entregador;
SELECT * FROM pedido;
SELECT * FROM historico_status;
SELECT * FROM feedback;


SELECT * FROM pedido WHERE status = 'PENDENTE';
SELECT * FROM pedido WHERE status = 'CANCELADO';
SELECT * FROM entregador WHERE disponivel = 1;
SELECT * FROM feedback WHERE nota <= 2;
SELECT * FROM historico_status WHERE id_pedido = 3 ORDER BY data_hora;

--  EDIÇÃO (UPDATE) 

UPDATE cliente
SET telefone = '31999991234'
WHERE id_cliente = 1;

UPDATE entregador
SET disponivel = 0
WHERE id_entregador = 4;

UPDATE pedido
SET id_entregador = 1,
    status = 'EM_ROTA'
WHERE id_pedido = 4;

UPDATE historico_status
SET observacoes = 'Atualização registrada pelo entregador'
WHERE id_hist = 1;


UPDATE feedback
SET nota = 3
WHERE id_pedido = 4;

--  EXCLUSÃO (DELETE) 

DELETE FROM historico_status
WHERE id_hist = 2;


DELETE FROM feedback
WHERE id_pedido = 5;


DELETE FROM historico_status
WHERE id_pedido = 5;

DELETE FROM pedido
WHERE id_pedido = 5;


INSERT INTO cliente (nome, telefone, endereco, observacoes)
VALUES ('Cliente Teste', '31999995555', 'Rua Teste, 99 - BH', NULL);

SELECT id_cliente FROM cliente WHERE nome = 'Cliente Teste';


DELETE FROM cliente
WHERE id_cliente = (
  SELECT id_cliente FROM (
    SELECT id_cliente FROM cliente WHERE nome = 'Cliente Teste' LIMIT 1
  ) t
);


INSERT INTO entregador (nome, contato, placa_moto, disponivel)
VALUES ('Entregador Teste', '31900000000', 'TST0X00', 1);

DELETE FROM entregador
WHERE placa_moto = 'TST0X00';

SELECT * FROM pedido;
SELECT * FROM historico_status;
SELECT * FROM feedback;




