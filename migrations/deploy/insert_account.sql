-- Deploy stackdump:insert_account to pg
-- requires: appschema
-- requires: accounts
-- requires: insert_user

BEGIN;

CREATE OR REPLACE FUNCTION stackdump.insert_account(
    id INTEGER
) RETURNS VOID LANGUAGE PLPGSQL AS $$
    BEGIN
        INSERT INTO stackdump_private.accounts(id, username, password) VALUES
            (id, CONCAT('SEED_USER', id), extensions.crypt(CONCAT('SEED_PASS', id), extensions.gen_salt('md5')));
    END;
$$;

CREATE OR REPLACE FUNCTION stackdump.insert_account(
    username TEXT,
    password TEXT
) RETURNS VOID LANGUAGE PLPGSQL AS $$
    DECLARE 
    newId INTEGER;
    BEGIN
        INSERT INTO stackdump.users(id, displayName, accountId) VALUES
            (nextval('stackdump.users_id_seq'), username, lastval())
            RETURNING id INTO newId;
        INSERT INTO stackdump_private.accounts(id, username, password) VALUES
            (newId, username, extensions.crypt(password, extensions.gen_salt('md5')));
    END;
$$;

COMMIT;
