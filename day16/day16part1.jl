demo = true

function todecimal(bits)
    total = 0
    for i in 1:size(bits,1)
        total *= 2
        total += bits[i]
    end
    return total
end

function readheader(bits) # 6 bits
    version = todecimal(bits[1:3])
    typeid = todecimal(bits[4:6])
    return (version, typeid)
end

function readliteral(bits, base) # unknown bits
    lastgroup = false
    value = 0
    while !lastgroup
        if bits[base] == 0
            lastgroup = true
        end
        for i in 1:4
            value *= 2
            value += bits[base+i]
        end
        base += 5
    end
    while base%4 != 1
        base += 1
    end
    return (value, base)
end

#rl = readliteral([parse(Bool, x) for x in split("110100101111111000101000", "")], 7)
#display("rl = $rl")
#println()

open(demo ? "day16/demoinput1" : "day16/input", "r") do f # demoinput
    line = readline(f)
    bits = Vector{Bool}()
    for hexdigit in split(line, "")
        append!(bits, digits(parse(Int8, hexdigit, base=16), base=2, pad=4) |> reverse)
    end

    #bits = [parse(Bool, x) for x in split("11101110000000001101010000001100100000100011000001100000", "")]
    #bits = [parse(Bool, x) for x in split("00111000000000000110111101000101001010010001001000000000", "")]

    totalversions = 0
    stack = []
    i = 1
    done = false
    while !done
        top = nothing
        if size(stack,1) != 0
            top = last(stack)
        end
        oldi = i

        # Read header
        nextversion, nexttypeid = readheader(bits[i:i+5])
        println("nextversion, nexttypeid = $nextversion, $nexttypeid")
        totalversions += nextversion
        i += 6

        if nexttypeid == 4 
            # literal
            value, i = readliteral(bits, i)
            println("Literal = $value")

            #check if can close a packet

        else
            #operator packet
            if bits[i] == 0
                # 15 bits are a number that represents the total length in bits of the sub-packets
                sublength = todecimal(bits[i+1:i+15])
                i += 16
                push!(stack, [0, sublength, i])
            else
                # 11 bits are a number that represents the number of sub-packets
                subcount = todecimal(bits[i+1:i+11])
                i += 12
                push!(stack, [1, subcount, i])
            end
        end

        if size(stack, 1) == 0
            done == true
        end
        display(stack)
        println();
        break
    end
    #println(bits)
    #println()
    #nextversion, nexttypeid = readheader(bits[1:6])
    
    println(i)
    index = 1
end