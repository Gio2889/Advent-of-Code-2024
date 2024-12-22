cd(@__DIR__)

input  = "test_input.txt"

function load_as_matrix(file_name)
    lines = readlines(file_name)
    char_matrix = reduce(vcat, permutedims.(collect.(lines)))
    return char_matrix
end

crop_map = load_as_matrix(input)


function search_map(grid)
    crop_info_map =Dict()
    rows,cols = size(grid)
    visited = []
    #build the function here so it has the correct scope
    function search_crop(ci,cj,perim,area)
        push!(visited,(ci,cj)) #push position as visited
        perim += 4
        area += 1
        pos = grid[ci,cj]
        neighbor_crop = Dict()
        neighbhors_to_check = []
        for (di, dj) in [(-1, 0), (1, 0),(0, -1), (0, 1)]
            ni, nj = ci + di, cj + dj
            if 1 <= ni <= rows && 1 <= nj <= cols
                neighbor_crop[(ni,nj)]=grid[ni,nj]
            end
        end
        for (neighbor_coord,neighbor) in pairs(neighbor_crop)
            println("neighbhor is $(neighbor)")        
            if neighbor == pos # we have to expand the search_crop
                perim-=1 #reduce perim by one for every neighbhor
                if !(neighbor_coord in visited) #if the neighbor hasnt been visited add it to the list of places to check
                    #the same crop is found around this one we can move to that spot
                    push!(neighbhors_to_check,neighbor_coord)
                end
            else
                #if theres none of the same crop then return area and perimiter
                return perim,area #perimiter and area of an isolated crop
            end
        end
        while !isempty(neighbhors_to_check)
            next_plant = pop!(neighbhors_to_check)
            perim,area = search_crop(next_plant[1],next_plant[2],perim,area)
        end
        return perim,area
    end
    for i in 1:rows
        for j in 1:cols
            pos = grid[i,j]
            if !haskey(crop_info_map,pos) #if theres no key add it to the dictionary                
                p = 0 #intial perimiter
                a = 0 #initial area
                perimiter,area = search_crop(i,j,p,a)
                crop_info_map[pos] = (perimiter,area)
                println("after first find $crop_info_map")
                
            else #if there is a key update the total 
                perimiter,area = [crop_info_map[pos][1],crop_info_map[pos][2]]
                perimiter,area = search_crop(i,j,perimiter,area) #update the number_of_empty_space
                crop_info_map[pos] = (perimiter,area)
            end
        end
    end
    return crop_info_map
end

crop_info = search_map(crop_map)
println(crop_info)
