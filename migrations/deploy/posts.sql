-- Deploy stackdump:posts to pg
-- requires: appschema
-- requires: postTypes
-- requires: users

BEGIN;

CREATE TABLE stackdump.posts(
id SERIAL PRIMARY KEY,
postTypeId INTEGER REFERENCES stackdump.postTypes(id),
acceptedAnswerId INTEGER REFERENCES stackdump.posts(id),
creationDate TIMESTAMP DEFAULT NOW(),
score INTEGER,
viewCount INTEGER,
body TEXT NOT NULL,
ownerUserId INTEGER REFERENCES stackdump.users(id),
ownerDisplayName TEXT,
lastEditorUserId INTEGER REFERENCES stackdump.users(id),
lastEditDate TIMESTAMP DEFAULT NOW(),
lastActivityDate TIMESTAMP DEFAULT NOW(),
title TEXT,
tags TEXT,
answerCount INTEGER,
commentCount INTEGER,
favoriteCount INTEGER
);

COMMIT;
