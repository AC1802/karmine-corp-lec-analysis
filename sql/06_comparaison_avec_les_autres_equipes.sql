-- Classement des équipes LEC par winrate
SELECT RANK() OVER (
	ORDER BY ROUND(AVG(result) * 100, 1) DESC
),
teamname,
COUNT(CASE WHEN result = 1 THEN 1 END) AS victories,
COUNT(gameid) AS matches,
ROUND(AVG(result) * 100, 1) AS winrate_percent
FROM lol_matches_2025
WHERE league = 'LEC' AND position = 'team'
GROUP BY teamname;

-- Classement des équipes LEC par kills moyens
SELECT RANK() OVER (
	ORDER BY ROUND(AVG(teamkills), 1) DESC
),
teamname,
ROUND(AVG(teamkills), 1) AS avg_teamkills
FROM lol_matches_2025
WHERE league = 'LEC' AND position = 'team'
GROUP BY teamname;

-- Classement des équipes LEC par gold moyen.
SELECT RANK() OVER (
	ORDER BY ROUND(AVG(totalgold)) DESC
),
teamname,
ROUND(AVG(totalgold)) AS avg_totalgold
FROM lol_matches_2025
WHERE league = 'LEC' AND position = 'team'
GROUP BY teamname;

-- Classement des équipes LEC par dégâts moyens.
SELECT RANK() OVER (
	ORDER BY ROUND(AVG(damagetochampions)) DESC
),
teamname,
ROUND(AVG(damagetochampions)) AS avg_total_damage
FROM lol_matches_2025
WHERE league = 'LEC' AND position = 'team'
GROUP BY teamname;

-- Classement des équipes LEC par durée moyenne des parties.
SELECT RANK() OVER (
	ORDER BY ROUND(AVG(gamelength)) ASC
),
teamname,
ROUND(AVG(gamelength) / 60, 1) AS avg_gamelength_in_minutes
FROM lol_matches_2025
WHERE league = 'LEC' AND position = 'team'
GROUP BY teamname;



-- Synthèse finale, utiliser CTE des requêtes précédentes
WITH winrate AS (
	SELECT RANK() OVER (
	ORDER BY ROUND(AVG(result) * 100, 1) DESC
	) AS winrate_rank,
	teamname,
	COUNT(CASE WHEN result = 1 THEN 1 END) AS victories,
	COUNT(gameid) AS matches,
	ROUND(AVG(result) * 100, 1) AS winrate_percent
	FROM lol_matches_2025
	WHERE league = 'LEC' AND position = 'team'
	GROUP BY teamname
),
kills AS (
	SELECT RANK() OVER (
	ORDER BY ROUND(AVG(teamkills), 1) DESC
	) AS kills_rank,
teamname,
ROUND(AVG(teamkills), 1) AS avg_teamkills
FROM lol_matches_2025
WHERE league = 'LEC' AND position = 'team'
GROUP BY teamname
),
golds AS (
		SELECT RANK() OVER (
		ORDER BY ROUND(AVG(totalgold)) DESC
	) AS golds_rank,
	teamname,
	ROUND(AVG(totalgold)) AS avg_totalgold
	FROM lol_matches_2025
	WHERE league = 'LEC' AND position = 'team'
	GROUP BY teamname
),
damages AS (
		SELECT RANK() OVER (
		ORDER BY ROUND(AVG(damagetochampions)) DESC
	) AS damages_rank,
	teamname,
	ROUND(AVG(damagetochampions)) AS avg_total_damage
	FROM lol_matches_2025
	WHERE league = 'LEC' AND position = 'team'
	GROUP BY teamname
),
gamelength AS (
		SELECT RANK() OVER (
		ORDER BY ROUND(AVG(gamelength)) ASC
	) AS gamelength_rank,
	teamname,
	ROUND(AVG(gamelength) / 60, 1) AS avg_gamelength_in_minutes
	FROM lol_matches_2025
	WHERE league = 'LEC' AND position = 'team'
	GROUP BY teamname
)
SELECT 'winrate' AS stats, winrate_rank AS kc_rank
FROM winrate
WHERE teamname = 'Karmine Corp'
UNION ALL
SELECT 'kills', kills_rank
FROM kills
WHERE teamname = 'Karmine Corp'
UNION ALL
SELECT 'golds', golds_rank 
FROM golds
WHERE teamname = 'Karmine Corp'
UNION ALL
SELECT 'damages', damages_rank 
FROM damages 
WHERE teamname = 'Karmine Corp'
UNION ALL
SELECT 'gamelength', gamelength_rank 
FROM gamelength
WHERE teamname = 'Karmine Corp';

