cd(@__DIR__)
using DelimitedFiles
using IterTools
using Graphs
function load_as_matrix(file_name)
    lines = readlines(file_name)
    char_matrix = reduce(vcat, permutedims.(collect.(lines)))
    return char_matrix
end

# Function to get or assign an ID to a vertex
function get_vertex_id(vertex, vertex_map, reverse_map, current_id)
    if !haskey(vertex_map, vertex)
        vertex_map[vertex] = current_id
        reverse_map[current_id] = vertex
        current_id += 1
    end
    return vertex_map[vertex], current_id
end

function add_edge_with_cycle_check!(graph, u, v, vertex_map, reverse_map, current_id)
    u_id, current_id = get_vertex_id(u, vertex_map, reverse_map, current_id)
    v_id, current_id = get_vertex_id(v, vertex_map, reverse_map, current_id)

    if has_edge(graph, u_id, v_id)
        #println("Edge already exists between $u and $v.")
        return false
    end

    # Add the edge temporarily
    add_edge!(graph, u_id, v_id)
    
    # Check for cycles
    has_cycle = !isforest(graph)

    if has_cycle
        # Remove the edge if it creates a cycle
        rem_edge!(graph, u_id, v_id)
        #println("Adding edge between $u and $v creates a cycle. Edge not added.")
        return true
    else
        #println("Edge between $u and $v added successfully.")
        return false
    end
end

function run_guard_route_with_path_tracking(grid)
    rows, cols = size(grid) #size of the grid
    rot_mtrx = [0 1; -1 0 ] #rotation matrix for the direction
    g = SimpleGraph()
    vertex_map = Dict()  # Map tuple to integer
    reverse_map = Dict() # Map integer back to tuple
    #current_id = 1       # Counter for assigning unique integers
    loops = 0
    function check_step(ci, cj, di, dj, idx,g,vertex_map,reverse_map)
        step_vertex = (ci, cj, di, dj)
        # Check bounds and letter match
        if grid[ci,cj] != 'X'
            grid[ci, cj] = 'X'
        end

        ni, nj = ci + di, cj + dj
        
        if ni < 1 || ni > rows || nj < 1 || nj > cols # out of bound we     return the number of steps
            return true # true refer to the guard escaping
        end
        next_step_vertex = (ni, nj, di, dj) #next step vertex gets defined 
        if grid[ni, nj] == '#' #obstacle found
            ni,nj = ni - di, nj - dj #go back onstep; we can proceed this way
            di,dj = rot_mtrx*[di;dj] #turn right and then try to proceed
        else
            add_edge_with_cycle_check!(g, step_vertex, next_step_vertex, vertex_map, reverse_map, idx) #log the step
        end
        # if with the new direction
        #display(grid) 
        return search_from(ni, nj, di, dj, idx + 1) #note that this continues till we are out of bounds
    end
    for i in 1:rows
        for j in 1:cols
            if grid[i, j] == '^' # Locater the guard and start
                println("guard found at position: ", (i,j))
                steps = check_step(i, j, -1,0, 0,g,vertex_map,reverse_map)
                display(grid) #display the final grid if you need to
                display(g)
                flat_list = vec(grid)
                count_X = count(x -> x == 'X', flat_list)
                count_cross = count(x -> x == '+', flat_list)
                total = count_X + count_cross
                return total 
            end
        end
    end
end

floor_plan = load_as_matrix("test_input.txt")
run_guard_route_with_path_tracking(floor_plan)