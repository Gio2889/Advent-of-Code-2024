cd(@__DIR__)


function load_as_matrix(file_name)
    lines = readlines(file_name)
    char_matrix = reduce(vcat, permutedims.(collect.(lines)))
    return char_matrix
end


function search_map(grid)
    #crop_info_map = Dict{Char, Tuple{Int, Int}}() # Stores perimeter and area for each crop type
    crop_info_map = [] 
    rows, cols = size(grid)
    visited = Set{Tuple{Int, Int}}()

    # Helper function to explore a crop
    function search_crop(ci, cj, perim, area,side)
        stack = [(ci, cj)]
        crop_type = grid[ci, cj]

        while !isempty(stack)
            current = pop!(stack)
            if current in visited
                continue
            end

            push!(visited, current)
            area += 1
            ci, cj = current
            perim += 4

            # Check neighbors
            for (di, dj) in [(-1, 0), (1, 0), (0, -1), (0, 1)]
                ni, nj = ci + di, cj + dj
                if 1 <= ni <= rows && 1 <= nj <= cols
                    if grid[ni, nj] == crop_type
                        perim -= 1
                        if (ni, nj) ∉ visited
                            push!(stack, (ni, nj))
                        end
                    ## change for partb
                    ## Needs an update.
                    # else 
                    #     side +=1  
                    end
                end
            end
        end
        return perim, area, side
    end

    # Main loop to find all crops
    for i in 1:rows
        for j in 1:cols
            if (i, j) ∉ visited
                crop_type = grid[i, j]
                perim, area, side = search_crop(i, j, 0, 0,0)
                push!(crop_info_map,(crop_type,perim,area,side))
                # if haskey(crop_info_map, crop_type)
                #    existing_perim, existing_area = crop_info_map[crop_type]
                #    crop_info_map[crop_type] = (existing_perim + perim, existing_area + area)
                # else
                #    crop_info_map[crop_type] = (perim, area)
                # end
            end
        end
    end

    return crop_info_map
end

# # Example Usage
# crop_map = [
#     'A' 'A' 'B';
#     'A' 'a' 'B';
#     'C' 'C' 'C'
# ]

input  = "test_input.txt"
#input = "input.txt"
crop_map = load_as_matrix(input)

crop_info = search_map(crop_map)

function get_cost(list)
    cost = 0
    for (type,perim,area) in list
        cost+= perim*area
    end
    return cost
end
println(crop_info)
#print(get_cost(crop_info))
