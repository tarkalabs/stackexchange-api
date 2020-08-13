-- Verify stackdump:roles on pg

BEGIN;
DO $$
    BEGIN
        ASSERT(SELECT 1 FROM pg_roles WHERE rolname='user_anon'), 'Role user_anon does not exist.';
        ASSERT(SELECT 1 FROM pg_roles WHERE rolname='user_reg'), 'Role user_reg does not exist.';
        ASSERT(SELECT 1 FROM pg_roles WHERE rolname='user_super'), 'Role user_super does not exist.';
    END;
$$ LANGUAGE PLPGSQL;
ROLLBACK;
