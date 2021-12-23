using OffsetArrays

mutable struct Block
    xmin::Int64
    xmax::Int64
    ymin::Int64
    ymax::Int64
    zmin::Int64
    zmax::Int64
end

mutable struct Instruction
    on::Bool
    block::Block
end

import Base.==
==(a::Block,b::Block) = a.xmin==b.xmin && a.xmax==b.xmax && a.ymin==b.ymin && a.ymax==b.ymax && a.zmin==b.zmin && a.zmax==b.zmax

function help()
    println("Help!")
end

function intersects(a::Block, b::Block)
    return (a.xmin <= b.xmax && a.xmax >= b.xmin) &&
           (a.ymin <= b.ymax && a.ymax >= b.ymin) &&
           (a.zmin <= b.zmax && a.zmax >= b.zmin);
end




function splitAbyB(asource::Block, b::Block)
    a = deepcopy(asource)
    splitblocks = []
    if (a.xmax > b.xmax) #rightmost portion
        push!(splitblocks, Block(b.xmax+1, a.xmax, a.ymin, a.ymax, a.zmin, a.zmax))
        a.xmax = b.xmax # resize what's left of the block
    end
    if (a.xmin < b.xmin) #leftmost portion
        push!(splitblocks, Block(a.xmin, b.xmin-1, a.ymin, a.ymax, a.zmin, a.zmax))
        a.xmin = b.xmin # resize what's left of the block
    end
    #A block should now be right sized or smaller on x-axis
    if (a.ymax > b.ymax) #upper portion
        push!(splitblocks, Block(a.xmin, a.xmax, b.ymax+1, a.ymax, a.zmin, a.zmax))
        a.ymax = b.ymax # resize what's left of the block
    end
    if (a.ymin < b.ymin) #leftmost portion
        push!(splitblocks, Block(a.xmin, a.xmax, a.ymin, b.ymin-1, a.zmin, a.zmax))
        a.ymin = b.ymin # resize what's left of the block
    end
    #A block should now be right sized or smaller on x and y-axis
    if (a.zmax > b.zmax) #upper portion
        push!(splitblocks, Block(a.xmin, a.xmax, a.ymin, a.ymax, b.zmax+1, a.zmax))
        a.zmax = b.zmax # resize what's left of the block
    end
    if (a.zmin < b.zmin) #leftmost portion
        push!(splitblocks, Block(a.xmin, a.xmax, a.ymin, a.ymax, a.zmin, b.zmin-1))
        a.ymin = b.ymin # resize what's left of the block
    end
    return splitblocks
end

demo = true

# Algo:
# Check if instruction intersects with existing blocks
# - if not, add instruction if it is an on
# - if intersection
#    - if instruction is on, split incoming block
#    - else instruction is off, split existing block
function startEngine(instructions::Vector{Instruction})
    onblocks = []

    for inst in instructions
        if inst.on # turn on - add blocks to onblocks
            blocksToAdd = Block[inst.block] # this should always be a disjoint set
            for block::Block in onblocks
                addedPieces = Block[]
                removedBlocks = Block[]
                for blockToAdd::Block in blocksToAdd
                    if intersects(block, blockToAdd)
                        println("On Intersection between $block and $blockToAdd")
                        append!(addedPieces, splitAbyB(blockToAdd, block)) # split the incoming block - remove the part of it that already exists
                        push!(removedBlocks, blockToAdd) # mark the original as to be removed
                    end
                end
                filter!(b->!(b in removedBlocks), blocksToAdd)
                append!(blocksToAdd, addedPieces)
            end
            append!(onblocks, blocksToAdd)
        else # turn off - split block in onblocks
            #fill in some magic here
            addedPieces = Block[]
            removedBlocks = Block[]
            for block in onblocks
                if intersects(block, inst.block)
                    println("Off Intersection between $block and $(inst.block)")
                    splitBlocks = splitAbyB(block, inst.block)
                    append!(addedPieces, splitBlocks)
                    push!(removedBlocks, block)
                end
            end
            filter!(b->!(b in removedBlocks), onblocks)
            append!(onblocks, addedPieces)
        end
    end

    return onblocks
end


open(demo ? "day22/demoinput" : "day22/input", "r") do f # demoinput
    help()
    line = readline(f)

    instructions = Instruction[]

    while line != ""
        matches = match(r"^([^ ]+) x=([^,]+),y=([^,]+),z=(.+)", line)
        on = (matches[1] == "on")
        xlower, xupper = [parse(Int64, x) for x in split(matches[2], "..")]
        ylower, yupper = [parse(Int64, x) for x in split(matches[3], "..")]
        zlower, zupper = [parse(Int64, x) for x in split(matches[4], "..")]
        #xrange = xlower:xupper
        #yrange = ylower:yupper
        #zrange = zlower:zupper
        push!(instructions, Instruction(on, Block(xlower, xupper, ylower, yupper, zlower, zupper)))
        line = readline(f)
    end

    engine = startEngine(instructions)
    println("Engine:")
    display(engine)
    println("\n")
    total = 0
    for b in engine
        total += (b.xmax-b.xmin+1)*(b.ymax-b.ymin+1)*(b.zmax-b.zmin+1)
    end
    println("Total on: $(total)") # 
end

function test()
    println("Test splitting block on corner")
    b1 = Block(0,1,0,1,0,1)
    b2 = Block(0,2,0,2,0,2)
    s = splitAbyB(b2, b1)
    display(s)
    println("\n")

    println("Test block that shouldn't have anything left")
    b1 = Block(0,1,0,1,0,1)
    b2 = Block(0,2,0,2,0,2)
    s = splitAbyB(b1, b2)
    display(s)
    println()

    println("Test block split in middle")
    b1 = Block(0,1,0,1,0,1)
    b2 = Block(-1,2,-1,2,-1,2)
    s = splitAbyB(b2, b1)
    display(s)
    println()
end

#test()