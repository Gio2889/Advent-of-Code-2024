cd(@__DIR__)

function load_as_matrix(file_name)
    lines = readlines(file_name)
    char_matrix = reduce(vcat, permutedims.(collect.(lines)))
    return char_matrix
end

function get_input_str(file_path)
    movement_list = []
    open(file_path,"r") do file
        lines = eachline(file)
        for line in lines
            append!(movement_list,collect(chomp(line)))
        end
    end
    return movement_list
end

function robot_setup(map,input)
    rows,cols = size(map)
    input_to_dir = Dict('^'=> (-1,0),'v'=> (1,0),'>'=> (0,1),'<'=> (0,-1))
    input_list  = get_input_str(input)
    objt_to_mov = []
    #helper function
    function move_object(i,j,di,dj)
        bot_x,bot_y = i,j
        push!(objt_to_mov,[map[i,j],i,j]) #add current object to stack 
        ci,cj = [i,j] + [di,dj] #check next position
        ei,ej = [ci,cj] #saving next objt position
        if ci > 2 || cj > 2 || ci < (rows - 2) || cj < (cols - 2) #within the grid.
            if map[ci,cj] == '.' #empty space
                # trigger movement on the saved stack
                while !isempty(objt_to_mov)
                    obj,m,n = pop!(objt_to_mov) #move the last obj, the closest to the empty space
                    previous_obj = map[ei,ej]
                    map[ei,ej] = obj #move the object forward
                    map[m,n] = '.' #leave and empty space where the obj was
                    if obj == '@' #moving the bot
                       
                        bot_x,bot_y = ei,ej #update the bots position to the latest position
                    end
                    ei,ej = [m,n] #cordinate for the empty space which are now in the position of the moved obj
                    
                    
                end
                return bot_x,bot_y # end the search 
            elseif map[ci,cj] == '#' #obstacle in the way we brea
                for item in objt_to_mov
                    obj,n,m = item
                    if obj == '@'
                        bot_x,bot_y = n,m
                    end
                end
                objt_to_mov =[]
                return  bot_x,bot_y # end the search & returns robot position
            elseif map[ci,cj] == 'O'
                #rock which can be moved go to the next space
                bot_x,bot_y  = move_object(ci,cj,di,dj)
                return bot_x,bot_y #move all objects and return the bots position
            end
        else
            return bot_x,bot_y
        end
    end
    

    function mover(i,j) #function to move the bot
        curr_i,curr_j = [i,j]
        for movement in input_list
            di,dj = input_to_dir[movement]
            curr_i,curr_j = move_object(curr_i,curr_j,di,dj)
        end
    end

    for i in 1:rows
        for j in 1:cols
            if map[i,j] == '@'
                println("Located robots; beginning moving")
                mover(i,j) #start moving the robot and rocks
                return map
            end 
        end
    end
    
end


function get_gps_coord(map)
    rows,cols = size(map)
    result  = 0
    for i in 1:rows
        for j in 1:cols
            if map[i,j] == '[' && map[i,j] == ']'
                k = i-1
                l= j - 1
            result += (100*k)+l 
            end 
        end
    end
    return result
end

function map_resizer(matrix::Matrix{Char})
    # Convert to Matrix{Any}
    resized_matrix = Matrix{Vector{Char}}(undef, size(matrix)...)

    for i in 1:size(matrix, 1)  # Iterate over rows
        for j in 1:size(matrix, 2)  # Iterate over columns
            if matrix[i, j] == '@'
                resized_matrix[i, j] = ['@', '.']
            elseif matrix[i, j] == 'O'
                resized_matrix[i, j] = ['[', ']']
            elseif matrix[i, j] == '.'
                resized_matrix[i, j] = ['.', '.']
            elseif matrix[i, j] == '#'
                resized_matrix[i, j] = ['#', '#']
            end
        end
    end
    return resized_matrix
end
map = "test_map2.txt"
input = "test_input2.txt"
# map = "map.txt"
# input = "input.txt"
map = load_as_matrix(map)
map = map_reziser(map)
print(map)
# evolve_map = robot_setup(map,input)
# display(evolve_map)
# println("sum of gps coord: ", get_gps_coord(evolve_map))
