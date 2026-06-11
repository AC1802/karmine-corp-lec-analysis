-- Kills moyens, deaths moyens, assists moyens de chaque joueur
SELECT playername, 
	ROUND(AVG(kills), 1) AS avg_kills, 
	ROUND(AVG(deaths), 1) AS avg_deaths, 
	ROUND(AVG(assists), 1) AS avg_assists
FROM lol_matches_2025
WHERE teamname = 'Karmine Corp' AND position != 'team' AND league = 'LEC'
GROUP BY playername;

-- KDA moyen de chaque joueur
SELECT playername, 
	ROUND(AVG((kills + assists) * 1.0 / NULLIF(deaths, 0)), 1) AS avg_kda
FROM lol_matches_2025
WHERE teamname = 'Karmine Corp' AND position != 'team' AND league = 'LEC'
GROUP BY playername;

-- Gold moyen, cs moyen, dégâts moyens de chaque joueur
SELECT playername, 
	ROUND(AVG(totalgold)) AS avg_total_gold, 
	ROUND(AVG("total cs")) AS avg_total_cs, 
	ROUND(AVG(damagetochampions)) AS avg_total_damage   
FROM lol_matches_2025
WHERE teamname = 'Karmine Corp' AND position != 'team' AND league = 'LEC'
GROUP BY playername;