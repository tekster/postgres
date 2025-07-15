## pg_tle Walkthrough
# 1. Install pg_tle to shared_preload_libraries in your postgresql.conf and restart PostgreSQL. 
# 2. enclose sample code metadata for your extension:
    SELECT pgtle.install_extension(
        'my_extension',
        '0.1',
        'This is a quick description of your extension',
        $_pg_tle_$
            -- YOUR EXTENSION FUNCTIONS GO HERE
        $_pg_tle_$
    );
# 3. CREATE EXTENSION my_extension;
# 4. REGISTER HOOK using pgtle.register_feature
     SELECT pgtle.register_feature('my_password_check_rules', 'passcheck');    
# 5. Enable Hook
    ALTER SYSTEM SET pgtle.enable_clientauth = on;
    SELECT pg_reload_conf();
# 6. Create function for hook
    CREATE OR REPLACE FUNCTION check_client_auth(
        username TEXT,
        password TEXT,
        auth_method TEXT
    )
    RETURNS BOOLEAN
    AS $$
    BEGIN
        -- Check if the user is allowed to connect
        IF username = 'testuser' AND auth_method = 'password' THEN
            IF password = 'testpassword' THEN
                RETURN TRUE;
            ELSE
                RETURN FALSE;
            END IF;
        ELSE
            -- Allow other authentication methods (e.g., from pg_hba.conf)
            RETURN NULL;
        END IF;
    END;
    $$ LANGUAGE plpgsql;
7. Register Hook
    SELECT pgtle.register_feature('check_client_auth', 'passcheck');
8. Test!


REF: https://github.com/aws/pg_tle/blob/main/docs/01_install.md