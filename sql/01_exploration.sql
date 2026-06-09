-- Nombre de lignes 
SELECT COUNT(*) AS total_lines
FROM lol_matches_2025;

-- Nombre de colonnes 
SELECT COUNT(*) AS total_columns
FROM information_schema."columns"
WHERE table_schema = 'public' AND table_name = 'lol_matches_2025';

-- Nombre de parties toutes ligues confondues 
SELECT COUNT(DISTINCT gameid) AS total_games
FROM lol_matches_2025;

-- Nombre de joueurs toutes ligues confondues 
SELECT COUNT(DISTINCT playerid) AS total_players
FROM lol_matches_2025;

-- Nombre d'équipes toutes ligues confondues
SELECT COUNT(DISTINCT teamid) AS total_teams
FROM lol_matches_2025;

-- Nombre de valeurs nulles dans gameid
SELECT COUNT(gameid) AS total_gameid_null_values
FROM lol_matches_2025
WHERE gameid IS NULL;

-- Nombre de valeurs nulles dans playername
SELECT COUNT(playername) AS total_playername_null_values
FROM lol_matches_2025
WHERE playername IS NULL;

-- Nombre de valeurs nulles dans champion
SELECT COUNT(champion) AS total_champion_null_values
FROM lol_matches_2025
WHERE champion IS NULL;

-- Vérification des doublons
SELECT COUNT(*) 
FROM lol_matches_2025
WHERE position != 'team';

SELECT gameid, playername, COUNT(*)
FROM lol_matches_2025
WHERE position != 'team'
GROUP BY gameid, playername
HAVING COUNT(*) > 1;

SELECT gameid, teamname, position, COUNT(*)
FROM lol_matches_2025
GROUP BY gameid, teamname, position
HAVING COUNT(*) > 1;

SELECT DISTINCT patch
FROM lol_matches_2025
ORDER BY patch;
