demo = false

global die = 100
function roll!()
    global die += 1
    if die == 101
        die = 1
    end
    return die
end

smears = [[3, 1] [4, 3] [5, 6] [6, 7] [7, 6] [8, 3] [9, 1]]

function dirac(p1start, p2start)
    global smears
    #display(smears)
    #println()

    state = Dict() # game state -> possible paths to state
    state[[0,0,p1start,p2start,1]] = 1
    #scores = [0, 0]
    #positions = [p1start, p2start]
    #activeplayer = 1
    #state[[scores ; positions ; activeplayer]] = 1

    #display(state)
    #println()

    
    completedStates = Dict()
    done = false
    while !done
        nextstate = Dict()
        println("State size: $(length(keys(state))). Completed size: $(length(keys(completedStates)))")
        println(sort(collect(keys(state)))[1])
        done = true
        for k in keys(state)
            #display(k)
            #println()
            if k[1] >=21 || k[2] >= 21 #state is already a winning state
                if k in keys(completedStates)
                    completedStates[k] += state[k]
                else
                    completedStates[k] = state[k]
                end
            else
                done = false
                #newkey = k
                for smear in eachcol(smears)
                    #println("s: $s")
                    newkey = deepcopy(k)
                    scores = view(newkey, 1:2)
                    positions = view(newkey, 3:4)
                    activeplayer = newkey[5]

                    positions[activeplayer] += smear[1]
                    positions[activeplayer] %= 10
                    if positions[activeplayer] == 0
                        positions[activeplayer] = 10
                    end
                    scores[activeplayer] += positions[activeplayer]
                    newkey[5] = activeplayer == 1 ? 2 : 1

                    if newkey[1] == 1
                        println("Newkey = $newkey from $k")
                    end
                    if newkey in keys(nextstate)
                        nextstate[newkey] += smear[2] * state[k]
                    else
                        nextstate[newkey] = smear[2] * state[k]
                    end
                end
            end
        end
        println("Next State size: $(length(keys(nextstate))). Completed size: $(length(keys(completedStates)))")
        
        state = nextstate

        #println("State:")
        #display(state)
        #println()
        #if rand() > 0.9
        #    println("*** BREAKING ***")
        #    break
        #end
        #println("State: $state")

    end

    #println("Completed states:")
    #display(completedStates)

    winner1count = 0
    winner2count = 0
    for s in keys(completedStates)
        if s[1] >= 21
            winner1count += completedStates[s]
        else
            winner2count += completedStates[s]
        end
    end
    println("winner1count: $winner1count") # 57328067654557
    println("winner2count: $winner2count") # 32971421421058
end

if demo
    dirac(4, 8)
else
    dirac(1, 10)
end