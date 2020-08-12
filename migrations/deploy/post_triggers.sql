-- Deploy stackdump:post_triggers to pg
-- requires: appschema
-- requires: posts
-- requires: postHistory
-- requires: tags

BEGIN;

CREATE FUNCTION stackdump_private.post_create_trigger() RETURNS TRIGGER AS $$
    DECLARE
        i INTEGER;
        newGUID TEXT := extensions.uuid_generate_v4();
    BEGIN
        SET ROLE user_super;
        UPDATE stackdump.posts SET answerCount = answerCount + 1
            WHERE posts.id = new.parentId;
        INSERT INTO stackdump.postHistory(postHistoryTypeId, postId, revisionGUID, userId, text)
            VALUES (1, new.id, newGUID, new.ownerUserId, new.title);
        INSERT INTO stackdump.postHistory(postHistoryTypeId, postId, revisionGUID, userId, text)
            VALUES (2, new.id, newGUID, new.ownerUserId, new.body);
        INSERT INTO stackdump.postHistory(postHistoryTypeId, postId, revisionGUID, userId, text)
            VALUES (3, new.id, newGUID, new.ownerUserId, CONCAT('<', ARRAY_TO_STRING(new.tags, '><'), '>'));
        IF array_upper(new.tags, 1) >= 1 THEN 
            FOR i IN 1 .. array_upper(new.tags, 1)
            LOOP
                UPDATE stackdump.tags SET count = count + 1 WHERE tagName = new.tags[i];
            END LOOP;
        END IF;
        RESET ROLE;
        RETURN new;
    END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER post_on_create AFTER INSERT
    ON stackdump.posts
    FOR EACH ROW
    EXECUTE PROCEDURE stackdump_private.post_create_trigger();

CREATE FUNCTION stackdump_private.post_delete_trigger() RETURNS TRIGGER AS $$
    DECLARE
        i INTEGER;
    BEGIN
        UPDATE stackdump.posts SET answerCount = answerCount - 1
            WHERE posts.id = old.parentId;
        UPDATE stackdump.posts SET deleted = true
            WHERE posts.id = old.id;
        INSERT INTO stackdump.postHistory(postHistoryTypeId, postId, revisionGUID, userId)
            VALUES (12, old.id, extensions.uuid_generate_v4(), old.ownerUserId);
        IF array_upper(new.tags, 1) >=  1 THEN
            FOR i IN 1 .. array_upper(old.tags, 1)
            LOOP
                UPDATE stackdump.tags SET count = count - 1 WHERE tagName = old.tags[i];
            END LOOP;
        END IF;
        RETURN old;
    END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER post_on_delete INSTEAD OF DELETE
    ON stackdump.post_view
    FOR EACH ROW
    EXECUTE PROCEDURE stackdump_private.post_delete_trigger();

CREATE FUNCTION stackdump_private.post_update_trigger() RETURNS TRIGGER AS $$
    DECLARE
        i INTEGER;
        newGUID TEXT := extensions.uuid_generate_v4();
    BEGIN
        SET ROLE user_super;
        IF new.title != old.title THEN
            INSERT INTO stackdump.postHistory(postHistoryTypeId, postId, revisionGUID, userId, text)
                VALUES (4, new.id, newGUID, new.ownerUserId, new.title);
        END IF;
        IF new.body != old.body THEN
            INSERT INTO stackdump.postHistory(postHistoryTypeId, postId, revisionGUID, userId, text)
                VALUES (5, new.id, newGUID, new.ownerUserId, new.body);
        END IF;
        IF new.tags != old.tags THEN
            IF array_upper(old.tags, 1) >=  1 THEN 
                FOR i IN 1 .. array_upper(old.tags, 1)
                LOOP
                    UPDATE stackdump.tags SET count = count - 1 WHERE tagName = old.tags[i];
                END LOOP;
            END IF;
            IF array_upper(new.tags, 1) >=  1 THEN 
                FOR i IN 1 .. array_upper(new.tags, 1)
                LOOP
                    UPDATE stackdump.tags SET count = count + 1 WHERE tagName = new.tags[i];
                END LOOP;
                INSERT INTO stackdump.postHistory(postHistoryTypeId, postId, revisionGUID, userId, text)
                    VALUES (6, new.id, newGUID, new.ownerUserId, CONCAT('<', ARRAY_TO_STRING(new.tags, '><'), '>'));
            END IF;
        END IF;
        RESET ROLE;
        RETURN new;
    END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER post_on_update AFTER UPDATE
    ON stackdump.posts
    FOR EACH ROW
    EXECUTE PROCEDURE stackdump_private.post_update_trigger();
    

CREATE OR REPLACE FUNCTION stackdump_private.check_parent() RETURNS trigger AS $$
DECLARE
    pid INTEGER;
BEGIN
    IF NEW.parentId IS NOT NULL THEN
        SELECT parentId INTO pid FROM stackdump.posts WHERE id = (SELECT id FROM stackdump.posts WHERE id = NEW.parentId);
        IF pid IS NOT NULL THEN 
            RAISE EXCEPTION 'Parent post already has a parent';
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER before_post_insert BEFORE INSERT ON stackdump.posts FOR EACH ROW EXECUTE PROCEDURE stackdump_private.check_parent(); 

COMMIT;
