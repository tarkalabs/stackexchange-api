-- Deploy stackdump:post_functions to pg
-- requires: posts
-- requires: tags
-- requires: users

BEGIN;

CREATE OR REPLACE FUNCTION stackdump.submit_question(
    question TEXT, 
    poster INTEGER, 
    question_title TEXT,
    question_tags TEXT[]
) RETURNS VOID LANGUAGE PLPGSQL AS $$
    DECLARE
    i INTEGER;
    BEGIN
        INSERT INTO stackdump.posts(postTypeId, body, ownerUserId, title, tags) 
        VALUES (1, question, poster, question_title, question_tags);
        FOR i IN 1 .. array_upper(question_tags, 1)
        LOOP
            UPDATE stackdump.tags SET count = count + 1 WHERE tagName = question_tags[i];
        END LOOP;
    END;
$$;

CREATE OR REPLACE FUNCTION stackdump.submit_answer(
    answer TEXT,
    question INTEGER,
    poster INTEGER
) RETURNS VOID LANGUAGE PLPGSQL AS $$
    BEGIN
        INSERT INTO stackdump.posts(postTypeId, parentId, viewCount, body, ownerUserId, answerCount) 
        VALUES (2, question, NULL, answer, poster, NULL);
    END;
$$;

CREATE OR REPLACE FUNCTION stackdump.delete_post(
    post INTEGER,
    poster INTEGER
) RETURNS VOID LANGUAGE PLPGSQL AS $$
    BEGIN
    DELETE FROM stackdump.posts WHERE post = id AND poster = ownerUserId;
    END;
$$;

COMMIT;
