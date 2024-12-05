module p4a_functions
using DelimitedFiles
using IterTools
function load_as_matrix(file_name)
    lines = readlines(file_name)
    char_matrix = reduce(vcat, permutedims.(collect.(lines)))
    return char_matrix
end


function xmas_count(grid)
    rows, cols = size(grid) 
    letter_list = ['X', 'M', 'A', 'S']
    xmas_counts = 0

    neighbors = collect(product([-1, 0, 1], [-1, 0, 1]))
    neighbors =  filter(x -> x != (0, 0), neighbors)  #dont counts same place
    function search_from(ci, cj, di, dj, idx)
        if idx > length(letter_list) #idx is larger than 4 meannin we have match on the string
            return true
        end

        # Check bounds and letter match
        ni, nj = ci + di, cj + dj
        #the point we are checkin is not equal to the letter we are looking for
        if ni < 1 || ni > rows || nj < 1 || nj > cols || grid[ni, nj] != letter_list[idx]
            return false
        end
        # if we are withing the bounds & the letter matches we look in the same direction(di,dj) 
        #for the next letter to match
        return search_from(ni, nj, di, dj, idx + 1) #note that this continues till we complete the string
    end

    for i in 1:rows
        for j in 1:cols
            if grid[i, j] == letter_list[1]  # Locater and readiate outward from X's
                for (di, dj) in neighbors
                    if search_from(i, j, di, dj, 2)  # Check from 'M' onwards
                        xmas_counts += 1
                    end
                end
            end
        end
    end

    return xmas_counts
end

end




