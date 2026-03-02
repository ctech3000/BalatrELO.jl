
export readNewFantasyPointData!

function readNewFantasyPointData!(players::Vector{Player};totalPlayed::Int=0)
    if totalPlayed == 0
        println("Update contestants new avg fantasy score:")
    else
        println("Update contestants new avg fantasy score (enter total score!):")
    end
    for player in players
        print(player.name*" new score:  ")
        score = 0.0
        try 
            str = readline()
            score = parse(Float64,str)
            if totalPlayed != 0
                score /= totalPlayed
            end
        catch e
            if e isa ArgumentError
                println("Invalid input.")
            end
        end
        player.avgFantasyPoints = score
    end
end

function readNewFantasyPointData!(player::Player)
    readNewFantasyPointData!([player])
end