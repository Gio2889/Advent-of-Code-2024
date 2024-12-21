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
            if !any(n -> n == (i,j), nodes) #if the current position is not in the nodes list add its
                push!(nodes,(i,j))
            end
            for next_antenna in position_list
                ci,cj = next_antenna
                delx = ci - i 
                dely = cj - j
                del_vec = [delx,dely] #vector which dictates the distance
                #update for part b
                
                for direction in [1,-1]
                    n=1
                    while true
                        node = [i,j] .+ n .* direction .* del_vec #progate in the direction
                        if node[1] < 1 || node[2] < 1 || node[1] > rows || node[2] > cols # check the position given by the new vector
                            break #skip this node as its out of bounds
                        else # the node is within the bounds
                            node = (node[1],node[2])
                            if !any(n -> n == node, position_list) && !any(n -> n == node, nodes) #the node is not blocked by antenna of the same type AND not in the node list
                                push!(nodes,node) #add a node    
                                n=n+1
                            else #if there is an antenna, of the same type,on the location then we skip
                                n=n+1
                                continue
                            end
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
#println(ant_dict)
noded_sky_map,nodes = locate_nodes(sky_map,ant_dict)
#print(nodes)
println("Number of nodes: ",length(nodes))
#display(noded_sky_map)