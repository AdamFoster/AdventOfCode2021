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
    winners = fill(0, size(squares, 3))
    winner = -1 #loser
    winnerindex = 1
    
    callindex = 1
    while reduce(+, winners) < (100*101/2)
        println(reduce(+, winners))
        println(numbersCalled[callindex])
        marks = [mark(squares[x,y,z], numbersCalled[callindex], marks[x,y,z]) for x in 1:5, y in 1:5, z in 1:100]
        #println(squares[:,:,34])
        #println(marks[:,:,34])

        #check winner
        #cols
        for index in 1:size(marks, 3)
            if winners[index] > 0
                # do nothing, already won
            else
                for col in eachcol(marks[:,:,index])
                    if reduce(+,col) == 5
                        winners[index] = winnerindex
                        winner = index
                        winnerindex += 1
                    end
                end
                if winners[index] > 0
                    # do nothing
                else
                    for row in eachrow(marks[:,:,index])
                        if reduce(+,row) == 5
                            winners[index] = winnerindex
                            winner = index
                            winnerindex += 1
                        end
                    end
                end
            end
        end

        callindex += 1
    end

    println()

    #println(squares)
    #println(typeof(squares))
    println(size(winners))

    #println(marks)
    #println(typeof(marks))
    #println(size(marks))

    println(winners)
    #println(squares[:,:,winner])
    #println(marks[:,:,winner])
    #println(squares[:,:,winner] .* marks[:,:,winner])
    winnersum = reduce(+, squares[:,:,winner])
    markedsum = reduce(+, squares[:,:,winner] .* marks[:,:,winner])
    unmarkedsum = winnersum - markedsum

    println(winnersum)
    println(unmarkedsum)
    println(numbersCalled[callindex - 1] * unmarkedsum) # 16836
    
end