function bin2dec(b)
    d = 0
    for value in b
        d *= 2
        d += value
    end 
    return d
end

open("day3/input", "r") do f
    gamma = [parse(Int64, x) for x in split("001110100111", "")]
    delta = [parse(Int64, x) for x in split("110001011000", "")] 

    line = [parse(Int64, x) for x in split(readline(f), "")]
    #println(line)
    #println(typeof(line))
    o2 = line
    co2 = line

    while !eof(f)
        line = [parse(Int64, x) for x in split(readline(f), "")]
        o2 = [o2 line]
        co2 = [co2 line]
    end

    index = 1

    while size(o2, 2) > 1
        ones = reduce(+, o2[index,:])
        count = size(o2, 2)
        keepers = (ones*2 >= count) ? 1 : 0
        newo2 = missing
        for col in eachcol(o2)
            if col[index] == keepers
                newo2 = ismissing(newo2) ? col : [newo2 col]
            end
        end
        o2 = newo2
        index += 1
    end
    println(o2)
    println(bin2dec(o2))

    index = 1
    while size(co2, 2) > 1
        ones = reduce(+, co2[index,:])
        count = size(co2, 2)
        keepers = (ones*2 < count) ? 1 : 0
        newco2 = missing
        for col in eachcol(co2)
            if col[index] == keepers
                newco2 = ismissing(newco2) ? col : [newco2 col]
            end
        end
        co2 = newco2
        index += 1
    end
    println(co2)
    println(bin2dec(co2))

    println()
    println(bin2dec(co2)*bin2dec(o2))
    #println(o2)
    #println(typeof(o2))
    #println(size(o2, 2))
end
