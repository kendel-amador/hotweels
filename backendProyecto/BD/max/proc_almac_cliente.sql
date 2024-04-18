
DELIMITER $$
--
-- Funciones
--
DROP PROCEDURE IF EXISTS buscarPersona$$
CREATE PROCEDURE buscarPersona (_id int, _idPersona varchar(15))
begin
    select * from persona where id = _id or _idPersona = idPersona;
end$$

DROP PROCEDURE IF EXISTS filtrarPersona$$
CREATE PROCEDURE filtrarPersona (
    _parametros varchar(250), -- %idCliente%&%nombre%&%apellido1%&%apellido2%&
    _pagina SMALLINT UNSIGNED, 
    _cantRegs SMALLINT UNSIGNED)
begin
    SELECT cadenaFiltro(_parametros, 'idPersona&nombre&apellidoUno&apellidoDos&') INTO @filtro;
    SELECT concat("SELECT * from persona where ", @filtro, " LIMIT ", 
        _pagina, ", ", _cantRegs) INTO @sql;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
end$$

DROP PROCEDURE IF EXISTS numRegsCliente$$
CREATE PROCEDURE numRegsPersona (
    _parametros varchar(250))
begin
    SELECT cadenaFiltro(_parametros, 'idPersona&nombre&apellidoUno&apellidoDos&') INTO @filtro;
    SELECT concat("SELECT count(id) from persona where ", @filtro) INTO @sql;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
end$$

DROP FUNCTION IF EXISTS nuevoCliente$$
CREATE FUNCTION nuevoCliente (
    _idPersona Varchar(50),
    _nombre Varchar (25),
    _apellidoUno Varchar (50),
    _apellidoDos Varchar (50),
    _correo Varchar (255),    
    _celular Varchar (15))
    RETURNS INT(1) 
begin
    declare _cant int;
    select count(id) into _cant from persona where idPersona = _idPersona;
    if _cant < 1 then
        insert into persona(idPersona, nombre, apellidoUno, apellidoDos, 
            correo, celular) 
            values (_idPersona, _nombre, _apellidoUno, _apellidoDos, 
            _correo, _celular);
    end if;
    return _cant;
end$$


CREATE FUNCTION editarPersona(
    _id INT, _idPersona VARCHAR(15), 
    _nombre VARCHAR(25), 
    _apellidoUno VARCHAR(50), 
    _apellidoDos VARCHAR(50), 
 _correo VARCHAR(255),
    _celular VARCHAR(15) 
   ) 
    RETURNS int(1)
begin
    declare _cant int;
    select count(id) into _cant from persona where id = _id;
    if _cant > 0 then
        select count(id) into _cant from persona where idPersona = idPersona and id <> _id;
        if _cant = 0 THEN
        	set _cant = 1;
        	update persona set
                idPersona = _idPersona,
                nombre = _nombre,
                apellidoUno = _apellidoUno,
                apellidoDos = _apellidoDos,
                correo = _correo,
                celular = _celular
                
        	where id = _id;
        else
        	set _cant = 2;
        end if;
    end if;
    return _cant;
end$$


DROP FUNCTION IF EXISTS eliminarPersona$$
CREATE FUNCTION eliminarPersona (_id INT(1)) RETURNS INT(1)
begin
    declare _cant int;
    declare _resp int;
    set _resp = 0;
    select count(idPersona) into _cant from persona where idPersona = _id;
    if _cant > 0 then
        set _resp = 1;
        if _cant > 0 then
            delete from persona where idPersona = _id;
        else 
            -- select 2 into _resp;
            set _resp = 2;
        end if;
    end if;
    return _resp;
end$$

DELIMITER ;
