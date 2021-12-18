demo = false

function parseNumber(s) 
    stack = []
    for el in split(s,"")
        if el == ","
        elseif el == "["
            push!(stack, [])
        elseif el == "]"
            item = pop!(stack)
            if size(stack,1) == 0
                return item
            end
            push!(last(stack), item)
        else
            push!(last(stack), parse(Int64, el))
        end
    end
    println("It's all gone wrong")
    display(stack)
    println()
end

function parseNumber2(s) 
    stack = []
    i = 1
    while i <= length(s)
        if s[i:i] == ","
        elseif s[i:i] == "["
            push!(stack, [])
        elseif s[i:i] == "]"
            item = pop!(stack)
            if size(stack,1) == 0
                return item
            end
            push!(last(stack), item)
        else
            if occursin(s[i+1:i+1], "0123456789")
                push!(last(stack), parse(Int64, s[i:i+1]))
                i += 1
            else
                push!(last(stack), parse(Int64, s[i:i]))
            end
        end
        i += 1
    end
    println("It's all gone wrong")
    display(stack)
    println()
end

function getElement(n, indexes)
    el = n
    for i in indexes
        el = el[i]
    end
    return el
end

function split!(n)
    indexes = [1]
    while true
        el = getElement(n, indexes)
        parent = getElement(n, indexes[1:(size(indexes,1)-1)])
        indexInParent = last(indexes)
        if isa(el, Array)
            push!(indexes, 1)
        else #it's a number
            if el > 9 # split
                newel = Array{Any}([floor(Int, el/2), ceil(Int, el/2)])
                #print("parent: ")
                #display(parent)
                #println()
                #print("parent[indexInParent]: ")
                #display(parent[indexInParent])
                #println()
                parent[indexInParent] = newel
                return true
            end
            while last(indexes) == 2 #end of this number
                if size(indexes,1) == 1
                    if last(indexes) == 2
                        done = true
                        return false
                    end
                    break
                end
                pop!(indexes)
                #println("Popping down to $indexes")
             end
            indexes[size(indexes,1)] += 1
        end
    end
end

function testsplit(input, output)
    num = parseNumber2(input)
    split!(num)
    if num != output
        println("SPLIT FAIL!")
        println(num)
        println(output)
        println("END FAIL!")
        exit()
    else
        println("Test ok: $input => $output")
    end
end

function explode!(n)
    done = false
    indexes = [1]
    while !done
        el = getElement(n, indexes)
        parent = getElement(n, indexes[1:(size(indexes,1)-1)])
        indexInParent = last(indexes)
        #println("el $el isa $(isa(el, Array))")
        if isa(el, Array)
            if size(indexes, 1) == 4 #explode
                #println("Exploding $el")
                #find last 2
                leftindex = findlast(x->x==2, indexes)
                if leftindex !== nothing
                    tochange = getElement(n, indexes[1:leftindex-1])
                    if !isa(tochange[1], Array)
                        #println("Changing sibling 1")
                        tochange[1] += el[1]
                    else
                        #println("Changing non-sibling")
                        tochange = tochange[1]
                        #println("tochange = $tochange")
                        while isa(tochange[2], Array)
                            tochange = tochange[2]
                        end
                        tochange[2] += el[1]
                    end
                end
                rightindex = findlast(x->x==1, indexes)
                if rightindex !== nothing
                    #println("rightindex = $rightindex, indexes = $indexes")
                    tochange = getElement(n, indexes[1:rightindex-1])
                    #println("Tochange = $tochange")
                    if !isa(tochange[2], Array)
                        #println("Changing sibling 2")
                        tochange[2] += el[2]
                    else
                        #println("Changing non-sibling 2")
                        tochange = tochange[2]
                        while isa(tochange[1], Array)
                            tochange = tochange[1]
                        end
                        tochange[1] += el[2]
                    end
                    #println("Tochange = $tochange")
                end
                parent[indexInParent] = 0
                return true
            else #push on to stack
                push!(indexes, 1)
                #println("Pushing $el. indexes = $indexes")
            end
        else # must be a number
            #println("incoming indexes $indexes")
            while last(indexes) == 2 #end of this number
                if size(indexes,1) == 1
                    if last(indexes) == 2
                        done = true
                        return false
                    end
                    break
                end
                pop!(indexes)
                #println("Popping down to $indexes")
            end
            indexes[size(indexes,1)] += 1
            #println("Incrementing to $indexes")
        end
    end
end

function snailreduce!(num)
    done = false
    while !done
        done = true
        while explode!(num)
            #println("Exploding $num")
        end
        if split!(num)
            #println("Splitting $num")
            done = false
        end
    end
end

function testexplode(input, output)
    num = parseNumber(input)
    explode!(num)
    if num != output
        println("FAIL!")
        println(num)
        println(output)
        println("END FAIL!")
        exit()
    else
        println("Test ok: $input => $output")
    end
