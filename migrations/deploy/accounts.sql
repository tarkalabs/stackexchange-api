-- Deploy stackdump:accounts to pg
-- requires: appschema

BEGIN;

CREATE TABLE stackdump_private.accounts(
    id INTEGER PRIMARY KEY REFERENCES stackdump.users(id),
    username TEXT NOT NULL,
    password TEXT NOT NULL,
    creationDate TIMESTAMP DEFAULT NOW()
);

COMMIT;
