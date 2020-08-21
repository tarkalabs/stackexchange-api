-- Verify stackexchange_api:votes/grants_votes on pg

BEGIN;

DO $$
    BEGIN
        ASSERT(SELECT has_table_privilege('user_anon','stackdump.votes','select')), 'User_anon was not given permission to select votes.';
        ASSERT(SELECT has_table_privilege('user_reg','stackdump.votes','select')), 'User_reg was not given permission to select votes.';
        ASSERT(SELECT has_table_privilege('user_reg','stackdump.votes','insert')), 'User_reg was not given permission to insert votes.';
        ASSERT(SELECT has_table_privilege('user_reg','stackdump.votes','delete')), 'User_reg was not given permission to delete votes.';
        ASSERT(SELECT 1 FROM information_schema.usage_privileges WHERE grantee='user_reg' AND object_name='votes_id_seq'), 'User_reg was not granted usage of sequence votes_id_seq.';
        ASSERT(SELECT array_to_string((SELECT relacl FROM pg_class WHERE relname='votes_id_seq'), ',') ~ '.*user_reg=r.*'), 'User_reg was not granted select privileges on sequence votes_id_seq';
    END;
$$ LANGUAGE PLPGSQL;

ROLLBACK;
