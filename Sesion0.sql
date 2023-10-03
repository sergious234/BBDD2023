

--   ______ .______       _______     ___   .___________. _______     _______.
--  /      ||   _  \     |   ____|   /   \  |           ||   ____|   /       |
-- |  ,----'|  |_)  |    |  |__     /  ^  \ `---|  |----`|  |__     |   (----`
-- |  |     |      /     |   __|   /  /_\  \    |  |     |   __|     \   \    
-- |  `----.|  |\  \----.|  |____ /  _____  \   |  |     |  |____.----)   |   
--  \______|| _| `._____||_______/__/     \__\  |__|     |_______|_______/    
                                                                           



CREATE TABLE COMPAÑIA(
	cif char(9) PRIMARY KEY,
	nombre varchar(20),
	web varchar(30)
);

CREATE TABLE TARIFA(
	TARIFA VARCHAR(10),
	COMPAÑIA CHAR(9),
	DESCRIPCION VARCHAR(50),
	COSTE NUMERIC(3,2),
	
	CONSTRAINT PK_TARIFA PRIMARY KEY (TARIFA, COMPAÑIA),
	CONSTRAINT FK_COMPAÑIA FOREIGN KEY (COMPAÑIA) REFERENCES compañia(cif)
	
);

CREATE TABLE CLIENTE(
	DNI CHAR(9) PRIMARY KEY,
	NOMBRE VARCHAR(50),
	FECHA_NAC DATE,
	DIRECCION VARCHAR(100),
	CP CHAR(6),
	CIUDAD VARCHAR(50),
	PROVINCIA VARCHAR(50)
);

CREATE TABLE TELEFONO(
	NUMERO CHAR(9),
	FECHA_ALTA DATE,
	TIPO CHAR(1),
	PUNTOS NUMBER(6,0),
	COMPAÑIA CHAR(9),
	TARIFA VARCHAR(10),
	CLIENTE CHAR(9),
	
	CONSTRAINT TIPO_CONTRATO
		CHECK(TIPO = 'T' OR TIPO = 'C'),
	
	CONSTRAINT CLIENTE_DNI
		FOREIGN KEY (CLIENTE) REFERENCES CLIENTE(DNI),
		
	CONSTRAINT COMPAÑIA_CMP
		FOREIGN KEY (COMPAÑIA) REFERENCES COMPAÑIA(CIF),
		
	CONSTRAINT TARIFA_FK
		FOREIGN KEY (TARIFA, COMPAÑIA) REFERENCES TARIFA (TARIFA, COMPAÑIA)
);

CREATE TABLE LLAMADA(
	TF_ORIGEN CHAR(9),
	TF_DESTINO CHAR(9),
	FECHA_HORA TIMESTAMP,
	DURACION NUMBER(5,0),
	CONSTRAINT FK_NUMERO_ORIGEN
		FOREIGN KEY (TF_ORIGEN) REFERENCES TELEFONO(NUMERO),
		
	CONSTRAINT FK_NUMERO_DESTINO 
		FOREIGN KEY (TF_DESTINO) REFERENCES TELEFONO(NUMERO),

	CONSTRAINT CLAVE_PRIMARIA_RUST
		PRIMARY key(tf_origen, fecha_hora),

	CONSTRAINT tf_destino_unico 
		UNIQUE(tf_destino, fecha_hora)
);



--     ___       __      .___________. _______ .______          _______.
--    /   \     |  |     |           ||   ____||   _  \        /       |
--   /  ^  \    |  |     `---|  |----`|  |__   |  |_)  |      |   (----`
--  /  /_\  \   |  |         |  |     |   __|  |      /        \   \    
-- /  _____  \  |  `----.    |  |     |  |____ |  |\  \----.----)   |   
--/__/     \__\ |_______|    |__|     |_______|| _| `._____|_______/    
                                                                      

ALTER TABLE COMPAÑIA 
	ADD CONSTRAINT nombre_unico UNIQUE(NOMBRE);
	
ALTER TABLE LLAMADA
	ADD CONSTRAINT LLAMADA_REFLEXIVA CHECK(TF_ORIGEN <> TF_DESTINO);
	
ALTER TABLE TARIFA
	ADD CONSTRAINT LIMITE_PRECIO CHECK(COSTE <= 1.5 AND COSTE >= 0.05);

ALTER TABLE COMPAÑIA 
	MODIFY NOMBRE VARCHAR(20) NOT NULL;

ALTER TABLE CLIENTE 
	MODIFY NOMBRE VARCHAR(50) NOT NULL;

ALTER TABLE TARIFA 
	MODIFY COSTE NUMBER(3,2) NOT NULL;

ALTER TABLE TELEFONO 
	MODIFY COMPAÑIA CHAR(9) NOT NULL
	MODIFY TARIFA VARCHAR(10) NOT NULL;

ALTER TABLE LLAMADA 
	MODIFY DURACION NUMBER(5,0) NOT NULL;

ALTER TABLE TARIFA
	DROP CONSTRAINT FK_COMPAÑIA;

ALTER TABLE TARIFA 
	ADD CONSTRAINT FK_COMPAÑIA  
	FOREIGN KEY (COMPAÑIA)
	REFERENCES COMPAÑIA (CIF)
	ON DELETE CASCADE;


--
--  _____ _   _  _____ ______ _____ _______ _____ 
-- |_   _| \ | |/ ____|  ____|  __ \__   __/ ____|
--   | | |  \| | (___ | |__  | |__) | | | | (___  
--   | | | . ` |\___ \|  __| |  _  /  | |  \___ \ 
--  _| |_| |\  |____) | |____| | \ \  | |  ____) |
-- |_____|_| \_|_____/|______|_|  \_\ |_| |_____/ 
--                                              
                                                


