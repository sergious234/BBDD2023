--  ███    ███  ██████  ██    ██ ██ ███████  █████   ██████ ████████ ██    ██ ██████   █████  ███████ 
--  ████  ████ ██    ██ ██    ██ ██ ██      ██   ██ ██         ██    ██    ██ ██   ██ ██   ██ ██      
--  ██ ████ ██ ██    ██ ██    ██ ██ █████   ███████ ██         ██    ██    ██ ██████  ███████ ███████ 
--  ██  ██  ██ ██    ██  ██  ██  ██ ██      ██   ██ ██         ██    ██    ██ ██   ██ ██   ██      ██ 
--  ██      ██  ██████    ████   ██ ██      ██   ██  ██████    ██     ██████  ██   ██ ██   ██ ███████ 





-- S1.1 Obtener el nombre de las compañías cuya dirección web contenga la cadena ‘et’ y acabe en ‘com’.

SELECT NOMBRE
FROM MF.COMPAÑIA C
WHERE C.WEB LIKE '%et%com';



-- S1.2 Obtener el nombre y dirección de los clientes nacidos en 
-- 1973 o 1985 y cuyo código postal comience por
-- 15, ordenado ascendentemente por el nombre y, en caso de igualdad, 
-- descendentemente por la dirección

SELECT NOMBRE, DIRECCION
FROM MF.CLIENTE c 
WHERE C.CP LIKE '15%' AND ( 
	EXTRACT(YEAR FROM c.F_NAC) = 1973 OR 
	EXTRACT(YEAR FROM c.F_NAC) = 1985 
)
ORDER BY C.NOMBRE ASC, C.DIRECCION DESC;





-- S1.3 Obtener el teléfono de destino de las llamadas realizadas desde el 
-- número “666010101”, en el año 2006.

SELECT L.TF_DESTINO  
FROM MF.LLAMADA L
WHERE L.TF_ORIGEN = '666010101' AND EXTRACT(YEAR FROM L.FECHA_HORA) = 2006;




-- S1.4 Obtener los números de teléfono que han 
-- llamado alguna vez al “666010101”, entre las 10:00 y las 12:00

SELECT L.TF_ORIGEN
FROM MF.LLAMADA L
WHERE L.TF_DESTINO = '666010101' 
	AND (EXTRACT (HOUR FROM L.FECHA_HORA) BETWEEN '10' AND '12');



-- S1.5 Obtener las tarifas distintas de aquellos clientes cuyo 
-- dni contiene el número 2 y tienen entre 10000 y 20000 puntos, 
-- pero que son de contrato, no tarjeta de prepago.

SELECT DISTINCT(T.TARIFA)
FROM MF.TELEFONO T INNER JOIN MF.CLIENTE C ON C.DNI = T.CLIENTE
WHERE C.DNI LIKE '%2%' AND t.TIPO = 'C' AND t.PUNTOS BETWEEN 10000 AND 20000;




-- S1.6 Obtener los números de teléfonos junto a su tarifa, cuya fecha de 
-- contrato es en mayo (cualquier día y año), con tarifa distinta de 
-- joven, y que acaban en 9, ordenados por puntos descendentemente.

SELECT t.NUMERO 
FROM MF.TELEFONO T
WHERE EXTRACT(MONTH FROM T.F_CONTRATO) = 5 
	AND T.TARIFA != 'joven' 
	AND T.NUMERO LIKE '%9';





-- S1.7 Obtener los distintos teléfonos a los que se han llamado desde 
-- el ‘654345345’ durante el mes de octubre y noviembre, cuyas llamadas 
-- hayan tenido una duración superior a los 250 segundos.

SELECT DISTINCT(T.NUMERO)
FROM MF.TELEFONO T INNER JOIN MF.LLAMADA L ON L.TF_ORIGEN = T.NUMERO 
WHERE L.TF_ORIGEN = '654345345' 
	AND EXTRACT(MONTH FROM L.FECHA_HORA) BETWEEN 10 AND 11
	AND DURACION > 250;
	



-- S1.8 Obtener los nombres de los clientes que nacieron entre 1970 y 1985 y 
-- que pertenezcan a la provincia de Huelva, ordenados ascendentemente por 
-- ciudad y descendentemente por provincia.

SELECT C.NOMBRE
FROM MF.CLIENTE C
WHERE EXTRACT(YEAR FROM C.F_NAC) BETWEEN 1970 AND 1985
	AND C.PROVINCIA = 'Huelva'
ORDER BY C.CIUDAD ASC, C.PROVINCIA DESC; 