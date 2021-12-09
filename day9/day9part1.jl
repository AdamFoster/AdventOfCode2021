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
    risk = 0
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
                lowpoints[i,j] = 1
                risk += lava[i,j]+1
            end
        end
    end

    println(size(lava, 1))
    #display(lava)
    #println()
    #display(lowpoints)
    println()
    println(risk) # 516
end