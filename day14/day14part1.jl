using DataStructures

demo = true

open(demo ? "day14/demoinput" : "day14/input", "r") do f # demoinput
    line = readline(f)
    poly = split(line, "")

    line = readline(f)
    line = readline(f)
    
    lookup = Dict{String, String}()

    while line != ""
        key,value = split(line," -> ")
        lookup[key] = value
        line = readline(f)
    end

    if demo
        display(poly)
        println()
        display(lookup)
        println()
    end

    for i in 1:10
        newpoly = []
        for c in 1:(size(poly,1)-1)
            push!(newpoly, poly[c])
            if (poly[c] * poly[c+1]) in keys(lookup)
                push!(newpoly, lookup[poly[c] * poly[c+1]])
            end
        end
        push!(newpoly, poly[size(poly,1)])
        poly = newpoly
    end

    println(reduce(*,poly))
    println()
    ct = counter(poly)
    display(ct)
    println()
    mx = reduce(max, values(ct))
    mn = reduce(min, values(ct))
    println(mx-mn) # 2590 
end