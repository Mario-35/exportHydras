CREATE OR REPLACE FUNCTION public._hydras_add_log(text, text, text) RETURNS VOID AS $$
BEGIN
	RAISE NOTICE 'notice : % % %',  $1, $2, $3;
	INSERT INTO log (ldate, laction, lvaleur, logstr) values (clock_timestamp(), $1, $2, $3) ON CONFLICT DO NOTHING;
END;
$$ LANGUAGE plpgsql;
