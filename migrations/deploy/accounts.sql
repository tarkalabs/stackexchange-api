-- Deploy stackdump:accounts to pg
-- requires: appschema

BEGIN;

CREATE TABLE stackdump_private.accounts(
    id SERIAL PRIMARY KEY,
    username TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,
    creationDate TIMESTAMP DEFAULT NOW()
);

COMMIT;