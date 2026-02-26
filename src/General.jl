export Player, Match, Result

mutable struct Player
    name::String
    rating::Float64
    cost::Float64
    id::Int64
end

struct Match
    players::Vector{Player}
end

struct Result
    match::Match
    player1Score::Int64
end