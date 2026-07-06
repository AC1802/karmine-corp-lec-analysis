-- Liste des matchs de la Karmine Corp
SELECT l1.gameid, 
	l1.teamname, 
	l2.teamname AS opponent,
	CASE l1.result WHEN 1 THEN 'KC won' ELSE 'KC lost' END
FROM lol_matches_2025 l1
JOIN lol_matches_2025 l2
ON l1.gameid = l2.gameid 
AND l1.teamname != l2.teamname
WHERE l1.league = 'LEC' 
	AND l1.position = 'team' 
	AND l1.teamname = 'Karmine Corp'
GROUP BY l1.gameid,  
	l1.teamname, 
	l2.teamname, 
	l1.result;

-- Equipe qui pose le plus de problème à la Karmine Corp
CREATE VIEW kc_toughest_opponents AS
WITH kc_matches AS (
	SELECT l1.gameid AS games_played, 
	l1.teamname AS teamname, 
	l2.teamname AS opponent, 
	l1.result AS result
	FROM lol_matches_2025 l1
	JOIN lol_matches_2025 l2
	ON l1.gameid = l2.gameid 
		AND l1.teamname != l2.teamname
	WHERE l1.league = 'LEC' 
		AND l1.position = 'team' 
		AND l1.teamname = 'Karmine Corp'
	GROUP BY l1.gameid,  l1.teamname, l2.teamname, l1.result
)
SELECT opponent, 
	COUNT(games_played) AS games_played, 
	SUM(result) AS kc_victories, 
	COUNT(games_played) - SUM(result) AS kc_defeats,
	ROUND(AVG(result) * 100, 1) AS kc_winrate
FROM kc_matches
GROUP BY opponent
ORDER BY kc_winrate ASC;

-- Joueur qui pose le plus de problème à la Karmine Corp en fonction des stats
CREATE VIEW kc_toughest_opponents_player AS
WITH kc_opponents_players AS (
    SELECT 
        l1.gameid AS games_played, 
        l1.teamname, 
        l2.teamname AS opponent, 
        l2.playername AS opponent_players, 
        l2.kills,
        l2.deaths,
        l2.assists,
        l2.damagetochampions AS damages,
        l2.totalgold AS golds,
        l2.teamkills,
        CASE
            WHEN l2.deaths = 0 THEN l2.kills + l2.assists
            ELSE (l2.kills + l2.assists) * 1.0 / l2.deaths
        END AS kda_not_null
    FROM lol_matches_2025 l1
    JOIN lol_matches_2025 l2
        ON l1.gameid = l2.gameid
        AND l1.teamname != l2.teamname
    WHERE l1.league = 'LEC'
      AND l1.position = 'team'
      AND l2.position != 'team'
      AND l1.teamname = 'Karmine Corp'
),
aggregated AS (
    SELECT
        opponent_players,
        COUNT(games_played) AS games_played,
        AVG(damages) AS avg_damages_raw,
        AVG(golds) AS avg_golds_raw,
        AVG((kills + assists) * 100.0 / NULLIF(teamkills, 0)) AS avg_kp_raw,
        AVG(kda_not_null) AS avg_kda_raw
    FROM kc_opponents_players
    GROUP BY opponent_players
    HAVING COUNT(games_played) > 5
),
ranked AS (
    SELECT
        *,
        RANK() OVER (ORDER BY avg_damages_raw DESC) AS avg_damages,
        RANK() OVER (ORDER BY avg_golds_raw DESC) AS avg_golds,
        RANK() OVER (ORDER BY avg_kp_raw DESC) AS avg_kp_per_match_percent,
        RANK() OVER (ORDER BY avg_kda_raw DESC) AS kda
    FROM aggregated
)
SELECT
    opponent_players,
    games_played,
    avg_damages,
    avg_golds,
    avg_kp_per_match_percent,
    kda,
    (avg_damages + avg_golds + avg_kp_per_match_percent + kda) AS global_ranking
FROM ranked
ORDER BY global_ranking ASC;



-- KC gagne-t-elle davantage avec des parties courtes ou longues ?
CREATE VIEW kc_gamelength AS
SELECT 
	CASE 
		WHEN gamelength / 60 < 30 THEN 'game under 30 min'
		WHEN gamelength / 60 > 30 AND gamelength / 60 < 35 THEN 'game between 30-35 min'
		ELSE 'game above 35 min'
	END AS game_type,
	COUNT(gameid) AS games_played,
	SUM(result) AS victories,
	ROUND(AVG(result) * 100) AS winrate
