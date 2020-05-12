CREATE OR REPLACE FUNCTION public._hydras_add_data(schemaname text, station int,sensor int, date_heure timestamptz, raw_data float, validate_data float) RETURNS VOID AS $$ 
declare 
	KEYID varchar;
	returnID bigint;
	countID int;

BEGIN     
--		creation de la clef unique TODO insert correction before
	KEYID = concat(station, sensor, regexp_replace(to_char(date_heure, 'YYYYMMDD HH24:MI'), '\D','','g'));
	EXECUTE format('INSERT INTO ' || schemaname || '.data (keyid, station_id, sensor_id, date_raw, value_raw, validate_data) VALUES (cast(%s as bigint), %L, %L, %L,  %L, %L) ON CONFLICT("id") DO NOTHING RETURNING id;' , KEYID, station, sensor, date_heure, raw_data, validate_data) INTO returnID;
--		si returnID est null on lance update
	IF returnID  IS null
	then
--			verifie si des doublons ne sont pas present
		EXECUTE format('select  count(*) as nb from ' || schemaname || '.correction where keyid = %L and date_correction = %L and value_correction=%L;' , KEYID, date_heure, raw_data) INTO countID;
--			on n'en a pas trouvê	
		IF countID = 0
		THEN
			EXECUTE format('INSERT INTO ' || schemaname || '.correction (keyid, date_correction, value_correction) VALUES (%s , %L,  %L) RETURNING id;' , KEYID, date_heure, raw_data) INTO returnID;
		END IF;
	END IF;
END;
$$
LANGUAGE plpgsql;