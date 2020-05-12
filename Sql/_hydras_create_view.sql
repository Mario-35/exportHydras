CREATE OR REPLACE FUNCTION public._hydras_create_view(viewname text, ownername text) returns void AS
$$
 declare
	TEMPTEXT TEXT;	
    TEST BOOLEAN;

BEGIN
    RAISE NOTICE 'CREATE_VIEW % ', $1;
    CASE $1
        WHEN 'data_view' THEN
        CREATE OR REPLACE VIEW data_view
            AS SELECT d.id,
                d.keyid,
                d.station_id,
                d.sensor_id,
                d.date_raw AS date,
                d.value_raw AS raw,
                d.value_correction_id AS correction_id,
                a.name AS area_name,
                s.code AS station_code,
                s.area_id,
                s.name AS station_name,
                c.code AS sensor_code,
                c.name AS sensor_name,
                c.unite AS sensor_unite
            FROM data d
                RIGHT JOIN station s ON d.station_id = s.id
                LEFT JOIN sensor c ON d.sensor_id = c.id
                LEFT JOIN area a ON s.area_id = a.id;

        EXECUTE 'ALTER TABLE ' || viewname || ' OWNER TO ' || ownername; 

            
        ELSE
            RAISE NOTICE 'CREATE_VIEW case structure';
    END CASE;  
END;
$$
LANGUAGE plpgsql;

