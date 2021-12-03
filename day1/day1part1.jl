open("day1/input", "r") do f
    prior = 9999999
    increases = 0
    while !eof(f)
        s = parse(Int64, readline(f))
        if s > prior
            increases = increases+1
        end
        prior = s
    
    end
    println(increases)
end