SELECT 
    t.tournament_name,
    t.tournament_year,
    t.tournament_location,
    tm.team_name AS winner
FROM tournament t
LEFT JOIN team tm ON t.winner_team_id = tm.team_id;


SELECT
    tm.team_name,
    tm.representetive_name
FROM tournament_team tt 
JOIN team tm ON tt.team_id = tm.team_id 
WHERE tt.tournament_id = :tournament_id;

SELECT
    first_name,
    last_name,
    date_of_birth,
    position
FROM player
WHERE team_id = :team_id;


SELECT
    m.match_date,
    m.match_time,
    th.team_name AS home_team,
    ta.team_name AS away_team,
    mt.match_type_name,
    m.home_score,
    m.away_score
FROM match_tbl m
JOIN team th ON m.team_home_id = th.team_id
JOIN team ta ON m.team_away_id = ta.team_id
JOIN match_type mt ON m.match_type_id = mt.match_type_id
WHERE m.tournament_id = :tournament_id;



SELECT
    tr.tournament_name,
    m.match_date,
    mt.match_type_name,
    th.team_name AS home_team,
    ta.team_name AS away_team,
    m.home_score,
    m.away_score
FROM match_tbl m
JOIN tournament tr ON m.tournament_id = tr.tournament_id
JOIN match_type mt ON m.match_type_id = mt.match_type_id
JOIN team th ON m.team_home_id = th.team_id
JOIN team ta ON m.team_away_id = ta.team_id
WHERE :team_id IN (m.team_home_id, m.team_away_id);


SELECT
    me.event_type,
    p.first_name,
    p.last_name,
    me.event_minute
FROM match_event me
LEFT JOIN player p ON me.player_id = p.player_id
WHERE me.match_id = :match_id;


SELECT
    p.first_name,
    p.last_name,
    tm.team_name,
    me.event_minute,
    me.event_type
FROM match_event me
JOIN match_tbl m ON me.match_id = m.match_id
JOIN player p ON me.player_id = p.player_id
JOIN team tm ON p.team_id = tm.team_id
WHERE m.tournament_id = :tournament_id
  AND me.event_type IN ('yellow_card', 'red_card');



SELECT
    p.first_name,
    p.last_name,
    tm.team_name,
    COUNT(*) AS goals
FROM match_event me
JOIN match_tbl m ON me.match_id = m.match_id
JOIN player p ON me.player_id = p.player_id
JOIN team tm ON p.team_id = tm.team_id
WHERE m.tournament_id = :tournament_id
  AND me.event_type = 'goal'
GROUP BY p.first_name, p.last_name, tm.team_name
ORDER BY goals DESC;



SELECT
    tm.team_name,
    tt.points,
    tt.goal_difference,
    tt.rankings
FROM tournament_team tt
JOIN team tm ON tt.team_id = tm.team_id
WHERE tt.tournament_id = :tournament_id
ORDER BY tt.points DESC, tt.goal_difference DESC;



SELECT
    tr.tournament_name,
    m.match_date,
    th.team_name AS home_team,
    ta.team_name AS away_team,
    m.home_score,
    m.away_score,
    CASE
        WHEN m.home_score > m.away_score THEN th.team_name
        ELSE ta.team_name
    END AS winner
FROM match_tbl m
JOIN match_type mt ON m.match_type_id = mt.match_type_id
JOIN tournament tr ON m.tournament_id = tr.tournament_id
JOIN team th ON m.team_home_id = th.team_id
JOIN team ta ON m.team_away_id = ta.team_id
WHERE mt.match_type_name = 'final';



SELECT
    mt.match_type_name,
    COUNT(m.match_id) AS total_matches
FROM match_type mt
LEFT JOIN match_tbl m ON mt.match_type_id = m.match_type_id
GROUP BY mt.match_type_name;



SELECT
    mt.match_type_name,
    COUNT(m.match_id) AS total_matches
FROM match_type mt
LEFT JOIN match_tbl m ON mt.match_type_id = m.match_type_id
GROUP BY mt.match_type_name;



SELECT
    th.team_name AS home_team,
    ta.team_name AS away_team,
    mt.match_type_name,
    m.home_score,
    m.away_score
FROM match_tbl m
JOIN team th ON m.team_home_id = th.team_id
JOIN team ta ON m.team_away_id = ta.team_id
JOIN match_type mt ON m.match_type_id = mt.match_type_id
WHERE m.match_date = :date;



SELECT
    p.first_name,
    p.last_name,
    COUNT(*) AS goals
FROM match_event me
JOIN match_tbl m ON me.match_id = m.match_id
JOIN player p ON me.player_id = p.player_id
WHERE m.tournament_id = :tournament_id
  AND me.event_type = 'goal'
GROUP BY p.first_name, p.last_name
ORDER BY goals DESC;



SELECT
    tr.tournament_name,
    tr.tournament_year,
    tt.rankings
FROM tournament_team tt
JOIN tournament tr ON tt.tournament_id = tr.tournament_id
WHERE tt.team_id = :team_id;



SELECT
    tr.tournament_name,
    tr.tournament_year,
    tt.rankings
FROM tournament_team tt
JOIN tournament tr ON tt.tournament_id = tr.tournament_id
WHERE tt.team_id = :team_id;


SELECT
    tr.tournament_name,
    CASE
        WHEN m.home_score > m.away_score THEN th.team_name
        ELSE ta.team_name
    END AS winner
FROM match_tbl m
JOIN match_type mt ON m.match_type_id = mt.match_type_id
JOIN tournament tr ON m.tournament_id = tr.tournament_id
JOIN team th ON m.team_home_id = th.team_id
JOIN team ta ON m.team_away_id = ta.team_id
WHERE mt.match_type_name = 'final'
  AND tr.tournament_id = :tournament_id;


SELECT
    tr.tournament_name,
    COUNT(DISTINCT tt.team_id) AS teams,
    COUNT(p.player_id) AS players
FROM tournament tr
JOIN tournament_team tt ON tr.tournament_id = tt.tournament_id
JOIN player p ON p.team_id = tt.team_id
GROUP BY tr.tournament_name;


SELECT DISTINCT ON (tm.team_id)
    tm.team_name,
    p.first_name,
    p.last_name,
    COUNT(*) OVER (PARTITION BY p.player_id) AS goals
FROM match_event me
JOIN player p ON me.player_id = p.player_id
JOIN team tm ON p.team_id = tm.team_id
WHERE me.event_type = 'goal'
ORDER BY tm.team_id, goals DESC;


SELECT
    m.match_date,
    th.team_name AS home_team,
    ta.team_name AS away_team,
    m.home_score,
    m.away_score
FROM match_tbl m
JOIN team th ON m.team_home_id = th.team_id
JOIN team ta ON m.team_away_id = ta.team_id
WHERE m.referee_id = :referee_id;
