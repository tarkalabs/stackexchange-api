-- Deploy stackdump:count_triggers to pg
-- requires: appschema
-- requires: comments
-- requires: posts
-- requires: users
-- requires: votes

BEGIN;

--triggers on comments

CREATE FUNCTION stackdump_private.inc_commentCount() RETURNS TRIGGER AS $$
    BEGIN
        UPDATE stackdump.posts SET commentCount = commentCount + 1
            WHERE posts.id = new.postId;
        RETURN new;
    END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER comment_count_increment AFTER INSERT
    ON stackdump.comments
    FOR EACH ROW
    EXECUTE PROCEDURE stackdump_private.inc_commentCount();

CREATE FUNCTION stackdump_private.dec_commentCount() RETURNS TRIGGER AS $$
    BEGIN
        UPDATE stackdump.posts SET commentCount = commentCount - 1
            WHERE posts.id = old.postId;
        RETURN old;
    END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER comment_count_decrement BEFORE DELETE
    ON stackdump.comments
    FOR EACH ROW
    EXECUTE PROCEDURE stackdump_private.dec_commentCount();

--triggers on posts

CREATE FUNCTION stackdump_private.post_create_trigger() RETURNS TRIGGER AS $$
    DECLARE
        i INTEGER;
    BEGIN
        UPDATE stackdump.posts SET answerCount = answerCount + 1
            WHERE posts.id = new.parentId;
        INSERT INTO stackdump.postHistory(postHistoryTypeId, postId, revisionGUID, userId, text)
            VALUES (1, new.id, extensions.uuid_generate_v4(), new.ownerUserId, new.title);
        INSERT INTO stackdump.postHistory(postHistoryTypeId, postId, revisionGUID, userId, text)
            VALUES (2, new.id, extensions.uuid_generate_v4(), new.ownerUserId, new.body);
        INSERT INTO stackdump.postHistory(postHistoryTypeId, postId, revisionGUID, userId, text)
            VALUES (3, new.id, extensions.uuid_generate_v4(), new.ownerUserId, ARRAY_TO_STRING(new.tags, ' '));
        FOR i IN 1 .. array_upper(new.tags, 1)
        LOOP
            UPDATE stackdump.tags SET count = count + 1 WHERE tagName = new.tags[i];
        END LOOP;
        
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
        INSERT INTO stackdump.postHistory(postHistoryTypeId, postId, revisionGUID, userId)
            VALUES (12, old.id, extensions.uuid_generate_v4(), old.ownerUserId);
        FOR i IN 1 .. array_upper(old.tags, 1)
        LOOP
            UPDATE stackdump.tags SET count = count - 1 WHERE tagName = old.tags[i];
        END LOOP;
        RETURN old;
    END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER post_on_delete BEFORE DELETE
    ON stackdump.posts
    FOR EACH ROW
    EXECUTE PROCEDURE stackdump_private.post_delete_trigger();

--vote triggers

CREATE FUNCTION stackdump_private.vote_create_trigger() RETURNS TRIGGER AS $$
    BEGIN
        IF new.voteTypeId = 1 THEN 
            UPDATE stackdump.posts SET acceptedAnswerId = new.postId
                WHERE posts.id = (SELECT parentId FROM stackdump.posts WHERE posts.id = new.postId);
        ELSIF new.voteTypeId = 2 THEN
            UPDATE stackdump.users SET upVotes = upVotes + 1
                WHERE users.id = new.userId;
            UPDATE stackdump.posts SET score = score + 1
                WHERE posts.id = new.postId;
        ELSIF new.voteTypeId = 3 THEN
            UPDATE stackdump.users SET downVotes = downVotes + 1
                WHERE users.id = new.userId;
            UPDATE stackdump.posts SET score = score - 1
                WHERE posts.id = new.postId;
        ELSIF new.voteTypeId = 5 THEN
            UPDATE stackdump.posts SET favoriteCount = favoriteCount + 1
                WHERE posts.id = new.postId;
        END IF;
        RETURN new;
    END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER vote_on_create AFTER INSERT
    ON stackdump.votes
    FOR EACH ROW
    EXECUTE PROCEDURE stackdump_private.vote_create_trigger();

CREATE FUNCTION stackdump_private.vote_delete_trigger() RETURNS TRIGGER AS $$
    BEGIN
        IF old.voteTypeId = 1 THEN 
            UPDATE stackdump.posts SET acceptedAnswerId = NULL
                WHERE posts.id = old.postId;
        ELSIF old.voteTypeId = 2 THEN
            UPDATE stackdump.users SET upVotes = upVotes - 1
                WHERE users.id = old.userId;
            UPDATE stackdump.posts SET score = score - 1
                WHERE posts.id = old.postId;
        ELSIF old.voteTypeId = 3 THEN
            UPDATE stackdump.users SET downVotes = downVotes - 1
                WHERE users.id = old.userId;
            UPDATE stackdump.posts SET score = score + 1
                WHERE posts.id = old.postId;
        ELSIF old.voteTypeId = 5 THEN
            UPDATE stackdump.posts SET favoriteCount = favoriteCount - 1
                WHERE posts.id = old.postId;
        END IF;
        RETURN old;
    END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER vote_on_delete BEFORE DELETE
    ON stackdump.votes
    FOR EACH ROW
    EXECUTE PROCEDURE stackdump_private.vote_delete_trigger();

COMMIT;
