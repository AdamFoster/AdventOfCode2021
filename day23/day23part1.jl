demo = true

VALID_CORRIDORS = Set([1,2,4,6,8,10,11])
ROOM_SIZE = 2

mutable struct Room
    type::Int
    contents::Array{Int}
    size::Int
    corridorAttachment::Int
    Room(type::Int, stringContents::String) = new(type, [Int(Char(c))-Int('A')+1 for c in reverse(stringContents)], ROOM_SIZE, 2*type+1)
end

mutable struct Move
    rooms::Vector{Room}
    corridor::Array
    cost::Int
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
        if length(filter(x->x!=letter, rooms[letter].contents)) == 0 && length(rooms[letter].contents) < rooms[letter].size
            #valid move
            moverooms = deepcopy(rooms)
            push!(moverooms[letter].contents, letter)
            movecorridor = deepcopy(corridor)
            movecorridor[corridorIndex] = 0
            movecost = 10^(letter-1) * (abs(corridorIndex-rooms[letter].corridorAttachment) + rooms[letter].size-length(rooms[letter].contents))
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

    if length(filter(x->x==roomNumber, rooms[roomNumber].contents)) == rooms[roomNumber].size
        #println("Room $roomNumber is done: $(rooms[roomNumber])")
        return moves
    end
    if length(filter(x->x!=roomNumber, rooms[roomNumber].contents)) == 0
        #println("Room $roomNumber contains only $roomNumber: $(rooms[roomNumber])")
        return moves
    end
    if length(rooms[roomNumber].contents) == 0
        #println("Room $roomNumber is empty")
        #println("Rooms:")
        #display(rooms)
        #println("\nCorridor: $corridor")
        #println("\n")
        #exit()
        return moves
    end

    corridorAttachment = rooms[roomNumber].corridorAttachment

    minEmptyCorridor = corridorAttachment
    maxEmptyCorridor = corridorAttachment
    letter = last(rooms[roomNumber].contents)
    if letter == 0
        println("Why does room $roomNumber have a 0? $rooms")
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

    # room to corridor move
    possibleDestinations = intersect(VALID_CORRIDORS, minEmptyCorridor:maxEmptyCorridor)
    for c in possibleDestinations
        distance = abs(c-corridorAttachment) + rooms[roomNumber].size - length(rooms[roomNumber].contents)

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


function possibleMoves(rooms::Vector{Room}, corridor::Vector{Int})
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
        pms = possibleMoves(rooms::Vector{Room}, corridor::Array)
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

function process(initialRooms::Array{String})
    done = false
    corridor = fill(0, 11)
    rooms = [Room(r, initialRooms[r]) for r in 1:4]

    display(rooms)
    println()

    cost = minCost(rooms, corridor, 0)

    println()
    println("***")
    display(cost)
    println()
    println("***")

    #while !done
    #    if count(c->c!==nothing, corridor) == 0
    #        # corridor is empty
    #        println("Corridor empty")
    #        if roomsDone(rooms)
    #            println("Rooms done")
    #            done = true
    #        end
    #    end
    #    if !done
    #        # there are moves to do
    #        println("Corridor = $corridor")
    #        # generate possible room moves
    #    end
    #    break
    #end
end


function testdemo()
    process(["BA", "CD", "BC", "DA"])
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
    println("Corridor empty: $moves should be full")
    println()

    corridor[2] = 1
    corridor[4] = 2
    moves = possibleRoomMoves(rooms, corridor, 1)
    println("Blocked corridor: $moves should be empty")
    println()
end

function testPossibleRoomMoves()
    corridor = fill(0, 11)
    rooms = [Room(r, ["BA", "CD", "BC", "DA"][r]) for r in 1:4]
    moves = possibleRoomMoves(rooms, corridor, 1)
    println("Corridor empty: $moves should be full")
    println()
end

#testPossibleRoomMoves()
#testPossibleCorridorMoves()
testdemo()
#testtest()

