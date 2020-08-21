-- Deploy stackexchange_api:comments/grants_comments to pg
-- requires: comments/comments
-- requires: schema/appschema
-- requires: schema/roles

BEGIN;

GRANT insert,select,update,delete ON TABLE stackdump.comments TO user_reg;
GRANT select ON TABLE stackdump.comments TO user_anon;
GRANT usage,select ON SEQUENCE stackdump.comments_id_seq TO user_reg;

COMMIT;
