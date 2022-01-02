using DataStructures

demo = true

VALID_CORRIDORS = Set([1,2,4,6,8,10,11])
ROOM_SIZE = 4

mutable struct Room
    type::Int
    contents::Array{Int}
    corridorAttachment::Int
    Room(type::Int, stringContents::String) = new(type, [Int(Char(c))-Int('A')+1 for c in reverse(stringContents)], 2*type+1)
    Room(type::Int, contents::Array{Int}) = new(type, contents, 2*type+1)
end

mutable struct Move
    rooms::Vector{Room}
    corridor::Array
    cost::Int
end

import Base.==
==(a::Move,b::Move) = a.rooms==b.rooms && a.corridor==b.corridor
==(a::Room,b::Room) = a.type==b.type && a.contents==b.contents

Base.hash(m::Move, h::UInt) = Base.hash(m.rooms, h) + Base.hash(m.corridor, h)
Base.isequal(a::Move,b::Move) = a == b

function printmoves(moves::Vector{Move})
    for m in moves
        printmove(m)
    end
end

function printmove(m::Move)
    for r in m.rooms
        rc = deepcopy(r.contents)
        append!(rc, fill(0, ROOM_SIZE))
        for i in 1:ROOM_SIZE
            print(rc[i])
        end
        print(" ")
    end
    print(": ")
    for c in m.corridor
        print(c)
    end
    print(" = $(m.cost)")
    println()
end

function attachmentPoint(letter::Int)
    return 2*letter+1
end

function roomsDone(rooms::Vector{Room})
    done = true
    for i in 1:length(rooms)
        if count(x->x!=i, rooms[i].contents) > 0 # check if room has non-native elements
            done = false
            break
        end
    end
    return done
end

function possibleCorridorMoves(rooms::Vector{Room}, corridor::Vector{Int}, corridorIndex::Int)
    moves = Vector{Move}()
    minEmptyCorridor = corridorIndex
    maxEmptyCorridor = corridorIndex
    letter = corridor[corridorIndex]
    if letter == 0
        return moves
    end

    for i in corridorIndex-1:-1:1
        if corridor[i] > 0
            break
        end
        minEmptyCorridor = i
    end
    for i in corridorIndex+1:length(corridor)
        if corridor[i] > 0
            break
        end
        maxEmptyCorridor = i
    end

    if rooms[letter].corridorAttachment in minEmptyCorridor:maxEmptyCorridor
        # destination room is in the right range
        # check room is empty or contains only matching letters
        if length(filter(x->x!=letter, rooms[letter].contents)) == 0 && length(rooms[letter].contents) < ROOM_SIZE
            #valid move
            moverooms = deepcopy(rooms)
            push!(moverooms[letter].contents, letter)
            movecorridor = deepcopy(corridor)
            movecorridor[corridorIndex] = 0
            movecost = 10^(letter-1) * (abs(corridorIndex-rooms[letter].corridorAttachment) + ROOM_SIZE-length(rooms[letter].contents))
            move = Move(moverooms, movecorridor, movecost) #rooms, corridor, cost
            push!(moves, move)
            #println("Possible corridor[$corridorIndex] to room move: $move")
        else
            #println("Room $(rooms[letter]) not valid target for $letter at corridor $corridorIndex")
        end
    end 

    return moves
end

