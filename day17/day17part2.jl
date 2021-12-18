demo = false

function xdistance(t, v)
    if (t>=v)
        return (v*(v+1)/2)
    else
        return (v*(v+1)/2) - ((v-t) * (v-t+1) / 2)
    end
end

function ydistance(t, v)
    return v * t - t*(t-1)/2
end

open(demo ? "day17/demoinput" : "day17/input", "r") do f # demoinput
    line = readline(f)
    matches = match(r".*x=([^,]+), y=(.+)", line)
    xlower, xupper = [parse(Int64, x) for x in split(matches[1], "..")]
    ylower, yupper = [parse(Int64, x) for x in split(matches[2], "..")]
    xrange = xlower:xupper
    yrange = ylower:yupper

    println(xrange)
    println(yrange)

    total = 0
    combos = Set()
    for time in 1:(1-2*ylower)
        println("*** Time = $time ***")
        xs = []
        ys = []

        # calculate y velocities
        vymin = (ylower:-ylower)[searchsortedfirst(ylower:-ylower, 99999, lt=(v1,v2)->(ydistance(time, v1)<ylower))] # && xdistance(time, v2)<xlower))
        println("vymin = $vymin, ydist = $(ydistance(time, vymin))")

        vymax = (yupper:-ylower)[searchsortedfirst(yupper:-ylower, 99999, lt=(v1,v2)->(ydistance(time, v1)<yupper))] # && xdistance(time, v2)<xlower))
        while ydistance(time, vymax) > yupper
            vymax -= 1
        end
        println("vymax = $vymax, ydist = $(ydistance(time, vymax))")
        if ylower <= ydistance(time, vymax) <= yupper && ylower <= ydistance(time, vymin) <= yupper 
            append!(ys, vymin:vymax)
            println("ys = $ys")
            #println()
        end
        
        # calculate x velocities
        vxmin = searchsortedfirst(1:xlower, 99999, lt=(v1,v2)->(xdistance(time, v1)<xlower)) # && xdistance(time, v2)<xlower))
        println("vxmin = $vxmin, xdist = $(xdistance(time, vxmin))")
        
        vxmax = searchsortedfirst(1:xupper, 99999, lt=(v1,v2)->(xdistance(time, v1)<xupper)) # && xdistance(time, v2)<xupper))
        while xdistance(time, vxmax) > xupper
            vxmax -= 1
        end
        println("vxmax = $vxmax, xdist = $(xdistance(time, vxmax))")
        if xlower <= xdistance(time, vxmax) <= xupper && xlower <= xdistance(time, vxmin) <= xupper 
            append!(xs, vxmin:vxmax)
            println("xs = $xs")
            #println()
        end

        println("Adding $(size(xs,1)*size(ys,1))")
        total += size(xs,1)*size(ys,1)
        toadd = [[x,y] for x in xs, y in ys]
        if length(intersect(combos, toadd)) > 0
            println("Intersection: $(intersect(combos, toadd))")
        end
        union!(combos, toadd)
        #break
        println()
    end
    println("Raw Total $total")
    println("Total $(length(combos))")
end