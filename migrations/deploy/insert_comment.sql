-- Deploy stackdump:insert_comment to pg
-- requires: appschema
-- requires: comments

BEGIN;

CREATE OR REPLACE FUNCTION stackdump.insert_comment(
    id INTEGER,
    postId INTEGER,
    score INTEGER,
    text TEXT,
    creationDate TIMESTAMP,
    userDisplayName TEXT,
    userId INTEGER,
    contentLicense TEXT
) RETURNS VOID LANGUAGE PLPGSQL AS $$
    BEGIN
    INSERT INTO stackdump.comments VALUES($1, $2, $3, $4, $5, $6, $7, $8);
    EXCEPTION
        WHEN foreign_key_violation THEN
            RAISE NOTICE 'Caught fk violation: ';
            IF (SELECT NOT EXISTS(SELECT 1 FROM stackdump.posts WHERE posts.id = $2) AND $2 IS NOT NULL) THEN
                $2 := NULL;
                RAISE NOTICE 'Invalid postId on comment with id = (%)', $1;
            END IF;
            IF (SELECT NOT EXISTS(SELECT 1 FROM stackdump.users WHERE users.id = $7) AND $7 IS NOT NULL) THEN
                $7 := NULL;
                RAISE NOTICE 'Invalid userId on comment with id = (%)', $1;
            END IF;
            
            INSERT INTO stackdump.comments VALUES($1, $2, $3, $4, $5, $6, $7, $8);
    END;
$$;

COMMIT;
