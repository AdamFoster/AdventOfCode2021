using OffsetArrays

mutable struct Instruction
    on::Bool
    xmin::Int64
    xmax::Int64
    ymin::Int64
    ymax::Int64
    zmin::Int64
    zmax::Int64
end

mutable struct Block
    xmin::Int64
    xmax::Int64
    ymin::Int64
    ymax::Int64
    zmin::Int64
    zmax::Int64
end

demo = true

function startEngine(instructions::Vector{Instruction})
    onblocks = []

    for inst in instructions
        for block in onblocks
            if intersects(block, inst)
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
        push!(instructions, Instruction(on, xlower, xupper, ylower, yupper, zlower, zupper))
        line = readline(f)
    end

    engine = startEngine(instructions)

    #println("Total on: $(reduce(+, engine))") # 580098
end

