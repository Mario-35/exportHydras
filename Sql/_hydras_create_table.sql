CREATE OR REPLACE FUNCTION public._hydras_create_table(nametable text) returns void AS
$$
 declare
	TEMPTEXT TEXT;	
    TEST BOOLEAN;

BEGIN
    RAISE NOTICE 'CREATE_TABLE % ', $1;
    CASE $1
        WHEN 'logs' THEN
            DROP TABLE IF EXISTS logs;
		    CREATE TABLE IF NOT EXISTS public.logs ( id serial NOT NULL,
                                parent_id integer,
                                ldate timestamp,
                                laction text, 
                                lvaleur text, 
                                logstr text,
                                CONSTRAINT public_id_key UNIQUE (id));
        WHEN 'data' THEN
            CREATE TABLE data (
            				id serial NOT NULL,
                            keyid varchar(25) NOT NULL,
                            station_id int4 NOT NULL,
                            sensor_id int4 NOT NULL,
                            date_record timestamp NOT NULL,
                            raw_data float8 NULL,
                            validate_data float8 NULL,
                            CONSTRAINT data_id_key UNIQUE (id),
                            CONSTRAINT data_pkey PRIMARY KEY (id),
                            CONSTRAINT data_keyid_key UNIQUE (keyid));       
        WHEN 'import' THEN
            CREATE TABLE IF NOT EXISTS public.import (   station text,
                                    sensor text, 
                                    date_heure text,
                                    valeur text,
                                    info text);
            
        WHEN 'data_update' THEN
            CREATE TABLE data_update (
                            id serial NOT NULL,
                            keyid varchar(25) NOT NULL,
                            "date" timestamp NOT NULL,
                            value float8 NULL,
                            CONSTRAINT data_update_id_key UNIQUE (id),
                            CONSTRAINT data_update_pkey PRIMARY KEY (id));
                                    
            ALTER TABLE data_update ADD CONSTRAINT fk_data_update__keyid FOREIGN KEY (keyid) REFERENCES data(keyid) ON DELETE CASCADE;

            
        WHEN 'importation' THEN
            CREATE TABLE importation (  id serial NOT NULL,
                                        myType int DEFAULT 0,
                                        keyId character varying(25), 
                                        station_id int4 NOT NULL,
                                        sensor_id int4 NOT NULL,
                                        date_record timestamp NOT NULL,
                                        valeur float8 NULL,
                                        info character varying(5));
            
        WHEN 'logsImports' THEN
            CREATE TABLE logsImports (  logs_id int DEFAULT 0,
                                        myType int DEFAULT 0,
                                        keyId character varying(25), 
                                        station_id int4 NOT NULL,
                                        sensor_id int4 NOT NULL,
                                        date_record timestamp NOT NULL,
                                        valeur float8 NULL,
                                        info character varying(5));
            -- ALTER TABLE logsImports ADD CONSTRAINT fk_area_id FOREIGN KEY (logs_id) REFERENCES public.logs(id);
            
        WHEN 'area' THEN
            CREATE TABLE area ( id serial NOT NULL,
                                code varchar NOT NULL,
                                name varchar NOT NULL,
                                CONSTRAINT area_id_key UNIQUE (id),
                                CONSTRAINT area_code_key UNIQUE (code),
                                CONSTRAINT area_pkey PRIMARY KEY (id));
            
		WHEN 'station' THEN
            CREATE TABLE station (  id serial NOT NULL,
                                    area_id int4 NULL,
                                    code varchar NULL,
                                    name varchar NULL,
                                    CONSTRAINT station_code_key UNIQUE (code),
                                    CONSTRAINT station_pkey PRIMARY KEY (id));

	        ALTER TABLE station ADD CONSTRAINT fk_area_id FOREIGN KEY (area_id) REFERENCES area(id);
            
		WHEN 'sensor' THEN
            CREATE TABLE sensor (  id serial NOT NULL,
                                    code varchar NULL,
                                    name varchar NULL,
                                    unite varchar NULL,
                                    CONSTRAINT sensor_code_key UNIQUE (code),
                                    CONSTRAINT sensor_pkey PRIMARY KEY (id));
            
        ELSE
            RAISE NOTICE 'CREATE_TABLE ERROR Not found case structure';
    END CASE;  
END;
$$
LANGUAGE plpgsql;

