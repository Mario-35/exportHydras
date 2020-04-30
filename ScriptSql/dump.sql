
CREATE OR REPLACE FUNCTION public.create_schema(schemaname text, ownername text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
 declare
	TEMPTEXT TEXT;	
    TEST BOOLEAN;

BEGIN
    RAISE NOTICE 'CREATE schémas % ', $1;

	-- EXECUTE 'DROP SCHEMA IF exists ' || schemaname || 'CASCADE;';
   	EXECUTE ' CREATE SCHEMA ' || schemaname || ';';

    EXECUTE 'ALTER SCHEMA nom OWNER TO ' || ownername;

    EXECUTE 'SET search_path = ' || schemaname;

	CREATE TABLE datas (
					keyid varchar(25) NOT NULL,
					station_id int4 NOT NULL,
					capteur_id int4 NOT NULL,
					date_record timestamp NOT NULL,
					raw_data float8 NULL,
					validate_data float8 NULL,
					CONSTRAINT datas_keyid_key UNIQUE (keyid));

    EXECUTE 'ALTER TABLE datas OWNER TO ' || ownername; 

	CREATE TABLE datas_updates (
					datas_updates_id serial NOT NULL,
					keyid varchar(25) NOT NULL,
					date_update timestamp NOT NULL,
					update_data float8 NULL,
					CONSTRAINT datas_updates_datas_updates_id_key UNIQUE (datas_updates_id),
					CONSTRAINT datas_updates_pkey PRIMARY KEY (datas_updates_id));
                    		
	ALTER TABLE datas_updates ADD CONSTRAINT fk_datas_updates__keyid FOREIGN KEY (keyid) REFERENCES datas(keyid) ON DELETE CASCADE;

    EXECUTE 'ALTER TABLE datas_updates OWNER TO ' || ownername; 

	CREATE TABLE area (
					area_id serial NOT NULL,
					code varchar NULL,
					name varchar NULL,
					CONSTRAINT area_id_key UNIQUE (code),
					CONSTRAINT area_code_key UNIQUE (code),
					CONSTRAINT area_pkey PRIMARY KEY (area_id));

	-- INSERT INTO area (area_id, code, name) VALUES (1, 'B_Naizin__03', 'B_Naizin');
	
    EXECUTE 'ALTER TABLE area OWNER TO ' || ownername; 

	CREATE TABLE station (
					station_id serial NOT NULL,
					area_id int4 NULL,
					name varchar NULL,
					CONSTRAINT station_name_key UNIQUE (name),
					CONSTRAINT station_pkey PRIMARY KEY (station_id));

	ALTER TABLE station ADD CONSTRAINT fk_area_id FOREIGN KEY (area_id) REFERENCES area(area_id);

    EXECUTE 'ALTER TABLE station OWNER TO ' || ownername; 

    CREATE TABLE capteur (  capteur_id serial NOT NULL,
                            code varchar NULL,
                            name varchar NULL,
                            unite varchar NULL,
                            CONSTRAINT capteur_code_key UNIQUE (code),
                            CONSTRAINT capteur_pkey PRIMARY KEY (capteur_id));
                            
    EXECUTE 'ALTER TABLE capteur OWNER TO ' || ownername; 


END;
$function$
;
