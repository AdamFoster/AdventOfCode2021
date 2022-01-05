demo = false

open(demo ? "day25/demoinput" : "day25/input", "r") do f # demoinput
    line = readline(f)
    row = [x=="." ? 0 : (x==">" ? 1 : 2) for x in split(line, "")]
    cucumbers::Matrix{Int} = reshape(row, (length(row), 1))
    line = readline(f)

    while line != ""
        row = [x=="." ? 0 : (x==">" ? 1 : 2) for x in split(line, "")]
        cucumbers = [cucumbers row]
        line = readline(f)
    end

    width = size(cucumbers,1)
    height = size(cucumbers,2)

    display(cucumbers')
    println()

    moves = 0
    done = false
    steps = 0
    while !done
        steps += 1
        rights = [cucumbers[x,y]==1 ? 1 : 0 for x in 1:width, y in 1:height]
        downs = [cucumbers[x,y]==2 ? 2 : 0 for x in 1:width, y in 1:height]

        offsetRights = [rights[width:width, 1:height] ; rights[1:(width-1), 1:height]]
        destinationRights = [offsetRights[x,y]==1 && cucumbers[x,y]==0 ? 1 : 0 for x in 1:width, y in 1:height]
        movableRights = [destinationRights[2:width, 1:height] ; destinationRights[1:1, 1:height]]
        newRights = [destinationRights[x,y] == 1 ? 1 : (
                            movableRights[x,y] == 1 ? 0 : (
                                rights[x,y]
                            ) 
                        )
                        for x in 1:width, y in 1:height]

        cucumbers = [newRights[x,y] + downs[x,y] for x in 1:width, y in 1:height]

        offsetDowns = [downs[1:width, height:height]  downs[1:width, 1:(height-1)]]
        destinationDowns = [offsetDowns[x,y]==2 && cucumbers[x,y]==0 ? 2 : 0 for x in 1:width, y in 1:height]
        movableDowns = [destinationDowns[1:width, 2:height]  destinationDowns[1:width, 1:1]]
        newDowns = [destinationDowns[x,y] == 2 ? 2 : (
                            movableDowns[x,y] == 2 ? 0 : (
                                downs[x,y]
                            ) 
                        )
                        for x in 1:width, y in 1:height]

        #display(downs')
        #println()
        #display(offsetDowns')
        #println()
        #display(destinationDowns')
        #println()
        #display(movableDowns')
        #println()
        #display(newDowns')
        #println()

        cucumbers = [newRights[x,y] + newDowns[x,y] for x in 1:width, y in 1:height]
        moves = length(filter(a->a>0, movableRights)) + length(filter(a->a>0, movableDowns))

        println("Step $steps:")
        if (demo)
            display(cucumbers')
            println("\n")
        end

        if moves == 0
            done = true
        end
    end

    # 453
end