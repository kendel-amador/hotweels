DELIMITER $$
DROP FUNCTION IF EXISTS nuevoCategoria$$
CREATE FUNCTION nuevoCategoria (
    _idCategoria int,
    _nombre Varchar (50),
    _descripcion Varchar (150))
    RETURNS INT(1)
    begin
    declare _cant int;
    select count(id) into _cant from categorias where idCategoria = _idCategoria;
    if _cant < 1 then
        insert into categorias(idCategoria , nombre, descripcion) 
            values (_idCategoria , _nombre, _descripcion);
    end if;
    return _cant;
end$$

DROP FUNCTION IF EXISTS editarCategoria$$
CREATE FUNCTION editarCategoria (
    _id INT, 
    _idCategoria INT,  
    _nombre VARCHAR(50), 
    _descripcion VARCHAR(150)) 
    RETURNS int
    begin
        declare _cant int;
        select count(id) into _cant from categorias where id = _id;
        if _cant > 0 then
            update categorias set
                 idCategoria = _idCategoria,
                 nombre = _nombre,
                 descripcion = _descripcion
            where id = _id;
        end if;
        return _cant;
    end$$

DROP FUNCTION IF EXISTS eliminarCategoria$$
CREATE FUNCTION eliminarCategoria (_id INT(1)) RETURNS INT(1)
    begin
        declare _cant int;
        declare _resp int;
        set _resp = 0;
        select count(id) into _cant from categorias where idCategoria = _id;
        if _cant > 0 then
            set _resp = 1;
            if _cant > 0 then
                delete from categorias where idCategoria = _id;
            else 
                set _resp = 2;
            end if;
        end if;
        return _resp;
    end$$

DROP PROCEDURE IF EXISTS filtrarCategoria$$
CREATE PROCEDURE filtrarCategoria (
    _parametros varchar(100), -- %idRol%&%Nombre%&
    _pagina SMALLINT UNSIGNED, 
    _cantRegs SMALLINT UNSIGNED)
begin
    SELECT cadenaFiltro(_parametros, 'idCategoria&nombre&descripcion') INTO @filtro;
    SELECT concat("SELECT * from categorias where ", @filtro, " LIMIT ", 
        _pagina, ", ", _cantRegs) INTO @sql;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;  
end$$

DROP PROCEDURE IF EXISTS numRegsCategoria$$
CREATE PROCEDURE numRegsCategoria (
    _parametros varchar(250))
begin
    SELECT cadenaFiltro(_parametros, 'idCategoria&nombre&descripcion') INTO @filtro;
    SELECT concat("SELECT count(id) from categorias where ", @filtro) INTO @sql;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
end$$

DROP PROCEDURE IF EXISTS buscarCategoria$$
CREATE PROCEDURE buscarCategoria (_id int)
    begin
        select * from categorias where idCategoria = id;
    end$$
DELIMITER ;