include("scanner.jl")

demo = true

open(demo ? "day19/demoinput" : "day19/input", "r") do f # demoinput
    line = readline(f)
    while line != ""
        if line[1:3] == "---" #scanner
            id = parse(Int64, line[13:length(line)-4])
            s = Scanner(id)
            line = readline(f)
            while (line != "")
                s = [parse(Int64, x) for x in split(line, ",")]
                line = readline(f)
            end
            display(s)
            println()
            println()
        end
            
        #line = readline(f)
    end
end