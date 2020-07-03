-- Deploy stackdump:posts to pg
-- requires: appschema
-- requires: roles
-- requires: postTypes
-- requires: users

BEGIN;

CREATE TABLE stackdump.posts(
id SERIAL PRIMARY KEY,
postTypeId INTEGER REFERENCES stackdump.postTypes(id),
acceptedAnswerId INTEGER REFERENCES stackdump.posts(id),
parentId INTEGER REFERENCES stackdump.posts(id),
creationDate TIMESTAMP DEFAULT NOW(),
score INTEGER DEFAULT 0,
viewCount INTEGER DEFAULT 0,
body TEXT NOT NULL,
ownerUserId INTEGER REFERENCES stackdump.users(id) DEFAULT current_setting('jwt.claims.user_id',false)::INTEGER,
ownerDisplayName TEXT DEFAULT current_setting('jwt.claims.username',false),
lastEditorUserId INTEGER REFERENCES stackdump.users(id),
lastEditDate TIMESTAMP DEFAULT NOW(),
lastActivityDate TIMESTAMP DEFAULT NOW(),
title TEXT,
tags TEXT[],
answerCount INTEGER DEFAULT 0,
commentCount INTEGER DEFAULT 0,
favoriteCount INTEGER DEFAULT 0,
closedDate TIMESTAMP DEFAULT NULL,
communityOwnedDate TIMESTAMP DEFAULT NULL,
contentLicense TEXT
);

COMMIT;