export expectedScore, ratingUpdate, updatePlayerRatings!, updateAllRatings!

function expectedScore(match::Match; which::Int=1)
    criticalRating = 5 # if diff between ratings bigger than this -> 3:1 victory very likely. Note: 3:1 instead of 4:0 since luck based variance? Might change.
    ratings = [match.players[i].rating for i=1:2]
    expected = 4/(1+10^((ratings[2]-ratings[1])/criticalRating))
    if which == 1
        return expected
    elseif which == 2 
        return 4 - expected
    elseif which == 0
        return expected, 4 - expected
    end
end

function ratingUpdate(result::Result,volatilityFactor::Float64)
    score = [result.player1Score,4-result.player1Score]
    expected = expectedScore(result.match,which=0)
    update = volatilityFactor*[score[i]-expected[i] for i=1:2]
    return update
end

function updatePlayerRatings!(result::Result;which::Int=0,volatilityFactor::Float64=8/2750*20)
    update = ratingUpdate(result,volatilityFactor)
    for (i,player) in enumerate(result.match.players)
        player.rating += update[i]
    end
end

function updateAllRatings!(results::Vector{Result};volatilityFactor::Float64=8/2750*20)
    for result in results
        updatePlayerRatings!(result,volatilityFactor=volatilityFactor)
    end
end