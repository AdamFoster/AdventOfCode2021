demo = true

open(demo ? "day17/demoinput" : "day17/input", "r") do f # demoinput
    line = readline(f)
    matches = match(r".*x=([^,]+), y=(.+)", line)
    xlower, xupper = [parse(Int64, x) for x in split(matches[1], "..")]
    ylower, yupper = [parse(Int64, x) for x in split(matches[2], "..")]
    xrange = xlower:xupper
    yrange = ylower:yupper

    println(xrange)
    println(yrange)

    done = false
    xs = []
    ys = []
    time = 7
    while !done
        t = time
        r = (2*xlower + t^2 - t) % (2*t)
        r = r==0 ? 0 : 2*t-r
        minvx = Int64((2*xlower + t^2 - t + r) / (2*t))
        println("minvx = $minvx")
        
        maxvx = Int64(trunc((2*xupper + t^2 - t) / (2*t)))
        println("maxvx = $maxvx")

        v = minvx
        display((v*(v+1)/2) - ((v-t) * (v-t+1) / 2))
        println()
        v = maxvx
        display((v*(v+1)/2) - ((v-t) * (v-t+1) / 2))
        println()
        # xpos after t = (v*(v+1)/2) - ((v-t) * (v-t+1) / 2)
        # 2pos = v*(v+1) - (v-t)*(v-t+1)
        # 2pos = v^2 + v - v^2 + vt - v + vt - t^2 + t
        #      = 2vt - t^2 + t
        # 2vt = 2pos + t^2 - t
        # v = (2pos + t^2 - t) / 2t 

        break
    end
end