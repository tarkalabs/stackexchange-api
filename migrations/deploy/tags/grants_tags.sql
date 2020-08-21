-- Deploy stackexchange_api:tags/grants_tgs to pg
-- requires: schema/appschema
-- requires: tags/tags
-- requires: schema/roles

BEGIN;

GRANT select ON TABLE stackdump.tags TO user_reg,user_anon;

COMMIT;
