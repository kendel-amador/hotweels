USE matricexamen;

DELIMITER $$

CREATE PROCEDURE buscarProfesor (_id varchar(15))
begin
    select * from Profesor where id = _id;
end$$

CREATE PROCEDURE filtrarProfesor (
    _parametros varchar(100), -- %id%&%nombre%&%apellido1%&%apellido2%&
    _pagina SMALLINT UNSIGNED, 
    _cantRegs SMALLINT UNSIGNED)
begin
    SELECT cadenaFiltro(_parametros, 'id&nombre&apellido1&apellido2&') INTO @filtro;
    SELECT concat("SELECT * from Profesor where ", @filtro, " LIMIT ", 
        _pagina, ", ", _cantRegs) INTO @sql;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;  
end$$

CREATE PROCEDURE numRegsProfesor (
    _parametros varchar(100))
begin
    declare _cant int;
    SELECT cadenaFiltro(_parametros, 'id&nombre&apellido1&apellido2&') INTO @filtro;
    SELECT concat("SELECT count(id) from Profesor where ", @filtro) INTO @sql;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
end$$

CREATE FUNCTION nuevoProfesor (
    _id varchar(15),
    _nombre VARCHAR(15),
    _apellido1 VARCHAR(15),
    _apellido2 VARCHAR(15),
    _telefono INT,
    _celular INT,
    _correo VARCHAR(255),
    _fechaNac DATE)
    RETURNS INT(1) 
begin
    declare _cant int;
    select count(id) into _cant from Profesor where id = _id;
    if _cant = 0 then
        insert into Profesor(id, nombre, apellido1, apellido2, telefono, celular, correo, fechaNac) 
                values (_id, _nombre, _apellido1, _apellido2, _telefono, _celular, _correo, _fechaNac);
    end if;
    return _cant;
end$$

CREATE FUNCTION editarProfesor (
    _id varchar(15),
    _nombre VARCHAR(15),
    _apellido1 VARCHAR(15),
    _apellido2 VARCHAR(15),
    _telefono INT,
    _celular INT,
    _correo VARCHAR(255),
    _fechaNac DATE)
    RETURNS INT(1) 
begin
    declare _cant int;
    select count(id) into _cant from Profesor where id = _id;
    if _cant > 0 then
        update Profesor set
            nombre = _nombre,
            apellido1 = _apellido1,
            apellido2 = _apellido2,
            telefono = _telefono,
            celular = _celular,
            correo = _correo,
            fechaNac = _fechaNac
            where id = _id;
    end if;
    return _cant;
end$$

CREATE FUNCTION eliminarProfesor (_id INT(1)) RETURNS INT(1)
begin
    declare _cant int;
    select count(id) into _cant from Profesor where id = _id;
    if _cant > 0 then
        delete from Profesor where id = _id;
    end if;
    return _cant;
end$$

DELIMITER ;
