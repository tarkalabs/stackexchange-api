-- Deploy stackdump:comments to pg
-- requires: appschema
-- requires: posts
-- requires: users

BEGIN;

CREATE TABLE stackdump.comments(
id SERIAL PRIMARY KEY,
postId INTEGER REFERENCES stackdump.posts(id),
score INTEGER,
text TEXT NOT NULL,
creationDate TIMESTAMP DEFAULT NOW(),
userId INTEGER REFERENCES stackdump.users(id)
);

COMMIT;
