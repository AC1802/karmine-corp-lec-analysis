-- Nombre total de games jouées par Karmine Corp
SELECT COUNT(gameid) AS total_games_played
FROM lol_matches_2025
WHERE teamname = 'Karmine Corp' AND position = 'team' AND league = 'LEC';

-- Nombre de victoires et défaites
SELECT COUNT(gameid) AS total_games_played,
	SUM(result) AS victories, 
	COUNT(gameid) - SUM(result) AS defeats
FROM lol_matches_2025
WHERE teamname = 'Karmine Corp' AND position = 'team' AND league = 'LEC';

-- Winrate global
SELECT CONCAT(ROUND(AVG(result) * 100, 1), ' %') AS avg_winrate
FROM lol_matches_2025
WHERE teamname = 'Karmine Corp' AND position = 'team' AND league = 'LEC';

-- Temps moyen des games
SELECT CONCAT(ROUND(AVG(gamelength / 60), 1), ' min') AS avg_gamelength
FROM lol_matches_2025
WHERE teamname = 'Karmine Corp' AND position = 'team' AND league = 'LEC';

-- Écart entre victoires et défaites
SELECT SUM(result) AS victories, COUNT(gameid) - SUM(result) AS defeats,
	CONCAT(SUM(result) - (COUNT(gameid) - SUM(result)), ' games') AS diff_victories_defeats
FROM lol_matches_2025 
WHERE teamname = 'Karmine Corp' AND position = 'team' AND league = 'LEC';