USE taller;
alter table usuario 
    add tkR varchar(255) null;

DROP FUNCTION IF EXISTS modificarToken;
DROP PROCEDURE IF EXISTS verificarToken;

DELIMITER $$

CREATE FUNCTION modificarToken (_idPersona VARCHAR(15), _tkR varchar(255)) RETURNS INT(1) 
begin
    declare _cant int;
    select count(idPersona) into _cant from usuario where idPersona = _idPersona;
    if _cant > 0 then
        update usuario set
                tkR = _tkR
                where idPersona = _idPersona;
        if _tkR <> "" then
            update usuario set
                ultimoAcceso = now()
                where idPersona = _idPersona;
        end if;
    end if;
    return _cant;
end$$

CREATE PROCEDURE verificarToken (_idPersona VARCHAR(15), _tkR varchar(255)) 
begin
    select rol from usuario where idPersona = _idPersona and tkR = _tkR;
end$$

DELIMITER ;