-- Verify stackexchange_api:schema/roles on pg

BEGIN;
DO $$
    BEGIN
        ASSERT(SELECT 1 FROM pg_roles WHERE rolname='user_anon'), 'Role user_anon was not created.';
        ASSERT(SELECT 1 FROM pg_roles WHERE rolname='user_reg'), 'Role user_reg was not created.';
        ASSERT(SELECT 1 FROM pg_roles WHERE rolname='user_super'), 'Role user_super was not created.';
    END;
$$ LANGUAGE PLPGSQL;
ROLLBACK;
