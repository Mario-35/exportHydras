CREATE OR REPLACE FUNCTION public._hydras_test_import() RETURNS TABLE(test text, result boolean) AS $$
DECLARE
    TOTAL INTEGER;
	TEMPINTEGER INTEGER;
	TEMPFLOAT FLOAT;
    TEMPTEST BOOLEAN;
    TEMPSTR VARCHAR;
    TESTUPDATE FLOAT = 1.2;
    TESTVALIDATE FLOAT = 3.4;

-- Create 3 janvier 2020
--
-- SCRIPT Importation csv issu d'Hydras3 @2020 Adam Mario Inrae mario.adam@inrae.fr
--
-- MAJ 26 mars 2020 [exportHydras]

--  si text = 'TEST' TDD test sinon fichier csv hydras



BEGIN
    DROP SCHEMA IF exists tdd CASCADE;

    CREATE SCHEMA tdd    
        CREATE TABLE tests_results (test text, result boolean);

    SET search_path = tdd;

    SHOW search_path INTO TEMPSTR;
	RAISE NOTICE 'SEARCH PATH for TDD : %', TEMPSTR;

    SELECT public._hydras_create_table('logsImports') INTO TEMPSTR;

    SELECT public._hydras_create_table('datas') INTO TEMPSTR;

    INSERT INTO datas (keyid, station_id, capteur_id, date_record, raw_data, validate_data)
    VALUES 	('71199804022000', 7, 1, '1998-04-02 00:00:00', null, null),
            ('71201201100030', 7, 1, '2012-01-10 00:30:00', -0.999, null),
            ('71200202020000', 7, 1, '02/02/2002 00:00:00', 20, null),
            ('71200202021200', 7, 1, '02/02/2002 00:12:00', 25, 50),
            ('729201201100115', 7, 29, '2012-01-10 01:15:00', -0.999, 50);    

    SELECT public._hydras_create_table('datas_updates') INTO TEMPSTR; 

    INSERT INTO datas_updates (keyid, date_update, update_data)
    VALUES 	('71200202021200','2002-02-02 12:00:00',30);    

    SELECT public._hydras_create_table('area') INTO TEMPSTR;

    INSERT INTO area (area_id, code, name) VALUES (1, 'B_Naizin__03', 'B_Naizin');		

    SELECT public._hydras_create_table('station') INTO TEMPSTR;
    INSERT INTO station (station_id, area_id, name) VALUES  (1, 1, 'KERRPK1'),
                                                            (2, 1, 'KERRPK2'),
                                                            (3, 1, 'KERRPK3'),
                                                            (4, 1, 'KERRPK4'),
                                                            (5, 1, 'KERRPK5'),
                                                            (6, 1, 'KERRPK6'),
                                                            (7, 1, 'GUERPG1'),
                                                            (8, 1, 'GUERPG2'),
                                                            (9, 1, 'GUERPG3');

    SELECT public._hydras_create_table('capteur') INTO TEMPSTR;
    INSERT INTO capteur (code, name, unite) VALUES  ('0101', 'Niveau Nappe', 'm'),
                                                    ('0102', 'Niveau Cours d''eau', 'm'),
                                                    ('0103', 'Vitesse Cours d''eau', 'm/s'),
                                                    ('0104', 'Débit', 'l/s'),
                                                    ('0105', 'Débit de base', 'L.s-1'),
                                                    ('0108', 'Niveau Nappe sur 24h', 'm'),
                                                    ('0109', 'Niveau manuel Nappe', 'm'),
                                                    ('0111', 'Gradient hydraulique', '%'),
                                                    ('0112', 'Niveau Cours d''eau 15 min', 'm'),
                                                    ('0115', 'Niveau Cours d''eau manuel', 'm'),
                                                    ('0120', 'Pression sommet tensio (-25cm)', ''),
                                                    ('0121', 'Pression sommet tensio (-50cm)', ''),
                                                    ('0122', 'Pression sommet tensio (-100cm)', ''),
                                                    ('0123', 'Pression sommet tensio (-150cm)', ''),
                                                    ('0124', 'Pression sommet tensio (-200cm)', ''),
                                                    ('0125', 'Pression sommet tensio (-250cm)', ''),
                                                    ('0130', 'Pression capillaire (-25cm)', ''),
                                                    ('0131', 'Pression capillaire (-50cm)', ''),
                                                    ('0132', 'Pression capillaire (-100cm)', ''),
                                                    ('0133', 'Pression capillaire (-150cm)', ''),
                                                    ('0134', 'Pression capillaire (-200cm)', ''),
                                                    ('0135', 'Pression capillaire (-250cm)', ''),
                                                    ('0140', 'Charge totale (-25cm)', ''),
                                                    ('0141', 'Charge totale (-50cm)', ''),
                                                    ('0142', 'Charge totale (-100cm)', ''),
                                                    ('0143', 'Charge totale (-150cm)', ''),
                                                    ('0144', 'Charge totale (-200cm)', ''),
                                                    ('0145', 'Charge totale (-250cm)', ''),
                                                    ('0201', 'Température de l''eau', '°C'),
                                                    ('0202', 'Température de l''air', '°C');


    SELECT public._hydras_create_table('import') INTO TEMPSTR;
    INSERT INTO import (station, capteur, date_heure, valeur, info) VALUES 
        ('GUER_B_PG1', '0101', '02/04/1998 00:00:00', '---', ''),
        ('GUER_B_PG1', '0101', '02/04/1998 04:00:00', '---', ''),
        ('GUER_B_PG1', '0101', '02/04/1998 08:00:00', '---', ''),
        ('GUER_B_PG1', '0101', '02/04/1998 12:00:00', '---', ''),
        ('GUER_B_PG1', '0101', '02/04/1998 16:00:00', '---', ''),
        ('GUER_B_PG1', '0101', '02/04/1998 20:00:00', '---', ''),
        ('GUER__PG1',  '0101', '03/04/1998 00:00:00', '-0.999', ''),
        ('GUERB_PG1',  '0101', '03/04/1998 04:00:00', '-0.999', ''),
        ('GUER_BPG1',  '0101', '03/04/1998 08:00:00', '-0.999', ''),
        ('GUER_PG1',   '0101', '03/04/1998 12:00:00', '-0.999', ''),
        ('RIEN_B_TEST','0101', '03/04/1998 16:00:00', '-0.999', ''),
        ('GUER_B_PG1', '101',  '04/04/1998 00:00:00', '-0.999', ''),
        ('GUER_B_PG1', '011',  '04/04/1998 04:00:00', '-0.999', ''),
        ('GUER_B_PG1', '0101', '09/04/1998 00:00:00', '-0.080', ''),
        ('GUER_B_PG1', '0101', '09/04/1998 04:00:00', '-0.060', ''),
        ('GUER_B_PG1', '0101', '09/04/1998 08:00:00', '-0.060', ''),
        ('GUER_B_PG1', '0101', '09/04/1998 12:00:00', '-0.070', ''),
        ('GUER_B_PG1', '0101', '09/04/1998 16:00:00', '-0.070', ''),
        ('GUER_B_PG1', '0101', '09/04/1998 20:00:00', '-0.080', ''),
        ('GUER_B_PG1', '0101', '10/04/1998 00:00:00', '-0.080', ''),
        ('GUER_B_PG1', '0101', '10/04/1998 04:00:00', '-0.080', ''),
        ('GUER_B_PG1', '0101', '10/04/1998 08:00:00', '-0.080', ''),
        ('GUER_B_PG1', '0101', '10/04/1998 12:00:00', '-0.100', ''),
        ('GUER_B_PG1', '0101', '10/04/1998 16:00:00', '-0.110', ''),
        ('GUER_B_PG1', '0101', '10/04/1998 20:00:00', '-0.120', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 00:00:00', '0.0', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 00:15:00', '0.15', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 00:30:00', '0.30', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 00:45:00', '0.45', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 01:00:00', '1.0', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 01:15:00', '1.15', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 01:30:00', '1.30', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 01:45:00', '1.45', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 02:00:00', '2.0', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 02:15:00', '2.15', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 02:30:00', '2.30', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 02:45:00', '2.45', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 03:00:00', '3.00', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 03:15:00', '3.15', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 03:30:00', '3.30', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 03:45:00', '3.45', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 04:00:00', '4.00', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 04:15:00', '4.15', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 04:30:00', '4.30', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 04:45:00', '4.45', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 05:00:00', '05.00', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 05:15:00', '05.15', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 05:30:00', '05.30', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 05:45:00', '05.45', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 06:00:00', '06.00', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 06:15:00', '06.15', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 06:30:00', '06.30', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 06:45:00', '06.45', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 07:00:00', '07.00', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 07:15:00', '07.15', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 07:30:00', '07.30', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 07:45:00', '07.45', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 08:00:00', '08.00', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 08:15:00', '08.15', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 08:30:00', '08.30', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 08:45:00', '08.45', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 09:00:00', '09.00', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 09:15:00', '09.15', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 09:30:00', '09.30', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 09:45:00', '09.45', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 10:00:00', '10.00', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 10:15:00', '10.15', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 10:30:00', '10.30', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 10:45:00', '10.45', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 11:00:00', '11.00', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 11:15:00', '11.15', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 11:30:00', '11.30', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 11:45:00', '11.45', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 12:00:00', '12.00', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 12:15:00', '12.15', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 12:30:00', '12.30', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 12:45:00', '12.45', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 13:00:00', '13.00', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 13:15:00', '13.15', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 13:30:00', '13.30', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 13:45:00', '13.45', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 14:00:00', '14.00', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 14:15:00', '14.15', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 14:30:00', '14.30', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 14:45:00', '14.45', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 15:00:00', '15.00', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 15:15:00', '15.15', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 15:30:00', '15.30', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 15:45:00', '15.45', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 16:00:00', '16.00', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 16:15:00', '16.15', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 16:30:00', '16.30', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 16:45:00', '16.45', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 17:00:00', '17.00', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 17:15:00', '17.15', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 17:30:00', '17.30', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 17:45:00', '17.45', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 18:00:00', '18.00', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 18:15:00', '18.15', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 18:30:00', '18.30', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 18:45:00', '18.45', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 19:00:00', '19.00', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 19:15:00', '19.15', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 19:30:00', '19.30', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 19:45:00', '19.45', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 20:00:00', '20.00', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 20:15:00', '20.15', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 20:30:00', '20.30', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 20:45:00', '20.45', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 21:00:00', '21.00', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 21:15:00', '21.15', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 21:30:00', '21.30', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 21:45:00', '21.45', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 22:00:00', '22.00', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 22:15:00', '22.15', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 22:30:00', '22.30', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 22:45:00', '22.45', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 23:00:00', '23.00', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 23:15:00', '23.15', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 23:30:00', '23.30', ''),
        ('GUER_B_PG1', '0201', '10/01/2012 23:45:00', '23.45', ''),
        ('GUER_B_PG1', '0101', '10/04/1998 00:00:00', '-0.080', '#'),
        ('GUER_B_PG1', '0101', '10/04/1998 04:00:00', '-0.080', '#'),
        ('GUER_B_PG1', '0101', '10/04/1998 08:00:00', '-0.080', '#'),
        ('GUER_B_PG1', '0101', '10/04/1998 12:00:00', '-0.100', '#'),
        ('GUER_B_PG1', '0101', '10/04/1998 16:00:00', '-0.110', '#'),
        ('GUER_B_PG1', '0101', '10/04/1998 20:00:00', '-0.120', '#'),
        ('GUER_B_PG1', '0101', '10/04/1998 00:00:00', '-0.080', '/'),
        ('GUER_B_PG1', '0101', '10/04/1998 04:00:00', '-0.080', '/'),
        ('GUER_B_PG1', '0101', '10/04/1998 08:00:00', '-0.080', '/'),
        ('GUER_B_PG1', '0101', '10/04/1998 12:00:00', '-0.100', '/'),
        ('GUER_B_PG1', '0101', '10/04/1998 16:00:00', '-0.110', '/'),
        ('GUER_B_PG1', '0101', '10/04/1998 20:00:00', '-0.120', '/'),
        ('GUER_B_PG1', '0101', '09/04/1998 00:00:00', '1.00', '#'),
        ('GUER_B_PG1', '0101', '09/04/1998 04:00:00', '1.4', '#'),
        ('GUER_B_PG1', '0101', '09/04/1998 08:00:00', '1.8', '#'),
        ('GUER_B_PG1', '0101', '09/04/1998 12:00:00', '1.12', '#'),
        ('GUER_B_PG1', '0101', '09/04/1998 16:00:00', '1.16', '#'),
        ('GUER_B_PG1', '0101', '09/04/1998 20:00:00', CAST(TESTUPDATE AS VARCHAR), '#'),
        ('GUER_B_PG1', '0101', '09/04/1998 00:00:00', '3', '/'),
        ('GUER_B_PG1', '0101', '09/04/1998 04:00:00', CAST(TESTVALIDATE AS VARCHAR), '/'),
        ('GUER_B_PG1', '0101', '09/04/1998 08:00:00', '3.8', '/'),
        ('GUER_B_PG1', '0101', '09/04/1998 12:00:00', '3.12', '/'),
        ('GUER_B_PG1', '0101', '09/04/1998 16:00:00', '3.16', '/'),
        ('GUER_B_PG1', '0101', '09/04/1998 20:00:00', '3.2', '/'),
        ('GUER_B_PG1', '0101', '09/04/1998 00:00:00', '-0.080', ''),
        ('GUER_B_PG1', '0101', '09/04/1998 00:00:00', '-0.080', ''),
        ('GUER_B_PG1', '0101', '02/02/2002 00:00:00', '20', ''),
        ('GUER_B_PG1', '0101', '02/02/2002 12:00:00', '30', '#'),
        ('GUER_B_PG1', '0101', '02/02/2002 12:00:00', '50', '/'),
        ('GUER_B_PG1', '0101', '02/02/2002 12:15:00', '99', 'ABCDEFGHIJ'),
        ('GUER_B_PG1', '0101', '02/02/2002 12:30:00', '60', '/'),
        ('GUER_B_PG1', '0101', '09/04/1998 00:00:00', '1.00', '#');

    SELECT public._hydras_import('tdd') INTO TEMPSTR;
       
    GET DIAGNOSTICS TEMPINTEGER = ROW_COUNT;	
    TEMPTEST = TEMPINTEGER = 1;

    SELECT COUNT(*) FROM tdd.import INTO TEMPINTEGER;

    INSERT INTO tdd.tests_results (test, result) values ('import', TRUE);

    SELECT lvaleur FROM log WHERE laction='LOAD' INTO TOTAL;

    INSERT INTO tests_results (test, result) values ('Load file', (TOTAL > 1)) ON CONFLICT DO NOTHING;
      
     INSERT INTO tests_results (test, result) values ('Test Info too long', ((select info from importation where keyid ='71200202021215') LIKE 'ABCDE')) ON CONFLICT DO NOTHING;                    

     INSERT INTO tests_results (test, result) values ('Test bad station GUER__PG1', ((SELECT laction FROM log WHERE lvaleur='GUER__PG1') LIKE 'STATION_%')) ON CONFLICT DO NOTHING;                    
     INSERT INTO tests_results (test, result) values ('Test bad station GUERB_PG1', ((SELECT laction FROM log WHERE lvaleur='GUERB_PG1') LIKE 'STATION_%')) ON CONFLICT DO NOTHING;                    
     INSERT INTO tests_results (test, result) values ('Test bad station GUER_BPG1', ((SELECT laction FROM log WHERE lvaleur='GUER_BPG1') LIKE 'STATION_%')) ON CONFLICT DO NOTHING;                    
     INSERT INTO tests_results (test, result) values ('Test bad station GUER_PG1', ((SELECT laction FROM log WHERE lvaleur='GUER_PG1') LIKE 'STATION_%')) ON CONFLICT DO NOTHING;                    
     INSERT INTO tests_results (test, result) values ('Test bad station RIEN_B_TEST', ((SELECT laction FROM log WHERE lvaleur='RIEN_B_TEST') LIKE 'STATION_%')) ON CONFLICT DO NOTHING;                    
     
     INSERT INTO tests_results (test, result) values ('Test bad capteur 101', ((SELECT laction FROM log WHERE lvaleur='101') LIKE 'CAPTEUR_%')) ON CONFLICT DO NOTHING;                    
     INSERT INTO tests_results (test, result) values ('Test bad capteur 011', ((SELECT laction FROM log WHERE lvaleur='011') LIKE 'CAPTEUR_%')) ON CONFLICT DO NOTHING;                    


     INSERT INTO tests_results (test, result) values ('Test doublons in file', ((SELECT lvaleur FROM log WHERE laction='DOUB_FILE') = '3')) ON CONFLICT DO NOTHING;   
     INSERT INTO tests_results (test, result) values ('Test null value', ((SELECT lvaleur FROM log WHERE laction='DOUB_NULL') = '1')) ON CONFLICT DO NOTHING;   
     INSERT INTO tests_results (test, result) values ('Test doublons rawdata', ((SELECT lvaleur FROM log WHERE laction='DOUB_BRUT') = '1')) ON CONFLICT DO NOTHING;   
     INSERT INTO tests_results (test, result) values ('Test doublons update', ((SELECT lvaleur FROM log WHERE laction='DOUB_UPDATE') = '1')) ON CONFLICT DO NOTHING;   
     INSERT INTO tests_results (test, result) values ('Test doublons validate', ((SELECT lvaleur FROM log WHERE laction='DOUB_VALIDATE') = '1')) ON CONFLICT DO NOTHING;   
     INSERT INTO tests_results (test, result) values ('Test validate without rawdata', ((SELECT lvaleur FROM log WHERE laction='ADD_VALIDATE_NORAW') = '1')) ON CONFLICT DO NOTHING;   
                      

    SELECT update_data FROM datas_updates AS u WHERE u.keyid = (
        SELECT d.keyid
        FROM datas AS d
        WHERE station_id = (SELECT s.station_id FROM station AS s WHERE s.name = 'GUERPG1')
        AND capteur_id = (SELECT c.capteur_id FROM capteur As c WHERE c.code = '0101')
        AND date_record = TO_TIMESTAMP('09/04/1998 20:00:00', 'DD/MM/YYYY HH24:MI:SS:MS'))
        INTO TEMPFLOAT;

    INSERT INTO tests_results (test, result) VALUES ('Test update data', (TEMPFLOAT = TESTUPDATE)) ON CONFLICT DO NOTHING; 

     SELECT validate_data FROM datas AS d
        WHERE station_id = (SELECT s.station_id FROM station As s WHERE s.name = 'GUERPG1')
        AND capteur_id = (SELECT c.capteur_id FROM capteur As c WHERE c.code = '0101')
        AND date_record = TO_TIMESTAMP('09/04/1998 04:00:00', 'DD/MM/YYYY HH24:MI:SS:MS')  
        INTO TEMPFLOAT;                

   INSERT INTO tests_results (test, result) VALUES ('Test validate data', (TEMPFLOAT = TESTVALIDATE)) ON CONFLICT DO NOTHING; 

   SELECT lvaleur FROM log WHERE laction='END' INTO TEMPSTR;

   INSERT INTO tests_results (test, result) VALUES ( TEMPSTR, TRUE) ON CONFLICT DO NOTHING; 

    RETURN QUERY EXECUTE 'SELECT test, result FROM tdd.tests_results';
    DROP SCHEMA IF exists tdd CASCADE;
END;
$$
LANGUAGE plpgsql;

