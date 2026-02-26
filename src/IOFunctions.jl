
export readPlayers, writePlayers!, readNewMatches, readNewResults, readAllResults, updateAllResults!
export stepThroughAllWeeks!

using CSV, DataFrames

#= 
form of csv dataframes:
players.csv: players = DataFrame(playerName=String[],rating=Float64[],cost=Float64[])
matches.csv: matches = DataFrame(playerName1=String[],playerName2=String[])
results.csv: results = DataFrame(player1Score=Int64[])
allResults.csv: allResults = DataFrame(matchday=Int64[],playerName1=String[],playerName2=String[],playerRating1=Float64[],playerRating2=Float64[],player1ScoreplayerRating1=Int64[])
=#

function readPlayers(;filename::String="players.csv")
    playerDF = DataFrame(CSV.File(filename))
    players = Player[]
    for entry = eachrow(playerDF)
        playerID = DataFrames.row(entry)
        name,rating,cost = entry
        push!(players,Player(name,rating,cost,playerID))
    end
    return players
end

function writePlayers!(players::Vector{Player};filename::String="players.csv")
    playerDF = DataFrame(playerName=String[],rating=Float64[],cost=Float64[])
    for player in players
        push!(playerDF,(player.name,player.rating,player.cost))
    end
    CSV.write(filename, playerDF)
end

function readNewMatches(players::Vector{Player};filename::String="matches.csv")
    matchDF = DataFrame(CSV.File(filename))
    matches = Match[]
    for entry = eachrow(matchDF)
        playerName1,playerName2 = entry
        playerNames = [playerName1,playerName2]
        playerInds = [findfirst(player -> player.name==playerNames[i],players) for i=1:2]
        if playerInds[1] === nothing || playerInds[2] === nothing 
            println("Player from Match "*playerName1*" - "*playerName2*" not found!")
        else
            player1 = players[playerInds[1]]
            player2 = players[playerInds[2]]
            push!(matches,Match([player1,player2]))
        end
    end
    return matches
end

function readNewResults(matches::Vector{Match};filename::String="results.csv")
    resultDF = DataFrame(CSV.File(filename))
    if size(resultDF,1) != length(matches)
        println("Number of results does not match number of matches!")
    else
        results = Result[]
        for entry in eachrow(resultDF)
            idx = DataFrames.row(entry)
            push!(results,Result(matches[idx],entry[:player1Score]))
        end
        return results
    end
end

function readAllResults(;filename::String="allResults.csv")
    allResultsDF = DataFrame(CSV.File(filename))
    return allResultsDF
end

function updateAllResults!(results::Vector{Result};filename::String="allResults.csv",matchday::Int=-1)
    allResultsDF = DataFrame(CSV.File(filename))
    if matchday == -1 
        if size(allResultsDF,1) == 0
            matchday = 1
        else
            matchday = maximum(allResultsDF[:,:matchday]) + 1
        end
    end
    for result in results
        push!(allResultsDF,(matchday,result.match.players[1].name,result.match.players[2].name,result.match.players[1].rating,result.match.players[2].rating, result.player1Score))
    end
    CSV.write(filename, allResultsDF)
end


# function loads weekly matches, results and player files and saves in allResults and updates players
# filenames for players,matches and results are only the part before "...x.csv" where x is the week, i.e.
# "players_k20_w" instead of "players_k20_w1.csv"
#e.g. stepThroughAllWeeks!("players_k20_w","matches_w","results_w","allResults_k20.csv",2)
# intended for when everything needs to be recalculated
function stepThroughAllWeeks!(playerFN::String,matchesFN::String,resultsFN::String,allResultsFN::String,lastweek::Int)
    fullPlayerFN = playerFN*"start.csv"
    for week = 1:lastweek
        fullMatchesFN = matchesFN*"$(week).csv"
        fullResultsFN = resultsFN*"$(week).csv"
        players = readPlayers(filename = fullPlayerFN)
        matches = readNewMatches(players,filename=fullMatchesFN)
        results = readNewResults(matches,filename=fullResultsFN)
        updateAllResults!(results,filename=allResultsFN)
        updateAllRatings!(results)
        writePlayers!(players,filename=playerFN*"$(week).csv")
        if week < lastweek
            fullPlayerFN = playerFN*"$(week).csv"
        end
    end
end
