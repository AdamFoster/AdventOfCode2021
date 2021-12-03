open("day1/input", "r") do f
    priora = parse(Int64, readline(f))
    priorb = parse(Int64, readline(f))
    current = parse(Int64, readline(f))
    increases = 0
    while !eof(f)
        s = parse(Int64, readline(f))
        window = priora + priorb + current
        newwindow = priorb + current + s
        if newwindow > window
            increases = increases+1
        end
        priora, priorb, current = [priorb, current, s]
    
    end
    println(increases)
end