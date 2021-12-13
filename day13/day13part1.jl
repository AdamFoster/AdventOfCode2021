demo = false

# ################
#       5     8
#          3
#    2  5
#     f - (x-f)
#     2f - x
# x = 8, f = 5. 
# x-f = 8-5 = 3
# f - (x-f) = 5 - (8-5)

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

    folddist = folds[1][2]
    if folds[1][1] == 'y'
        newpoints = [[p[1], 2*folddist-p[2]] for p in points if p[2]>folddist]
        oldpoints = [[p[1], p[2]] for p in points if p[2]<=folddist]
        display(sort(unique([newpoints ; oldpoints])))
        println()
    else
        newpoints = [[2*folddist-p[1], p[2]] for p in points if p[1]>folddist]
        oldpoints = [[p[1], p[2]] for p in points if p[1]<=folddist]
        display(sort(unique([newpoints ; oldpoints])))
        println()
    end
    
    # 802

end