-- Deploy stackdump:postHistory to pg
-- requires: appschema
-- requires: users
-- requires: posts
-- requires: postHistoryTypes

BEGIN;

CREATE TABLE stackdump.posthistory(
id SERIAL PRIMARY KEY,
postHistoryTypeId INTEGER REFERENCES stackdump.postHistoryTypes(id),
postId INTEGER REFERENCES stackdump.posts(id),
revisionGUID TEXT,
creationDate TIMESTAMP DEFAULT NOW(),
userId INTEGER REFERENCES stackdump.users(id),
UserDisplayName TEXT,
comment TEXT,
text TEXT,
contentLicense TEXT
);

COMMIT;
