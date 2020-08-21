-- Verify stackexchange_api:data/dataRows on pg

BEGIN;

DO $$
    BEGIN
        ASSERT(SELECT (SELECT COUNT(*) FROM stackdump_private.accounts) > 0), 'No rows added to accounts table.';
        ASSERT(SELECT (SELECT COUNT(*) FROM stackdump.users) > 0), 'No rows added to users table.';
        ASSERT(SELECT (SELECT COUNT(*) FROM stackdump.badges) > 0), 'No rows added to badges table.';
        ASSERT(SELECT (SELECT COUNT(*) FROM stackdump.posts) > 0), 'No rows added to posts table.';
        ASSERT(SELECT (SELECT COUNT(*) FROM stackdump.comments) > 0), 'No rows added to comments table.';
        ASSERT(SELECT (SELECT COUNT(*) FROM stackdump.tags) > 0), 'No rows added to tags table.';
        ASSERT(SELECT (SELECT COUNT(*) FROM stackdump.postHistory) > 0), 'No rows added to postHistory table.';
        ASSERT(SELECT (SELECT COUNT(*) FROM stackdump.postLinks) > 0), 'No rows added to postLinks table.';
        ASSERT(SELECT (SELECT COUNT(*) FROM stackdump.votes) > 0), 'No rows added to votes table.';
        ASSERT(SELECT (SELECT COUNT(*) FROM stackdump.posts WHERE acceptedAnswerId IS NOT NULL) > 0), 'No acceptedAnswerIds added to posts table.';
    END;
$$ LANGUAGE PLPGSQL;

ROLLBACK;
