-- Revert stackexchange_api:postHistory/postHistoryTypes from pg

BEGIN;

DROP TABLE stackdump.postHistoryTypes;

COMMIT;
