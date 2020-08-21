-- Verify stackexchange_api:votes/votes_rls_comments on pg

BEGIN;

DO $$
    BEGIN
        ASSERT LENGTH((SELECT col_description((SELECT 'stackdump.votes'::regclass::oid), 1)))::boolean, 'Votes id smart comment not created.';
        ASSERT LENGTH((SELECT col_description((SELECT 'stackdump.votes'::regclass::oid), 4)))::boolean, 'Votes userId smart comment not created.';
        ASSERT LENGTH((SELECT col_description((SELECT 'stackdump.votes'::regclass::oid), 5)))::boolean, 'Votes creationDate smart comment not created.';
        ASSERT LENGTH((SELECT col_description((SELECT 'stackdump.votes'::regclass::oid), 6)))::boolean, 'Votes bountyAmount smart comment not created.';
    END;
$$ LANGUAGE PLPGSQL;

ROLLBACK;
