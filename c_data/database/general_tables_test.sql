-- < CREACION DE TABLAS > --
**************************************************************************************************************
-- TABLA INSTANCIAS
CREATE TABLE REPORTDBA.INSTANCE_INFO
(
  ID_INSTANCE_INFO     INT           NOT NULL       ,	-- INSTANCIA ID        (PK) (CREATE SECUENCE INSTANCE_
  INSTANCE_NAME    	   VARCHAR2(30)  NOT NULL UNIQUE,  	-- INSTANCIA
  VERSION              VARCHAR2(10)  NOT NULL,         	-- VERSION
  AMBIENTE             VARCHAR2(2)   NOT NULL,         	-- AMBIENTE (AD|AT|AF|AP)
  EQUIPO               VARCHAR2(30) ,                   -- EQUIPO
  DOMINIO              VARCHAR2(30) ,                  	-- DOMINIO
  HOSTNAME             VARCHAR2(30) ,                  	-- HOSTNAME
  ZONA                 VARCHAR2(5) ,                  	-- ZONA
  OS_USER              VARCHAR2(20) ,                   -- OS_USER  
  APLICACION           VARCHAR2(100) ,                  -- APLICACION
  PUERTO               NUMBER(4,0)  ,                  	-- PUERTO
  IP                   VARCHAR2(15)                    	-- IP
);


-- INDEXES
CREATE INDEX REPORTDBA.PK_ID_INSTANCE_INFO ON REPORTDBA.INSTANCE_INFO(ID_INSTANCE_INFO) TABLESPACE REPORTDBA_INDEX;

-- CONSTRAINTS
ALTER TABLE REPORTDBA.INSTANCE_INFO 
ADD CONSTRAINT    ID_INSTANCE_INFO PRIMARY KEY (ID_INSTANCE_INFO) 
USING INDEX    REPORTDBA.PK_ID_INSTANCE_INFO;

-- SECUENCIA
CREATE SEQUENCE REPORTDBA.INSTANCE_INFO_SEQ START WITH 1 INCREMENT BY 1  NOCACHE  NOCYCLE MINVALUE 0;


************************ TABLA ADMINISTRADOR <-> DBA ENCARGADO *****************************************************************
-- TABLA DBA <=> INSTANCIA
CREATE TABLE REPORTDBA.DBA_ADMIN_INFO
(
   ID_DBA_INFO_DETALLE INT NOT NULL,    	  			-- DBA INFORMACION ID DETALLE 
   ID_INSTANCE_INFO    INT NOT NULL    					-- NOMBRE DE INSTANCIA (FK)
);

-- INDEXES
CREATE INDEX REPORTDBA.PK_ID_DBA_ADMIN_INFO ON REPORTDBA.DBA_ADMIN_INFO(ID_DBA_INFO_DETALLE,ID_INSTANCE_INFO) TABLESPACE REPORTDBA_INDEX;

-- CONSTRAINTS
ALTER TABLE REPORTDBA.DBA_ADMIN_INFO 
ADD CONSTRAINT    ID_DBA_ADMIN_INFO PRIMARY KEY (ID_DBA_INFO_DETALLE,ID_INSTANCE_INFO) 
USING INDEX    REPORTDBA.PK_ID_DBA_ADMIN_INFO;

ALTER TABLE REPORTDBA.DBA_ADMIN_INFO 
ADD CONSTRAINT ID_DBA_INFO_DETALLE_UNQ UNIQUE(ID_INSTANCE_INFO);

-- SECUENCIA
CREATE SEQUENCE REPORTDBA.DBA_ADMIN_INFO_SEQ START WITH 1 INCREMENT BY 1  NOCACHE  NOCYCLE MINVALUE 0;

-- TABLA ADMINISTRADOR DBA INFORMACION PERSONAL
CREATE TABLE REPORTDBA.DBA_ADMIN_INFO_DETALLE
(
  ID_DBA_ADMIN_INFO_DETALLE INT NOT NULL, 	-- DBA INFORMACION ID  (PK) SECUENCIA
  NOMBRE     VARCHAR2(50)  NOT NULL ,       -- DBA NOMBRE
  APELLIDO_P VARCHAR2(50)  NOT NULL ,       -- DBA APELLIDO PATERNO
  APELLIDO_M VARCHAR2(50)  NOT NULL ,       -- DBA APELLIDO MATERNO
  TELEFONO   VARCHAR2(30)           ,       -- TELEFONO DE CONTACTO PERSONAL
  CORREO      VARCHAR(80)                   -- CORREO ELECTRONICO PERSONAL
);

-- INDEXES
CREATE INDEX REPORTDBA.PK_ID_DBA_ADMIN_INFO_DETALLE ON REPORTDBA.DBA_ADMIN_INFO_DETALLE(ID_DBA_ADMIN_INFO_DETALLE) TABLESPACE REPORTDBA_INDEX;

-- CONSTRAINTS
ALTER TABLE REPORTDBA.DBA_ADMIN_INFO_DETALLE 
ADD CONSTRAINT    ID_DBA_ADMIN_INFO_DETALLE PRIMARY KEY (ID_DBA_ADMIN_INFO_DETALLE) 
USING INDEX    REPORTDBA.PK_ID_DBA_ADMIN_INFO_DETALLE;

ALTER TABLE REPORTDBA.DBA_ADMIN_INFO_DETALLE 
ADD CONSTRAINT DBA_ADMIN_DETALLE_NAME_UNQC UNIQUE(NOMBRE,APELLIDO_P,APELLIDO_M);

-- DBA <-> DETALLE DBA
ALTER TABLE   REPORTDBA.DBA_ADMIN_INFO ADD CONSTRAINT FK_DBA_ID_DBA_INFO_DETALLE
FOREIGN KEY   (ID_DBA_INFO_DETALLE) 
REFERENCES    REPORTDBA.DBA_ADMIN_INFO_DETALLE(ID_DBA_ADMIN_INFO_DETALLE);

-- DBA <-> INSTANCIA
ALTER TABLE   REPORTDBA.DBA_ADMIN_INFO ADD CONSTRAINT FK_DBA_ID_INSTANCE_INFO
FOREIGN KEY   (ID_INSTANCE_INFO) 
REFERENCES    REPORTDBA.INSTANCE_INFO(ID_INSTANCE_INFO);

-- SECUENCIA
CREATE SEQUENCE REPORTDBA.DBA_ADMIN_INFO_DETALLE_SEQ START WITH 1 INCREMENT BY 1  NOCACHE  NOCYCLE MINVALUE 0;
**************************************************************************************************************
-- TABLA DE TIEMPOS DE RESPALDO
CREATE TABLE REPORTDBA.RESPALDOS_INFO
(
  ID_RESPALDO      INT NOT NULL,  		 -- RESPALDOS ID         (PK)
  ID_INSTANCE_INFO INT NOT NULL, 	     -- NOMBRE DE INSTANCIA  (FK)
  T_FULL_EXPORT VARCHAR2(30)   ,  		 -- RESPALDO FULL EXPORT 
  T_FULL_RMAN   VARCHAR2(30)   ,  		 -- RESPALDO FULL RMAN   
  T_COLD        VARCHAR2(30)      		 -- RESPALDO EN FRIO     
);

-- INDEXES
CREATE INDEX REPORTDBA.PK_ID_RESPALDO ON REPORTDBA.RESPALDOS_INFO(ID_RESPALDO) TABLESPACE REPORTDBA_INDEX;

-- CONSTRAINTS
ALTER TABLE REPORTDBA.RESPALDOS_INFO 
ADD CONSTRAINT    ID_RESPALDO PRIMARY KEY (ID_RESPALDO) 
USING INDEX REPORTDBA.PK_ID_RESPALDO;

-- RESPALDO <=> INSTANCIA
ALTER TABLE     REPORTDBA.RESPALDOS_INFO ADD CONSTRAINT FK_RESP_ID_INSTANCE_INFO
FOREIGN KEY    (ID_INSTANCE_INFO)
  REFERENCES    REPORTDBA.INSTANCE_INFO(ID_INSTANCE_INFO);

ALTER TABLE REPORTDBA.RESPALDOS_INFO 
ADD CONSTRAINT ID_INSTANCE_INFO_UNQ UNIQUE(ID_INSTANCE_INFO);

-- SECUENCIA
CREATE SEQUENCE REPORTDBA.RESPALDOS_INFO_SEQ START WITH 1 INCREMENT BY 1  NOCACHE  NOCYCLE MINVALUE 0;
**************************************************************************************************************
-- POLITICAS DE DEPURACION TABLESPACES --
CREATE TABLE REPORTDBA.POL_DEPURA_TS
(
  ID_POL_DEPURA_TS_DETALLE INT NOT NULL,		-- POLITICA DE DEPURACION ID DETALLE (FK)
  ID_TABLESPACE_INFO 	   INT NOT NULL			-- TABLESPACE 						 (PK) 
);

-- INDEXES
CREATE INDEX REPORTDBA.PK_ID_POL_DEPURA_TS ON REPORTDBA.POL_DEPURA_TS(ID_POL_DEPURA_TS_DETALLE,ID_TABLESPACE_INFO) TABLESPACE REPORTDBA_INDEX;

-- CONSTRAINTS
ALTER TABLE REPORTDBA.POL_DEPURA_TS 
ADD CONSTRAINT    ID_POL_DEPURA_TS PRIMARY KEY (ID_POL_DEPURA_TS_DETALLE,ID_TABLESPACE_INFO) 
USING INDEX REPORTDBA.PK_ID_POL_DEPURA_TS;

-- SECUENCIA
CREATE SEQUENCE REPORTDBA.POL_DEPURA_TS_SEQ START WITH 1 INCREMENT BY 1  NOCACHE  NOCYCLE MINVALUE 0;

-- POLITICAS DE DEPURACION DETALLE --
CREATE TABLE REPORTDBA.POL_DEPURA_TS_DETALLE
(
  ID_POL_DEPURA_TS_DETALLE INT           NOT NULL,  -- POLITICA DE DEPURACION ID (PK)
  DESCRIPCION       	   VARCHAR2(150) NOT NULL,  -- DESCRIPCION
  FECHA_REPORTADO    	   DATE          NOT NULL,  -- FECHA EN QUE SE PRESENTO EL EVENTO
  FECHA_COMPROMISO   	   DATE,                    -- FECHA COMPROMISO DE ENTREGA
  FECHA_INICIO_REAL  	   DATE,                    -- FECHA DE INICIO REAL
  PLAN_EJECUCION     	   VARCHAR2(400)            -- DOCUMENTACION, HORA DE EJECUCION, COMO, SCRIPT QUE EJECUTA ETC.
);

-- INDEXES
CREATE INDEX REPORTDBA.PK_ID_POL_DEPURA_TS_DETALLE ON REPORTDBA.POL_DEPURA_TS_DETALLE(ID_POL_DEPURA_TS_DETALLE) TABLESPACE REPORTDBA_INDEX;

-- CONSTRAINTS
ALTER TABLE REPORTDBA.POL_DEPURA_TS_DETALLE 
ADD CONSTRAINT    ID_POL_DEPURA_TS_DETALLE PRIMARY KEY (ID_POL_DEPURA_TS_DETALLE) 
USING INDEX REPORTDBA.PK_ID_POL_DEPURA_TS_DETALLE;

ALTER TABLE     REPORTDBA.POL_DEPURA_TS ADD CONSTRAINT FK_T_ID_POL_DEPURA_TS_DETALLE
FOREIGN KEY    (ID_POL_DEPURA_TS_DETALLE)
  REFERENCES    REPORTDBA.POL_DEPURA_TS_DETALLE(ID_POL_DEPURA_TS_DETALLE);

ALTER TABLE REPORTDBA.POL_DEPURA_TS_DETALLE 
ADD CONSTRAINT DESCRIPCION_UNQ UNIQUE(DESCRIPCION);

-- SECUENCIA
CREATE SEQUENCE REPORTDBA.POL_DEPURA_TS_DETALLE_SEQ START WITH 1 INCREMENT BY 1  NOCACHE  NOCYCLE MINVALUE 0;

-- TABLA TABLESPACE <=> RESPONSABLE
CREATE TABLE REPORTDBA.TABLESPACE_INFO
(
  ID_TABLESPACE_INFO         INT NOT NULL,    -- ID
  ID_TABLESPACE_INFO_DETALLE INT NOT NULL,    -- ID DE TABLESPACE DETALLE (FK)
  ID_RESPONSABLE_INFO        INT NOT NULL     -- ID RESPONSABLE 			(FK)
);

-- INDEXES
CREATE INDEX REPORTDBA.PK_ID_TABLESPACE_INFO ON REPORTDBA.TABLESPACE_INFO(ID_TABLESPACE_INFO) TABLESPACE REPORTDBA_INDEX;

-- CONSTRAINTS
ALTER TABLE REPORTDBA.TABLESPACE_INFO 
ADD CONSTRAINT    ID_TABLESPACE_INFO PRIMARY KEY (ID_TABLESPACE_INFO) 
USING INDEX REPORTDBA.PK_ID_TABLESPACE_INFO;

ALTER TABLE REPORTDBA.TABLESPACE_INFO 
ADD CONSTRAINT ID_TABLESPACE_INFO_UNQC UNIQUE(ID_TABLESPACE_INFO_DETALLE,ID_RESPONSABLE_INFO);

-- SECUENCIA
CREATE SEQUENCE REPORTDBA.TABLESPACE_INFO_SEQ START WITH 1 INCREMENT BY 1  NOCACHE  NOCYCLE MINVALUE 0;

-- TABLA TABLESPACE <=> DETALLE TABLESPACE 
CREATE TABLE REPORTDBA.TABLESPACE_INFO_DETALLE
(
  ID_TABLESPACE_INFO_DETALLE INT NOT NULL,  -- ID DE TABLESPACE
  ID_INSTANCE_INFO   	     INT NOT NULL, 	-- INSTANCIA (FK)
  TABLESPACE_NAME   		 VARCHAR2(50)  	-- TABLESPACE NAME
);

-- INDEXES
CREATE INDEX REPORTDBA.PK_ID_TABLESPACE_INFO_DETALLE ON REPORTDBA.TABLESPACE_INFO_DETALLE(ID_TABLESPACE_INFO_DETALLE) TABLESPACE REPORTDBA_INDEX;

-- CONSTRAINTS
ALTER TABLE REPORTDBA.TABLESPACE_INFO_DETALLE 
ADD CONSTRAINT    ID_TABLESPACE_INFO_DETALLE PRIMARY KEY (ID_TABLESPACE_INFO_DETALLE) 
USING INDEX REPORTDBA.PK_ID_TABLESPACE_INFO_DETALLE;

-- CONSTRAINTS 
ALTER TABLE     REPORTDBA.TABLESPACE_INFO ADD CONSTRAINT FK_TI_ID_TABLESPACE_INFO
FOREIGN KEY    (ID_TABLESPACE_INFO_DETALLE)
  REFERENCES    REPORTDBA.TABLESPACE_INFO_DETALLE(ID_TABLESPACE_INFO_DETALLE);

ALTER TABLE     REPORTDBA.POL_DEPURA_TS ADD CONSTRAINT FK_T_ID_TABLESPACE_INFO
FOREIGN KEY    (ID_TABLESPACE_INFO)
  REFERENCES    REPORTDBA.TABLESPACE_INFO(ID_TABLESPACE_INFO);
  
ALTER TABLE     REPORTDBA.TABLESPACE_INFO_DETALLE ADD CONSTRAINT FK_I_ID_INSTANCE_INFO
FOREIGN KEY    (ID_INSTANCE_INFO)
  REFERENCES    REPORTDBA.INSTANCE_INFO(ID_INSTANCE_INFO);

ALTER TABLE REPORTDBA.TABLESPACE_INFO_DETALLE 
ADD CONSTRAINT INSTANCE_TABLESPACE_UNQC UNIQUE(ID_INSTANCE_INFO,TABLESPACE_NAME);

-- SECUENCIA
CREATE SEQUENCE REPORTDBA.TABLESPACE_INFO_DETALLE_SEQ START WITH 1 INCREMENT BY 1  NOCACHE  NOCYCLE MINVALUE 0;

-- TABLA RESPONSABLE INFORMACION
CREATE TABLE REPORTDBA.RESPONSABLE_INFO
(
  ID_RESPONSABLE_INFO INT           ,    -- INFORMACION RESPONSABLES ID  (PK) SECUENCIA
  NOMBRE     VARCHAR2(50)  NOT NULL ,    -- NOMBRE
  APELLIDO_P VARCHAR2(50)  NOT NULL ,    -- APELLIDO PATERNO
  APELLIDO_M VARCHAR2(50)  NOT NULL ,    -- APELLIDO MATERNO
  TELEFONO   VARCHAR2(30)           ,    -- TELEFONO DE CONTACTO PERSONAL
  CORREO      VARCHAR(30)                -- CORREO ELECTRONICO PERSONAL
);

-- INDEXES
CREATE INDEX REPORTDBA.PK_ID_RESPONSABLE_INFO ON REPORTDBA.RESPONSABLE_INFO(ID_RESPONSABLE_INFO) TABLESPACE REPORTDBA_INDEX;

-- CONSTRAINTS
ALTER TABLE REPORTDBA.RESPONSABLE_INFO 
ADD CONSTRAINT    ID_RESPONSABLE_INFO PRIMARY KEY (ID_RESPONSABLE_INFO) 
USING INDEX REPORTDBA.PK_ID_RESPONSABLE_INFO;

ALTER TABLE     REPORTDBA.TABLESPACE_INFO ADD CONSTRAINT FK_TI_ID_RESPONSABLE_INFO
FOREIGN KEY    (ID_RESPONSABLE_INFO)
  REFERENCES    REPORTDBA.RESPONSABLE_INFO(ID_RESPONSABLE_INFO);

ALTER TABLE REPORTDBA.RESPONSABLE_INFO 
ADD CONSTRAINT NOMBRE_UNQC UNIQUE(NOMBRE,APELLIDO_P,APELLIDO_M);
  
-- SECUENCIA
CREATE SEQUENCE REPORTDBA.RESPONSABLE_INFO_SEQ START WITH 1 INCREMENT BY 1  NOCACHE  NOCYCLE MINVALUE 0;

-- FIN