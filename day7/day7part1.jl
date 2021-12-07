using OffsetArrays

demo = false

open(demo ? "day7/demoinput" : "day7/input", "r") do f # demoinput
    line = readline(f)
    crabs = [parse(Int64, x) for x in split(line, ",")]

    max = maximum(crabs)
    min = minimum(crabs)
    maxcost = reduce(+, [abs(x-max) for x in crabs])
    mincost = reduce(+, [abs(x-min) for x in crabs])
    
    while max > min
        test = Int64(trunc((max+min)/2))
        costs = [abs(x-test) for x in crabs]
        testcost = reduce(+, costs)
        println("$test @ $testcost")
        println(costs)
        println()
        if maxcost > mincost
            max = test
            maxcost = testcost
        else
            min = test
            mincost = testcost
        end
    end

    println(maxcost)
    println(mincost)
end