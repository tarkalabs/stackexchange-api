-- Deploy stackdump:badges to pg
-- requires: appschema
-- requires: users

BEGIN;

CREATE TABLE stackdump.badges(
id SERIAL PRIMARY KEY,
userId INTEGER REFERENCES stackdump.users(id),
name TEXT NOT NULL,
date TIMESTAMP DEFAULT NOW(),
class INTEGER,
tagBased BOOLEAN
);

COMMIT;
