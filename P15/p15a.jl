cd(@__DIR__)
function load_as_matrix(file_name)
    lines = readlines(file_name)
    char_matrix = reduce(vcat, permutedims.(collect.(lines)))
    return char_matrix
end

map = "test_map.txt"
input = "test_input.txt"

  

function robot_setup(map,input)
    rows,cols = size(map)
    input_to_dir = Dict("^"=> (0,-1),"v"=> (0,1),">"=> (1,0),"<"=> (-1,0))
    input_list  = collect(test_input)
    function move_bot() #function to move the bot
        for i in 
    end
    for i in 1:rows
        for j in 1:cols
            if map == '@'
                println("Located robots; beginning moving")
                move_bot()
        end
    end

end