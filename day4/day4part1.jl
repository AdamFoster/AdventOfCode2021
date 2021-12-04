function mark(input, call, previous)
    return previous || input == call
end

open("day4/input", "r") do f
    numbersCalled = [parse(Int64, x) for x in split(readline(f), ",")]
    
    readline(f) #chomp empty line

    squares = missing

    while !eof(f)
        sq = missing
        row = readline(f)
        while row != ""
            parsedRow = [parse(Int64, x) for x in split(strip(row), r" +")]
            sq = ismissing(sq) ? parsedRow : sq = [sq parsedRow]
            row = readline(f)
        end
        squares = ismissing(squares) ? sq : cat(squares, sq, dims=3)
    end

    #squares = cat(squares, fill(false, size(squares)), dims=4) #size(squares,1), size(squares,2), size(squares,3))
    marks = fill(false, size(squares))
    
    winner = -1
    callindex = 1
    while winner < 0
        println(numbersCalled[callindex])
        marks = [mark(squares[x,y,z], numbersCalled[callindex], marks[x,y,z]) for x in 1:5, y in 1:5, z in 1:100]
        println(squares[:,:,34])
        println(marks[:,:,34])

        #check winner
        #cols
        for index in 1:size(marks, 3)
            for col in eachcol(marks[:,:,index])
                if reduce(+,col) == 5
                    winner = index
                end
            end
            for row in eachrow(marks[:,:,index])
                if reduce(+,row) == 5
                    winner = index
                end
            end
        end

        callindex += 1
    end

    println()

    #println(squares)
    #println(typeof(squares))
    #println(size(squares))

    #println(marks)
    #println(typeof(marks))
    #println(size(marks))

    println(winner)
    println(squares[:,:,winner])
    println(marks[:,:,winner])
    println(squares[:,:,winner] .* marks[:,:,winner])
    winnersum = reduce(+, squares[:,:,winner])
    markedsum = reduce(+, squares[:,:,winner] .* marks[:,:,winner])
    unmarkedsum = winnersum - markedsum

    println(winnersum)
    println(unmarkedsum)
    println(numbersCalled[callindex - 1] * unmarkedsum) # 38913
    
end