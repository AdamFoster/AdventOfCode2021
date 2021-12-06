using DataStructures
using Printf

demo = false

open(demo ? "day6/demoinput.txt" : "day6/input.txt", "r") do f # demoinput
    line = readline(f)
    
    fish = [parse(Int64, x) for x in split(line, ",")]

    for day in 1:80
        fishtospawn = counter(fish)[0]
        fish = [(x==0 ? 6 : x-1) for x in fish]
        fish = [fish ; fill(8, fishtospawn)]
        #println(day  + " : " + join(fish, ','))
        #@printf("Day %d: %s\n", day, join(fish, ','))
    end
    println(size(fish)) #365131
    #display(fish)

end