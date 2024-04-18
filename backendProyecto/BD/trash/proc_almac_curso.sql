USE matricexamen;

DELIMITER $$

CREATE PROCEDURE buscarCurso (_codigo varchar(10))
begin
    select * from Curso where codigo = _codigo;
end$$

CREATE PROCEDURE filtrarCurso (
    _parametros varchar(100), -- %codigo%&%nombre%&%area%&%carrera%&%descripcion%&
    _pagina SMALLINT UNSIGNED, 
    _cantRegs SMALLINT UNSIGNED)
begin
    SELECT cadenaFiltro(_parametros, 'codigo&nombre&area&carrera&descripcion&') INTO @filtro;
    SELECT concat("SELECT * from Curso where ", @filtro, " LIMIT ", 
        _pagina, ", ", _cantRegs) INTO @sql;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;  
end$$

CREATE PROCEDURE numRegsCurso (
    _parametros varchar(100))
begin
    declare _cant int;
    SELECT cadenaFiltro(_parametros, 'codigo&nombre&area&carrera&descripcion&') INTO @filtro;
    SELECT concat("SELECT count(codigo) from Curso where ", @filtro) INTO @sql;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
end$$

CREATE FUNCTION nuevoCurso (
    _codigo varchar(10),
    _nombre VARCHAR(15),
    _area varchar(10),
    _carrera varchar(10),
    _descripcion varchar(255),
    _fechaInclusion date,
    _codReq1 varchar(10),
    _codReq2 varchar(10)
)  RETURNS INT(1) 
begin
    declare _cant int;
    select count(_codigo) into _cant from Curso where _codigo = _codigo or carnet = _carnet;
    if _cant = 0 then
        insert into Curso(codigo, nombre, area, carrera, descripcion, fechaInclusion, codReq1, codReq2) 
            values (_codigo, _nombre, _area, _carrera, _descripcion, _fechaInclusion, _codReq1, _codReq2);
    end if;
    return _cant;
end$$

CREATE FUNCTION editarCurso (
    _codigo varchar(10),
    _nombre VARCHAR(15),
    _area varchar(10),
    _carrera varchar(10),
    _descripcion varchar(255),
    _fechaInclusion date,
    _codReq1 varchar(10),
    _codReq2 varchar(10)
    )  RETURNS INT(1) 
begin
    declare _cant int;
    select count(id) into _cant from Curso where id = _id;
    if _cant > 0 then
        update Curso set
            nombre = _nombre,
            area = _area,
            carrera = _carrera,
            descripcion = _descripcion,
            fechaInclusion = _fechaInclusion,
            codReq1 = _codReq1,
            codReq2 = _codReq2
            where codigo = _codigo;
    end if;
    return _cant;
end$$

CREATE FUNCTION eliminarCurso (_carnet varchar(12)) RETURNS INT(1)
begin
    declare _cant int;
    select count(codigo) into _cant from Curso where codigo = _codigo;
    if _cant > 0 then
        delete from Curso where codigo = _codigo;
    end if;
    return _cant;
end$$

DELIMITER ;
