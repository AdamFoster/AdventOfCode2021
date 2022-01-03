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

function process(instructions::Vector{Vector{Instruction}})
    registers::Vector{Int} = fill(0, 4) #w=1,x=2,y=3,z=4
    inps::Vector{Int} = fill(0, length(instructions))
    zs::Vector{Int} = fill(0, length(instructions))

    println("Registers:")
    display(registers)
    println("\n")
    println("Instructions:")
    display(instructions)
    println("\n")
end

function runProgram(instructions::Vector{Vector{Instruction}}, inputs::Vector{Int})
    registers::Vector{Int} = fill(0, 4) #w=1,x=2,y=3,z=4
    inps::Vector{Int} = fill(0, length(instructions))
    zs::Vector{Int} = fill(0, length(instructions))

    for (groupIndex, instructionGroup) in enumerate(instructions)
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

    #process(instructions)



    
#    runProgram(instructions, [parse(Int, c) for c in split("23579246899999", "")])
end