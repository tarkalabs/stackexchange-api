-- Deploy stackexchange_api:votes/grants_votetypes to pg
-- requires: schema/appschema
-- requires: votes/votes
-- requires: schema/roles

BEGIN;

GRANT select ON TABLE stackdump.votetypes TO user_reg,user_anon;

COMMIT;
