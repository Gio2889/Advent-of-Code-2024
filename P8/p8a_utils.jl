using DelimitedFiles
using IterTools

cd(@__DIR__)


function load_as_matrix(file_name)
    lines = readlines(file_name)
    char_matrix = reduce(vcat, permutedims.(collect.(lines)))
    return char_matrix
end


# Define the file path
#file_path = "input.txt"
file_path = "test_input.txt"
floor_plan =load_as_matrix(file_path)
display(floor_plan)

function get_distance(vec1,vec2)
    dis = sqrt((vec1[1] - vec2[1])^2 + (vec1[2] - vec2[2])^2)
    return dis
end

function search_grid(array,ant_type,pos_dict,position)
    position_list = pos_dict[ant_type]
    pop!(position_list,position) #remove current position from position_list
    for pos in position_list
        #dist = get_distance(position,pos) #set distance for the other antenna of the same type
        delx = position[1] - pos[1]
        dely = position[2] - pos[2]
        del_vec = (delx,dely) #vector which dictates the distance 
        del_vec = -1*del_vec #reflect vector
        if del_vec[1] < 
        if array[del_vec[1],del_vec[2]] == '.'
            array[del_vec[1],del_vec[2]]

        end

    end

end

rows,cols = size(floor_plan)
known_antennas = Dict{String, Vector{Any}}()
visited = []
for i in rows
    for j in cols
        pos = floor_plan[i,j]
        push!(visited,pos) #add point to grid
        if pos != '.' #this means an antena is found
            if haskey(known_antennas,pos) #check if the antena is known
                #initiante a search for the point of the grid
                for pos in known_antennas[pos]
                    #dist = get_distance(position,pos) #set distance for the other antenna of the same type
                    delx = position[1] - pos[1]
                    dely = position[2] - pos[2]
                    del_vec = (delx,dely) #vector which dictates the distance 
                    del_vec = -1*del_vec #reflect vector
                    if del_vec[1] < 
                    if array[del_vec[1],del_vec[2]] == '.'
                        array[del_vec[1],del_vec[2]]
            
                    end
            
                end
            else 
                known_antennas[pos] = (i,j)# add the antena type  to the known array
            end
        end
    end
end
println("distance ",get_distance([1,1],[3,3]))