#using OffsetArrays

demo = false

open(demo ? "day9/demoinput" : "day9/input", "r") do f # demoinput
    line = readline(f)
    lava = [parse(Int64, x) for x in split(line, "")]
    line = readline(f)
    while line != ""
        lava = [lava [parse(Int64, x) for x in split(line, "")]]
        line = readline(f)
    end

    lowpoints = fill(0, size(lava))
    basins = []
    s1 = size(lava, 1)
    s2 = size(lava, 2)

    for i in 1:size(lava, 1)
        for j in 1:size(lava, 2)
            settotest = []
            if i != 1
                push!(settotest, lava[i-1,j])
            end
            if i != s1
                push!(settotest, lava[i+1,j])
            end
            if j != 1
                push!(settotest, lava[i,j-1])
            end
            if j != s2
                push!(settotest, lava[i,j+1])
            end
            if lava[i,j] < min(settotest...)
                basinsize = 0
                points = [[i,j]]
                while size(points,1) > 0
                    p = pop!(points)
                    if lava[p[1], p[2]] != 9 && lowpoints[p[1], p[2]] == 0
                        lowpoints[p[1], p[2]] = 1
                        basinsize += 1
                        if p[1] != 1
                            push!(points, [p[1]-1, p[2]])
                        end
                        if p[1] != s1
                            push!(points, [p[1]+1, p[2]])
                        end
                        if p[2] != 1
                            push!(points, [p[1], p[2]-1])
                        end
                        if p[2] != s2
                            push!(points, [p[1], p[2]+1])
                        end
                    end
                end
                push!(basins, basinsize)
            end
        end
    end

    println(size(lava, 1))
    display(lava)
    println()
    display(lowpoints)
    println()
    sort!(basins, rev=true)
    display(basins) # 
    println()
    top3 = basins[1]*basins[2]*basins[3]
    println("Top 3 = $top3") # 1023660
end