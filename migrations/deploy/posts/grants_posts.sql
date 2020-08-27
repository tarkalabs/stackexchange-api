-- Deploy stackexchange_api:posts/grants_posts to pg
-- requires: schema/appschema
-- requires: posts/posts
-- requires: schema/roles

BEGIN;

GRANT select ON TABLE stackdump.posts TO user_anon;
GRANT usage,select ON SEQUENCE stackdump.posts_id_seq TO user_reg,user_anon;
GRANT select,insert,update,delete ON TABLE stackdump.posts TO user_reg;

COMMIT;
