-- Deploy stackexchange_api:postLinks/postLinks to pg
-- requires: schema/appschema
-- requires: posts/posts

BEGIN;

CREATE TABLE stackdump.postlinks(
id SERIAL PRIMARY KEY,
creationDate TIMESTAMP DEFAULT NOW(),
postId INTEGER REFERENCES stackdump.posts(id),
relatedPostId INTEGER REFERENCES stackdump.posts(id),
linkTypeId INTEGER
);

CREATE INDEX postLinks_id_idx ON stackdump.postLinks(id);
CREATE INDEX postLinks_postId_idx ON stackdump.postLinks(postId);
CREATE INDEX postLinks_relatedPostId_idx ON stackdump.postLinks(relatedPostId);

COMMIT;
