mutable struct Scanner
    id::Int64
    x::Int64
    y::Int64
    z::Int64
    beacons::Array{Vector{Int64}}
    Scanner(id) = new(id, missing, missing, missing, Array{Vector{Int64}}())
end

mutable struct Beacon
    x::Int64
    y::Int64
    z::Int64
    Beacon(x, y, z) = new(x, y, z)
end

function addBeacon!(scanner::Scanner, beacon::Beacon)
    push!(scanner.beacons, beacon)
end