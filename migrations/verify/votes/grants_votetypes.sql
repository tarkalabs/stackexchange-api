-- Verify stackexchange_api:votes/grants_votetypes on pg

BEGIN;

DO $$
    BEGIN
        ASSERT(SELECT has_table_privilege('user_reg','stackdump.votetypes','select')), 'User_reg was not given permission to select voteTypes.';
        ASSERT(SELECT has_table_privilege('user_anon','stackdump.votetypes','select')), 'User_anon was not given permission to select voteTypes.';
    END;
$$ LANGUAGE PLPGSQL;

ROLLBACK;
