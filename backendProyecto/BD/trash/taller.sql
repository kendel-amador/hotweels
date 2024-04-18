SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: taller
--
DROP DATABASE IF EXISTS taller;
CREATE DATABASE IF NOT EXISTS taller DEFAULT CHARACTER SET utf8mb3 COLLATE utf8mb3_spanish_ci;
USE taller;

DELIMITER $$
--
-- Procedimientos
--
CREATE PROCEDURE buscarArtefacto (_id INT)   begin
    select * from artefacto where id = _id;
end$$

CREATE PROCEDURE filtrarArtefacto (_parametros VARCHAR(100), _pagina SMALLINT UNSIGNED, _cantRegs SMALLINT UNSIGNED)   begin
    SELECT cadenaFiltro(_parametros, 'serie&modelo&marca&categoria&') INTO @filtro;
    SELECT concat("SELECT * from artefacto where ", @filtro, " LIMIT ", 
        _pagina, ", ", _cantRegs) INTO @sql;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;    
end$$

CREATE PROCEDURE numRegsArtefacto (_parametros VARCHAR(100))   begin
    declare _cant int;
    SELECT cadenaFiltro(_parametros, 'serie&modelo&marca&categoria&') INTO @filtro;
    SELECT concat("SELECT count(id) from artefacto where ", @filtro) INTO @sql;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
end$$

--
-- Funciones
--
CREATE FUNCTION cadenaFiltro (_parametros VARCHAR(250), _campos VARCHAR(100)) RETURNS VARCHAR(250) CHARSET utf8mb3 COLLATE utf8mb3_spanish_ci  begin
    declare _salida varchar (100);
    set @param = _parametros;
    set @campos = _campos;
    set @filtro = "";
    WHILE (LOCATE('&', @param) > 0) DO
        set @valor = SUBSTRING_INDEX(@param, '&', 1);
        set @param = substr(@param, LOCATE('&', @param)+1);
        set @campo = SUBSTRING_INDEX(@campos, '&', 1);
        set @campos = substr(@campos, LOCATE('&', @campos)+1);
        set @filtro = concat(@filtro, " ", @campo, " LIKE '", @valor, "' and");       
    END WHILE;
    set @filtro = TRIM(TRAILING 'and' FROM @filtro);  
    return @filtro;
end$$

CREATE FUNCTION cambiarPropietario (_id INT, _idCliente INT) RETURNS INT(1)  begin
    declare _cant int;
    select count(id) into _cant from artefacto where id = _id;
    if _cant > 0 then
        select count(id) into _cant from cliente where id = _idCliente;
        if _cant > 0 then
            update artefacto set
                idCliente = _idCliente
            where id = _id;
        else
            select 2 into _cant;
        end if;
    end if;
    return _cant;
end$$

CREATE FUNCTION editarArtefacto (_id INT, _serie VARCHAR(15), _modelo VARCHAR(15), _marca VARCHAR(15), _categoria VARCHAR(15), _descripcion VARCHAR(50)) RETURNS INT(1)  begin
    declare _cant int;
    select count(id) into _cant from artefacto where id = _id;
    if _cant > 0 then
        select count(id) into _cant from artefacto where serie = _serie and id <> _id;
        if _cant = 0 then
            update artefacto set
                serie = _serie,
                modelo = _modelo,
                marca = _marca,
                categoria = _categoria,
                descripcion = _descripcion
            where id = _id;
            set _cant = 1;
        else
            set _cant = 2; -- Retorna 2 si la serie nueva ya pertenece a otro artefacto
        end if;
    end if;
    return _cant;
end$$

CREATE FUNCTION eliminarArtefacto (_id INT(1)) RETURNS INT(1)  begin
    declare _cant int;
    select count(id) into _cant from Artefacto where id = _id;
    if _cant > 0 then
        select count(idArtefacto) into _cant from caso where idArtefacto = _id;
        if _cant = 0 then
            select 1 into _cant;
            delete from artefacto where id = _id;
        else 
            select 2 into _cant;
        end if;
    end if;
    return _cant;
end$$

