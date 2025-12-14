CREATE OR REPLACE FUNCTION set_tournament_winner()
RETURNS TRIGGER AS $$
DECLARE
    final_match_type_id BIGINT;
BEGIN
    SELECT match_type_id    
    INTO final_match_type_id
    FROM match_type
    WHERE match_type_name = 'final';

    IF NEW.match_type_id = final_match_type_id
        AND NEW.home_score IS NOT NULL
        AND NEW.away_score IS NOT NULL THEN

            IF NEW.home_score > NEW.away_score THEN
                UPDATE tournament
                SET winner_team_id = NEW.team_home_id
                WHERE tournament_id = NEW.tournament_id;
            ELSEIF NEW.away_score > NEW.home_score THEN
                UPDATE tournament
                SET winner_team_id = NEW.team_away_id
                WHERE tournament_id = NEW.tournament_id;
            END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_set_tournament_winner
AFTER INSERT OR UPDATE OF home_score, away_score
ON match_tbl
FOR EACH ROW
EXECUTE FUNCTION set_tournament_winner();


CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_team_updated
BEFORE UPDATE ON team
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_tournament_updated
BEFORE UPDATE ON tournament
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_player_updated
BEFORE UPDATE ON player
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_tournament_team_updated
BEFORE UPDATE ON tournament_team
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_match_type_updated
BEFORE UPDATE ON match_type
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_referee_updated
BEFORE UPDATE ON referee
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_match_updated
BEFORE UPDATE ON match_tbl
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_match_event_updated
BEFORE UPDATE ON match_event
FOR EACH ROW EXECUTE FUNCTION set_updated_at();