end

function testreduce(input, output)
    num = parseNumber2(input)
    snailreduce!(num)
    if num != output
        println("REDUCE FAIL!")
        println(num)
        println(output)
        println("END FAIL!")
        exit()
    else
        println("Reduce Test ok: $input => $output")
    end
end

function testexplodes()
    println("*** TEST 1 ***")
    testexplode("[[[[[9,8],1],2],3],4]", [[[[0,9],2],3],4])
    testexplode("[7,[6,[5,[4,[3,2]]]]]", [7,[6,[5,[7,0]]]])
    testexplode("[[6,[5,[4,[3,2]]]],1]", [[6,[5,[7,0]]],3])
    testexplode("[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]", [[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]])
    testexplode("[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]", [[3,[2,[8,0]]],[9,[5,[7,0]]]])
    println("*** TEST 2 ***")
    num = parseNumber("[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]")
    while (explode!(num))
    end
    if num != [[3,[2,[8,0]]],[9,[5,[7,0]]]]
        println("Multi-fail")
    else
        println("Multi-success")
    end
end

function testsplits()
    testsplit("[[[[0,7],4],[15,[0,13]]],[1,1]]", [[[[0,7],4],[[7,8],[0,13]]],[1,1]])
    testsplit("[[[[0,7],4],[[7,8],[0,13]]],[1,1]]", [[[[0,7],4],[[7,8],[0,[6,7]]]],[1,1]])
    num = parseNumber2("[[[[0,7],4],[15,[0,13]]],[1,1]]")
    while (split!(num))
    end
    expected = [[[[0,7],4],[[7,8],[0,[6,7]]]],[1,1]]
    if num != expected
        println("Split Multi-fail")
        println("$num != $expected")
    else
        println("Split Multi-success")
    end
end

function testreduces()
    #testreduce("[[[[0,7],4],[15,[0,13]]],[1,1]]", [[[[0,7],4],[[7,8],[0,[6,7]]]],[1,1]])
    
    println("*** TEST 1 ***")
    testreduce("[[[[[9,8],1],2],3],4]", [[[[0,9],2],3],4])
    testreduce("[7,[6,[5,[4,[3,2]]]]]", [7,[6,[5,[7,0]]]])
    testreduce("[[6,[5,[4,[3,2]]]],1]", [[6,[5,[7,0]]],3])
    testreduce("[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]", [[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]])
    testreduce("[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]", [[3,[2,[8,0]]],[9,[5,[7,0]]]])
    println("*** TEST 2 ***")
    num = parseNumber("[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]")
    reduce!(num)
    expected = [[3,[2,[8,0]]],[9,[5,[7,0]]]]
    if num != expected
        println("$num != $expected")
        println("Multi-fail")
    else
        println("Multi-success")
    end
end

function magnitude(n)
    total = 0
    if isa(n, Array)
        total += 3*magnitude(n[1])
        total += 2*magnitude(n[2])
    else
        total += n
    end
    return total
end

function testmag(input, output)
    num = parseNumber2(input)
    mag = magnitude(num)
    if mag != output
        println("Magnitude FAIL!")
        println("$mag != $output")
        println(input)
        println("END FAIL!")
        exit()
    else
        println("Mag Test ok: $input => $output")
    end
end

function testmags()
    testmag("[[1,2],[[3,4],5]]", 143)
    testmag("[[[[0,7],4],[[7,8],[6,0]]],[8,1]]", 1384)
    testmag("[[[[1,1],[2,2]],[3,3]],[4,4]]", 445)
    testmag("[[[[3,0],[5,3]],[4,4]],[5,5]]", 791)
    testmag("[[[[5,0],[7,4]],[5,5]],[6,6]]", 1137)
    testmag("[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]", 3488)
end

open(demo ? "day18/demoinput5" : "day18/input", "r") do f # demoinput
    line = readline(f)
    ns = []
    total = []
    while line != ""
        push!(ns, parseNumber(line))
        line = readline(f)
    end
    #display(ns)
    #println()

    total = ns[1]
    for i in 2:size(ns,1)
        #println("Working on $i")
        newtotal = []
        push!(newtotal, total)
        push!(newtotal, ns[i])
        snailreduce!(newtotal)
        total = newtotal 
    end
    println(total)

    mag = magnitude(total)
    println("mag = $mag") # 3486

    #testmags()

    #testnumber = parseNumber2("[[[[[9,8],1],2],3],4]")
    #println("TN1: $testnumber")
    #explode!(testnumber)
    #println("TN1: $testnumber")
    #explode!(testnumber)
    #println("TN1: $testnumber")
    #testnumber = parseNumber2("[[[[0,7],4],[[7,8],[0,13]]],[1,1]]")
    #println("TN2: $testnumber")
    
    #testexplodes()
    #testsplits()
    #testreduces()

end