CREATE FUNCTION nuevoArtefacto (_idCliente INT(11), _serie VARCHAR(15), _modelo VARCHAR(15), _marca VARCHAR(15), _categoria VARCHAR(15), _descripcion VARCHAR(50)) RETURNS INT(1)  begin
    declare _cant int;
    select count(serie) into _cant from artefacto where serie = _serie;
    if _cant = 0 then
        select count(id) into _cant from cliente where _idCliente = id;
        if _cant > 0 then
            set _cant = 0;
            insert into artefacto(idCliente, serie, modelo, marca, categoria, descripcion) 
                values (_idCliente, _serie, _modelo, _marca, _categoria, _descripcion);
        else
            set _cant = 2;
        end if;
    end if;
    return _cant;
end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla artefacto
--

CREATE TABLE artefacto (
  id int(11) NOT NULL,
  idCliente int(11) NOT NULL,
  serie varchar(15) NOT NULL,
  marca varchar(15) NOT NULL,
  modelo varchar(15) NOT NULL,
  categoria varchar(15) NOT NULL,
  descripcion varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

--
-- Volcado de datos para la tabla artefacto
--

INSERT INTO artefacto (id, idCliente, serie, marca, modelo, categoria, descripcion) VALUES
(2, 2, '123456531', 'VAIO', 'Sony', 'TV', 'Televisor 43 pulgadas'),
(3, 1, '1234565313', 'VAIO', 'Sony', 'TV', 'Televisor 43 pulgadas'),
(4, 1, '32', 'VAIO', 'Sony', 'TV', 'Televisor 54 pulgadas');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla caso
--

CREATE TABLE caso (
  id int(11) NOT NULL,
  idTecnico varchar(15) NOT NULL,
  idCreador varchar(15) NOT NULL,
  idArtefacto int(11) NOT NULL,
  descripcion varchar(100) NOT NULL,
  fechaEntrada date DEFAULT NULL,
  fechaSalida date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla cliente
--

CREATE TABLE cliente (
  id int(11) NOT NULL,
  idCliente varchar(15) NOT NULL,
  nombre varchar(30) NOT NULL,
  apellido1 varchar(15) NOT NULL,
  apellido2 varchar(15) NOT NULL,
  telefono varchar(9) NOT NULL,
  celular varchar(9) DEFAULT NULL,
  direccion varchar(255) DEFAULT NULL,
  correo varchar(100) NOT NULL,
  fechaIngreso datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

--
-- Volcado de datos para la tabla cliente
--

INSERT INTO cliente (id, idCliente, nombre, apellido1, apellido2, telefono, celular, direccion, correo, fechaIngreso) VALUES
(1, '1', 'Luis', 'West', 'Grant', '77777', '88888', 'Cieneguita', 'luiswest@gmail.com', '2023-04-03 17:40:03'),
(2, '2', 'Armando', 'West', 'Grant', '777', '8999', 'Cienega', 'armandowest@gmail.com', '2023-04-03 17:56:30');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla historialcaso
--

CREATE TABLE historialcaso (
  id int(11) NOT NULL,
  idCaso int(11) NOT NULL,
  idResponsable int(11) NOT NULL,
  estado int(11) DEFAULT 0,
  fechaCambio date DEFAULT NULL,
  descripcion varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla usuario
--

CREATE TABLE usuario (
  id int(11) NOT NULL,
  idPersona varchar(15) NOT NULL,
  rol int(11) NOT NULL,
  passw varchar(255) NOT NULL,
  ultimoAcceso datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla artefacto
--
ALTER TABLE artefacto
  ADD PRIMARY KEY (id);

--
-- Indices de la tabla caso
--
ALTER TABLE caso
  ADD PRIMARY KEY (id);

--
-- Indices de la tabla cliente
--
ALTER TABLE cliente
  ADD PRIMARY KEY (id);

--
-- Indices de la tabla historialcaso
--
ALTER TABLE historialcaso
  ADD PRIMARY KEY (id);

--
-- Indices de la tabla usuario
--
ALTER TABLE usuario
  ADD PRIMARY KEY (id),
  ADD UNIQUE KEY idx_Usuario (idPersona);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla artefacto
--
ALTER TABLE artefacto
  MODIFY id int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla caso
--
ALTER TABLE caso
  MODIFY id int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla cliente
--
ALTER TABLE cliente
  MODIFY id int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla historialcaso
--
ALTER TABLE historialcaso
  MODIFY id int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla usuario
--
ALTER TABLE usuario
  MODIFY id int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
