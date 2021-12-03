open("day2/input", "r") do f
    position = 0
    depth = 0
    while !eof(f)
        instruction, value = split(readline(f), " ")
        valueParsed = parse(Int64, value)

        if instruction == "forward"
            position += valueParsed
        elseif instruction == "down"
            depth += valueParsed
        elseif instruction == "up"
            depth -= valueParsed
        else
            println("Unknown Instruction $instruction")
        end
        
    end
    println(position)
    println(depth)
    println(position*depth)
end