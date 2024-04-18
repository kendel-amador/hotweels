Use Taller;
DELIMITER $$
CREATE TRIGGER eliminar_Cliente AFTER DELETE ON cliente FOR EACH ROW 
BEGIN
    DELETE FROM usuario WHERE Usuario.idPersona = OLD.idCliente;
END$$
DELIMITER ;