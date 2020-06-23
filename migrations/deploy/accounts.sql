-- Deploy stackdump:accounts to pg
-- requires: appschema

BEGIN;

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE stackdump_private.accounts(
    id SERIAL PRIMARY KEY,
    username TEXT NOT NULL,
    password TEXT NOT NULL,
    creationDate TIMESTAMP DEFAULT NOW()
);

COMMIT;
