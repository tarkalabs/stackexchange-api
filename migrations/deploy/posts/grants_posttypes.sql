-- Deploy stackexchange_api:posts/grants_posttypes to pg
-- requires: schema/appschema
-- requires: posts/posts
-- requires: schema/roles

BEGIN;

GRANT select ON TABLE stackdump.posttypes TO user_reg,user_anon;

COMMIT;
