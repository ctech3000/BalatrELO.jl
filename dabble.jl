
using BalatrELO

leagueDataFN = "src\\leagueData\\"

playerFilename = leagueDataFN*"players_k20_w4.csv"
outputPlayerFileName = leagueDataFN*"players_k20_w5.csv"
matchFilename = leagueDataFN*"matches_w5.csv"
resultFilename = leagueDataFN*"results_w5.csv"
allResultsFilename = leagueDataFN*"allResults_k20.csv"

players = readPlayers(filename = playerFilename)
matches = readNewMatches(players,filename=matchFilename)
giveExpectedScores(matches)
giveMatchdayExpectedValue(matches)

#results = readNewResults(matches,filename=resultFilename)
#updateAllRatings!(results)
#writePlayers!(players,filename=outputPlayerFileName)
#updateAllResults!(results,filename=allResultsFilename)


#stepThroughAllWeeks(leagueDataFN*"players_k20_w",leagueDataFN*"matches_w",leagueDataFN*"results_w",leagueDataFN*"allResults_k20.csv",2)