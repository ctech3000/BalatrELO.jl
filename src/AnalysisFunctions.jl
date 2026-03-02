
export giveExpectedScores, giveMatchdayExpectedValue, matchesPlayed, showPredictionResult

function giveExpectedScores(matches::Vector{Match};print::Bool=true)
    expected = expectedScore.(matches)
    if print
        println("=================================================================")
        println("Expected Score for each player in a match:")
        println("-----------------------------------------------------------------")
        for (i,match) in enumerate(matches)
            println(match.players[1].name*" - "*match.players[2].name*":    $(round(expected[i],digits=1)) : $(round(4-expected[i],digits=1))")
        end
        println("=================================================================")
        println("")
    end
    return expected
end

function giveMatchdayExpectedValue(matches::Vector{Match})
    expected = expectedScore.(matches)
    println("=================================================================")
    println("Expected Value for each player in a match (expected points/cost):")
    println("-----------------------------------------------------------------")
    for (i,match) in enumerate(matches)
        cost = [match.players[j].cost for j = 1:2]
        println(match.players[1].name*" - "*match.players[2].name*":    $(round(expected[i]/cost[1],digits=1)) : $(round((4-expected[i])/cost[2],digits=1))")
    end
    println("=================================================================")
    println("")
end

function matchesPlayed(player::Player,allResultsFN::String;print::Bool=true)
    return matchesPlayed(player.name,allResultsFN,print=print)
end

function matchesPlayed(playerName::String,allResultsFN::String;print::Bool=true)
    allResults = DataFrame(CSV.File(allResultsFN))
    matchesPlayedDF = empty(allResults)
    for row in eachrow(allResults)
        if row.playerName1 == playerName || row.playerName2 == playerName
            push!(matchesPlayedDF,row)
        end
    end
    return matchesPlayedDF
end

function showPredictionResult(results::Vector{Result};printErr::Bool=false,norm::String="l1")
    println("==================================================")
    println("Match results along with predictions based on elo:")
    println("--------------------------------------------------")
    diffs = Float64[]
    for result in results
        match = result.match
        expected = expectedScore(match,which=0)
        score = [result.player1Score,4-result.player1Score]
        diff = score[1]-expected[1]
        push!(diffs,diff)
        print(match.players[1].name*" - "*match.players[2].name*":    $(score[1]) : $(score[2]) (expected $(round(expected[1],digits=1)) : $(round(expected[2],digits=1)))")
        if printErr
            print(" ($(round(score[1]-expected[1],digits=1))) ")
        end
        print("\n")
    end
    if printErr 
        if norm == "l1"
            res_norm = sum(abs.(diffs))/length(diffs)
            println("--------------------------------------------------")
            println("Total avg err ($(norm)): $res_norm")
        end
    end
    println("==================================================")
end