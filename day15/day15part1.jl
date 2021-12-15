using OffsetArrays

demo = false

open(demo ? "day15/demoinput" : "day15/input", "r") do f # demoinput
    line = readline(f)
    risks = [parse(Int64, x) for x in split(line, "")]
    line = readline(f)
    while line != ""
        risks = [risks [parse(Int64, x) for x in split(line, "")]]
        line = readline(f)
    end

    display(risks)
    println()

    totalrisk = fill(9999999, size(risks))
    totalrisk[1,1] = 0

    totalrisk = [fill(9999999, size(totalrisk, 1)) totalrisk fill(9999999, size(totalrisk, 1))]
    totalrisk = [fill(9999999, 1, size(totalrisk, 2)) ; totalrisk  ; fill(9999999, 1, size(totalrisk, 2))]
    totalrisk = OffsetArray(totalrisk, 0:(size(totalrisk,1)-1), 0:(size(totalrisk,2)-1))

    front = []
    push!(front, [1,2])
    push!(front, [2,1])
    #display(front)
    #println()

    while totalrisk[size(risks, 1), size(risks,2)] == 9999999
        minval = 9999999
        minloc = [0,0]
        for fr in front
            #println("fr = $fr")
            minadj = reduce(min, [totalrisk[x[1], x[2]] 
                                    for x in [
                                        [fr[1]-1, fr[2]],
                                        [fr[1]+1, fr[2]],
                                        [fr[1], fr[2]-1],
                                        [fr[1], fr[2]+1]
                                    ]])
            #fr[1]-1:fr[1]+1, y in fr[2]-1:fr[2]+1])
            minadj += risks[fr[1], fr[2]]
            if minadj < minval
                minval = minadj
                minloc = fr
            end
            #println("minloc = $minloc , minval = $minval")
        end
        totalrisk[minloc[1], minloc[2]] = minval
        filter!(x->x!=minloc, front)
        newfront = []
        if minloc[1]-1 > 0
            push!(newfront, [minloc[1]-1, minloc[2]])
        end
        if minloc[1]+1 <= size(risks,1)
            push!(newfront, [minloc[1]+1, minloc[2]])
        end
        if minloc[2]-1 > 0
            push!(newfront, [minloc[1], minloc[2]-1])
        end
        if minloc[2]+1 <= size(risks,2)
            push!(newfront, [minloc[1], minloc[2]+1])
        end
        #display(newfront)
        #println()
        front = [front ; newfront]
        unique!(front)
        filter!(x->totalrisk[x[1],x[2]]==9999999, front)
        #display(front)
        #println()
        #if size(front,1) > 3
        #    break
        #end
    end

    display(totalrisk)
    println()
    println(totalrisk[size(risks,1),size(risks,2)]) # 537

end