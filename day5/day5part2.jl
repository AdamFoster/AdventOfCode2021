using OffsetArrays

demo = false

open(demo ? "day5/demoinput" : "day5/input", "r") do f # demoinput
    line = readline(f)
    grid = demo ? fill(0, 10, 10) : fill(0, 1000, 1000)
    offsetGrid = demo ? OffsetArray(grid, 0:9, 0:9) : OffsetArray(grid, 0:999, 0:999)
    while line != ""
        println(line)
        p1,p2 = split(line, " -> ")
        x1,y1 = [parse(Int64, a) for a in split(p1, ",")]
        x2,y2 = [parse(Int64, a) for a in split(p2, ",")]
        
        dx = x1==x2 ? 0 : (x1>x2 ? -1 : 1)
        dy = y1==y2 ? 0 : (y1>y2 ? -1 : 1)

        x = x1
        y = y1
        offsetGrid[x,y] += 1
        while x != x2 || y != y2
            x += dx
            y += dy
            offsetGrid[x,y] += 1
        end

        println()
        line = readline(f)
    end
    if demo 
        display(grid) # demoinput
    end
    println()
    println()
    println(reduce(+,grid))
    grid2plus = map(x -> x>1 ? 1 : 0, grid)
    println(reduce(+,grid2plus)) #20898
end