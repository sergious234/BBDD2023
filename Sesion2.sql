--  ███    ███  ██████  ██    ██ ██ ███████  █████   ██████ ████████ ██    ██ ██████   █████  ███████ 
--  ████  ████ ██    ██ ██    ██ ██ ██      ██   ██ ██         ██    ██    ██ ██   ██ ██   ██ ██      
--  ██ ████ ██ ██    ██ ██    ██ ██ █████   ███████ ██         ██    ██    ██ ██████  ███████ ███████ 
--  ██  ██  ██ ██    ██  ██  ██  ██ ██      ██   ██ ██         ██    ██    ██ ██   ██ ██   ██      ██ 
--  ██      ██  ██████    ████   ██ ██      ██   ██  ██████    ██     ██████  ██   ██ ██   ██ ███████ 





--  ███████ ███████ ███████ ███████ ██  ██████  ███    ██      ██ 
--  ██      ██      ██      ██      ██ ██    ██ ████   ██     ███ 
--  ███████ █████   ███████ █████   ██ ██    ██ ██ ██  ██      ██ 
--       ██ ██           ██ ██      ██ ██    ██ ██  ██ ██      ██ 
--  ███████ ███████ ███████ ███████ ██  ██████  ██   ████      ██ 
                                                             

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

SELECT DISTINCT(L.TF_DESTINO)
FROM MF.LLAMADA L  
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




--  ███████ ███████ ███████ ███████ ██  ██████  ███    ██     ██████  
--  ██      ██      ██      ██      ██ ██    ██ ████   ██          ██ 
--  ███████ █████   ███████ █████   ██ ██    ██ ██ ██  ██      █████  
--       ██ ██           ██ ██      ██ ██    ██ ██  ██ ██     ██      
--  ███████ ███████ ███████ ███████ ██  ██████  ██   ████     ███████ 
                                                                    

-- S2.1 Mostrar el código y coste de las tarifas junto con el nombre de la compañía que las 
-- ofrecen, de aquellas tarifas cuya descripción indique que otras personas deben estar 
-- también en la misma compañía.

SELECT T.COMPAÑIA, T.COSTE, C.NOMBRE 
FROM MF.TARIFA T INNER JOIN MF.COMPAÑIA C ON T.COMPAÑIA = C.CIF 
WHERE T.DESCRIPCION LIKE '%en la compañía';

-- S2.2 Nombre y número de teléfonos de aquellos abonados con contrato que 
-- tienen tarifas inferiores a 0,20 €.

SELECT T.NUMERO, C.NOMBRE 
FROM MF.TELEFONO T 
	INNER JOIN MF.TARIFA TAR ON T.TARIFA =TAR.TARIFA 
	INNER JOIN MF.CLIENTE C ON C.DNI = T.CLIENTE 
WHERE TAR.COSTE < 0.2;

-- S2.3 Obtener el código de las tarifas, el nombre de las compañías, los números 
-- de teléfono y los puntos, de aquellos teléfonos que se contrataron en el año 2006 
-- y que hayan obtenido más de 200 puntos

SELECT T.NUMERO, T.PUNTOS, C.NOMBRE 
FROM MF.TARIFA TAR
	INNER JOIN MF.TELEFONO T ON T.TARIFA = TAR.TARIFA
	INNER JOIN MF.COMPAÑIA C ON C.CIF = TAR.COMPAÑIA 
WHERE T.PUNTOS > 200 AND EXTRACT(YEAR FROM T.F_CONTRATO) = 2006;

-- S2.4 Obtener los números de teléfono (origen y destino), así como el tipo de contrato, 
-- de los clientes que alguna vez hablaron por teléfono entre las 8 y las 10 de la mañana

SELECT LL.TF_ORIGEN, LL.TF_DESTINO, TEL.TIPO
FROM MF.TELEFONO TEL
	INNER JOIN MF.LLAMADA LL ON LL.TF_ORIGEN = TEL.NUMERO 
WHERE EXTRACT(HOUR FROM LL.FECHA_HORA) BETWEEN 8 AND 10;

-- S2.5 Interesa conocer los nombres y números de teléfono de los clientes (origen y destino) que, 
-- perteneciendo a compañías distintas, mantuvieron llamadas que superaron los 15 minutos. 
-- Se desea conocer, también, la fecha y la hora de dichas llamadas así como la 
-- duración de esas llamada

