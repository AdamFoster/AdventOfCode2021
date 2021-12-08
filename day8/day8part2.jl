#using OffsetArrays

#       11
#      2  3
#       44
#      5  6
#       77
# 1 = 2
# 2 = 5
# 3 = 5
# 4 = 4
# 5 = 5
# 6 = 6
# 7 = 3
# 8 = 7
# 9 = 6

demo = false

open(demo ? "day8/demoinput" : "day8/input", "r") do f # demoinput
    line = readline(f)
    total = 0
    while line != ""
        inputLine, outputLine = split(line, " | ")
        line = readline(f)
        outputs = split(outputLine, " ")
        inputs = split(inputLine, " ")

        segments = [Set(["a", "b", "c", "d", "e", "f", "g"])]
        for i in 2:7
            segments = [segments Set(["a", "b", "c", "d", "e", "f", "g"])]
        end
        one = []
        four = []
        seven = []
        eight = []

        for i in inputs
            is = split(i, "")
            if length(i) == 2 # i.e. it's a 1
                one = Set(is)
                for s in [1,2,4,5,7] #remove
                    setdiff!(segments[s], is)
                end
                for s in [3,6] #keep
                    intersect!(segments[s], is)
                end
            elseif length(i) == 4 # i.e. it's a 4
                four = Set(is)
                for s in [1,5,7] #remove
                    setdiff!(segments[s], is)
                end
                for s in [2,3,4,6] #keep
                    intersect!(segments[s], is)
                end
            elseif length(i) == 3 # i.e. it's a 7
                seven = Set(is)
                for s in [2,4,5,7] #remove
                    setdiff!(segments[s], is)
                end
                for s in [1,3,6] #keep
                    intersect!(segments[s], is)
                end
            elseif length(i) == 7 # i.e. it's a 8
                eight = Set(is)
                for s in [1,2,3,4,5,6,7] #keep
                    intersect!(segments[s], is)
                end
            end
        end
        
        minitotal = 0
        for i in outputs
            minitotal *= 10
            is = split(i, "")
            if length(i) == 2 #1
                minitotal += 1
            elseif length(i) == 4 #4
                minitotal += 4
            elseif length(i) == 3 #7
                minitotal += 7
            elseif length(i) == 7 #8
                minitotal += 8
            elseif length(i) == 5 #2,3,5
                if length(intersect(segments[2], is)) == 2
                    minitotal += 5
                elseif length(intersect(one, is)) == 2
                    minitotal += 3
                else
                    minitotal += 2
                end
            elseif length(i) == 6 #6,9,0
                if length(intersect(four, is)) == 4
                    minitotal += 9
                elseif length(intersect(seven, is)) == 3
                    minitotal += 0
                else
                    minitotal += 6
                end
            end
        end
        total += minitotal
        
        #println("$outputsCount : $outputLine => $outputFiltered")
        #display(segments)
        #break
        println(minitotal)
    end
    println("total = $total") #1055164
end