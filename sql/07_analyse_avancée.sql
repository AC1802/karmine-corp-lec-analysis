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
WITH kc_opponents_players AS (
	SELECT l1.gameid AS games_played, 
	l1.teamname, 
	l2.teamname AS opponent, 
	l2.playername AS opponent_players, 
	l2.kills AS kills, 
	l2.deaths  AS deaths, 
	l2.assists AS assists, 
	l2.damagetochampions AS damages,
	l2.totalgold  AS golds,
	l2.teamkills AS teamkills,
	CASE
	   	WHEN l2.deaths = 0 THEN l2.kills + l2.assists
	    ELSE (l2.kills + l2.assists) * 1.0 / l2.deaths
	END AS kda_not_null
	FROM lol_matches_2025 l1
	JOIN lol_matches_2025 l2
	ON l1.gameid = l2.gameid AND l1.teamname != l2.teamname
	WHERE l1.league = 'LEC' AND l1.position = 'team' AND l2.position != 'team' AND l1.teamname = 'Karmine Corp'
),
kc_opponents_players_agg AS (
	SELECT opponent_players, 
	COUNT(games_played) AS games_played, 
	RANK() OVER(ORDER BY ROUND(AVG(damages)) DESC) AS avg_damages,
	RANK() OVER(ORDER BY ROUND(AVG(golds)) DESC) AS avg_golds,
	RANK() OVER(ORDER BY ROUND(AVG((kills + assists) * 100.0 / NULLIF(teamkills, 0)), 1) DESC) AS avg_kp_per_match_percent,
	RANK() OVER(ORDER BY ROUND(AVG(kda_not_null)) DESC) AS kda
	FROM kc_opponents_players
	GROUP BY opponent_players
	ORDER BY opponent_players ASC
)
SELECT opponent_players, 
	games_played, 
	avg_damages, 
	avg_golds, 
	avg_kp_per_match_percent, 
	kda,
	avg_damages + avg_golds + avg_kp_per_match_percent + kda AS global_ranking
FROM opponents_global_ranking
GROUP BY opponent_players, games_played
ORDER BY global_ranking ASC;

-- Classement des joueurs les plus performants contre la Karmine Corp
 





SELECT l1.gameid, l1.kills, l1.deaths, l1.assists,
	(l1.kills + l1.assists) * 1.0 / NULLIF(l1.deaths, 0) AS kda,
	CASE
	   	WHEN l1.deaths = 0 THEN l1.kills + l1.assists
	    ELSE (l1.kills + l1.assists) * 1.0 / l1.deaths
	END AS kda_not_null
FROM lol_matches_2025 l1
JOIN lol_matches_2025 l2
ON l1.gameid = l2.gameid AND l1.teamname != l2.teamname
WHERE l1.playername = 'Closer' AND l2.teamname = 'Karmine Corp' AND l2.position = 'team'
GROUP BY l1.gameid, l1.kills, l1.deaths, l1.assists;
/*
KC gagne-t-elle davantage avec des parties courtes ou longues ?
Quels sont les champions les plus joués ?
Quels champions sont associés au meilleur taux de victoire ? 
*/
