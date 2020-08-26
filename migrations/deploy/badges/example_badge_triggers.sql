-- Deploy stackexchange_api:badges/example_badge_triggers to pg
-- requires: badges/badges
-- requires: users/users
-- requires: schema/appschema

BEGIN;

CREATE FUNCTION stackdump_private.autobio_badge() RETURNS TRIGGER AS $$
    BEGIN
        SET ROLE user_super;
        IF old.aboutMe IS NULL AND 
        ((SELECT COUNT(*) FROM stackdump.badges WHERE badges.userId = old.id AND badges.name = 'Autobiographer') = 0) THEN
            INSERT INTO stackdump.badges(userId, name, class, tagBased) VALUES (current_setting('jwt.claims.user_id')::int, 'Autobiographer', 3, FALSE);
        END IF;
        RETURN new;
        RESET ROLE;
    END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER autobio_check BEFORE UPDATE
    OF aboutMe ON stackdump.users
    FOR EACH ROW
    EXECUTE PROCEDURE stackdump_private.autobio_badge();

COMMIT;
