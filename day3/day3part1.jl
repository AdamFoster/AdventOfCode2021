open("day3/input", "r") do f
    bitcount = Array{Int64}(undef, 12)
    fill!(bitcount, 0)
    lines = 0
    while !eof(f)
        instruction = split(readline(f), "")
        for (index, value) in enumerate(instruction)
            # println("$index = $value")
            bitcount[index] += parse(Int64, value)
        end
        lines += 1
    end
    println(bitcount)
    gamma = 0
    delta = 0 
    for value in bitcount
        gamma *= 2
        delta *= 2
        if (value > lines/2)
            print(1)
            gamma += 1
        else
            print(0)
            delta += 1
        end
    end
    println()
    println(gamma)
    println(delta)
    println(gamma*delta)
end