CREATE OR REPLACE FUNCTION public._hydras_import(schemaname text default 'tdd') RETURNS TABLE(ldate timestamp, laction text, lvaleur text, logstr text) AS $$
-- Create 26 fevrier janvier 2020
--
-- SCRIPT Importation csv issu d'Hydras3 @2020 Adam Mario Inrae mario.adam@inrae.fr
--
-- MAJ 26 mars 2020 [exportHydras]

--  

-- mrtype   9 exclut l'importation
-- 91 => DOUB_FILE
-- 92 => DOUB_NULL
-- 93 => DOUB_BRUT
-- 94 => DOUB_UPDATE
-- 95 => DOUB_VALIDATE

 declare
	TEMP INTEGER;
	ITEM  RECORD;
	LOGID record;
	TEMPTEXT TEXT;
	TEMPTIME TEXT;

BEGIN
	EXECUTE 'SET search_path = public, ' || schemaname;

	-- Seulement pour le dev
	-- SELECT pg_terminate_backend (pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = 'agrhys_dev';

	-- Efface les table temporaires
	DROP TABLE IF EXISTS log;
	DROP TABLE IF EXISTS importation;
	
	-- Ajoute le Nouveau Logs 
	INSERT INTO public.logs (parent_id, ldate, laction, lvaleur, logstr) VALUES (1, clock_timestamp(), 'CREATE_LOG', 'IMPORT', schemaname) RETURNING id INTO LOGID;
	EXECUTE format('CREATE TABLE log (parent_id int4 DEFAULT %s, ldate timestamp, ltime time, laction text, lvaleur text, logstr text);', LOGID.id);
	

	-- SELECT public._hydras_add_log('SCHEMA', schemaname, 'Schema use for procedure');

	SELECT public._hydras_add_log('SCHEMA', schemaname, 'Schema use for procedure') INTO TEMPTIME;
	
	SHOW search_path INTO TEMPTEXT;
	SELECT public._hydras_add_log('SEARCH', TEMPTEXT, 'Search path') INTO TEMPTIME;	

    CREATE TABLE importation (  id serial NOT NULL,
                                myType int DEFAULT 0,
                                keyId character varying(25), 
                                station_id int4 NOT NULL,
                                sensor_id int4 NOT NULL,
                                date_record timestamp NOT NULL,
                                valeur float8 NULL,
                                info character varying(5)); 
	
	SELECT public._hydras_add_log('IMPORT', 'FILE', schemaname) INTO TEMPTIME;
	
	SELECT public._hydras_add_log('LOAD', CAST((SELECT count(*) FROM import) AS VARCHAR), 'lignes dans import') INTO TEMPTIME;

	-- Verification sur les stations 
	TEMP := 1;
	FOR ITEM IN EXECUTE 'select distinct station FROM import where regexp_replace(station, ''_._'', '''')  not in (select distinct code FROM station);' 
	LOOP
		SELECT public._hydras_add_log(CONCAT('STATION_', TEMP), ITEM.station, ' non trouvé') INTO TEMPTIME;
		TEMP := TEMP  + 1;
	END LOOP;

	-- Verification sur les sensors 
    TEMP := 1;
    FOR ITEM IN EXECUTE 'select distinct sensor FROM import where sensor not in (select distinct code FROM sensor);' 
    LOOP
	    SELECT public._hydras_add_log(CONCAT('SENSOR_', TEMP), ITEM.sensor, ' non trouvé') INTO TEMPTIME;
		TEMP := TEMP  + 1;
    END LOOP;

	-- copie avec cast des données (hydras a des heures a 24:00 qui sont en fait 00:00:00)
	INSERT INTO importation (keyid, myType, station_id, sensor_id, date_record, valeur, info)
			SELECT 
			-- RegEx ne conserve que les digits
			concat(station.id,sensor.id, regexp_replace(to_char(TO_TIMESTAMP(REPLACE(import.date_heure,'24:00:00','00:00:00'), 'DD/MM/YYYY HH24:MI:SS:MS'), 'YYYYMMDD HH24:MI'), '\D','','g')), 
			CASE substr(import.info, 0, 2)	
				WHEN '#' THEN
					2
				WHEN '/' THEN
					3
				ELSE
					1
			END,
			cast(station.id as int),
			cast(sensor.id as int),
			TO_TIMESTAMP(REPLACE(import.date_heure,'24:00:00','00:00:00'), 'DD/MM/YYYY HH24:MI:SS:MS'), 
			CASE import.valeur
				WHEN '---' THEN
					NULL
				ELSE
					cast(REPLACE(valeur,',','.') as float)
			END,
			substr(import.info, 0, 6)			
			FROM import
			inner join station
			on station.code = regexp_replace(substr(import.station,0,16), '_._', '') 
			inner join sensor
			on sensor.code = substr(import.sensor,0,6);

	GET DIAGNOSTICS TEMP = ROW_COUNT;
	SELECT public._hydras_add_log('IMPORTATION', cast(TEMP as TEXT),  'lignes ajoutées dans importation') INTO TEMPTIME;
						
	-- Doublons dans le fichier lui meme.
	DELETE FROM importation AS i WHERE i.id in ( SELECT id FROM
					(SELECT unnest(ARRAY_AGG(id)) as id FROM importation GROUP BY keyId, station_id, sensor_id, date_record, valeur, info HAVING  COUNT(*) > 1) a 
					WHERE id NOT IN (SELECT min(id) as id FROM importation GROUP BY keyId, station_id, sensor_id, date_record, valeur, info HAVING COUNT(*) > 1));		

	GET DIAGNOSTICS TEMP = ROW_COUNT;
	SELECT public._hydras_add_log('DOUB_FILE', cast(TEMP as TEXT),  'Doublons dans le fichier lui meme') INTO TEMPTIME;

	-- Doublons avec une valeur null (pas 0).
	DELETE FROM importation AS i WHERE i.keyid = (SELECT keyid FROM data AS d WHERE d.keyid = i.keyid AND d.raw_data isnull AND i.valeur isNULL);

	GET DIAGNOSTICS TEMP = ROW_COUNT;
	SELECT public._hydras_add_log('DOUB_NULL', cast(TEMP as TEXT),  'Doublons avec une valeur null') INTO TEMPTIME;

	-- Doublons des valeurs brutes.
	DELETE FROM importation AS i WHERE i.keyid = (SELECT keyid FROM data AS d WHERE d.keyid = i.keyid AND d.raw_data = i.valeur and (i.info = '' OR i.info isNULL));

	GET DIAGNOSTICS TEMP = ROW_COUNT;
	SELECT public._hydras_add_log('DOUB_BRUT', cast(TEMP as TEXT),  'Doublons des valeurs brutes') INTO TEMPTIME;

	-- Doublons des valeurs corrigees.
	DELETE FROM importation AS i WHERE i.keyid = (SELECT distinct keyid FROM data_update AS u WHERE u.keyid = i.keyid and u.value = i.valeur and i.info = '#') AND myType=2;
			
	GET DIAGNOSTICS TEMP = ROW_COUNT;
	SELECT public._hydras_add_log('DOUB_UPDATE', cast(TEMP as TEXT),  'Doublons des valeurs corrigees') INTO TEMPTIME;
				
	-- Doublons des valeurs validees.
	DELETE FROM importation AS i WHERE i.keyid = (SELECT keyid FROM  data AS d WHERE d.keyid = i.keyid AND d.validate_data = i.valeur) AND myType=3;

	GET DIAGNOSTICS TEMP = ROW_COUNT;
	SELECT public._hydras_add_log('DOUB_VALIDATE', cast(TEMP as TEXT),  'Doublons des valeurs validees') INTO TEMPTIME;

	SELECT public._hydras_add_log('REMAIN', CAST((SELECT COUNT(*) FROM importation) AS VARCHAR), 'ligne(s) restant à traiter') INTO TEMPTIME;

	INSERT 	INTO data (keyid, station_id, sensor_id, date_record, raw_data) 
			SELECT keyid, station_id, sensor_id, date_record, valeur
			FROM importation
			WHERE myType=1
			ON CONFLICT (keyid) DO NOTHING;

	GET DIAGNOSTICS TEMP = ROW_COUNT;
	SELECT public._hydras_add_log('ADD_BRUT', cast(TEMP as TEXT),  'Nombre de ligne(s) ajoutées aux données brutes') INTO TEMPTIME;

	INSERT 	INTO data_update (keyid, date, value) 
			SELECT keyid, date_record, valeur
			FROM importation AS i
			WHERE i.keyid in (select keyid from data) 
			AND i.keyid NOT in (select keyid from data_update) 
			AND i.myType=2;


	GET DIAGNOSTICS TEMP = ROW_COUNT;
	SELECT public._hydras_add_log('ADD_UPDATE', cast(TEMP as TEXT), 'Nombre de ligne(s) ajoutées aux données corrigées') INTO TEMPTIME;
	
	UPDATE data AS d 	SET validate_data = valeur
						FROM importation As i
						WHERE d.keyid = i.keyid
						AND i.myType=3;

	GET DIAGNOSTICS TEMP = ROW_COUNT;
	SELECT public._hydras_add_log('ADD_VALIDATE', cast(TEMP as text), 'Nombre de données validées') INTO TEMPTIME;

	INSERT 	INTO data (keyid, station_id, sensor_id, date_record, raw_data, validate_data) 
			SELECT keyid, station_id, sensor_id, date_record, null, valeur
			FROM importation as i
			WHERE i.myType=3
			ON CONFLICT (keyid) DO NOTHING;	

	GET DIAGNOSTICS TEMP = ROW_COUNT;
	SELECT public._hydras_add_log('ADD_VALIDATE_NORAW', cast(TEMP as TEXT), 'Nombre de données validées sans data brute ajoutées') INTO TEMPTIME;

	-- SELECT public._hydras_add_log('---', cast(TEMP as TEXT),  ) INTO TEMPTIME;

	SELECT to_char(max(log.ldate) - min(log.ldate), 'MI:SS:MS') from log INTO TEMPTEXT;

	INSERT INTO log (ldate, laction, lvaleur, logstr) values (clock_timestamp(), 'END', TEMPTEXT, 'Traitements terminé ...') ON CONFLICT DO NOTHING;

	INSERT INTO public.logs (parent_id, ldate, laction, lvaleur, logstr) select log.parent_id, log.ldate, log.laction, log.lvaleur, log.logstr from log ON CONFLICT DO NOTHING;

	RETURN QUERY EXECUTE 'SELECT ldate, laction, lvaleur, logstr FROM log';

	IF (schemaname = 'tdd') THEN
		SELECT public._hydras_add_log('IMPORT', 'FILE', 'TESTS') INTO TEMPTIME;		
	ELSE
		-- Efface les table temporaires
		DROP TABLE IF EXISTS log;
		DROP TABLE IF EXISTS importation;
		DROP TABLE IF EXISTS import;
	END IF;
END;
$$
LANGUAGE plpgsql;
