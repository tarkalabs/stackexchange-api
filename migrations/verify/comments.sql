-- Verify stackdump:comments on pg

BEGIN;

SELECT id, postId, score
    FROM stackdump.comments
    WHERE FALSE;

SELECT 'stackdump.comments_id_idx'::regclass;
SELECT 'stackdump.comments_postId_idx'::regclass;
SELECT 'stackdump.comments_userId_idx'::regclass;

ROLLBACK;
