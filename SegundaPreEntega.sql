CREATE DATABASE agencia_aseguradora;
USE agencia_aseguradora;

CREATE TABLE usuario (
id_usuario INT NOT NULL AUTO_INCREMENT,
nombre_de_usuario VARCHAR(15) NOT NULL,
nombre VARCHAR(20) NOT NULL,
apellido VARCHAR(20) NOT NULL,
PRIMARY KEY (id_usuario));

CREATE TABLE  IF NOT EXISTS seguros_vehiculos (
vehiculo VARCHAR(30) NOT NULL,
marca VARCHAR(20) NOT NULL,
modelo VARCHAR(20) NOT NULL,
id_patente NUMERIC(10) NOT NULL AUTO_INCREMENT,
id_usuario INT AUTO_INCREMENT,
PRIMARY KEY (id_patente),
FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario));

CREATE TABLE IF NOT EXISTS seguros_viviendas (
pais VARCHAR(30) NOT NULL,
localidad VARCHAR(30) NOT NULL,
direccion VARCHAR(30) NOT NULL,
altura NUMERIC(10) NOT NULL,
id_usuario INT AUTO_INCREMENT,
PRIMARY KEY (direccion),
FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario));

ALTER TABLE seguros_viviendas modify localidad VARCHAR(50) NOT NULL;
ALTER TABLE seguros_viviendas modify direccion VARCHAR(50) NOT NULL;

CREATE TABLE IF NOT EXISTS informacion_personal (
nombre VARCHAR(40) NOT NULL,
apellido VARCHAR(40) NOT NULL,
telefono VARCHAR(40) NOT NULL,
email VARCHAR(30) NOT NULL,
dni NUMERIC(20) NOT NULL,
id_usuario INT AUTO_INCREMENT,
PRIMARY KEY (id_usuario, dni),
FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario));

CREATE TABLE IF NOT EXISTS servicios(
id_producto INT AUTO_INCREMENT,
tipo VARCHAR(30) NOT NULL,
precios_servicios INT NOT NULL,
PRIMARY KEY (Id_producto)
);

CREATE TABLE IF NOT EXISTS servicios_contratados(
id_orden INT AUTO_INCREMENT,
fecha DATE NOT NULL,
nombre VARCHAR(30) NOT NULL,
tipo VARCHAR(30) NOT NULL,
PRIMARY KEY(id_orden)
);


INSERT INTO seguros_vehiculos (vehiculo, marca, modelo, id_patente) 
	VALUES ("Auto", "Alfa Romeo", "Giulietta", "132"),
    ("Auto", "Alfa Romeo", "Stelvio", "112"),
    ("Auto", "ASTON MARTIN", "Vantage V8", "864"),
    ("Auto", "ASTON MARTIN", "Rapide", "667"),
    ("Auto", "AUDI", "A8", "409"),
	("Moto", "Benelli", "752S", "001"),
	("Moto", "BMW", "G 310 R", "113"),
	("Moto", "BMW", "R 1250 R", "743"),
	("Moto", "Ducati", "Hypermotard 698 Mono", "590"),
    ("Moto", "Ducati", "Monster SP", "263");
    
SELECT * FROM usuario;
SELECT * FROM seguros_vehiculos;
SELECT * FROM seguros_viviendas;
SELECT * FROM informacion_personal;

INSERT INTO servicios (id_producto, tipo, precios_servicios)
VALUES (101,'Autos', 10000),
(102, 'Motos', 5000),
(103, 'Viviendas', 25000);


-- Se crean las vistas para obtener los precios de cada servicio --

CREATE OR REPLACE VIEW servicios_autos_vw AS
SELECT tipo, precios_servicios
FROM servicios
WHERE tipo = "Autos";

CREATE OR REPLACE VIEW servicios_motos_vw AS
SELECT tipo, precios_servicios
FROM servicios
WHERE tipo = "Motos";

CREATE OR REPLACE VIEW servicios_viviendas_vw AS
SELECT tipo, precios_servicios
FROM servicios
WHERE tipo = "Viviendas";


-- Se crea la vista para ver que servicio compra cada usuario --

CREATE OR REPLACE VIEW servicio_contratado_vw AS
SELECT u.nombre_de_usuario, u.nombre, s.id_producto, s.tipo
FROM usuario AS u JOIN servicios AS s ;

select * from servicio_contratado_vw;

-- Stored Procedures para ordenar las tablas . --
DELIMITER //
CREATE PROCEDURE ordenar_tablas_sp (IN tabla VARCHAR (20), IN campo VARCHAR (20), IN orden VARCHAR (4))
BEGIN
SET @ordenar = CONCAT( 'SELECT * FROM', ' ', tabla, ' ','ORDER BY',' ', campo,' ', orden);
PREPARE consulta FROM @ordenar;
EXECUTE consulta;
DEALLOCATE PREPARE consulta;
END
//

-- Tabla servicios ordenada desde los precios de forma descendente -- 
CALL ordenar_tablas_sp ('servicios', 'precios_servicios', 'DESC');

-- Tomar contrataciones a medida que entran --
DELIMITER //
CREATE PROCEDURE servicios_contratados_sp (IN orden INT, IN sp_fecha DATE, IN sp_nombre VARCHAR (30), in sp_tipo VARCHAR (30))
BEGIN
INSERT INTO servicios_contratados
(id_orden,fecha, nombre, tipo)
VALUES
(orden, sp_fecha, sp_nombre, sp_tipo);
END
//
-- Insertamos servicio contratado -- 
CALL servicios_contratados_sp (1, '2024-08-15', 'Roombo', "Autos");

-- Verificamos insercion --
SELECT * FROM servicios_contratados;