SELECT TEL.COMPAÑIA, C.NOMBRE, LLA.TF_ORIGEN, LLA.TF_DESTINO, LLA.DURACION, LLA.FECHA_HORA
FROM MF.CLIENTE C
	INNER JOIN MF.TELEFONO TEL ON TEL.CLIENTE = C.DNI
	INNER JOIN MF.LLAMADA LLA ON LLA.TF_ORIGEN = TEL.NUMERO
	INNER JOIN MF.TELEFONO DEST ON DEST.NUMERO = LLA.TF_DESTINO 
WHERE LLA.DURACION > 15*60 AND TEL.COMPAÑIA <> DEST.COMPAÑIA;


--  ███████ ███████ ███████ ██  ██████  ███    ██     ██████  
--  ██      ██      ██      ██ ██    ██ ████   ██          ██ 
--  ███████ █████   ███████ ██ ██    ██ ██ ██  ██      █████  
--       ██ ██           ██ ██ ██    ██ ██  ██ ██          ██ 
--  ███████ ███████ ███████ ██  ██████  ██   ████     ██████  
                                                            

-- S3.1 Obtener la fecha (día-mes-año) en la que se realizó la llamada de mayor duración


SELECT TO_CHAR(LLA.FECHA_HORA, 'DD-MM-YYYY')
FROM MF.LLAMADA LLA
WHERE LLA.DURACION = (
	SELECT MAX(LLA.DURACION)
	FROM MF.LLAMADA LLA
);  


-- S3.2 Obtener el nombre de los abonados de la compañía ‘Aotra’ con 
-- el mismo tipo de tarifa que la del teléfono "654123321"


SELECT CLI.NOMBRE 
FROM MF.CLIENTE CLI
	INNER JOIN MF.TELEFONO TEL ON TEL.CLIENTE = CLI.DNI
WHERE TEL.COMPAÑIA = (
	SELECT CIF 
	FROM MF.COMPAÑIA COM
	WHERE NOMBRE = 'Aotra'
) AND 
TEL.TARIFA = (
	SELECT PHN.TARIFA
	FROM MF.TELEFONO PHN
	WHERE PHN.NUMERO = '654123321'
);

-- S3.3 Mostrar, utilizando para ello una subconsulta, el número de teléfono, 
-- fecha de contrato y tipo de los abonados que han llamado a teléfonos de 
-- clientes de fuera de la provincia de La Coruña durante el mes de octubre de 2006.


SELECT DISTINCT(TF_ORIGEN), TEL.F_CONTRATO, TEL.TIPO 
FROM MF.LLAMADA LLA
	INNER JOIN MF.TELEFONO TEL ON TEL.NUMERO = LLA.TF_ORIGEN 
WHERE TO_CHAR(LLA.FECHA_HORA, 'mm-yyyy') = '10-2006' AND  LLA.TF_DESTINO IN (
	SELECT PHN.NUMERO 
	FROM MF.TELEFONO PHN
		INNER JOIN MF.CLIENTE CLI ON CLI.DNI = PHN.CLIENTE 
	WHERE CLI.PROVINCIA <> 'La Coruña'
);


-- S3.4 Se necesita conocer el nombre de los clientes que tienen teléfonos con 
-- tarifa “dúo” pero no “autónomos”. Utiliza subconsultas para obtener la solución.

SELECT CLI.NOMBRE 
FROM MF.TELEFONO TEL
	INNER JOIN MF.CLIENTE CLI ON CLI.DNI = TEL.CLIENTE 
WHERE TEL.TARIFA = 'dúo' AND TEL.TARIFA NOT IN (
	SELECT PHN.NUMERO 
	FROM MF.TELEFONO PHN
	WHERE PHN.TARIFA = 'autónomos'
);

-- S3.5 Obtener mediante subconsultas los nombres de clientes y números de teléfono 
-- que aquellos que hicieron llamadas a teléfonos de la compañía Petafón pero no Aotra

SELECT DISTINCT(CLI.NOMBRE), TEL.NUMERO, TEL_D.COMPAÑIA  
FROM MF.CLIENTE CLI
	INNER JOIN MF.TELEFONO TEL ON TEL.CLIENTE = CLI.DNI 
	INNER JOIN MF.LLAMADA LLA ON LLA.TF_ORIGEN = TEL.NUMERO 
	INNER JOIN MF.TELEFONO TEL_D ON TEL_D.NUMERO = LLA.TF_DESTINO
	INNER JOIN MF.COMPAÑIA COM_D ON COM_D.CIF = TEL_D.COMPAÑIA
