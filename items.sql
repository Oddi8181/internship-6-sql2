INSERT INTO match_type (match_type_name, match_type_description)
VALUES
('group', 'Group stage'),
('quarterfinal', 'Quarterfinal'),
('semifinal', 'Semifinal'),
('final', 'Final');

INSERT INTO tournament (tournament_name, tournament_year, tournament_location)
SELECT
    'Tournament ' || gs,
    2005 + (gs % 20),
    'City ' || (gs % 30)
FROM generate_series(1, 20) gs;




INSERT INTO team (team_name, country, representetive_name)
SELECT
    'Team ' || gs,
    'Country ' || (gs % 50),
    'Representative ' || gs
FROM generate_series(1, 1000) gs;




INSERT INTO player (first_name, last_name, date_of_birth, position, team_id)
SELECT
    'First' || p,
    'Last' || p,
    DATE '1980-01-01' + (p % 8000),
    CASE (p % 4)
        WHEN 0 THEN 'GK'
        WHEN 1 THEN 'DF'
        WHEN 2 THEN 'MF'
        ELSE 'FW'
    END,
    t.team_id
FROM team t
CROSS JOIN generate_series(1, 20) p;



INSERT INTO referee (first_name, last_name, date_of_birth, nationality)
SELECT
    'RefFirst' || gs,
    'RefLast' || gs,
    DATE '1960-01-01' + (gs % 15000),
    'Country ' || (gs % 40)
FROM generate_series(1, 200) gs;




INSERT INTO tournament_team (tournament_id, team_id, points, goal_difference, stage_reached)
SELECT
    tr.tournament_id,
    tm.team_id,
    0,
    0,
    'group'
FROM tournament tr
JOIN LATERAL (
    SELECT team_id
    FROM team
    ORDER BY random()
    LIMIT 32
) tm ON true;




WITH ranked_teams AS (
    SELECT
        tt.tournament_id,
        tt.team_id,
        ROW_NUMBER() OVER (PARTITION BY tt.tournament_id ORDER BY random()) rn
    FROM tournament_team tt
)
INSERT INTO match_tbl (
    tournament_id,
    match_type_id,
    referee_id,
    team_home_id,
    team_away_id,
    match_date,
    match_time,
    home_score,
    away_score
)
SELECT
    r1.tournament_id,
    (SELECT match_type_id FROM match_type ORDER BY random() LIMIT 1),
    (SELECT referee_id FROM referee ORDER BY random() LIMIT 1),
    r1.team_id,
    r2.team_id,
    DATE '2024-01-01' + (random() * 300)::INT,
    TIME '12:00' + (random() * INTERVAL '8 hours'),
    (random() * 5)::INT,
    (random() * 5)::INT
FROM ranked_teams r1
JOIN ranked_teams r2
  ON r1.tournament_id = r2.tournament_id
 AND r1.rn % 2 = 1
 AND r2.rn = r1.rn + 1;



INSERT INTO match_event (match_id, player_id, event_type, event_minute)
SELECT
    m.match_id,
    p.player_id,
    CASE (gs % 3)
        WHEN 0 THEN 'goal'
        WHEN 1 THEN 'yellow_card'
        ELSE 'red_card'
    END,
    (random() * 90)::INT
FROM match_tbl m
JOIN LATERAL (
    SELECT player_id
    FROM player
    ORDER BY random()
    LIMIT 3
) p ON true
JOIN generate_series(1, 3) gs ON true;



INSERT INTO match_tbl (
    tournament_id,
    match_type_id,
    referee_id,
    team_home_id,
    team_away_id,
    match_date,
    match_time,
    home_score,
    away_score
)
SELECT
    tt.tournament_id,
    (SELECT match_type_id FROM match_type WHERE match_type_name = 'final'),
    (SELECT referee_id FROM referee ORDER BY random() LIMIT 1),
    MIN(tt.team_id),
    MAX(tt.team_id),
    DATE '2024-12-01',
    TIME '18:00',
    2,
    1
FROM tournament_team tt
GROUP BY tt.tournament_id;
