-- Revert stackexchange_api:badges/grants_badges from pg

BEGIN;

REVOKE select ON TABLE stackdump.badges FROM user_reg, user_anon;

COMMIT;
