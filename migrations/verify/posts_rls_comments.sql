-- Verify stackdump:posts_rls_comments on pg

BEGIN;

DO $$
    BEGIN
        ASSERT LENGTH((SELECT col_description((SELECT 'stackdump.posts'::regclass::oid), 1)))::boolean, 'Posts id smart comment not created.';
        ASSERT LENGTH((SELECT col_description((SELECT 'stackdump.posts'::regclass::oid), 3)))::boolean, 'Posts acceptedAnswerId smart comment not created.';
        ASSERT LENGTH((SELECT col_description((SELECT 'stackdump.posts'::regclass::oid), 5)))::boolean, 'Posts creationDate smart comment not created.';
        ASSERT LENGTH((SELECT col_description((SELECT 'stackdump.posts'::regclass::oid), 6)))::boolean, 'Posts score smart comment not created.';
        ASSERT LENGTH((SELECT col_description((SELECT 'stackdump.posts'::regclass::oid), 7)))::boolean, 'Posts viewCount smart comment not created.';
        ASSERT LENGTH((SELECT col_description((SELECT 'stackdump.posts'::regclass::oid), 9)))::boolean, 'Posts ownerUserId smart comment not created.';
        ASSERT LENGTH((SELECT col_description((SELECT 'stackdump.posts'::regclass::oid), 10)))::boolean, 'Posts ownerDisplayName smart comment not created.';
        ASSERT LENGTH((SELECT col_description((SELECT 'stackdump.posts'::regclass::oid), 11)))::boolean, 'Posts lastEditorUserId smart comment not created.';
        ASSERT LENGTH((SELECT col_description((SELECT 'stackdump.posts'::regclass::oid), 12)))::boolean, 'Posts lastEditDate smart comment not created.';
        ASSERT LENGTH((SELECT col_description((SELECT 'stackdump.posts'::regclass::oid), 13)))::boolean, 'Posts lastActivityDate smart comment not created.';
        ASSERT LENGTH((SELECT col_description((SELECT 'stackdump.posts'::regclass::oid), 16)))::boolean, 'Posts answerCount smart comment not created.';
        ASSERT LENGTH((SELECT col_description((SELECT 'stackdump.posts'::regclass::oid), 17)))::boolean, 'Posts commentCount smart comment not created.';
        ASSERT LENGTH((SELECT col_description((SELECT 'stackdump.posts'::regclass::oid), 18)))::boolean, 'Posts favoriteCount smart comment not created.';

        ASSERT(SELECT relrowsecurity FROM pg_class WHERE oid = (SELECT 'stackdump.posts'::regclass::oid));

        ASSERT(SELECT 1 FROM pg_policies WHERE policyname='policy_update_posts');
        ASSERT(SELECT 1 FROM pg_policies WHERE policyname='policy_delete_posts');
        ASSERT(SELECT 1 FROM pg_policies WHERE policyname='policy_select_posts');
        ASSERT(SELECT 1 FROM pg_policies WHERE policyname='policy_insert_posts');
    END;
$$ LANGUAGE PLPGSQL;

ROLLBACK;
