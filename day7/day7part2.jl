using OffsetArrays

demo = false

function cost(location, target)
    return Int64(abs(location-target)*(abs(location-target)+1)/2)
end

open(demo ? "day7/demoinput" : "day7/input", "r") do f # demoinput
    line = readline(f)
    crabs = [parse(Int64, x) for x in split(line, ",")]

    max = maximum(crabs)
    min = minimum(crabs)
    smallestScore = reduce(+, [cost(x,min) for x in crabs])
        
    for i in min:max
        costs = [cost(x,i) for x in crabs]
        testcost = reduce(+, costs)
        println("$testcost")
        if smallestScore > testcost
            smallestScore = testcost
            println("Smalles now = $smallestScore")
        end
        println()
    end

    println(smallestScore) # 96708205
    # original answer:       96709197 too high 
end