function possibleRoomMoves(rooms::Vector{Room}, corridor::Vector{Int}, roomNumber::Int)
    moves = Vector{Move}()

    if length(filter(x->x==roomNumber, rooms[roomNumber].contents)) == ROOM_SIZE
        #println("Room $roomNumber is done: $(rooms[roomNumber])")
        return moves
    end
    if length(filter(x->x!=roomNumber, rooms[roomNumber].contents)) == 0
        #println("Room $roomNumber contains only $roomNumber: $(rooms[roomNumber])")
        return moves
    end
    if length(rooms[roomNumber].contents) == 0
        return moves
    end

    corridorAttachment = rooms[roomNumber].corridorAttachment

    minEmptyCorridor = corridorAttachment
    maxEmptyCorridor = corridorAttachment
    letter = last(rooms[roomNumber].contents)
    if letter == 0
        println("!!! Why does room $roomNumber have a 0? $rooms")
        exit()
        return moves
    end

    for i in corridorAttachment-1:-1:1
        if corridor[i] > 0
            break
        end
        minEmptyCorridor = i
    end
    for i in corridorAttachment+1:length(corridor)
        if corridor[i] > 0
            break
        end
        maxEmptyCorridor = i
    end

    # check if it can go straight to the right room
    if attachmentPoint(letter) in minEmptyCorridor:maxEmptyCorridor # the target room is not blocked
        if length(rooms[letter].contents) < ROOM_SIZE # there is room
            if length(filter(x->x!=letter, rooms[letter].contents)) == 0 # there isn't anything else incorrect in the room
                distance = abs(attachmentPoint(letter)-corridorAttachment) # corridor distance
                distance += 2*ROOM_SIZE - length(rooms[letter].contents) - length(rooms[roomNumber].contents) + 1 #room depth
                moverooms = deepcopy(rooms)
                pop!(moverooms[roomNumber].contents)
                push!(moverooms[letter].contents, letter)
                movecorridor = deepcopy(corridor)
                movecost = 10^(letter-1) * distance
                move = Move(moverooms, movecorridor, movecost) #rooms, corridor, cost
                push!(moves, move)
                return moves
            end
        end
    end

    # room to corridor move
    possibleDestinations = intersect(VALID_CORRIDORS, minEmptyCorridor:maxEmptyCorridor)
    for c in possibleDestinations
        distance = abs(c-corridorAttachment) + ROOM_SIZE - length(rooms[roomNumber].contents) + 1

        moverooms = deepcopy(rooms)
        pop!(moverooms[roomNumber].contents)
        movecorridor = deepcopy(corridor)
        movecorridor[c] = letter
        movecost = 10^(letter-1) * distance
        move = Move(moverooms, movecorridor, movecost) #rooms, corridor, cost
        push!(moves, move)
        #println("Possible room[$roomNumber] to corridor move: $move")
    end

    #room to room move

    return moves
end


function possibleMoves(rooms::Vector{Room}, corridor::Vector{Int})::Vector{Move}
    moves = Vector{Move}()

    for ci in 1:length(corridor)
        if corridor[ci] > 0
            # something is in this room
            append!(moves, possibleCorridorMoves(rooms, corridor, ci))
        end
    end
    for r in rooms
        append!(moves, possibleRoomMoves(rooms, corridor, r.type))
    end
    return moves
end


function minCost(rooms::Vector{Room}, corridor::Vector{Int}, depth::Int)
    #println("Depth: $depth. Corridor: $corridor. Rooms: $rooms")
    if count(c->c>0, corridor) == 0 && roomsDone(rooms)
        return 0
    else
        cost = 0
        pms = possibleMoves(rooms, corridor)
        if length(pms) == 0
            #println("No possible moves for $rooms $corridor")
            cost = typemax(Int32)
        else
            #println("Possible moves:")
            #display(pms)
            #println()
            #println()
            for m in pms
                #exit()
                mcost = minCost(m.rooms, m.corridor, depth+1) + m.cost
                if mcost < cost
                    cost = mcost
                end
            end
        end
        return cost
    end
end

function h(m::Move)
    hcost = 0

    #letters in the corridor costs
    for i in 1:length(m.corridor)
        if m.corridor[i] != 0
            letter = m.corridor[i]
            hcost += 10^(letter-1) * (abs(attachmentPoint(letter) - i) + 1)
            #movecost = 10^(letter-1) * (abs(corridorIndex-rooms[letter].corridorAttachment) + ROOM_SIZE-length(rooms[letter].contents))
        end
    end

    #room costs
    for r in 1:length(m.rooms)
        for i in 1:length(m.rooms[r].contents)
            if m.rooms[r].contents[i] != r
                letter = m.rooms[r].contents[i]
                cost = 10^(letter-1) * (abs(attachmentPoint(letter) - attachmentPoint(r)) + 1 + ROOM_SIZE-i+1)
                hcost += cost
            end
        end
    end

    return hcost
end

function reconstruct_path(cameFrom, current)
    total_path = [current]
    while haskey(cameFrom, current)
        current = cameFrom[current]
        pushfirst!(total_path, current)
    end
    return total_path
end