FROM lol_matches_2025
WHERE league = 'LEC'
	AND position = 'team'
	AND teamname = 'Karmine Corp'
GROUP BY game_type
ORDER BY game_type DESC;



-- Quels sont les champions les plus joués ?
CREATE VIEW kc_champion_pool AS
SELECT champion, 
	COUNT(gameid) AS games_played
FROM lol_matches_2025
WHERE position != 'team'
	AND league = 'LEC'
	AND teamname = 'Karmine Corp'
GROUP BY champion
ORDER BY games_played DESC;

-- Quels sont les champions les plus joués par rôle ?
CREATE VIEW kc_champion_pool_per_role AS
WITH champion_games_played_by_role AS (
	SELECT position,
	champion,
	COUNT(gameid) AS games_played
FROM lol_matches_2025
WHERE position != 'team'
	AND league = 'LEC'
	AND teamname = 'Karmine Corp'
GROUP BY position, 
	champion
),
max AS (
	SELECT position,
	MAX(games_played) AS max_games_played
	FROM champion_games_played_by_role
	GROUP BY position
)
SELECT c.position,
	c.champion,
	c.games_played
FROM champion_games_played_by_role c
JOIN max m
ON c.position = m.position 
	AND c.games_played  = m.max_games_played
GROUP BY c.position, 
	c.champion, 
	c.games_played
ORDER BY CASE
	WHEN c.position = 'top' THEN 1
	WHEN c.position = 'jng' THEN 2
	WHEN c.position = 'mid' THEN 3
	WHEN c.position = 'bot' THEN 4
	WHEN c.position = 'sup' THEN 5
END;

-- Quels champions KC joue-t-elle le plus souvent comparé à la LEC ?
WITH kc_matches AS (
	SELECT gameid,
		teamname,
		champion
	FROM  lol_matches_2025
	WHERE teamname = 'Karmine Corp'
		AND league = 'LEC'
		AND position != 'team'
),
lec_matches AS (
	SELECT gameid,
		teamname,
		champion
	FROM lol_matches_2025
	WHERE league = 'LEC'
		AND position != 'team'
),
kc_champion_pool AS (
	SELECT champion,
		COUNT(DISTINCT gameid) AS games_played
	FROM kc_matches
	GROUP BY champion
),
lec_champion_pool AS (
	SELECT champion,
		COUNT(DISTINCT gameid) AS games_played
	FROM lec_matches
	GROUP BY champion
),
kc_matches_count AS (
	SELECT COUNT(DISTINCT gameid) AS total_matches
	FROM kc_matches
),
lec_matches_count AS (
	SELECT COUNT(DISTINCT gameid) AS total_matches
	FROM lec_matches
),
kc_frequency AS (
	SELECT kcp.champion,
	kcp.games_played,
	kmc.total_matches,
	(kcp.games_played::numeric / kmc.total_matches) * 100 AS kc_frequency   
	FROM kc_champion_pool kcp
	CROSS JOIN kc_matches_count kmc
),
lec_frequency AS (
	SELECT lcp.champion,
	lcp.games_played,
	lmc.total_matches,
	(lcp.games_played::numeric / lmc.total_matches) * 100 AS lec_frequency   
	FROM lec_champion_pool lcp
	CROSS JOIN lec_matches_count lmc
)
SELECT kc.champion,
	kc.kc_frequency AS KC_frequency,
	lec.lec_frequency AS LEC_frequency,
	ROUND(kc.kc_frequency::numeric - lec.lec_frequency, 1) AS difference
FROM kc_frequency kc
JOIN lec_frequency lec
ON kc.champion = lec.champion
ORDER BY difference DESC;

-- Quels champions sont associés au meilleur taux de victoire ?
CREATE VIEW kc_champion_pool_winrate AS
SELECT champion, 
	COUNT(gameid) AS games_played,
	SUM(result) AS victories,
	ROUND(AVG(result), 1) * 100 AS winrate
FROM lol_matches_2025
WHERE teamname = 'Karmine Corp' 
	AND league = 'LEC' 
	AND position != 'team'
GROUP BY champion
HAVING COUNT(gameid) > 10
ORDER BY winrate DESC, 
	games_played DESC;