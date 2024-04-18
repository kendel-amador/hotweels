USE matricexamen;

DELIMITER $$

drop PROCEDURE if EXISTS buscarAlumno$$
CREATE PROCEDURE buscarAlumno (_carnet int)
begin
    select * from Alumno where carnet = _carnet;
end$$

drop PROCEDURE if EXISTS filtrarAlumno$$
CREATE PROCEDURE filtrarAlumno (
    _parametros varchar(100), -- %id%&%carnet%&%nombre%&%apellido1%&%apellido2%&
    _pagina SMALLINT UNSIGNED, 
    _cantRegs SMALLINT UNSIGNED)
begin
    SELECT cadenaFiltro(_parametros, 'id&carnet&nombre&apellido1&apellido2&') INTO @filtro;
    SELECT concat("SELECT * from Alumno where ", @filtro, " LIMIT ", 
        _pagina, ", ", _cantRegs) INTO @sql;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;  
end$$

drop PROCEDURE if EXISTS numRegsAlumno$$
CREATE PROCEDURE numRegsAlumno (
    _parametros varchar(100))
begin
    declare _cant int;
    SELECT cadenaFiltro(_parametros, 'id&carnet&nombre&apellido1&apellido2&') INTO @filtro;
    SELECT concat("SELECT count(carnet) from Alumno where ", @filtro) INTO @sql;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
end$$

drop FUNCTION if EXISTS nuevoAlumno$$
CREATE FUNCTION nuevoAlumno (
    _carnet varchar(12),
    _id varchar(15),
    _nombre VARCHAR(15),
    _apellido1 VARCHAR(15),
    _apellido2 VARCHAR(15),
    _celular INT,
    _correo VARCHAR(255),
    _fechaNac DATE )
    RETURNS INT(1) 
begin
    declare _cant int;
    select count(id) into _cant from Alumno where id = _id or carnet = _carnet;
    if _cant = 0 then
        insert into Alumno(carnet, id, nombre, apellido1, apellido2, celular, correo, fechaNac) 
                values (_carnet, _id, _nombre, _apellido1, _apellido2, _celular, _correo, _fechaNac);
    end if;
    return _cant;
end$$

drop FUNCTION if EXISTS editarAlumno$$
CREATE FUNCTION editarAlumno (
    _carnet varchar(12),
    _id varchar(15),
    _nombre VARCHAR(15),
    _apellido1 VARCHAR(15),
    _apellido2 VARCHAR(15),
    _celular INT,
    _correo VARCHAR(255),
    _fechaNac DATE)
    RETURNS INT(1) 
begin
    declare _cant int;
    select count(id) into _cant from Alumno where id = _id;
    if _cant > 0 then
        update Alumno set
            id = _id,
            nombre = _nombre,
            apellido1 = _apellido1,
            apellido2 = _apellido2,
            celular = _celular,
            correo = _correo,
            fechaNac = _fechaNac
            where carnet = _carnet;
    end if;
    return _cant;
end$$
DROP FUNCTION IF EXISTS eliminarAlumno$$
CREATE FUNCTION eliminarAlumno (_carnet varchar(12)) RETURNS INT(1)
begin
    declare _cant int;
    select count(carnet) into _cant from Alumno where carnet = _carnet;
    if _cant > 0 then
        delete from Alumno where carnet = _carnet;
    end if;
    return _cant;
end$$

DELIMITER ;
