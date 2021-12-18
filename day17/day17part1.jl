demo = false

open(demo ? "day17/demoinput" : "day17/input", "r") do f # demoinput
    line = readline(f)
    matches = match(r".*x=([^,]+), y=(.+)", line)
    xlower, xupper = [parse(Int64, x) for x in split(matches[1], "..")]
    ylower, yupper = [parse(Int64, x) for x in split(matches[2], "..")]
    xrange = xlower:xupper
    yrange = ylower:yupper

    println(xrange)
    println(yrange)

    maxy = -ylower*(-ylower-1)/2
    println(maxy) # 19503
end