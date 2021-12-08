#using OffsetArrays

demo = false

open(demo ? "day8/demoinput" : "day8/input", "r") do f # demoinput
    line = readline(f)
    total = 0
    while line != ""
        input, output = split(line, " | ")
        line = readline(f)
        outputs = split(output, " ")
        outputFiltered = [x for x in outputs if length(x) in [2,4,3,7]]
        outputsCount = reduce(+, [1 for x in outputFiltered])
        total += outputsCount

        println("$outputsCount : $output => $outputFiltered")
    end
    println(total) # 495
end