cd(@__DIR__)

function load_as_matrix(file_name)
    lines = readlines(file_name)
    char_matrix = reduce(vcat, permutedims.(collect.(lines)))
    return char_matrix
end

# function maze_solver(maze_map)
#     cols,rows = size(maze_map)
#     score = 999999999999
#     visited =[]
#     function route(ci,cj,di,dj,current_score)
#         if current_score > score #if the route overtakes the current score stop the loop
#             return score #return the active score.
#         end
#         push!(visited,(ci,cj)) #mark spot as visited
#         for (ei, ej) in [(-1, 0), (1, 0), (0, -1), (0, 1)]
#             ni, nj = ci + ei, cj + ej
#             if (maze_map[ni,nj] == '.' || maze_map[ni,nj] == 'E') &&  !((ni,nj) in visited)
#                 if di == 0 && dj == 0 #direction not set
#                     current_score +=1 # this move is always worth 1 point
#                 else
#                     if ei == dj && ej == dj ## direction is the same 
#                         current_score += 1
#                         if maze_map[ni,nj] == 'E'
#                             return current_score # we have finished the maze
#                         end
#                         current_score =  route(ni,nj,ei,ej,current_score)  #move to the next step
#                     else #direction is not the same, therefore we must turn 90 degrees since we cant go back
#                         current_score += 1000
#                         current_score = route(ni,nj,ei,ej,current_score)
#                         if maze_map[ni,nj] == 'E'
#                             return current_score # we have finished the maze
#                         end
#                     end              
#                 end
#                 return current_score
#             else #if theres no possible neigbhor to move
#                 return score #return the active score.
#             end
#         end
#     end
    
    
#     for i in 1:rows
#         for j in 1:cols
#             if maze_map[i,j] == 'S'
#                 println("Starting maze solver")
#                 score = route(i,j,0,0,score)
#             end
#         end
#     end
#     return score
# end


# input = "test_input.txt"
# best_score = maze_solver(load_as_matrix(input))
function direction_marker(ei, ej)
    return (ei == 1 && ej == 0 ? 'v' :   # Down
            ei == -1 && ej == 0 ? '^' :  # Up
            ei == 0 && ej == 1 ? '>' :   # Right
            ei == 0 && ej == -1 ? '<' :  # Left
            '.')                         # Default or invalid direction
end


function maze_solver(maze_map)
    rows, cols = size(maze_map)
    min_score = typemax(Int)  # Use a large integer instead of a hardcoded value
    directions = [(-1, 0), (1, 0), (0, -1), (0, 1)]  # Up, Down, Left, Right

    function route(ci, cj, di, dj, current_score, visited, local_map)
        if maze_map[ci, cj] == 'E'  # Exit condition
            return current_score, deepcopy(local_map)  # Return the score and the current map
        end
    
        local_score = current_score
        best_map = deepcopy(local_map)  # To keep track of the best map
        min_score = typemax(Int)  # Start with a large score
        original_pos = local_map[ci,cj]
        for (ei, ej) in directions
            ni, nj = ci + ei, cj + ej
    
            if (maze_map[ni, nj] == '.' || maze_map[ni, nj] == 'E') && !(visited[ni, nj])
                new_score = local_score + (ei != di || ej != dj ? 1000 : 1)  # Add turn cost or step cost
                visited[ni, nj] = true

                # Mark the map with the direction
                local_map[ci, cj] = direction_marker(ei, ej)
    
                # Recursively explore
                score, updated_map = route(ni, nj, ei, ej, new_score, visited, local_map)
    
                # Update min_score and best_map if this path is better
                if score < min_score
                    min_score = score
                    best_map = deepcopy(updated_map)
                end
            else #this no possible way out 
                # Unmark visited cell and restore map
                visited[ni, nj] = false
                local_map[ci, cj] = original_pos  # Restore to empty path
            end
        end
    
        return min_score, best_map
    end
    
    # Find the start position
    for i in 1:rows
        for j in 1:cols
            if maze_map[i, j] == 'S'
                visited = falses(rows, cols)  # Boolean matrix to track visited positions
                visited[i, j] = true
                score, final_map = route(i, j, 0, 0, 0, visited, maze_map)
                return score, final_map
            end
        end
    end

    return -1,maze_map  # Return -1 if no start position is found
end

# Example usage
input = "test_input.txt"
best_score,visited_map = maze_solver(load_as_matrix(input))
println("Best Score: ", best_score)
display(visited_map)
