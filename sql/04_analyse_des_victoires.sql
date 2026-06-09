-- Comparaison des stats de combat en cas de victoire et défaite
SELECT 
	CASE WHEN result = 1 THEN 'KC Won'
		ELSE 'KC Lost'
	END	AS match_result,
	ROUND(AVG(teamkills), 1) AS avg_team_kills,
	ROUND(AVG(teamdeaths), 1) AS avg_team_deaths
FROM lol_matches_2025
WHERE teamname = 'Karmine Corp' AND position = 'team' AND league = 'LEC'
GROUP BY match_result;

-- Comparaison de l'économie de l'équipe en cas de victoire et défaite
SELECT
	CASE WHEN result = 1 THEN 'KC Won'
		ELSE 'KC Lost'
	END	AS match_result,
	ROUND(AVG(totalgold)) AS avg_total_gold,
	ROUND(AVG("earned gpm")) AS avg_gpm
FROM lol_matches_2025
WHERE teamname = 'Karmine Corp' AND position = 'team' AND league = 'LEC'
GROUP BY match_result;

-- Comparaison des objectifs réalisés en cas de victoire et défaite
SELECT
	CASE WHEN result = 1 THEN 'KC Won'
		ELSE 'KC Lost'
	END	AS match_result,
	ROUND(AVG(towers), 1) AS avg_towers_destroyed,
	ROUND(AVG(dragons), 1) AS avg_dragons_killed,
	ROUND(AVG(void_grubs), 1) AS avg_void_grubs_killed,
	ROUND(AVG(heralds), 1) AS avg_heralds_killed,
	ROUND(AVG(barons), 1) AS avg_barons_killed
FROM lol_matches_2025
WHERE teamname = 'Karmine Corp' AND position = 'team' AND league = 'LEC'
GROUP BY match_result;

-- Comparaison de temps de game en cas de victoire et défaite
SELECT 
	CASE WHEN RESULT = 1 THEN  'KC Won'
		ELSE 'KC Lost'
	END AS match_result,
	CONCAT(ROUND(AVG(gamelength / 60), 1), ' min') AS avg_gamelength
FROM lol_matches_2025
WHERE teamname = 'Karmine Corp' AND position = 'team' AND league = 'LEC'
GROUP BY match_result;
