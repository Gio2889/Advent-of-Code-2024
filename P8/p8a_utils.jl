using DelimitedFiles
using IterTools

cd(@__DIR__)


function load_as_matrix(file_name)
    lines = readlines(file_name)
    char_matrix = reduce(vcat, permutedims.(collect.(lines)))
    return char_matrix
end


# Define the file path
file_path = "input.txt"
#file_path = "test_input.txt"
sky_map = load_as_matrix(file_path)
#display(floor_plan)

function locate_antenas(array)
    rows,cols = size(array)
    known_antennas = Dict{Char, Vector{Vector{Int}}}()
    visited = []
    #scan the whole grid and locate anttenas first
    for i in 1:rows
        for j in 1:cols
            pos = array[i,j]
            push!(visited,(i,j)) #add point to grid
            if pos != '.' #this means an antena is found
                if haskey(known_antennas,pos) #check if the antena is known
                    push!(known_antennas[pos],[i,j])
                else 
                    known_antennas[pos] = [[i,j]]# add the antena type to the known array
                end
            end
        end
    end
    return known_antennas
end

function locate_nodes(array,known_ant_dict)
    rows, cols = size(array)
    counts = 0
    nodes = []
    for ant_type in keys(known_ant_dict) # search nodes for each antenna type
        position_list = known_ant_dict[ant_type] # positions of all antennas of the given type
        while !isempty(position_list)
            i,j = popfirst!(position_list) #current position_list
            for next_antenna in position_list
                ci,cj = next_antenna
                delx = ci - i 
                dely = cj - j
                del_vec = [delx,dely] #vector which dictates the distance
                node_point1 = [i,j]+2*del_vec #node at twice the distance
                del_vec = -1*del_vec #reflect vector
                node_point2 = [i,j]+del_vec #node at the opposite direction
                for node in [node_point1,node_point2] #check if the node is within the boundaries
                    if node[1] < 1 || node[2] < 1 || node[1] > rows || node[2] > cols # check if the position given by the new vector
                        continue #skip this node as its out of bounds
                    else # the node is within the bounds
                        node = (node[1],node[2])
                        if !any(n -> n == node, position_list) && !any(n -> n == node, nodes) #the node is not blocked by antenna of the same type AND not in the node list
                            push!(nodes,node) #add a node    
                        else #if there is an antenna, of the same type,on the location then we skip
                            continue
                        end
                    end
                end
                if length(position_list) == 1 # if there is only one antenna left break the loop
                    break
                end
            end
        end
    end
    return array,nodes
end

ant_dict = locate_antenas(sky_map)
println(ant_dict)
noded_sky_map,nodes = locate_nodes(sky_map,ant_dict)
print(nodes)
println("Number of nodes: ",length(nodes))
#display(noded_sky_map)