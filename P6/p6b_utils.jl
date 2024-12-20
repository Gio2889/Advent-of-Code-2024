using DelimitedFiles
using IterTools
using Graphs
cd(@__DIR__)
function load_as_matrix(file_name)
    lines = readlines(file_name)
    char_matrix = reduce(vcat, permutedims.(collect.(lines)))
    return char_matrix
end



function position_counts(grid)
    rows, cols = size(grid) 
    position_counts = 0
    directions = collect(product([-1, 1], [-1, 1]))
    rot_mtrx = [0 1; -1 0 ]
    graph = SimpleGraph()
    vertex_map = Dict()  # Map tuple to integer
    reverse_map = Dict() # Map integer back to tuple
    #idx = 1       # Counter for assigning unique integers
    steps = 0
    function search_from(ci, cj, di, dj, idx)
        # Check bounds and letter match
        # Function to get or assign an ID to a vertex
        function get_vertex_id(vertex, vertex_map, reverse_map, idx)
            if !haskey(vertex_map, vertex)
                vertex_map[vertex] = idx
                reverse_map[idx] = vertex
                idx += 1
            end
            return vertex_map[vertex], idx
        end

        function add_edge_with_cycle_check!(graph, u, v, vertex_map, reverse_map, idx)
            

            if cycle == [] 
                # Remove the edge if it creates a cycle
                return true
            else
                return false
            end
        end
        curent_step_vertex = (ci, cj, di, dj)
        if grid[ci,cj] != 'X'
            grid[ci, cj] = 'X'
        end
        ni, nj = ci + di, cj + dj
        #println("on step: ", idx,"  ","position ", (ci,cj)," direction: ", (di,dj), " grid value ",grid[ci, cj] )
        if ni < 1 || ni > rows || nj < 1 || nj > cols # out of bound we return the number of steps
            return true #its means you get out
        end
        next_step_vertex = (ni,nj,di,cj)
        cs_id, idx = get_vertex_id(curent_step_vertex, vertex_map, reverse_map, idx)
        ns_id, idx = get_vertex_id(next_step_vertex, vertex_map, reverse_map, idx)

        if has_edge(graph, cs_id, ns_id)
            println("Edge already exists between $u and $v.")
            return false
        end

        # Add the edge temporarily
        add_edge!(graph, cs_id, ns_id)
        cycle = cycle_basis(graph)
        # Check for cycles
        println(graph)
        
        

        #println(" next value ",grid[ni, nj])
        if grid[ni, nj] == '#' #obstacle found
            ni,nj = ni - di, nj - dj #go back onstep; we can proceed this way
            di,dj = rot_mtrx*[di;dj] #90 degree rotation on the direction
        end
        # if with the new direction
        #display(grid) 
        return search_from(ni, nj, di, dj, idx + 1) #note that this continues till we are out of bounds
    end
    for i in 1:rows
        for j in 1:cols
            if grid[i, j] == '^' # Locater the guard and start
                println("guard found at position: ", (i,j))
                if search_from(i, j, -1,0, 0)
                    display(grid) #display the final grid if you need to
                    flat_list = vec(grid)
                    count_X = count(x -> x == 'X', flat_list)
                    count_cross = count(x -> x == '+', flat_list)
                    total = count_X + count_cross
                    return total
                else
                    return "Not able to escape!"
                end
            end
        end
    end
end

file_path = "test_input.txt"
floor_plan = load_as_matrix(file_path)

println("Number of unique positions: ",position_counts(floor_plan))