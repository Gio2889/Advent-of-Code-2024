cd(@__DIR__)
function load_as_matrix(file_name)
    lines = readlines(file_name)
    char_matrix = reduce(vcat, permutedims.(collect.(lines)))
    return char_matrix
end

input = "test_input.txt"
display(load_as_matrix(input))

function maze_solver(maze_map)
    cols,rows = size(maze_map)
    score = 999999999999
    visited =[]
    function route(ci,cj,di,dj,current_score)
        push!(vistied,(ci,cj)) #mark spot as visited
        if di == 0 && dj == 0 #direction not set
            for (ei, ej) in [(-1, 0), (1, 0), (0, -1), (0, 1)]
                ni, nj = ci + ei, cj + ej
                if maze_map[ni,nj] == '.' &&  (ni,nj) in visited
                    
                end
            end
        end
    for i in 1:rows
        for j in 1:cols
            if maze_map(i,j) == 'S'
                println("Starting maze solver")
                routing(i,j)
            end
        end
    end
end

