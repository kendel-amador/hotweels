USE taller;

DELIMITER $$

DROP PROCEDURE IF EXISTS buscarArticulo$$
CREATE PROCEDURE buscarArticulo (_id int)
begin
    select * from articulo where idArticulo = _id;
end$$

DROP PROCEDURE IF EXISTS filtrarArtefacto$$
CREATE PROCEDURE filtrarArtefacto (
    _parametros varchar(100), -- %serie%&%modelo%&%marca%&%categoria%&
    _pagina SMALLINT UNSIGNED, 
    _cantRegs SMALLINT UNSIGNED)
begin
    SELECT cadenaFiltro(_parametros, 'serie&modelo&marca&categoria&') INTO @filtro;
    SELECT concat("SELECT * from artefacto where ", @filtro, " LIMIT ", 
        _pagina, ", ", _cantRegs) INTO @sql;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;  
end$$

DROP PROCEDURE IF EXISTS numRegsArtefacto$$
CREATE PROCEDURE numRegsArtefacto (
    _parametros varchar(100))
begin
    declare _cant int;
    SELECT cadenaFiltro(_parametros, 'serie&modelo&marca&categoria&') INTO @filtro;
    SELECT concat("SELECT count(id) from artefacto where ", @filtro) INTO @sql;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
end$$

DELIMITER $$

DROP FUNCTION IF EXISTS nuevoArticulo$$
CREATE FUNCTION nuevoArticulo (
    _idArticulo Varchar (11),
    _idCategoriaArticulo int,
    _precio decimal (10,2),
    _descripcion Varchar (150),
    _stock int,
    _imagen Varchar (150))
    RETURNS INT(1)
begin
    declare _cant int;
    select count(id) into _cant from articulo where idArticulo = _idArticulo;
    if _cant < 1 then
        insert into articulo(idArticulo , idCategoriaArticulo, nombre, precio, descripcion, stock, 
            imagen) 
            values (_idArticulo , _idCategoriaArticulo, _nombre, _precio, _descripcion, _stock,
            _imagen);
    end if;
    return _cant;
end

DELIMITER $$

DROP FUNCTION IF EXISTS editarArticulo$$
CREATE FUNCTION editarArticulo (
    _idArticulo Varchar (11),
    _idCategoriaArticulo int,
    _precio decimal (10,2),
    _descripcion Varchar (150),
    _stock int,
    _imagen Varchar (150))
    RETURNS INT(1) 
begin
    declare _cant int;
    select count(_idArticulo) into _cant from articulo where idArticulo = _idArticulo;
    if _cant > 0 then
        -- select count(id) into _cant from artefacto where serie = _serie and id <> _id;
        -- if _cant = 0 then
            update articulo set
                _idCategoriaArticulo = idCategoriaArticulo,
                _precio = precio,
                _descripcion = descripcion,
                _stock = stock,
                _imagen = imagen
            where idArticulo = _idArticulo;
        --    set _cant = 1;
        -- else
        --     set _cant = 2;
        -- end if;
    end if;
    return _cant;
end$$

DELIMITER ;

DROP FUNCTION IF EXISTS eliminarArticulo$$
CREATE FUNCTION eliminarArticulo(_id INT(1)) RETURNS INT(1)
begin
    declare _cant int;
    declare _resp int;
    set _resp = 0;
    select count(idArticulo) into _cant from articulo where idArticulo = _id;
    if _cant > 0 then
        set _resp = 1;
        -- select count(idArticulo) into _cant from articulo where idArticulo = _id;
        if _cant > 0 then
            delete from articulo where idArticulo = _id;
        else 
            set _resp = 2;
        end if;
    end if;
    return _resp;
end$$

DELIMITER ;

