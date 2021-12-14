using DataStructures

demo = false

open(demo ? "day14/demoinput" : "day14/input", "r") do f # demoinput
    line = readline(f)
    poly = split(line, "")

    line = readline(f)
    line = readline(f)

    pairs = Dict{String, Int64}()

    for c in 1:(size(poly,1)-1)
        key = poly[c] * poly[c+1]
        if key in keys(pairs)
            pairs[key] += 1
        else
            pairs[key] = 1
        end
    end
    
    lookup = Dict{String, String}()

    while line != ""
        key,value = split(line," -> ")
        lookup[key] = value
        line = readline(f)
    end

    if demo
        display(pairs)
        println()
        display(lookup)
        println()
    end

    for i in 1:40
        newpairs = Dict{String, Int64}()
        for k in keys(pairs)
            if k in keys(lookup)
                p1 = k[1:1] * lookup[k]
                p2 = lookup[k] * k[2:2]
                # println("$p1 - $p2")
                if p1 in keys(newpairs)
                    newpairs[p1] += pairs[k]
                    # println("newpairs[p1] - $(newpairs[p1])")
                else
                    newpairs[p1] = pairs[k]
                end
                if p2 in keys(newpairs)
                    newpairs[p2] += pairs[k]
                else
                    newpairs[p2] = pairs[k]
                end
            else
                if p1 in keys(newpairs)
                    newpairs[k] += pairs[k]
                else
                    newpairs[k] = pairs[k]
                end
            end
        end
        pairs = newpairs
    end

    display(pairs)
    letters = Set{String}()
    for p in keys(pairs)
        push!(letters, p[1:1])
        push!(letters, p[2:2])
    end

    counts = Dict{String, Int64}()

    println()
    for letter in letters
        total = 0
        for k in keys(pairs)
            if k == letter*letter
                total += 2*pairs[k]
            elseif occursin(letter, k)
                total += pairs[k]
            end 
        end
        if total % 2 == 1
            total += 1
        end
        total = Int64(total/2)
        #println("Total $letter = $total")
        counts[letter] = total
    end

    display(counts)
    println()

    mx = reduce(max, values(counts))
    mn = reduce(min, values(counts))
    println(mx-mn) # 2875665202438
end