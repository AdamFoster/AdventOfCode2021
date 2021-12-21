mutable struct Beacon
    x::Int
    y::Int
    z::Int
    Beacon(x::Int, y::Int, z::Int) = new(x, y, z)
    Beacon(a::Array{Int}) = new(a[1], a[2], a[3])
end

import Base.==
==(a::Beacon,b::Beacon) = a.x==b.x && a.y==b.y && a.z==b.z


mutable struct Scanner
    id::Int
    x::Union{Int, Missing}
    y::Union{Int, Missing}
    z::Union{Int, Missing}
    facing::String
    beacons::Array{Beacon}
    originalBeacons::Array{Beacon}
    distances::Array{Int64, 2} #actually distances squared
    Scanner(id) = new(id, missing, missing, missing, "x+", Beacon[], Beacon[], Array{Int64}(undef, 0, 0))# Array{Float64, 2}())
end

function addBeacon!(scanner::Scanner, beacon::Beacon)
    push!(scanner.beacons, beacon)
    push!(scanner.originalBeacons, beacon)
end

function calculateDistances!(scanner::Scanner)
    scanner.distances = [(b2.x-b1.x)^2 + (b2.y-b1.y)^2 + (b2.z-b1.z)^2 for b1 in scanner.beacons, b2 in scanner.beacons]
end

function changeFacing!(scanner::Scanner, facingAxis::String, facingDirection::String)
    if facingAxis == "x"
        scanner.beacons = deepcopy(scanner.originalBeacons)
    elseif facingAxis == "y"
        scanner.beacons = [Beacon(-b.y,b.x,b.z) for b in scanner.originalBeacons]
    elseif facingAxis == "z"
        scanner.beacons = [Beacon(-b.z,b.y,b.x) for b in scanner.originalBeacons]
    else
        error("Invalid facing axis $facingAxis")
    end

    if facingDirection == "-"
        scanner.beacons = [Beacon(-b.x,b.y,-b.z) for b in scanner.beacons]
    elseif facingDirection == "+" #do nothing
    else
        error("Invalid facing direction $facingDirection")
    end

    scanner.facing = facingAxis*facingDirection
end

function changeFacing!(scanner::Scanner, facing::String)
    changeFacing!(scanner, facing[1:1], facing[2:2])
    rotateFacing!(scanner, parse(Int64, facing[3:3]))
end

function rotateFacing!(scanner::Scanner, times::Int)
    if times == 0
        scanner.beacons = [Beacon(b.x, b.y, b.z) for b in scanner.beacons]
    elseif times == 1
        scanner.beacons = [Beacon(b.x, b.z, -b.y) for b in scanner.beacons]
    elseif times == 2
        scanner.beacons = [Beacon(b.x, -b.y, -b.z) for b in scanner.beacons]
    elseif times == 3
        scanner.beacons = [Beacon(b.x, -b.z, b.y) for b in scanner.beacons]
    else
        error("Can't rotate $times")
    end
end

function offsetScanner!(scanner::Scanner, offset::Array{Int})
    scanner.beacons = [Beacon(b.x+offset[1], b.y+offset[2], b.z+offset[3]) for b in scanner.beacons]
    scanner.x = offset[1]
    scanner.y = offset[2]
    scanner.z = offset[3]
end

function test()
    s = Scanner(0)
    addBeacon!(s, Beacon(1,2,3))
    addBeacon!(s, Beacon(2,3,4))
    calculateDistances!(s)
    display(s)
    println()
end

#test()
