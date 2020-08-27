-- Revert stackexchange_api:posts/grants_posts from pg

BEGIN;

REVOKE select,insert,update,delete ON TABLE stackdump.posts FROM user_reg;
REVOKE usage,select ON SEQUENCE stackdump.posts_id_seq FROM user_reg;
REVOKE select ON TABLE stackdump.posts FROM user_anon;

COMMIT;
