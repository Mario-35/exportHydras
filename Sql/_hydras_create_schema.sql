CREATE OR REPLACE FUNCTION public._hydras_create_schema(schemaname text, ownername text) returns void AS
$$
 declare
	TEMPTEXT TEXT;
	TEMPSTR VARCHAR;	
    TEST BOOLEAN;

BEGIN
    RAISE NOTICE 'CREATE schémas % ', $1;

    SELECT public._hydras_create_table('logs') INTO TEMPSTR;
    EXECUTE 'ALTER TABLE public.logs OWNER TO ' || ownername; 

	-- EXECUTE 'DROP SCHEMA IF exists ' || schemaname || 'CASCADE;';
   	EXECUTE ' CREATE SCHEMA ' || schemaname || ';';

    EXECUTE 'ALTER SCHEMA ' || schemaname || ' OWNER TO ' || ownername;

    EXECUTE 'SET search_path = ' || schemaname;


	SELECT public._hydras_create_table('data') INTO TEMPSTR;
    EXECUTE 'ALTER TABLE data OWNER TO ' || ownername; 

	SELECT public._hydras_create_table('data_update') INTO TEMPSTR;
    EXECUTE 'ALTER TABLE data_update OWNER TO ' || ownername;
	
	-- INSERT INTO area (area_id, code, name) VALUES (1, 'B_Naizin__03', 'B_Naizin');

	SELECT public._hydras_create_table('area') INTO TEMPSTR;	
    EXECUTE 'ALTER TABLE area OWNER TO ' || ownername; 

	SELECT public._hydras_create_table('station') INTO TEMPSTR;	
    EXECUTE 'ALTER TABLE station OWNER TO ' || ownername; 

    SELECT public._hydras_create_table('sensor') INTO TEMPSTR;                            
    EXECUTE 'ALTER TABLE sensor OWNER TO ' || ownername; 

END;
$$
LANGUAGE plpgsql;
