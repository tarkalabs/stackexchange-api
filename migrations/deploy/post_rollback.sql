-- Deploy stackdump:post_rollback to pg
-- requires: appschema
-- requires: posts
-- requires: postHistory
-- requires: post_triggers

BEGIN;

CREATE FUNCTION stackdump.post_rollback(
    oldGUID TEXT
) RETURNS VOID AS $$
    DECLARE
        oldTitle TEXT := (SELECT text FROM stackdump.postHistory WHERE revisionGUID = oldGUID AND (postHistoryTypeId = 1 OR postHistoryTypeId = 4));
        oldBody TEXT := (SELECT text FROM stackdump.postHistory WHERE revisionGUID = oldGUID AND (postHistoryTypeId = 2 OR postHistoryTypeId = 5));
        oldTagString TEXT := (SELECT text FROM stackdump.postHistory WHERE revisionGUID = oldGUID AND (postHistoryTypeId = 3 OR postHistoryTypeId = 6));
        oldTagArray TEXT[] := (SELECT STRING_TO_ARRAY((SUBSTRING(oldTagString, 2, length(oldTagString) - 2)), '><'));
        newGUID TEXT := extensions.uuid_generate_v4();
        rollbackPostId INTEGER := (SELECT postId FROM stackdump.postHistory WHERE oldGUID = revisionGUID LIMIT 1);
        postUserId INTEGER := (SELECT ownerUserId FROM stackdump.posts WHERE id = rollbackPostId);
        currentTags TEXT[] := (SELECT tags FROM stackdump.posts WHERE id = rollbackPostId);
    BEGIN
        SET ROLE user_super;
        ALTER TABLE stackdump.posts DISABLE TRIGGER post_on_update;
        IF oldTitle IS NOT NULL THEN
            INSERT INTO stackdump.postHistory(postHistoryTypeId, postId, revisionGUID, userId, text)
                VALUES (7, rollbackPostId, newGUID, postUserId, oldTitle);
        END IF;
        IF oldBody IS NOT NULL THEN
            INSERT INTO stackdump.postHistory(postHistoryTypeId, postId, revisionGUID, userId, text)
                VALUES (8, rollbackPostId, newGUID, postUserId, oldBody);
        END IF;
        IF oldTagArray IS NOT NULL THEN
            IF array_upper(currentTags, 1) >= 1 THEN 
                FOR i IN 1 .. array_upper(currentTags, 1)
                LOOP
                    UPDATE stackdump.tags SET count = count - 1 WHERE tagName = currentTags[i];
                END LOOP;
            END IF;
            IF array_upper(oldTagArray, 1) >= 1 THEN 
                FOR i IN 1 .. array_upper(oldTagArray, 1)
                LOOP
                    UPDATE stackdump.tags SET count = count + 1 WHERE tagName = oldTagArray[i];
                END LOOP;
            END IF;
            INSERT INTO stackdump.postHistory(postHistoryTypeId, postId, revisionGUID, userId, text)
                VALUES (9, rollbackPostId, newGUID, postUserId, oldTagString);
        END IF;
        UPDATE stackdump.posts SET 
            title = COALESCE(oldTitle, title), 
            body = COALESCE(oldBody, body),
            tags = COALESCE(oldTagArray, tags)
            WHERE id = rollbackPostId;
        ALTER TABLE stackdump.posts ENABLE TRIGGER post_on_update;
        RESET ROLE;
    END;
$$ LANGUAGE PLPGSQL;

COMMIT;