function astar(start::Move, goal::Move)
    openSet = PriorityQueue{Move, Int}()
    enqueue!(openSet, start, 0)

    cameFrom = Dict{Move, Move}()

    gScore = Dict{Move, Int}() # defaults to infinity
    gScore[start] = 0

    fScore = Dict{Move, Int}() # defaults to infinity
    fScore[start] = h(start)

    while length(openSet) > 0
        current = dequeue!(openSet)
        if current == goal
            return reconstruct_path(cameFrom, current)
            #display(cameFrom)
        end

        neighbours::Vector{Move} = possibleMoves(current.rooms, current.corridor)
        for n::Move in neighbours
            tentative_gScore = haskey(gScore, current) ? (gScore[current] + n.cost) : typemax(Int32)
            if !haskey(gScore, n) || tentative_gScore < gScore[n]
                cameFrom[n] = current
                gScore[n] = tentative_gScore
                fScore[n] = tentative_gScore + h(n)
                if !haskey(openSet, n)
                    enqueue!(openSet, n, tentative_gScore + h(n))
                else
                    openSet[n] = tentative_gScore + h(n)
                end
            end
        end
    end
    println("Couldn't find valid path")
end

function process(initialRooms::Array{String})
    done = false
    corridor = fill(0, 11)
    rooms = [Room(r, initialRooms[r]) for r in 1:4]
    endrooms = [Room(r, fill(r, ROOM_SIZE)) for r in 1:4]

    display(rooms)
    println()

    #cost = minCost(rooms, corridor, 0)
    path = astar(Move(rooms, corridor, 0), Move(endrooms, corridor, 0)) 

    println()
    println("***")
    printmoves(path)
    println()
    println("***")
    totalCost = 0
    for m::Move in path
        totalCost += m.cost
    end
    println("Total Cost = $totalCost")
end


function testdemo()
    process(["BDDA", "CCBD", "BBAC", "DACA"])
end

function testreal()
    process(["ADDD", "CCBD", "BBAB", "AACC"])
end

function testPossibleCorridorMoves()
    corridor = fill(0, 11)
    rooms = [Room(r, ["BA", "CD", "BC", "DA"][r]) for r in 1:4]
    moves = possibleCorridorMoves(rooms, corridor, 1)
    println("Empty corridor: $moves should be empty")
    println()

    corridor[1] = 1
    moves = possibleCorridorMoves(rooms, corridor, 1)
    println("Full room: $moves should be empty")
    println()

    rooms[1].contents = [4]
    moves = possibleCorridorMoves(rooms, corridor, 1)
    println("Invalid room: $moves should be empty")
    println()

    rooms[1].contents = [1]
    moves = possibleCorridorMoves(rooms, corridor, 1)
    println("Valid room: $moves should be move to 1")
    println()

    corridor[2] = 2
    moves = possibleCorridorMoves(rooms, corridor, 1)
    println("Blocked corridor: $moves should be empty")
    println()

    moves = possibleCorridorMoves(rooms, corridor, 2)
    println("Full room: $moves should be empty")
    println()

    rooms[2].contents = [1]
    moves = possibleCorridorMoves(rooms, corridor, 2)
    println("Invalid room contents: $moves should be empty")
    println()
    
    rooms[2].contents = []
    moves = possibleCorridorMoves(rooms, corridor, 2)
    println("Empty room success: $moves should be to 2")
    println()
    
end



function testPossibleRoomMoves()
    corridor = fill(0, 11)
    rooms = [Room(r, ["BA", "CD", "BC", "DA"][r]) for r in 1:4]
    moves = possibleRoomMoves(rooms, corridor, 1)
    println("Corridor empty: should be full")
    printmoves(moves)
    println()
    println()

    corridor[2] = 1
    corridor[4] = 2
    moves = possibleRoomMoves(rooms, corridor, 1)
    println("Blocked corridor: $moves should be empty")
    println()

    corridor = fill(0, 11)
    rooms = [Room(r, ["BA", "CD", "BC", "DA"][r]) for r in 1:4]
    moves = possibleRoomMoves(rooms, corridor, 1)
    println("Corridor empty: should be full")
    printmoves(moves)
    println()
    println()

    rooms = [Room(r, ["BA", "DC", "BC", "D"][r]) for r in 1:4]
    moves = possibleRoomMoves(rooms, corridor, 2)
    println("Should be a direct move to D")
    printmoves(moves)
    println()
    println()

end

#testPossibleRoomMoves()
#testPossibleCorridorMoves()
#testdemo()
testreal() #50265
#testdemo()
#testtest()

