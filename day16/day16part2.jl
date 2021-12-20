
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

    return (value, base)
end

#rl = readliteral([parse(Bool, x) for x in split("110100101111111000101000", "")], 7)
#display("rl = $rl")
#println()

demo = false

open(demo ? "day16/demoinput1" : "day16/input", "r") do f # demoinput
    line = readline(f)

    #test data:
    #line = "C200B40A82" # 3
    #line = "04005AC33890" # 54
    #line = "880086C3E88112" # 7
    #line = "CE00C43D881120" # 9
    #line = "D8005AC2A8F0" # 1
    #line = "F600BC2D8F" # 0
    #line = "9C005AC2F8F0" # 0 
    #line = "9C0141080250320F1802104A08" # 1

    bits = Vector{Bool}()
    for hexdigit in split(line, "")
        append!(bits, digits(parse(Int8, hexdigit, base=16), base=2, pad=4) |> reverse)
    end

    #bits = [parse(Bool, x) for x in split("110100101111111000101000", "")] # 2021
    #bits = [parse(Bool, x) for x in split("00111000000000000110111101000101001010010001001000000000", "")]
    #bits = [parse(Bool, x) for x in split("11101110000000001101010000001100100000100011000001100000", "")]
    
    println(bits)
    println()

    totalversions = 0
    stack = []
    i = 1
    done = false
    while !done
        oldi = i

        # Read header
        nextversion, nexttypeid = readheader(bits[i:i+5])
        println("version = $nextversion, type = $nexttypeid, i = $i")
        totalversions += nextversion
        i += 6

        if nexttypeid == 4 
            # literal
            value, i = readliteral(bits, i)
            println("Literal = $value")
            if size(stack, 1) != 0
                println("Adding value $value to " * string(size(stack, 1)))
                top = last(stack)
                push!(top["subvalues"], value)
            end

            #check if can close a packet
            popping = true
            while popping
                popping = false
                popped = nothing
                
                top = last(stack)
                if "length" in keys(top)
                    if i == top["finish"]
                        popped = pop!(stack)
                        popping = true
                    elseif i > top["finish"]
                        println("Why is $i > " * string(top["finish"]) * ". This better be the last packet!")
                        popped = pop!(stack)
                        popping = true
                    elseif demo
                        println("At $i - need to get to " * string(top["finish"]) * " at stack " * string(size(stack,1)))
                    end
                else # must be a count type
                    top["seen"] += 1
                    if top["seen"] == top["packets"]
                        popped = pop!(stack)
                        popping = true
                    elseif demo
                        println("At " * string(top["seen"]) * " - need to get to " * string(top["packets"]) * " at stack " * string(size(stack,1)))
                    end
                end

                if popped !== nothing
                    poppedvalue = -1
                    if popped["type"] == 0
                        poppedvalue = reduce(+, popped["subvalues"])
                    elseif popped["type"] == 1
                        poppedvalue = reduce(*, popped["subvalues"])
                    elseif popped["type"] == 2
                        poppedvalue = reduce(min, popped["subvalues"])
                    elseif popped["type"] == 3
                        poppedvalue = reduce(max, popped["subvalues"])
                    elseif popped["type"] == 5
                        v2 = pop!(popped["subvalues"])
                        v1 = pop!(popped["subvalues"])
                        poppedvalue = v1 > v2 ? 1 : 0
                    elseif popped["type"] == 6
                        v2 = pop!(popped["subvalues"])
                        v1 = pop!(popped["subvalues"])
                        poppedvalue = v1 < v2 ? 1 : 0
                    elseif popped["type"] == 7
                        v2 = pop!(popped["subvalues"])
                        v1 = pop!(popped["subvalues"])
                        poppedvalue = v1 == v2 ? 1 : 0
                    else
                        println("*** Unknown type id! ***")
                    end
                    println("Pushing poppedvalue $poppedvalue up the stack")
                    if size(stack, 1) == 0
                        println("Done!")
                        println(poppedvalue)
                        break
                    else
                        nexttop = last(stack)
                        push!(nexttop["subvalues"], poppedvalue)
                    end

                end
            end

        else
            #operator packet
            if bits[i] == 0
                # 15 bits are a number that represents the total length in bits of the sub-packets
                sublength = todecimal(bits[i+1:i+15])
                i += 16
                push!(stack, Dict("length"=>sublength, "start"=>i, "finish"=>(sublength+i), "version"=>nextversion, "type"=>nexttypeid, "subvalues"=>[])) # [0, sublength, i])
                if sublength > size(bits, 1)
                    println("************ - length")
                    display(stack)
                    println()
                    exit()
                end
            else
                # 11 bits are a number that represents the number of sub-packets
                subcount = todecimal(bits[i+1:i+11])
                i += 12
                push!(stack, Dict("packets"=>subcount, "start"=>i, "seen"=>0, "version"=>nextversion, "type"=>nexttypeid, "subvalues"=>[])) #[1, subcount, i])
                if subcount > 1000
                    println("************ - count")
                    display(stack)
                    println()
                    exit()
                end
            end
        end

        if size(stack, 1) == 0
            done = true
        end
        display(stack)
        println();
        #break
    end
    #println(bits)
    #println()
    #nextversion, nexttypeid = readheader(bits[1:6])
    
    #println("i = $i")
    #println("totalversions = $totalversions")
end