-- Deploy stackexchange_api:badges/grants_badges to pg
-- requires: schema/appschema
-- requires: badges/badges
-- requires: schema/roles

BEGIN;

GRANT select ON TABLE stackdump.badges TO user_reg, user_anon; 

COMMIT;
