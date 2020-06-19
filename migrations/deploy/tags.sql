-- Deploy stackdump:tags to pg
-- requires: appschema
-- requires: posts

BEGIN;

CREATE TABLE stackdump.tags(
id SERIAL PRIMARY KEY,
tagName TEXT,
count INTEGER,
excerptPostId INTEGER REFERENCES stackdump.posts(id),
wikiPostId INTEGER REFERENCES stackdump.posts(id)
);

COMMIT;
