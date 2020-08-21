-- Deploy stackexchange_api:votes/votes to pg
-- requires: schema/appschema
-- requires: posts/posts
-- requires: users/users
-- requires: schema/jwt

BEGIN;

CREATE TABLE stackdump.votes(
id SERIAL PRIMARY KEY,
postId INTEGER REFERENCES stackdump.posts(id),
voteTypeId INTEGER REFERENCES stackdump.voteTypes(id) NOT NULL,
userId INTEGER REFERENCES stackdump.users(id) DEFAULT current_setting('jwt.claims.user_id',false)::int,
creationDate TIMESTAMP DEFAULT NOW(),
bountyAmount INTEGER
);

CREATE INDEX votes_id_idx ON stackdump.votes(id);
CREATE INDEX votes_postId_idx ON stackdump.votes(postId);
CREATE INDEX votes_voteTypeId_idx ON stackdump.votes(voteTypeId);
CREATE INDEX votes_userId_idx ON stackdump.votes(userId);

COMMIT;
