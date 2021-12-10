#using OffsetArrays

demo = false

open(demo ? "day10/demoinput" : "day10/input", "r") do f 

    score = 0
    scores = Dict(")" => 3, "]" => 57, "}" => 1197, ">" => 25137)
    opens =  Set(["(", "[", "{", "<"])
    closes = Set([")", "]", "}", ">"])
    pairs = Dict(")" => "(", "]" => "[", "}" => "{", ">" => "<")
    # display(scores)
    
    line = readline(f)
    while line != ""
        items = split(line, "")
        done = false
        stack = []
        while !done
            if length(items) == 0
                done = true
                println("Got to end of input")
                #println(line)
            else
                next = popfirst!(items)
                if length(stack) == 0 || next in opens
                    push!(stack, next)
                elseif next in closes
                    opener = pop!(stack)
                    if pairs[next] != opener
                        println("Corrupt. Got $next to match $opener")
                        done = true
                        score += scores[next]
                    end
                else
                    println("Should not be here...")
                end
            end
        end
        line = readline(f)
    end

    println("Score = $score") # 215229
end