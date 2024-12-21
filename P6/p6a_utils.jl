module p6a_functions
using DelimitedFiles
using IterTools
function load_as_matrix(file_name)
    lines = readlines(file_name)
    char_matrix = reduce(vcat, permutedims.(collect.(lines)))
    return char_matrix
end

function position_counts(grid)
    rows, cols = size(grid) 
    position_counts = 0
    rot_mtrx = [0 1; -1 0 ]
    steps = 0
    function search_from(ci, cj, di, dj, idx)
        # Check bounds and letter match
        if grid[ci,cj] != 'X'
            if grid[ci,cj] == '+'
            else
                grid[ci, cj] = 'X'
            end
        end
        ni, nj = ci + di, cj + dj
        #println("on step: ", idx,"  ","position ", (ci,cj)," direction: ", (di,dj), " grid value ",grid[ci, cj] )
        if ni < 1 || ni > rows || nj < 1 || nj > cols # out of bound we return the number of steps
            return true
        end
        #println(" next value ",grid[ni, nj])
        if grid[ni, nj] == '#' #obstacle found
            ni,nj = ni - di, nj - dj #go back onstep; we can proceed this way
            di,dj = rot_mtrx*[di;dj] #90 degree rotation on the direction
            grid[ci,cj] = '+'
        elseif grid[ni, nj] == 'X' #identify crossing points
            grid[ci,cj] = '+'    #print("direction updated: ", (di,dj))
        end
        # if with the new direction
        #display(grid) 
        return search_from(ni, nj, di, dj, idx + 1) #note that this continues till we are out of bounds
    end
    for i in 1:rows
        for j in 1:cols
            if grid[i, j] == '^' # Locater the guard and start
                println("guard found at position: ", (i,j))
                steps = search_from(i, j, -1,0, 0)
                display(grid) #display the final grid if you need to
                flat_list = vec(grid)
                count_X = count(x -> x == 'X', flat_list)
                count_cross = count(x -> x == '+', flat_list)
                total = count_X + count_cross
                return total 
            end
        end
    end
end

end
#-1,0 -> 0,1-> 1,0 ->0,-1 