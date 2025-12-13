CREATE TABLE team (
    team_id BIGSERIAL PRIMARY KEY,
    team_name TEXT NOT NULL,
    country TEXT,
    representetive_name TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL
);

CREATE TABLE tournament (
    tournament_id BIGSERIAL PRIMARY KEY,
    tournament_name TEXT NOT NULL,
    tournament_year INTEGER NOT NULL,
    tournament_location TEXT,
    winner_team_id BIGINT REFERENCES team(team_id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL
);

CREATE TABLE player (
    player_id BIGSERIAL PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    date_of_birth DATE,
    position TEXT,
    team_id BIGINT NOT NULL REFERENCES team(team_id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL
);

CREATE TABLE tournament_team (
    tournament_team_id BIGSERIAL PRIMARY KEY,
    team_id BIGINT NOT NULL REFERENCES team(team_id) ON DELETE CASCADE,
    tournament_id BIGINT NOT NULL REFERENCES tournament(tournament_id) ON DELETE CASCADE,
    rankings INTEGER,
    points INTEGER DEFAULT 0,
    goal_difference INTEGER DEFAULT 0,
    stage_reached TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
    UNIQUE (tournament_id, team_id)
);

CREATE TABLE match_type (
    match_type_id BIGSERIAL PRIMARY KEY,
    match_type_name TEXT NOT NULL,
    match_type_description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL
);

CREATE TABLE referee (
    referee_id BIGSERIAL PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    date_of_birth DATE,
    nationality TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL
);

CREATE TABLE match_tbl (
    match_id BIGSERIAL PRIMARY KEY,
    tournament_id BIGINT NOT NULL REFERENCES tournament(tournament_id) ON DELETE CASCADE,
    match_type_id BIGINT NOT NULL REFERENCES match_type(match_type_id),
    referee_id BIGINT NOT NULL REFERENCES referee(referee_id) ON DELETE SET NULL,
    team_home_id BIGINT NOT NULL REFERENCES team(team_id),
    team_away_id BIGINT NOT NULL REFERENCES team(team_id),
    match_date DATE NOT NULL,
    match_time TIME WITH TIME ZONE,
    home_score INTEGER DEFAULT 0,
    away_score INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
    CHECK (team_home_id <> team_away_id)
);

CREATE TABLE match_event (
    match_event_id BIGSERIAL PRIMARY KEY,
    match_id BIGINT NOT NULL REFERENCES match_tbl(match_id) ON DELETE CASCADE,
    player_id REFERENCES player(player_id) ON DELETE SET NULL,
    event_type TEXT NOT NULL,
    event_minute INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL
);