demo = false

function mi(a, b, i) 
    return max(a[i], b[i])
end

open(demo ? "day13/demoinput" : "day13/input", "r") do f # demoinput
    line = readline(f)
    points = []
    folds = []

    while line != ""
        push!(points, [parse(Int64, x) for x in split(line, ",")])
        line = readline(f)
    end

    line = readline(f)
    while line != ""
        push!(folds, [line[12], parse(Int64, split(line, "=")[2])])
        line = readline(f)
    end

    if demo
        display(points)
        println()
        display(folds)
        println()
    end

    for fold in folds
        folddist = fold[2]
        if fold[1] == 'y'
            newpoints = [[p[1], 2*folddist-p[2]] for p in points if p[2]>folddist]
            oldpoints = [[p[1], p[2]] for p in points if p[2]<=folddist]
            points = [newpoints ; oldpoints]
        else
            newpoints = [[2*folddist-p[1], p[2]] for p in points if p[1]>folddist]
            oldpoints = [[p[1], p[2]] for p in points if p[1]<=folddist]
            points = [newpoints ; oldpoints]
        end
    end

    if demo
        display(sort(unique(points)))
        println()
    end
    
    max1 = reduce(max, [x[1] for x in points])
    max2 = reduce(max, [x[2] for x in points])
    min1 = reduce(min, [x[1] for x in points])
    min2 = reduce(min, [x[2] for x in points])
    
    println("$max1 , $max2")
    final = [([x,y] in points ? 8 : 1) for x in min1:max1, y in min2:max2]
    display(final')
    println()
    println()

    for c in eachcol(final)
        for i in c
            print(i==8 ? "*" : " ")
        end
        println()
    end

    # RKHFZGUB

end