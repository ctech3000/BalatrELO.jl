module BalatrELO

using CSV, DataFrames

include("General.jl")
include("EloFunctions.jl")
include("IOFunctions.jl")
include("AnalysisFunctions.jl")

playerFilename = "src\\players_k20_w2.csv"
outputPlayerFileName = "src\\players_k20_w3.csv"
matchFilename = "src\\matches_w3.csv"
resultFilename = "src\\results_w3.csv"
allResultsFilename = "src\\allResults_k20.csv"

players = readPlayers(filename = playerFilename)
matches = readNewMatches(players,filename=matchFilename)
#results = readNewResults(matches,filename=resultFilename)
#updateAllResults!(results,filename=allResultsFilename)
#updateAllRatings!(results)
#writePlayers!(players,filename=outputPlayerFileName)
#stepThroughAllWeeks("players_k20_w","matches_w","results_w","allResults_k20.csv",2)
giveExpectedScores(matches)
giveMatchdayExpectedValue(matches)

end;
