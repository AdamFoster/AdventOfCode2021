demo = false

open(demo ? "day12/demoinput" : "day12/input", "r") do f # demoinput
    line = readline(f)
    s,e = split(line, "-")
    start = "start"
    theexit = "end"
    connections = Dict(s => Set([e]))
    connections[e] = Set([s])
    line = readline(f)
    while line != ""
        s,e = split(line, "-")
        if s in keys(connections)
            push!(connections[s], e)
        else
            connections[s] = Set([e])
        end
        if e in keys(connections)
            push!(connections[e], s)
        else
            connections[e] = Set([s])
        end

        line = readline(f)
    end

    paths = []
    untouched = 0
    push!(paths, [start])
    while untouched != length(paths)
        #display(paths)
        p = pop!(paths)
        if last(p) == theexit
            pushfirst!(paths, p)
            untouched += 1
            if demo
                println("Path is complete: $p")
            end
        else
            untouched = 0
            for c in connections[last(p)] # for each connection to last node
                if c == uppercase(c)
                    push!(paths, [p [c]])
                elseif !(c in p)
                    push!(paths, [p [c]])
                elseif c != start # this one isn't the start
                    smallcaves = filter(x->x==lowercase(x), p)
                    if length(Set(smallcaves)) == length(smallcaves) # check if a smallcave has been visited twice
                        push!(paths, [p [c]])
                    end
                end
            end
        end
    end

    #display(connections)
    if demo
        display(paths)
        println()
    end
    println(length(paths)) # 3708
end