INSERT INTO COMPAÑIA(cif, nombre, web)
VALUES ('A00000001', 'Kietostar', 'http://www.kietostar.com');

INSERT INTO COMPAÑIA(CIF, NOMBRE, WEB)
VALUES ('B00000002', 'Aotra', 'http://www.aotra.com');



INSERT INTO TARIFA(tarifa, compañia, descripcion, coste)
VALUES ('joven', 'A00000001', 'menores de 25 años', 0.25);

INSERT INTO tarifa (tarifa, compañia, descripcion, coste)
VALUES ('dúo', 'A00000001', 'la pareja también está en la compañía', 0.20);

INSERT INTO tarifa (tarifa, compañia, descripcion, coste)
VALUES ('familiar', 'A00000001', '4 miembros de la familia en la compañía', 0.15);

INSERT INTO tarifa (tarifa, compañia, descripcion, coste)
VALUES ('autónomos', 'B00000002', 'trabajador autónomo', 0.12);

INSERT INTO tarifa (tarifa, compañia, descripcion, coste)
VALUES ('dúo', 'B00000002', 'la pareja también está en la compañía', 0.15);



--  _______        __   _______ .______        ______  __    ______  __    ______       _  _    
-- |   ____|      |  | |   ____||   _  \      /      ||  |  /      ||  |  /  __  \     | || |   
-- |  |__         |  | |  |__   |  |_)  |    |  ,----'|  | |  ,----'|  | |  |  |  |    | || |_  
-- |   __|  .--.  |  | |   __|  |      /     |  |     |  | |  |     |  | |  |  |  |    |__   _| 
-- |  |____ |  `--'  | |  |____ |  |\  \----.|  `----.|  | |  `----.|  | |  `--'  |       | |   
-- |_______| \______/  |_______|| _| `._____| \______||__|  \______||__|  \______/        |_|   
                                                                                             

-- SQL Error [1] [23000]: ORA-00001: unique constraint (BD_034.SYS_C0064068) violated
INSERT INTO COMPAÑIA(cif, nombre, web) 
VALUES ('A00000001', 'Petafón', 'http://www.petafón.com');

-- SQL Error [1] [23000]: ORA-00001: unique constraint (BD_034.NOMBRE_UNICO) violated
INSERT INTO COMPAÑIA 
VALUES ('C00000003', 'Aotra', 'http://www.aot.com');

-- SQL Error [2291] [23000]: ORA-02291: integrity constraint (BD_034.FK_COMPAÑIA) violated - parent key not found
INSERT INTO TARIFA
VALUES ('joven', 'D00000004', 'menores de 21 años', 0.20);

-- SQL Error [1] [23000]: ORA-00001: unique constraint (BD_034.PK_TARIFA) violated
INSERT INTO TARIFA
VALUES ('dúo', 'B00000002', 'la pareja también está en la compañía', 0.18);

-- SQL Error [2290] [23000]: ORA-02290: check constraint (BD_034.LIMITE_PRECIO) violated
INSERT INTO TARIFA
VALUES ('amigos', 'B00000002', '10 amigos están también en la compañía', 1.60);


--   _______        __   _______ .______        ______  __    ______  __    ______       _____  
--  |   ____|      |  | |   ____||   _  \      /      ||  |  /      ||  |  /  __  \     | ____| 
--  |  |__         |  | |  |__   |  |_)  |    |  ,----'|  | |  ,----'|  | |  |  |  |    | |__   
--  |   __|  .--.  |  | |   __|  |      /     |  |     |  | |  |     |  | |  |  |  |    |___ \  
--  |  |____ |  `--'  | |  |____ |  |\  \----.|  `----.|  | |  `----.|  | |  `--'  |     ___) | 
--  |_______| \______/  |_______|| _| `._____| \______||__|  \______||__|  \______/     |____/  
--                                                                                                                                                                               

-- Si se borran las tarifas jeje.
DELETE FROM COMPAÑIA 
WHERE CIF = 'B00000002';
