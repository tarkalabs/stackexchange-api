-- Deploy stackexchange_api:schema/grants_schema to pg
-- requires: schema/roles
-- requires: schema/appschema
-- requires: users/authentication
-- requires: users/register_user
-- requires: posts/posts

BEGIN;

GRANT usage ON SCHEMA stackdump TO user_anon, user_reg;
GRANT usage ON SCHEMA extensions TO user_anon,user_reg;
GRANT execute ON FUNCTION stackdump.register_user(text, text) TO user_anon;
GRANT execute ON FUNCTION stackdump.authenticate(text, text) TO user_anon;
GRANT execute ON FUNCTION stackdump.register_superuser(text) TO user_anon;

COMMIT;
