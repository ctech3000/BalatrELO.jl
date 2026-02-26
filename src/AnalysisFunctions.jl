
export giveExpectedScores, giveMatchdayExpectedValue, matchesPlayed

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