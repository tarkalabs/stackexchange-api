-- Deploy stackdump:register_user to pg
-- requires: appschema
-- requires: accounts
-- requires: users

BEGIN;

CREATE OR REPLACE FUNCTION stackdump.register_user(
    username text,
    password text
) RETURNS stackdump.users AS $$
DECLARE
	usr stackdump.users;
	usr_account stackdump_private.accounts;
BEGIN
    IF username ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$' THEN
        INSERT INTO stackdump_private.accounts (username, password) VALUES ($1, extensions.crypt($2, extensions.gen_salt('bf'))) RETURNING * INTO usr_account;
        INSERT INTO stackdump.users (emailaddr, accountId) VALUES (username, usr_account.id) RETURNING * INTO usr;
        RETURN usr;
    ELSE 
        RAISE EXCEPTION 'Username needs to be a valid email address';
    END IF;
END;
$$ LANGUAGE PLPGSQL STRICT SECURITY DEFINER;

COMMIT;
