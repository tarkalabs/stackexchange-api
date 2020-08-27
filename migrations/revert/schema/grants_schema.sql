-- Revert stackexchange_api:schema/grants_schema from pg

BEGIN;

REVOKE usage ON SCHEMA stackdump FROM user_anon,user_reg;
REVOKE usage ON SCHEMA extensions FROM user_anon, user_reg;
REVOKE execute ON FUNCTION stackdump.register_user(text, text) FROM user_anon;
REVOKE execute ON FUNCTION stackdump.authenticate(text, text) FROM user_anon;
REVOKE execute ON FUNCTION stackdump.register_superuser(text) FROM user_anon;

COMMIT;
