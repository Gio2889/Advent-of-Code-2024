cd(@__DIR__)

function load_as_matrix(file_name)
    lines = readlines(file_name)
    char_matrix = reduce(vcat, permutedims.(collect.(lines)))
    return char_matrix
end

function direction_marker(ei, ej)
    return (ei == 1 && ej == 0 ? 'v' :   # Down
            ei == -1 && ej == 0 ? '^' :  # Up
            ei == 0 && ej == 1 ? '>' :   # Right
            ei == 0 && ej == -1 ? '<' :
            '.')  # Left)                         # Default or invalid direction
end

function maze_solver(maze_map)
    cols,rows = size(maze_map)
    score = typemax(Int)
    visited =falses(rows,cols)
    function route(ci,cj,di,dj,visited,current_score)
        println("route at position $ci, $cj, with score $current_score")
        if current_score > score #if the route overtakes the current score stop the loop
            println("bad route; reseting")
            return score,visited #return the active score.
        end
        visited_local = copy(visited) #copy the visited array to not make global changes
        visited_local[ci,cj] = true
         #mark spot as visited
        for (ei, ej) in [(-1, 0), (1, 0), (0, -1), (0, 1)]
            ni, nj = ci + ei, cj + ej
            if (maze_map[ni,nj] == '.' || maze_map[ni,nj] == 'E') &&  !(visited_local[ni,nj])
                println("good neigbhor found")
                if maze_map[ni,nj] == 'E'
                    println("mazed finished")
                    return current_score,visited_local # we have finished the maze
                end
                if di == 0 && dj == 0 #direction not set
                    # this move is always worth 1 point
                    current_score,visited_local =  route(ni,nj,ei,ej,visited_local,current_score+1)
                else
                    println("same direction")
                    if ei == di && ej == dj ## direction is the same 
                        current_score,visited_local =  route(ni,nj,ei,ej,visited_local,current_score+1)  #move to the next step
                    else #direction is not the same, therefore we must turn 90 degrees since we cant go back
                        println("changin direction")
                        current_score,visited_local = route(ni,nj,ei,ej,visited_local,current_score+1001)
                    end              
                end
                return current_score,visited_local
            # else #if theres no possible neigbhor to move
            #     return score,visited_local #return the active score, previous visited map
            end
        end
    end
    
    
    for i in 1:rows
        for j in 1:cols
            if maze_map[i,j] == 'S'
                println("Starting maze solver")
                score = route(i,j,0,0,visited,0)
            end
        end
    end
    return score
end


input = "test_input.txt"
best_score,visited_final = maze_solver(load_as_matrix(input))
display(visited_final)