WHERE COM_D.NOMBRE = 'Petafón' and LLA.TF_DESTINO NOT IN (
	SELECT TEL2.NUMERO
	FROM MF.TELEFONO TEL2
		INNER JOIN COMPAÑIA COM2 ON COM2.CIF = TEL2.COMPAÑIA
	WHERE COM2.NOMBRE = 'Aotra'
);


-- S3.6 Nombre de los clientes de la compañía Kietostar que hicieron las llamadas 
-- de mayor duración en septiembre de 2006


-- S3.7 Se necesita conocer el nombre de los clientes que tienen teléfonos con fecha 
-- de contratación anterior a alguno de los teléfonos de Ramón Martínez Sabina, excluido, 
-- claro, el propio Ramón Martínez Sabina.



-- S4.1 Utilizando consultas correlacionadas, mostrar el nombre de los abonados que han 
-- llamado el día ‘16/10/06’

SELECT DISTINCT(CLI.NOMBRE)
FROM MF.CLIENTE CLI
	INNER JOIN MF.TELEFONO TEL ON CLI.DNI = TEL.CLIENTE  
	INNER JOIN MF.LLAMADA LLA ON LLA.TF_ORIGEN = TEL.NUMERO 
WHERE to_char(LLA.FECHA_HORA, 'dd/mm/yyyy') = '16/10/2006';


-- S4.2 Utilizando consultas correlacionadas, obtener el nombre de los abonados que han 
-- realizado llamadas de menos de 1 minuto y medio

SELECT cli.NOMBRE 
FROM mf.CLIENTE cli 
	INNER JOIN mf.TELEFONO tel ON tel.CLIENTE = cli.DNI 
	INNER JOIN mf.LLAMADA lla ON tel.NUMERO = LLA.TF_ORIGEN 
WHERE lla.DURACION < 90;


-- S4.3 Utilizando consultas correlacionadas, obtener el nombre de los abonados de la 
-- compañía ‘KietoStar’ que no hicieron ninguna llamada el mes de septiembre

SELECT cli.NOMBRE 
FROM mf.CLIENTE cli
	INNER JOIN MF.TELEFONO tel ON tel.CLIENTE = cli.DNI 
	INNER JOIN mf.COMPAÑIA c ON c.cif = tel.COMPAÑIA 
WHERE c.NOMBRE = 'Kietostar' and tel.NUMERO NOT IN (
	SELECT lla.tf_origen
	FROM mf.LLAMADA lla
	WHERE EXTRACT(MONTH FROM LLA.FECHA_HORA) = 9
);

	
--S4.4 Utilizando consultas correlacionadas, mostrar todos los datos de los telefonos
-- que hayan llamado al número 654234234 pero no al 666789789

SELECT *
FROM mf.TELEFONO tel
WHERE tel.NUMERO IN (
	SELECT lla.tf_origen
	FROM mf.LLAMADA lla
	WHERE tel.NUMERO = lla.tf_origen AND lla.tf_destino = '654234234'
) AND tel.NUMERO NOT IN (
	SELECT lla2.tf_origen
	FROM mf.LLAMADA lla2
	WHERE tel.NUMERO = lla2.tf_origen AND lla2.tf_destino = '666789789'
);


--S4.5 Utilizando consultas correlacionadas, obtener el nombre y número de teléfono de
-- los clientes de la compañía Kietostar que no han hecho llamadas a
-- otros teléfonos de la misma compañía

SELECT lla.*, com.*
FROM mf.CLIENTE cli
	INNER JOIN mf.TELEFONO tel ON cli.DNI = tel.CLIENTE
	INNER JOIN mf.COMPAÑIA com ON com.cif = tel.COMPAÑIA 
	INNER JOIN mf.LLAMADA lla ON lla.tf_origen = tel.numero
WHERE com.nombre = 'Kietostar' AND lla.tf_origen NOT IN (
	SELECT lla2.tf_origen
	FROM mf.LLAMADA lla2
	INNER JOIN mf.TELEFONO tel_des ON tel_des.numero = lla2.tf_destino
	INNER JOIN mf.compañia com_des ON com_des.cif = tel_des.compañia
	WHERE lla2.tf_origen = tel.numero AND com_des.cif = com.cif 
);

