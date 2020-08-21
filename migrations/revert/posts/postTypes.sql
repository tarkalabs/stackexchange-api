-- Revert stackexchange_api:posts/postTypes from pg

BEGIN;

DROP TABLE stackdump.postTypes;

COMMIT;
