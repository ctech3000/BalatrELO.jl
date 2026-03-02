
using BalatrELO

leagueDataFN = "src\\leagueData\\"

playerFilename = leagueDataFN*"players_k20_w3.csv"
outputPlayerFileName = leagueDataFN*"players_k20_w4.csv"
matchFilename = leagueDataFN*"matches_w4.csv"
#resultFilename = leagueDataFN*"results_w3.csv"
allResultsFilename = leagueDataFN*"allResults_k20.csv"

players = readPlayers(filename = playerFilename)
matches = readNewMatches(players,filename=matchFilename)
#results = readNewResults(matches,filename=resultFilename)
#updateAllResults!(results,filename=allResultsFilename)
#updateAllRatings!(results)
#writePlayers!(players,filename=outputPlayerFileName)
#stepThroughAllWeeks(leagueDataFN*"players_k20_w",leagueDataFN*"matches_w",leagueDataFN*"results_w",leagueDataFN*"allResults_k20.csv",2)
giveExpectedScores(matches)
giveMatchdayExpectedValue(matches)
