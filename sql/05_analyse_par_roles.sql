-- Statistiques moyennes des joueurs en LEC par rôle
SELECT position,  
	ROUND(AVG((kills + assists) * 1.0 / NULLIF(deaths, 0)), 1) AS avg_kda, 
	ROUND(AVG(totalgold)) AS avg_total_gold,
	ROUND(AVG(damagetochampions)) AS avg_total_damage,
	ROUND(AVG((kills + assists) * 100.0 / NULLIF(teamkills, 0)), 1) AS avg_kp_per_match_percent
FROM lol_matches_2025
WHERE league = 'LEC' AND position != 'team' AND teamname != 'Karmine Corp'
GROUP BY position
ORDER BY CASE position 
	WHEN 'top' THEN 1
	WHEN 'jng' THEN 2
	WHEN 'mid' THEN 3
	WHEN 'adc' THEN 4
	WHEN 'sup' THEN 5
END;

-- Statistiques moyennes des joueurs en LEC par rôle en cas de victoire et défaite
SELECT position,
	CASE "result" 
		WHEN 1 THEN 'Win'
		ELSE 'Loss'
	END AS match_result
	,
	ROUND(AVG((kills + assists) * 1.0 / NULLIF(deaths, 0)), 1) AS avg_kda, 
	ROUND(AVG(totalgold)) AS avg_total_gold,
	ROUND(AVG(damagetochampions)) AS avg_total_damage,
	ROUND(AVG((kills + assists) * 100.0 / NULLIF(teamkills, 0)), 1) AS avg_kp_per_match_percent
FROM lol_matches_2025
WHERE league = 'LEC' AND position != 'team' AND teamname != 'Karmine Corp'
GROUP BY position, result
ORDER BY CASE position 
	WHEN 'top' THEN 1
	WHEN 'jng' THEN 2
	WHEN 'mid' THEN 3
	WHEN 'adc' THEN 4
	WHEN 'sup' THEN 5
END,
result DESC;

-- Statistiques moyennes des joueurs de la Karmine Corp en LEC par rôle en cas de victoire et défaite
SELECT position,
	CASE "result" 
		WHEN 1 THEN 'Win'
		ELSE 'Loss'
	END AS match_result
	,
	ROUND(AVG((kills + assists) * 1.0 / NULLIF(deaths, 0)), 1) AS avg_kda, 
	ROUND(AVG(totalgold)) AS avg_total_gold,
	ROUND(AVG(damagetochampions)) AS avg_total_damage,
	ROUND(AVG((kills + assists) * 100.0 / NULLIF(teamkills, 0)), 1) AS avg_kp_per_match_percent
FROM lol_matches_2025
WHERE league = 'LEC' AND position != 'team' AND teamname = 'Karmine Corp'
GROUP BY position, result
ORDER BY CASE position 
	WHEN 'top' THEN 1
	WHEN 'jng' THEN 2
	WHEN 'mid' THEN 3
	WHEN 'adc' THEN 4
	WHEN 'sup' THEN 5
END,
result DESC;