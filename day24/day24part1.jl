# PLAN
# create 14 machines
# working backwards, starting with d14 = 9 find out what values of z[14] are valid
# find out which values of z[13] and d[13] make z[14] valid
# etc for z[12] and d[12] ....

demo = false

global R = Dict("w"=>1, "x"=>2, "y"=>3, "z"=>4)
global F = Dict("add"=>+, "mul"=>*, "div"=>div, "mod"=>%, "eql"=>(a,b)->(a==b ? 1 : 0))

@enum InstructionType begin
    literal = 1
    register = 2
end

mutable struct Instruction
    type::String
    f::Function
    target::String
    source::Union{Int, String}
    Instruction(type::String, target::String, source::Union{Int, String}) = new(type, F[type], target, source)
end

function process(instructionGroups::Vector{Vector{Instruction}})
    registers::Vector{Int} = fill(0, 4) #w=1,x=2,y=3,z=4
    inps::Vector{Int} = fill(9, length(instructionGroups))
    zs::Vector{Int} = fill(0, length(instructionGroups))

    cache = Dict{Int, Dict{Int, Vector{Int}}}() 
    cache[0] = Dict{Int, Vector{Int}}(0=>[0, 0, 0]) #group[0] z=0 maxinp=0, [input, zprev, max]

    # idea - change direction of this loop - go from 9999.....11111 instead of 1-9, 1-9....
    done = false
    while !done
        for (igIndex, ig) in enumerate(instructionGroups)
            cache[igIndex] = Dict{Int, Vector{Int}}()
            
            for z in keys(cache[igIndex-1])
                for inp in 1:9
                    regs = runGroup(ig, z, inp)
                    #println("$igIndex @ ($inp,$z) -> $(regs[4])")
                    localmax = cache[igIndex-1][z][3]*10 + inp
                    if haskey(cache[igIndex], regs[4])
                        if localmax > cache[igIndex][regs[4]][3]
                            cache[igIndex][regs[4]] = [inp, z, localmax]
                        end
                    else
                        cache[igIndex][regs[4]] = [inp, z, localmax]
                    end
                end
            end

            println("Cache size @$igIndex = $(length(cache[igIndex]))")
            debug = 0
            if igIndex == debug
                println("Cache:")
                display(cache[debug])
                println("\n\nCache size = $(length(cache[debug]))")
                    break
            end
        end

        done = true
    end

    zprev = 0
    for i in length(instructionGroups):-1:1
        println("i: $(cache[i][zprev])")
        zprev = cache[i][zprev][2]
    end

    #println("Registers:")
    #display(registers)
    #println("\n")
    #println("Instructions:")
    #display(instructionGroups)
    #println("\n")
end

function runGroup(instructions::Vector{Instruction}, z::Int, input::Int)::Vector{Int}
    registers = fill(0, 4)
    registers[1] = input
    registers[4] = z
    for inst in instructions
        if inst.source isa String # register
            registers[R[inst.target]] = inst.f(registers[R[inst.target]], registers[R[inst.source]])
        else # literal
            registers[R[inst.target]] = inst.f(registers[R[inst.target]], inst.source)
        end
    end
    return registers
end

function runGroup(instructions::Vector{Instruction}, initialRegisters::Vector{Int}, input::Int)::Vector{Int}
    registers = deepcopy(initialRegisters)
    registers[R["w"]] = input
    for inst in instructions
        if inst.source isa String # register
            registers[R[inst.target]] = inst.f(registers[R[inst.target]], registers[R[inst.source]])
        else # literal
            registers[R[inst.target]] = inst.f(registers[R[inst.target]], inst.source)
        end
    end
    return registers
end

function runProgram(instructionGroups::Vector{Vector{Instruction}}, inputs::Vector{Int})
    registers::Vector{Int} = fill(0, 4) #w=1,x=2,y=3,z=4
    inps::Vector{Int} = fill(0, length(instructionGroups))
    zs::Vector{Int} = fill(0, length(instructionGroups))

    for (groupIndex, instructionGroup) in enumerate(instructionGroups)
        registers[R["w"]] = inputs[groupIndex]
        for inst in instructionGroup
            if inst.source isa String # register
                registers[R[inst.target]] = inst.f(registers[R[inst.target]], registers[R[inst.source]])
            else # literal
                registers[R[inst.target]] = inst.f(registers[R[inst.target]], inst.source)
            end
        end
    end
    return registers
    #println("Registers:")
    #display(registers)
    #println("\n")
end

function bruteForce(instructions::Vector{Vector{Instruction}})
    z = 1
    serial = 99999999999999
    while z != 0
        if serial%10000 == 0
            println("Serial: $serial")
        end

        test = serial
        testArray = Vector{Int}()
        while test > 0
            pushfirst!(testArray, test%10)
            test = div(test, 10)
        end
        #println(testArray)
        registers = runProgram(instructions, testArray)
        z = registers[R["z"]]

        serial -= 1
    end
    println("Ending-1 serial: $serial")
end

open(demo ? "day24/demoinput" : "day24/input", "r") do f # demoinput
    instructions::Vector{Vector{Instruction}} = Vector{Vector{Instruction}}()
    instructionBatch::Vector{Instruction} = Vector{Instruction}()

    line = readline(f)
    line = readline(f)
    while line != ""
        if line[1:3] == "inp"
            push!(instructions, instructionBatch)
            instructionBatch = Vector{Instruction}()
        else
            source = line[7:length(line)]
            source = tryparse(Int, source) !== nothing ? parse(Int, source) : source 
            push!(instructionBatch, Instruction(line[1:3], line[5:5], source))
        end
        line = readline(f)
    end
    push!(instructions, instructionBatch)

    process(instructions) # 93499629698999

    # registers = runProgram(instructions, [parse(Int, c) for c in split("31497418154473", "")]) # 31497418154473 is too low
#    display(registers)
    println()
end