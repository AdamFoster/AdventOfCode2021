#using OffsetArrays

demo = false

open(demo ? "day10/demoinput" : "day10/input", "r") do f 

    linescore = []
    scores = Dict("(" => 1, "[" => 2, "{" => 3, "<" => 4)
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
                score = 0
                while length(stack) > 0
                    score *= 5
                    score += scores[pop!(stack)]
                end
                push!(linescore, score)
                println("Line Score = $score")
            else
                next = popfirst!(items)
                if length(stack) == 0 || next in opens
                    push!(stack, next)
                elseif next in closes
                    opener = pop!(stack)
                    if pairs[next] != opener
                        println("Corrupt. Got $next to match $opener")
                        done = true
                    end
                else
                    println("Should not be here...")
                end
            end
        end

        line = readline(f)
    end

    sort!(linescore)
    display(linescore)
    thescore = linescore[Int64(length(linescore)/2+.5)]
    println()
    println("Score = $thescore")
end