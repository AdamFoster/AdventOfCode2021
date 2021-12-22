using OffsetArrays

mutable struct Instruction
    on::Bool
    block::Block
end

mutable struct Block
    xmin::Int64
    xmax::Int64
    ymin::Int64
    ymax::Int64
    zmin::Int64
    zmax::Int64
end

import Base.==
==(a::Block,b::Block) = a.xmin==b.xmin && a.xmax==b.xmax &&
                        a.ymin==b.ymin && a.ymax==b.ymax &&
                        a.zmin==b.zmin && a.zmax==b.zmax &&


function intersect(a::Block, b::Block)
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
            blocksToAdd = [inst.block] # this should always be a disjoint set
            for block in onblocks
                addedPieces = Block[]
                removedBlocks = Block[]
                for blockToAdd in blocksToAdd
                    if intersects(block, blockToAdd)
                        println("On Intersection between $block and $blockToAdd")
                        append!(addedPieces, splitAbyB(blockToAdd, block)) # split the incoming block - remove the part of it that already exists
                        push!(removedBlocks, blockToAdd)
                    end
                end
                filter!(b->!(b in removedBlocks), blocksToAdd)
                append!(blocksToAdd, addedPieces)
            end
        else
            blocksToRemove = []
            #fill in some magic here
            for r in blocksToRemove
                filter!(a->a!=r, onblocks)
            end
        end
    end



    return 1
end

open(demo ? "day22/demoinput" : "day22/input", "r") do f # demoinput
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

    #println("Total on: $(reduce(+, engine))") # 580098
end

