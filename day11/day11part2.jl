using OffsetArrays

demo = false

open(demo ? "day11/demoinput" : "day11/input", "r") do f # demoinput

    line = readline(f)
    octopodes = parse.(Int64, split(line, ""))
    line = readline(f)
    while line != ""
        octopodes = [octopodes parse.(Int64, split(line, ""))]
        line = readline(f)
    end
    s1 = size(octopodes, 1)
    s2 = size(octopodes, 2)

    allflash = false
    i = 0

    while !allflash
        octopodes = [octopodes[x,y]+1 for x in 1:s1, y in 1:s2] # step 1: Increment
        flashed = fill(0, size(octopodes))
        
        flashing = true #step 2. Propogate flashes
        while flashing
            nextflashed = [(octopodes[x,y]>9 && flashed[x,y] == 0) ? 1 : 0 for x in 1:s1, y in 1:s2]
            nextflashed = [fill(0, size(nextflashed, 1)) nextflashed fill(0, size(nextflashed, 1))]
            nextflashed = [fill(0, 1, size(nextflashed, 2)) ; nextflashed  ; fill(0, 1, size(nextflashed, 2))]
            nextflashed = OffsetArray(nextflashed, 0:(size(nextflashed,1)-1), 0:(size(nextflashed,2)-1))
    
            if reduce(+, nextflashed) == 0
                flashing = false
            else
                # propogate flash
                octopodes = [reduce(+, nextflashed[x-1:x+1, y-1:y+1]) + octopodes[x,y] for x in 1:s1, y in 1:s2]
            end
            flashed = [flashed[x,y]+nextflashed[x,y] for x in 1:s1, y in 1:s2]
        end
        if reduce(+, flashed) == reduce(*, size(octopodes))
            allflash = true
        else
            println("Not all flash on $i")
        end

        octopodes = [octopodes[x,y]>9 ? 0 : octopodes[x,y] for x in 1:s1, y in 1:s2] # step 3: reset > 9 to 0
        i += 1
    end

    display(octopodes)
    println()
    println("All flashed on round $i") # 320
end