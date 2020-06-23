-- Deploy stackdump:tags to pg
-- requires: appschema
-- requires: posts

BEGIN;

CREATE TABLE stackdump.tags(
id SERIAL PRIMARY KEY,
tagName TEXT NOT NULL,
count INTEGER DEFAULT 0,
excerptPostId INTEGER REFERENCES stackdump.posts(id),
wikiPostId INTEGER REFERENCES stackdump.posts(id)
);

COMMIT;
