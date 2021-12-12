demo = true

open(demo ? "dayX/demoinput" : "dayX/input", "r") do f # demoinput
    line = readline(f)
    while line != ""
        line = readline(f)
    end
end