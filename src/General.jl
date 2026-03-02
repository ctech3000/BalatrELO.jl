export Player, Match, Result, updateAvgFantasyScore!

mutable struct Player
    name::String
    rating::Float64
    cost::Float64
    id::Int64
    avgFantasyPoints::Float64
end

struct Match
    players::Vector{Player}
end

struct Result
    match::Match
    player1Score::Int64
end

function updateAvgFantasyScore!(player::Player,newScore::Float64)
    player.avgFantasyPoints = newScore
end