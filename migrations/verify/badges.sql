-- Verify stackdump:badges on pg

BEGIN;

SELECT id, userId, name
    FROM stackdump.badges
    WHERE FALSE;

SELECT 'stackdump.badges_id_idx'::regclass;
SELECT 'stackdump.badges_userId_idx'::regclass;

ROLLBACK;
