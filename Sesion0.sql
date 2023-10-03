CREATE TABLE TANQUES(
	nomTanque varchar2(20) NOT NULL,
	dmg number(3,0) NOT NULL,
	velocidadFwd number(3,2) NOT NULL,
	velocidadBck number(3,2) NOT NULL,
	dispersion number(1,3) NOT NULL,
	hp number(4,0) NOT NULL,
	CONSTRAINT dmgGTZero
		CHECK(dmg > 0),
	CONSTRAINT velocidadFwdLimit
		CHECK(velocidadFwd > 0.0),
	CONSTRAINT velocidadBckLimit
		CHECK(velocidadBck < 0.0),
	CONSTRAINT dispersionGTZero
		CHECK(dispersion >= 0.00),
	CONSTRAINT HPGTZero
		CHECK(hp > 0)
);


ALTER TABLE TANQUES
	ADD CONSTRAINT clavePrimeraia PRIMARY KEY (nomTanque)
;

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
	PROVINCIA VARCHAR(50)
);

CREATE TABLE TELEFONO(
	NUMERO CHAR(9),
	FECHA_ALTA DATE,
	TIPO VARCHAR(10),
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
VALUES ('A00000001', 'Petafón', 'http://www.petafón.com');

INSERT INTO COMPAÑIA 
VALUES ('C00000003', 'Aotra', 'http://www.aot.com');

-- Peta porque no hay compañia con este CIF
INSERT INTO TARIFA
VALUES ('joven', 'D00000004', 'menores de 21 años', 0.20);

-- Peta porque no hay compañia con este CIF
INSERT INTO TARIFA
VALUES ('dúo', 'B00000002', 'la pareja también está en la compañía', 0.18);

-- Peta porque no hay compañia con este CIF
INSERT INTO TARIFA
VALUES ('amigos', 'B00000002', '10 amigos están también en la compañía', 1.60);




