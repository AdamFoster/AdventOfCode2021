demo = false

global die = 100
function roll!()
    global die += 1
    if die == 101
        die = 1
    end
    return die
end

function dirac(p1start, p2start)
    scores = [0, 0]
    positions = [p1start, p2start]
    activeplayer = 1
    rolls = 0

    while reduce(max, scores) < 1000
        d = roll!() + roll!() + roll!()
        rolls += 3
        positions[activeplayer] += d
        positions[activeplayer] %= 10
        if positions[activeplayer] == 0
            positions[activeplayer] = 10
        end
        scores[activeplayer] += positions[activeplayer]
        println("Scores: $scores - Positions: $positions")
        activeplayer = activeplayer == 1 ? 2 : 1 
    end

    println("Scores: $scores")
    println("Rolls: $rolls")
    println("Total: $(reduce(min,scores)*rolls)") # 428736

end

if demo
    dirac(4, 8)
else
    dirac(1, 10)
end