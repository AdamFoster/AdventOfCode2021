using OffsetArrays

mutable struct Instruction
    on::Bool
    xrange::UnitRange{Int64}
    yrange::UnitRange{Int64}
    zrange::UnitRange{Int64}
    Instruction(on::Bool, xrange::UnitRange{Int64}, yrange::UnitRange{Int64}, zrange::UnitRange{Int64}) = new(on, xrange, yrange, zrange)
end

demo = false

function startEngine(instructions::Vector{Instruction})
    engine = fill(0, 101, 101, 101)
    offsetEngine = OffsetArray(engine, -50:50, -50:50, -50:50)

    for inst in instructions
        offsetEngine[inst.xrange, inst.yrange, inst.zrange] .= inst.on
    end

    return engine
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
        xrange = xlower:xupper
        yrange = ylower:yupper
        zrange = zlower:zupper

        if xlower<-50 || ylower<-50 || zlower<-50 || xupper>50 || yupper>50 || zupper>50 
            #pass over this input for now
        else
            push!(instructions, Instruction(on, xrange, yrange, zrange))
        end

        line = readline(f)
    end

    #display(instructions)
    #println()

    engine = startEngine(instructions)
    #display(engine)
    #println()

    println("Total on: $(reduce(+, engine))") # 580098
end

