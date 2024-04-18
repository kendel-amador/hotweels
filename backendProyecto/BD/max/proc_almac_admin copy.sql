
DELIMITER $$
--
-- Funciones
--
DROP PROCEDURE IF EXISTS buscarAdministrador$$
CREATE PROCEDURE buscarAdministrador (_id int, _idAdministrador varchar(15))
begin
    select * from administrador where id = _id or _idAdministrador = _idAdministrador;
end$$

DROP PROCEDURE IF EXISTS filtrarAdministrador$$
CREATE PROCEDURE filtrarAdministrador (
    _parametros varchar(250), -- %idCliente%&%nombre%&%apellido1%&%apellido2%&
    _pagina SMALLINT UNSIGNED, 
    _cantRegs SMALLINT UNSIGNED)
begin
    SELECT cadenaFiltro(_parametros, 'idAdministrador&nombre&apellidoUno&apellidoDos&') INTO @filtro;
    SELECT concat("SELECT * from administrador where ", @filtro, " LIMIT ", 
        _pagina, ", ", _cantRegs) INTO @sql;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
end$$

DROP PROCEDURE IF EXISTS numRegsAdministrador$$
CREATE PROCEDURE numRegsAdministrador (
    _parametros varchar(250))
begin
    SELECT cadenaFiltro(_parametros, 'idAdministrador&nombre&apellidoUno&apellidoDos&') INTO @filtro;
    SELECT concat("SELECT count(id) from administrador where ", @filtro) INTO @sql;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
end$$

DROP FUNCTION IF EXISTS nuevoAdministrador$$
CREATE FUNCTION nuevoAdministrador (
    _idAdministrador Varchar(50),
    _nombre Varchar (25),
    _apellidoUno Varchar (50),
    _apellidoDos Varchar (50),
    _correo Varchar (255),    
    _celular Varchar (15))
    RETURNS INT(1) 
begin
    declare _cant int;
    select count(id) into _cant from administrador where idAdministrador = _idAdministrador;
    if _cant < 1 then
        insert into administrador(idAdministrador, nombre, apellidoUno, apellidoDos, 
            correo, celular) 
            values (_idAdministrador, _nombre, _apellidoUno, _apellidoDos, 
            _correo, _celular);
    end if;
    return _cant;
end$$

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `editarCliente`(`_id` INT, `_idCliente` VARCHAR(15), `_nombre` VARCHAR(30), `_apellidoUno` VARCHAR(15), `_apellidoDos` VARCHAR(15), `_telefono` VARCHAR(9), `_celular` VARCHAR(9), `_direccion` VARCHAR(255), `_correo` VARCHAR(100)) RETURNS int(1)
begin
    declare _cant int;
    select count(id) into _cant from cliente where id = _id;
    if _cant > 0 then
        select count(id) into _cant from cliente where idCliente = _idCliente and id <> _id;
        if _cant = 0 THEN
        	set _cant = 1;
        	update cliente set
                idCliente = _idCliente,
                nombre = _nombre,
                apellido1 = _apellido1,
                apellido2 = _apellido2,
                telefono = _telefono,
                celular = _celular,
                direccion = _direccion,
                correo = _correo
        	where id = _id;
        else
        	set _cant = 2;
        end if;
    end if;
    return _cant;
end$$
DELIMITER ;

DROP FUNCTION IF EXISTS editarAdministrador;
CREATE FUNCTION editarAdministrador(
    _id INT, _idAdministrador VARCHAR(15), 
    _nombre VARCHAR(25), 
    _apellidoUno VARCHAR(50), 
    _apellidoDos VARCHAR(50), 
 _correo VARCHAR(255),
    _celular VARCHAR(15) 
   ) 
    RETURNS int(1)
begin
    declare _cant int;
    select count(id) into _cant from cliente where id = _id;
    if _cant > 0 then
        select count(id) into _cant from cliente where idCliente = _idCliente and id <> _id;
        if _cant = 0 THEN
        	set _cant = 1;
        	update cliente set
                idCliente = _idCliente,
                nombre = _nombre,
                apellido1 = _apellido1,
                apellido2 = _apellido2,
                telefono = _telefono,
                celular = _celular,
                direccion = _direccion,
                correo = _correo
        	where id = _id;
        else
        	set _cant = 2;
        end if;
    end if;
    return _cant;
end$$


DROP FUNCTION IF EXISTS eliminarAdministrador$$
CREATE FUNCTION eliminarAdministrador (_id INT(1)) RETURNS INT(1)
begin
    declare _cant int;
    declare _resp int;
    set _resp = 0;
    select count(idAdministrador) into _cant from administrador where idAdministrador = _id;
    if _cant > 0 then
        set _resp = 1;
        if _cant > 0 then
            delete from administrador where idAdministrador = _id;
        else 
            -- select 2 into _resp;
            set _resp = 2;
        end if;
    end if;
    return _resp;
end$$

DELIMITER ;
