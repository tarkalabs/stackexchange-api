-- Deploy stackexchange_api:users/grants_user to pg
-- requires: schema/roles
-- requires: schema/appschema
-- requires: users/users

BEGIN;

GRANT select,update,delete ON TABLE stackdump.users TO user_reg;
GRANT select ON TABLE stackdump.users TO user_anon;
GRANT usage,select ON SEQUENCE stackdump.users_id_seq TO user_reg;

COMMIT;
