USE taller;

DELIMITER $$

DROP PROCEDURE IF EXISTS buscarRol$$
CREATE PROCEDURE buscarRol (_id int, _idRol int)
begin
    select * from roles where idRol = _idRol or id = _id;
end

DROP PROCEDURE IF EXISTS filtrarRol$$
CREATE PROCEDURE filtrarRol (
    _parametros varchar(100), -- %idRol%&%Nombre%&
    _pagina SMALLINT UNSIGNED, 
    _cantRegs SMALLINT UNSIGNED)
begin
    SELECT cadenaFiltro(_parametros, 'idRol&nombre') INTO @filtro;
    SELECT concat("SELECT * from roles where ", @filtro, " LIMIT ", 
        _pagina, ", ", _cantRegs) INTO @sql;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;  
end$$

DROP PROCEDURE IF EXISTS numRegsRol$$
CREATE PROCEDURE numRegsRol (
    _parametros varchar(250))
begin
    SELECT cadenaFiltro(_parametros, 'idRol&nombre&descripcion&') INTO @filtro;
    SELECT concat("SELECT count(id) from roles where ", @filtro) INTO @sql;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
end$$


DROP FUNCTION IF EXISTS nuevoRol$$
CREATE FUNCTION nuevoRol (
    _idRol Varchar (11),
    _nombre Varchar (255),
    _descripcion Varchar (11))
    RETURNS INT(1)
begin
    declare _cant int;
    select count(id) into _cant from roles where idRol = _idRol;
    if _cant < 1 then
        insert into roles(idRol , nombre, descripcion) 
            values (_idRol , _nombre, _descripcion);
    end if;
    return _cant;
end$$



DROP FUNCTION IF EXISTS editarRol$$
CREATE FUNCTION editarRol (
    _idRol Varchar (11),
    _nombre Varchar (255),
    _descripcion Varchar (11))
    RETURNS INT(1) 
begin
    declare _cant int;
    select count(_idRol) into _cant from roles where idRol = _idRol;
    if _cant > 0 then
        -- select count(id) into _cant from artefacto where serie = _serie and id <> _id;
        -- if _cant = 0 then
            update roles set
                nombre = _nombre,
                descripcion = _descripcion
            where idRol = _idRol;
        --    set _cant = 1;
        -- else
        --     set _cant = 2;
        -- end if;
    end if;
    return _cant;
end$$



DROP FUNCTION IF EXISTS eliminarRol$$
CREATE FUNCTION eliminarRol(_id INT(1)) RETURNS INT(1)
begin
    declare _cant int;
    declare _resp int;
    set _resp = 0;
    select count(idRol) into _cant from roles where idRol = _id;
    if _cant > 0 then
        set _resp = 1;
        -- select count(idArticulo) into _cant from articulo where idArticulo = _id;
        if _cant > 0 then
            delete from roles where idRol = _id;
        else 
            set _resp = 2;
        end if;
    end if;
    return _resp;
end$$

DELIMITER ;

