using OffsetArrays

function matrixToBinary(m)
    parse(Int, join([m...]); base=2)
end

demo = false

open(demo ? "day20/demoinput" : "day20/input", "r") do f # demoinput
    line = readline(f)
    algo = [x=="#" ? 1 : 0 for x in split(line, "")]
    
    readline(f)
    line = readline(f)
    image = [x=="#" ? 1 : 0 for x in split(line, "")]
    line = readline(f)
    
    while line != ""
        image = [image [x=="#" ? 1 : 0 for x in split(line, "")]]
        line = readline(f)
    end
    #println(algo)
    #display(image)
    #println()

    paddedImage = image

    for i in 0:49
        println("Pass $i")
        bit = 0
        if algo[1] == 1 # if the algorithm has all offs -> on, then need to fill alternate fills with off and then on
            bit = i%2
        end
        paddedImage = [fill(bit, size(paddedImage, 1)) paddedImage fill(bit, size(paddedImage, 1))] #pad once
        paddedImage = [fill(bit, 1, size(paddedImage, 2)) ; paddedImage  ; fill(bit, 1, size(paddedImage, 2))]
        paddedImage = [fill(bit, size(paddedImage, 1)) paddedImage fill(bit, size(paddedImage, 1))] # pad twice
        paddedImage = [fill(bit, 1, size(paddedImage, 2)) ; paddedImage  ; fill(bit, 1, size(paddedImage, 2))]
        paddedImage = OffsetArray(paddedImage, 0:(size(paddedImage,1)-1), 0:(size(paddedImage,2)-1))
        #display(paddedImage)
        #println()

        #println("Padded image input = $(paddedImage[0:4,0:4]')")
        #display(paddedImage')#[0:4,0:4]')
        #println()
        #newPaddedImage = [reduce(+, paddedImage[x-1:x+1,y-1:y+1]) for x in 1:(size(paddedImage,1)-2), y in 1:(size(paddedImage,2)-2)]
        paddedImage = [algo[matrixToBinary(paddedImage[x-1:x+1,y-1:y+1])+1] for x in 1:(size(paddedImage,1)-2), y in 1:(size(paddedImage,2)-2)]
        #display(paddedImage)
        #println("Padded image output = $(paddedImage[1:3,1:3]')")
        #display(paddedImage')#[1:3,1:3]')
        #println()
        println()
    end

    println("Total lights = $(reduce(+,paddedImage))") # 17172
end