CREATE DATABASE casa_seguros;
USE casa_seguros;

CREATE TABLE usuario (
id_usuario INT NOT NULL AUTO_INCREMENT,
nombre_de_usuario VARCHAR(15) NOT NULL,
nombre VARCHAR(20) NOT NULL,
apellido VARCHAR(20) NOT NULL,
PRIMARY KEY (id_usuario));

CREATE TABLE seguros_vehiculos (
vehiculo VARCHAR(30) NOT NULL,
marca VARCHAR(20) NOT NULL,
modelo VARCHAR(20) NOT NULL,
id_patente NUMERIC(10) NOT NULL,
id_usuario INT,
PRIMARY KEY (id_patente),
FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario));

CREATE TABLE seguros_viviendas (
vivienda VARCHAR(30) NOT NULL,
localidad VARCHAR(30) NOT NULL,
id_direccion VARCHAR(30) NOT NULL,
altura NUMERIC(5) NOT NULL,
id_usuario INT,
PRIMARY KEY (id_direccion),
FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario));

CREATE TABLE informacion_personal (
nombre VARCHAR(30) NOT NULL,
apellido VARCHAR(30) NOT NULL,
fecha_nacimiento DATE,
telefono VARCHAR(30) NOT NULL,
email VARCHAR(30) NOT NULL,
dni NUMERIC(8) NOT NULL,
id_usuario INT,
PRIMARY KEY (id_usuario, dni),
FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario));