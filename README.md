# Projet Portfolio Data Analyst - Karmine Corp LEC

## Objectif du projet
Ce projet consiste à analyser les performances en 2025 de l'équipe Karmine Corp en LEC.

## Source des données
- Source : Dataset contenant tous les matchs de chaque équipe professionnelle dans toutes les ligues de Oracle's Elixir avec des statistiques détaillés pour chaque joueur et chaque game jouée.
- Format : CSV

## Technologies
- SQL (PostgreSQL)
- DBeaver

## Compréhension du dataset

### Taille du dataset
- 120 456 lignes
- 165 colonnes
- 10 038 games
- 2637 joueurs
- 383 équipes

Chaque ligne représente un joueur et sa performance dans une game.

Une game complète contient 12 lignes correspondant aux 10 joueurs de chaque équipe séparées par 2 lignes représentant les 2 équipes.

### Description des colonnes

#### Colonnes principales

| Colonne | Description |
|:---------------|:--------------|
| gameid | Identifiant de la game |
| date | Date du match |
| playername | Nom du joueur |
| teamname | Nom de l'équipe |
| position | Poste joué|
| champion | Champion joué |
| kills | Nombre d'ennemis tués |
| deaths | Nombre de morts |
| assists | Identifiant d'assistances |
| earnedgold | Or gagné |
| total_cs | Nombre de sbires tués |

#### Catégories de colonnes
- Identification : gameid, playername, teamname
- Combat : kills, deaths, assists
- Économie : earnedgold, totalgold, goldspent, earnedgoldshare
- Vision : visionscore, wardsplaced, wardskilled 
- Objectifs : firstblood, firsttower, firstherald, firstdragon, firstbaron
- Statistiques à XX minutes (allant de 10 à 25 min) : golddiffatXX, xpdiffatXX, csdiffatXX

### Qualité des données

| Contrôle | Résultat |
|-----------|----------|
| Valeurs nulles dans gameid | 0 |
| Valeurs nulles dans playername | 0 |
| Valeurs nulles dans champion | 0 |
| Valeurs nulles dans certaines métriques avancées | Présentes |
| Doublons détectés | Aucun |

### Premières observations
- Chaque ligne correspond à un joueur dans une partie.
- Une partie contient 10 joueurs.
- Différentes compétitions et versions du jeu sont présentes dans ce dataset

## Analyses SQL

### Analyse descriptive de Karmine Corp
### Analyse des joueurs
### Analyse des victoires
### Analyse par rôle
### Comparaison avec les autres équipes
### Analyse avancée

## Conclusions
...