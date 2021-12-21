include("scanner.jl")

demo = false

open(demo ? "day19/demoinput" : "day19/input", "r") do f # demoinput
    line = readline(f)
    scanners = []
    canonicalScanner::Scanner = Scanner(-1)

    while line != ""
        if line[1:3] == "---" #scanner
            id = parse(Int64, line[13:length(line)-4])
            s = Scanner(id)
            line = readline(f)
            while (line != "")
                addBeacon!(s, Beacon([parse(Int64, x) for x in split(line, ",")]))
                line = readline(f)
            end
            calculateDistances!(s)
            push!(scanners, s)

        end
            
        line = readline(f)
    end

    processedScanners = Scanner[]
    s0 = popfirst!(scanners)
    offsetScanner!(s0, [0,0,0])
    push!(processedScanners, s0)
    canonicalScanner.beacons = deepcopy(s0.beacons)
    canonicalScanner.x = 0
    canonicalScanner.y = 0
    canonicalScanner.z = 0
    calculateDistances!(canonicalScanner)
    s0 = canonicalScanner

    while !isempty(scanners)
        s = popfirst!(scanners)
        d0 = s0.distances
        ds = s.distances
        println()
        println("Processing scanner: $(s.id)")

        beaconIndexMatches = []

        for i0 in 1:size(d0, 1)
            bestIndex = 0
            bestCount = 0
            setd0 = Set(d0[i0, :])
            for is in 1:size(ds, 1)
                setds = Set(ds[is,:])
                overlap = intersect(setd0, setds)
                if bestCount < length(overlap)
                    bestCount = length(overlap)
                    bestIndex = is
                end
            end
            if bestCount >= 12
                #println("$i0 = $bestD ($bestCount)") 
                push!(beaconIndexMatches, [i0, bestIndex])
            else
                #println("No good matches: $bestCount")
            end
        end
        println(beaconIndexMatches)

        if length(beaconIndexMatches) < 12
            # no good, try a different beacon
            println("Not enough matches found: $(length(beaconIndexMatches))")
            push!(scanners, s)
        else
            aligned = false
            variants = [x*y*z for x in ["x","y","z"],y in ["+","-"],z in ["0","1","2","3"]]
            for f in [variants...]
                changeFacing!(s, f)
                bmi = beaconIndexMatches
                s0b1 = s0.beacons[bmi[1][1]]
                s0b2 = s0.beacons[bmi[2][1]]
                s0b3 = s0.beacons[bmi[3][1]]
                sxb1 = s.beacons[bmi[1][2]]
                sxb2 = s.beacons[bmi[2][2]]
                sxb3 = s.beacons[bmi[3][2]]
                #println("$(s0b1) - $(sxb1)")
                #println("$(s0b2) - $(sxb2)")
                #println("$(s0b3) - $(sxb3)")
                #println("$(s0b1.x - sxb1.x) | $(s0b2.x - sxb2.x) | $(s0b3.x - sxb3.x)")
                #println("$(s0b1.y - sxb1.y) | $(s0b2.y - sxb2.y) | $(s0b3.y - sxb3.y)")
                #println("$(s0b1.z - sxb1.z) | $(s0b2.z - sxb2.z) | $(s0b3.z - sxb3.z)")

                if s0b1.x - sxb1.x == s0b2.x - sxb2.x == s0b3.x - sxb3.x
                    # right facing
                    # println("x-aligned")
                    if s0b1.y - sxb1.y == s0b2.y - sxb2.y == s0b3.y - sxb3.y
                        # right alignment
                        println("Aligned: $f")
                        offsets = [(s0b1.x - sxb1.x), (s0b2.y - sxb2.y), (s0b3.z - sxb3.z)]
                        println("Before transform $(s0.beacons[bmi[1][1]]) = $(s.beacons[bmi[1][2]])")
                        println("Offset: $offsets")
                        offsetScanner!(s, offsets)
                        println("After transform $(bmi[1][1]):$(s0.beacons[bmi[1][1]]) = $(bmi[1][2]):$(s.beacons[bmi[1][2]])")
                        aligned = true
                        break
                    end
                end
                if !aligned
                    #println("Not aligned: $f")
                end
                
            end
            if !aligned
                println("No alignment found: $(s.id)")
                push!(scanners, s)
            else
                beaconsToAdd = [b for b in s.beacons if !(b in s0.beacons)]
                println("Adding $(length(beaconsToAdd)) beacons")
                append!(s0.beacons, beaconsToAdd)
                calculateDistances!(s0)
                push!(processedScanners, s)
            end
        end

        #if rand() > 0.95
        #    println("Breaking")
        #    break
        #end
    end

    #println()
    #println()
    #display(processedScanners)
    #println()
    println()
    distances = [abs(b2.x-b1.x) + abs(b2.y-b1.y) + abs(b2.z-b1.z) for b1 in processedScanners, b2 in processedScanners]
    println("Max manhattan: $(reduce(max, distances))")
    
end