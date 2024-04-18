USE taller;

DELIMITER $$

DROP PROCEDURE IF EXISTS buscarProveedor$$
CREATE PROCEDURE buscarProveedor (_id int)
begin
    select * from proveedores where idProveedor = _id;
end$$

DROP PROCEDURE IF EXISTS filtrarProveedor$$
CREATE PROCEDURE filtrarProveedor (
    _parametros varchar(100), -- %idProvedor%&%Nombre%&
    _pagina SMALLINT UNSIGNED, 
    _cantRegs SMALLINT UNSIGNED)
begin
    SELECT cadenaFiltro(_parametros, 'idProveedor&nombre') INTO @filtro;
    SELECT concat("SELECT * from proveedores where ", @filtro, " LIMIT ", 
        _pagina, ", ", _cantRegs) INTO @sql;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;  
end$$


DELIMITER $$

DROP PROCEDURE IF EXISTS numRegsProveedor$$
CREATE PROCEDURE numRegsProveedor (
    _parametros varchar(100))
begin
    declare _cant int;
    SELECT cadenaFiltro(_parametros, 'idProveedor&nombre') INTO @filtro;
    SELECT concat("SELECT count(id) from proveedores where ", @filtro) INTO @sql;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
end$$

DELIMITER ;

DROP FUNCTION IF EXISTS nuevoProveedor$$
CREATE FUNCTION nuevoProveedor (
    _idProveedor Varchar (11),
    _nombre Varchar (255),
    _telefono Varchar (11),
    _correo Varchar (255))
    RETURNS INT(1)
begin
    declare _cant int;
    select count(id) into _cant from proveedores where idProveedor = _idProveedor;
    if _cant < 1 then
        insert into proveedores(idProveedor , nombre, telefono, correo) 
            values (_idProveedor , _nombre, _telefono, _correo);
    end if;
    return _cant;
end$$

DELIMITER $$

DROP FUNCTION IF EXISTS editarProveedor$$
CREATE FUNCTION editarProveedor (
    _idProveedor Varchar (11),
    _nombre Varchar (255),
    _telefono Varchar (11),
    _correo Varchar (255))
    RETURNS INT(1) 
begin
    declare _cant int;
    select count(_idProveedor) into _cant from proveedores where idProveedor = _idProveedor;
    if _cant > 0 then
        -- select count(id) into _cant from artefacto where serie = _serie and id <> _id;
        -- if _cant = 0 then
            update proveedores set
                nombre = _nombre,
                telefono = telefono,
                correo = _correo
            where idProveedor = _idProveedor;
        --    set _cant = 1;
        -- else
        --     set _cant = 2;
        -- end if;
    end if;
    return _cant;
end$$

DELIMITER ;

DROP FUNCTION IF EXISTS eliminarProveedor$$
CREATE FUNCTION eliminarProveedor(_id INT(1)) RETURNS INT(1)
begin
    declare _cant int;
    declare _resp int;
    set _resp = 0;
    select count(idProveedor) into _cant from proveedores where idProveedor = _id;
    if _cant > 0 then
        set _resp = 1;
        -- select count(idArticulo) into _cant from articulo where idArticulo = _id;
        if _cant > 0 then
            delete from proveedores where idProveedor = _id;
        else 
            set _resp = 2;
        end if;
    end if;
    return _resp;
end$$

DELIMITER ;

