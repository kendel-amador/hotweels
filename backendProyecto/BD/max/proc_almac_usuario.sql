
DELIMITER $$
--aaaaaaaaaaaaaaaaaaaaaaaaaaa
DROP PROCEDURE IF EXISTS buscarUsuario$$
CREATE PROCEDURE buscarUsuario (_id int(11), _idPersona varchar(15))
begin
    select * from usuario where idPersona = _idPersona or id = _id;
end$$


DROP PROCEDURE IF EXISTS filtrarUsuario$$
CREATE PROCEDURE filtrarUsuario (
    _parametros varchar(250), -- %idCliente%&%nombre%&%apellido1%&%apellido2%&
    _pagina SMALLINT UNSIGNED, 
    _cantRegs SMALLINT UNSIGNED)
begin
    SELECT cadenaFiltro(_parametros, 'idPersona&idRol&ultimoAcceso&') INTO @filtro;
    SELECT concat("SELECT * from usuario where ", @filtro, " LIMIT ", 
        _pagina, ", ", _cantRegs) INTO @sql;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
end$$

DROP PROCEDURE IF EXISTS numRegsUsuario$$
CREATE PROCEDURE numRegsUsuario (
    _parametros varchar(250))
begin
    SELECT cadenaFiltro(_parametros, 'idPersona&idRol&ultimoAcceso&') INTO @filtro;
    SELECT concat("SELECT count(id) from usuario where ", @filtro) INTO @sql;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
end$$

--aaaaaaaaaaaaaaaaaaaaaaaaaaa
DROP FUNCTION IF EXISTS nuevoUsuario$$
CREATE FUNCTION nuevoUsuario (
    _idPersona Varchar(15),
    _idRol int,
    _passw Varchar (255))
    RETURNS INT(1) 
begin
    declare _cant int;
    select count(id) into _cant from usuario where idPersona = _idPersona;
    if _cant < 1 then
        insert into usuario(idPersona, idRol, passw) 
            values (_idPersona, _idRol, _passw);
    end if;
    return _cant;
end$$


--jhfkuhfckas
DELIMITER $$

CREATE FUNCTION registrarProducto (
    _IDProducto INT,
    _NPrecio int
    
) RETURNS INT(1) 
begin

 return update productos set
    Precio = _NPrecio

    where ProductoID = _IDProducto
end$$

    CREATE FUNCTION actualizarProductoPrecio (
    _Nombre Varchar (255),
    _Precio int,
    _idTenant int
) RETURNS INT(1) 
begin

 return insert into productos(Nombre, Precio, TenantID) 
            values (_Nombre, _Precio, _idTenant);
    end$$
 
DELIMITER ;
--kjadslsahjdlkasj
DROP FUNCTION IF EXISTS eliminarUsuario$$
CREATE FUNCTION eliminarUsuario (_id INT(1)) RETURNS INT(1)
begin
    declare _cant int;
    select count(id) into _cant from usuario where id = _id;
    if _cant > 0 then
        delete from usuario where id = _id;
    end if;
    return _cant;
end$$
DROP FUNCTION IF EXISTS rolUsuario$$
CREATE FUNCTION rolUsuario (
    _id int, 
    _rol int
    ) RETURNS INT(1) 
begin
    declare _cant int;
    select count(id) into _cant from usuario where id = _id;
    if _cant > 0 then
        update usuario set
            rol = _rol
        where id = _id;
    end if;
    return _cant;
end$$

DROP FUNCTION IF EXISTS passwUsuario$$
CREATE FUNCTION passwUsuario (
    _id int, 
    _passw Varchar(255)
    ) RETURNS INT(1) 
begin
    declare _cant int;
    select count(id) into _cant from usuario where id = _id;
    if _cant > 0 then
        update usuario set
            passw = _passw
        where id = _id;
    end if;
    return _cant;
end$$
DELIMITER ;
