-- Revert stackexchange_api:votes/voteTypes from pg

BEGIN;

DROP TABLE stackdump.voteTypes;

COMMIT;
