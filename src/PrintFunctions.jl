



function Base.show(io::IO, player::Player)
    print(io,"$(player.name): 💰 $(player.cost)\$ | 💪 $(round(player.rating,digits=1))\$ | 📝 $(round(player.avgFantasyPoints,digits=1))")
end