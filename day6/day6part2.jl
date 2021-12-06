using DataStructures
using Printf

demo = false

open(demo ? "day6/demoinput.txt" : "day6/input.txt", "r") do f # demoinput
    line = readline(f)
    
    fish = [parse(Int64, x) for x in split(line, ",")]
    fishcounter = counter(fish)
    dict = Dict(i => fishcounter[i] for i in keys(fishcounter))
    println(fish)
    println(dict)
    println()

    for day in 1:256
        zeros = 0
        if haskey(dict, 0)
            zeros = dict[0]
            delete!(dict, 0)
        end
        dict = Dict(i-1 => dict[i] for i in keys(dict))
        dict[8] = zeros
        if haskey(dict, 6)
            dict[6] += zeros
        else
            dict[6] = zeros
        end
        
        #@printf("Day %d: %s\n", day, join(fish, ','))
        println("Day $day")
        println(dict)
        println()
    end
    println(values(dict))
    println(reduce(+, values(dict))) # 1650309278600
    #display(fish)

end