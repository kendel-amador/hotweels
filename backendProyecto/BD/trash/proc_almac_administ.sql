USE matricexamen;

DELIMITER $$
drop PROCEDURE IF EXISTS buscarAdministrativo$$
CREATE PROCEDURE buscarAdministrativo (_id varchar(15))
begin
    select * from Administrativo where id = _id;
end$$

drop PROCEDURE IF EXISTS filtrarAdministrativo$$
CREATE PROCEDURE filtrarAdministrativo (
    _parametros varchar(100), -- %id%&%nombre%&%apellido1%&%apellido2%&%apuesto%&
    _pagina SMALLINT UNSIGNED, 
    _cantRegs SMALLINT UNSIGNED)
begin
    SELECT cadenaFiltro(_parametros, 'id&nombre&apellido1&apellido2&puesto&') INTO @filtro;
    SELECT concat("SELECT * from Administrativo where ", @filtro, " LIMIT ", 
        _pagina, ", ", _cantRegs) INTO @sql;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;  
end$$

drop PROCEDURE IF EXISTS numRegsAdministrativo$$
CREATE PROCEDURE numRegsAdministrativo (
    _parametros varchar(100))
begin
    declare _cant int;
    SELECT cadenaFiltro(_parametros, 'id&nombre&apellido1&apellido2&puesto&') INTO @filtro;
    SELECT concat("SELECT count(id) from Administrativo where ", @filtro) INTO @sql;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
end$$

drop FUNCTION IF EXISTS nuevoAdministrativo$$
CREATE FUNCTION nuevoAdministrativo (
    _id varchar(15),
    _nombre VARCHAR(15),
    _apellido1 VARCHAR(15),
    _apellido2 VARCHAR(15),
    _telefono INT,
    _correo VARCHAR(255),
    _fechaNac DATE,
    puesto varchar(30)
    ) RETURNS INT(1) 
begin
    declare _cant int;
    select count(id) into _cant from Administrativo where id = _id;
    if _cant = 0 then
        insert into Administrativo(id, nombre, apellido1, apellido2, telefono, correo, fechaNac, puesto) 
                values (_id, _nombre, _apellido1, _apellido2, _telefono, _correo, _fechaNac, _puesto);
    end if;
    return _cant;
end$$

drop FUNCTION IF EXISTS editarAdministrativo$$
CREATE FUNCTION editarAdministrativo (
    _id varchar(15),
    _nombre VARCHAR(15),
    _apellido1 VARCHAR(15),
    _apellido2 VARCHAR(15),
    _telefono INT,
    _correo VARCHAR(255),
    _fechaNac DATE,
    _puesto varchar(30)
    ) RETURNS INT(1) 
begin
    declare _cant int;
    select count(id) into _cant from Administrativo where id = _id;
    if _cant > 0 then
        update Administrativo set
            nombre = _nombre,
            apellido1 = _apellido1,
            apellido2 = _apellido2,
            telefono = _telefono,
            correo = _correo,
            fechaNac = _fechaNac,
            puesto = _puesto
            where id = _id;
    end if;
    return _cant;
end$$
drop FUNCTION IF EXISTS eliminarAdministrativo$$
CREATE FUNCTION eliminarAdministrativo (_id INT(1)) RETURNS INT(1)
begin
    declare _cant int;
    select count(id) into _cant from Administrativo where id = _id;
    if _cant > 0 then
        delete from Administrativo where id = _id;
    end if;
    return _cant;
end$$

DELIMITER ;
