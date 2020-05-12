CREATE OR REPLACE FUNCTION public._hydras_create_schema(schemaname text, ownername text) returns void AS
$$
 declare
	TEMPTEXT TEXT;
	TEMPSTR VARCHAR;	
    TEST BOOLEAN;

BEGIN
    RAISE NOTICE 'CREATE schémas % ', $1;

    SELECT public._hydras_create_table('logs', $2) INTO TEMPSTR;
    EXECUTE 'ALTER TABLE public.logs OWNER TO ' || ownername; 

	-- EXECUTE 'DROP SCHEMA IF exists ' || schemaname || 'CASCADE;';
   	EXECUTE ' CREATE SCHEMA ' || schemaname || ';';

    EXECUTE 'ALTER SCHEMA ' || schemaname || ' OWNER TO ' || ownername;

    EXECUTE 'SET search_path = ' || schemaname;


	SELECT public._hydras_create_table('data', $2) INTO TEMPSTR;

	SELECT public._hydras_create_table('correction', $2) INTO TEMPSTR;
	
	-- INSERT INTO area (area_id, code, name) VALUES (1, 'B_Naizin__03', 'B_Naizin');

	SELECT public._hydras_create_table('area', $2) INTO TEMPSTR;	

	SELECT public._hydras_create_table('station', $2) INTO TEMPSTR;	

    SELECT public._hydras_create_table('sensor', $2) INTO TEMPSTR;    

    SELECT public._hydras_create_view('data_view', $2) INTO TEMPSTR;       

END;
$$
LANGUAGE plpgsql;
