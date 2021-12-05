using OffsetArrays

#open("day5/demoinput", "r") do f # demoinput
open("day5/input", "r") do f
    line = readline(f)
    grid = fill(0, 1000, 1000)
    offsetGrid = OffsetArray(grid, 0:999, 0:999)
    #grid = fill(0, 10, 10) # demoinput
    #offsetGrid = OffsetArray(grid, 0:9, 0:9) # demoinput
    while line != ""
        p1,p2 = split(line, " -> ")
        x1,y1 = [parse(Int64, a) for a in split(p1, ",")]
        x2,y2 = [parse(Int64, a) for a in split(p2, ",")]
        if x1 == x2
            #println("$x1,$y1 -> $x2,$y2")
            for y in min(y1,y2):max(y1,y2)
                offsetGrid[x1,y] += 1
            end
        elseif y1 == y2
            #println("$x1,$y1 -> $x2,$y2")
            for x in min(x1,x2):max(x1,x2)
                offsetGrid[x,y1] += 1
            end
        end
        line = readline(f)
    end
    #print(grid)
    println(reduce(+,grid))
    #grid2plus = filter(x -> x>1, grid) #4210
    grid2plus = map(x -> x>1 ? 1 : 0, grid)
    println(reduce(+,grid2plus)) #7674
    

    #println(grid)
end