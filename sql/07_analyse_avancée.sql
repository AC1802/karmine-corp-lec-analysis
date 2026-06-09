-- Liste des matchs de la Karmine Corp
SELECT l1.gameid, l1.teamname, l2.teamname AS opponent,
	CASE l1.result WHEN 1 THEN 'KC won' ELSE 'KC lost' END
FROM lol_matches_2025 l1
JOIN lol_matches_2025 l2
ON l1.gameid = l2.gameid AND l1.teamname != l2.teamname
WHERE l1.league = 'LEC' AND l1.position = 'team' AND l1.teamname = 'Karmine Corp'
GROUP BY l1.gameid,  l1.teamname, l2.teamname, l1.result;

-- Equipe qui pose le plus de problème à la Karmine Corp
WITH kc_matches AS (
	SELECT l1.gameid AS games_played, l1.teamname AS teamname, l2.teamname AS opponent, l1.result AS result
	FROM lol_matches_2025 l1
	JOIN lol_matches_2025 l2
	ON l1.gameid = l2.gameid AND l1.teamname != l2.teamname
	WHERE l1.league = 'LEC' AND l1.position = 'team' AND l1.teamname = 'Karmine Corp'
	GROUP BY l1.gameid,  l1.teamname, l2.teamname, l1.result
)
SELECT opponent, COUNT(games_played) AS games_played, SUM(result) AS kc_victories, 
	COUNT(games_played) - SUM(result) AS kc_defeats,
	ROUND(AVG(result) * 100, 1) AS kc_winrate
FROM kc_matches
GROUP BY opponent
ORDER BY kc_winrate ASC;

-- Joueur qui pose le plus de problème à la Karmine Corp
WITH best_player_vs_kc AS (
	SELECT l1.gameid AS games_played, l1.teamname, l2.teamname AS opponent, l2.playername AS opponent_players, 
	l2.kills AS kills, l2.deaths  AS deaths, l2.assists AS assists, l2.damagetochampions AS damages
	FROM lol_matches_2025 l1
	JOIN lol_matches_2025 l2
	ON l1.gameid = l2.gameid AND l1.teamname != l2.teamname
	WHERE l1.league = 'LEC' AND l1.position = 'team' AND l2.position != 'team' AND l1.teamname = 'Karmine Corp'
)
SELECT opponent_players, COUNT(games_played), ROUND(AVG((kills + assists) * 1.0 / NULLIF(deaths, 0)), 1) AS avg_kda, 
FROM best_player_vs_kc;

/*
KC gagne-t-elle davantage avec des parties courtes ou longues ?
Quels sont les champions les plus joués ?
Quels champions sont associés au meilleur taux de victoire ? 
*/
