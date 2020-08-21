-- Deploy stackexchange_api:votes/vote_triggers to pg
-- requires: schema/appschema
-- requires: posts/posts
-- requires: users/users

BEGIN;

CREATE FUNCTION stackdump_private.vote_create_trigger() RETURNS TRIGGER AS $$
    BEGIN
        SET ROLE user_super;
        IF new.voteTypeId = 1 THEN 
            UPDATE stackdump.posts SET acceptedAnswerId = new.postId
                WHERE posts.id = (SELECT parentId FROM stackdump.posts WHERE posts.id = new.postId);
            UPDATE stackdump.users SET reputation = reputation + 15
                WHERE users.id = (SELECT ownerUserId FROM stackdump.posts WHERE posts.id = new.postId) AND
                    users.id != current_setting('jwt.claims.user_id')::int;
            UPDATE stackdump.users SET reputation = reputation + 2
                WHERE users.id = current_setting('jwt.claims.user_id')::int AND
                    users.id != (SELECT ownerUserId FROM stackdump.posts WHERE posts.id = new.postId);
        ELSIF new.voteTypeId = 2 THEN
            UPDATE stackdump.users SET upVotes = upVotes + 1, reputation = reputation + 10
                WHERE users.id = (SELECT ownerUserId FROM stackdump.posts WHERE posts.id = new.postId);
            UPDATE stackdump.posts SET score = score + 1
                WHERE posts.id = new.postId;
        ELSIF new.voteTypeId = 3 THEN
            UPDATE stackdump.users SET downVotes = downVotes + 1, reputation = reputation - 2
                WHERE users.id = (SELECT ownerUserId FROM stackdump.posts WHERE posts.id = new.postId);
            UPDATE stackdump.users SET reputation = reputation - 1
                WHERE users.id = current_setting('jwt.claims.user_id')::int;
            UPDATE stackdump.posts SET score = score - 1
                WHERE posts.id = new.postId;
        ELSIF new.voteTypeId = 5 THEN
            UPDATE stackdump.posts SET favoriteCount = favoriteCount + 1
                WHERE posts.id = new.postId;
        END IF;
        RESET ROLE;
        RETURN new;
    END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER vote_on_create AFTER INSERT
    ON stackdump.votes
    FOR EACH ROW
    EXECUTE PROCEDURE stackdump_private.vote_create_trigger();

CREATE FUNCTION stackdump_private.vote_delete_trigger() RETURNS TRIGGER AS $$
    BEGIN
        SET ROLE user_super;
        IF old.voteTypeId = 1 THEN 
            UPDATE stackdump.posts SET acceptedAnswerId = NULL
                WHERE posts.id = old.postId;
            UPDATE stackdump.users SET reputation = reputation - 15
                WHERE users.id = (SELECT ownerUserId FROM stackdump.posts WHERE posts.id = old.postId) AND
                    users.id != current_setting('jwt.claims.user_id')::int;
            UPDATE stackdump.users SET reputation = reputation - 2
                WHERE users.id = current_setting('jwt.claims.user_id')::int AND
                    users.id != (SELECT ownerUserId FROM stackdump.posts WHERE posts.id = old.postId);
        ELSIF old.voteTypeId = 2 THEN
            UPDATE stackdump.users SET upVotes = upVotes - 1, reputation = reputation - 10
                WHERE users.id = (SELECT ownerUserId FROM stackdump.posts WHERE posts.id = old.postId);
            UPDATE stackdump.posts SET score = score - 1
                WHERE posts.id = old.postId;
        ELSIF old.voteTypeId = 3 THEN
            UPDATE stackdump.users SET downVotes = downVotes - 1, reputation = reputation + 10
                WHERE users.id = (SELECT ownerUserId FROM stackdump.posts WHERE posts.id = old.postId);
            UPDATE stackdump.users SET reputation = reputation + 1
                WHERE users.id = current_setting('jwt.claims.user_id')::int;
            UPDATE stackdump.posts SET score = score + 1
                WHERE posts.id = old.postId;
        ELSIF old.voteTypeId = 5 THEN
            UPDATE stackdump.posts SET favoriteCount = favoriteCount - 1
                WHERE posts.id = old.postId;
        END IF;
        RESET ROLE;
        RETURN old;
    END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER vote_on_delete BEFORE DELETE
    ON stackdump.votes
    FOR EACH ROW
    EXECUTE PROCEDURE stackdump_private.vote_delete_trigger();

CREATE OR REPLACE FUNCTION stackdump_private.check_votes() RETURNS trigger AS $$
DECLARE
    votenum INTEGER;
    usrid INTEGER;
BEGIN
    SELECT COUNT(*) INTO votenum FROM stackdump.votes 
    WHERE postId = NEW.postId AND userId = current_setting('jwt.claims.user_id')::int;
    IF votenum != 0 THEN
        RAISE EXCEPTION 'Duplicate votes not allowed.';
    END IF;
    IF NEW.voteTypeId = 1 THEN
        SELECT owneruserid INTO usrid FROM stackdump.posts WHERE id = (SELECT parentId FROM stackdump.posts WHERE id = NEW.postId);
        IF usrid != current_setting('jwt.claims.user_id')::int THEN
            RAISE EXCEPTION 'Only question owner can vote for answer.';
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER before_vote_insert BEFORE INSERT ON stackdump.votes FOR EACH ROW EXECUTE PROCEDURE stackdump_private.check_votes(); 

COMMIT;
