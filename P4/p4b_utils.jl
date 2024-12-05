module p4b_functions
using IterTools

function xmas_cross(grid)
    rows, cols = size(grid) 
    letter_list = ['M', 'A', 'S']
    xmas_counts = 0

    neighbors = collect(product([-1, 1], [-1, 1])) #remove lateral movements here.
    function check_cross(i, j)
        if grid[i, j] != letter_list[2] #set starting point to A
            return false
        end
        for (di, dj) in neighbors
            # Check the diagonals
            if i + di < 1 || i + di > rows || j + dj < 1 || j + dj > cols || grid[i + di, j + dj] != letter_list[3]
                continue 
            end
            if i - di < 1 || i - di > rows || j - dj < 1 || j - dj > cols || grid[i - di, j - dj] != letter_list[1] 
                continue
            end
            di,dj = [0 -1;1 0]*[di;dj] #this ensures c2v symmetry on the 'A' 
            if i + di < 1 || i + di > rows || j + dj < 1 || j + dj > cols || grid[i + di, j + dj] != letter_list[3]
                continue 
            end
            if i - di < 1 || i - di > rows || j - dj < 1 || j - dj > cols || grid[i - di, j - dj] != letter_list[1] 
                continue
            end
            # If both diagonals have the MAS string and therefore the correct symmerty count the cross
            return true
        end
        return false
    end

    for i in 1:rows
        for j in 1:cols
            if check_cross(i,j)
                xmas_counts += 1
            end
        end
    end

    return xmas_counts
end

end