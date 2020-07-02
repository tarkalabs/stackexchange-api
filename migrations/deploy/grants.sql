-- Deploy stackdump:grants to pg
-- requires: roles
-- requires: appschema
-- requires: authentication
-- requires: register_user
-- requires: posts

BEGIN;

grant usage on schema stackdump to user_anon, user_reg;
grant execute on function stackdump.register_user(text, text) to user_anon;
grant execute on function stackdump.authenticate(text, text) to user_anon;
grant select,insert,update,delete on table stackdump.posts to user_reg;
grant usage,select on sequence stackdump.posts_id_seq to user_reg;

COMMIT;
