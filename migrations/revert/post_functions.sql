-- Revert stackdump:post_functions from pg

BEGIN;

DROP FUNCTION stackdump.submit_question(TEXT, INTEGER, TEXT, TEXT[]);
DROP FUNCTION stackdump.submit_answer(TEXT, INTEGER, INTEGER);
DROP FUNCTION stackdump.delete_post(INTEGER, INTEGER);

COMMIT;
