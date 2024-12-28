using DataStructures  # For PriorityQueue
cd(@__DIR__)
function load_as_matrix(file_name)
    lines = readlines(file_name)
    char_matrix = reduce(vcat, permutedims.(collect.(lines)))
    return char_matrix
end

function aStar(g_matrix::Matrix{Int}, start_node::Tuple{Int, Int}, end_node::Tuple{Int, Int})
    # Heuristic function (Manhattan distance) ONLY FOR TESTING
    function cost_function(node::Tuple{Int, Int}, goal::Tuple{Int, Int})
        return abs(node[1] - goal[1]) + abs(node[2] - goal[2])
    end

    # Rebuild the path from came_from dictionary
    function rebuild_path(n::Tuple{Int, Int}, came_from::Dict{Tuple{Int, Int}, Tuple{Int, Int}})
        path = [n]
        while haskey(came_from, n)
            n = came_from[n]
            push!(path, n)
        end
        return reverse(path)  # Return path from start to end
    end

    # Priority queue to hold nodes to explore
    open_set = PriorityQueue{Tuple{Int, Int}, Float64}()
    enqueue!(open_set, start_node => 0.0)

    # Dictionaries to track costs and paths
    cost_so_far = Dict(start_node => 0.0)
    came_from = Dict{Tuple{Int, Int}, Tuple{Int, Int}}()

    while !isempty(open_set)
        curr_node, _ = dequeue!(open_set)

        if curr_node == end_node
            return rebuild_path(curr_node, came_from)  # Goal reached, return path
        end

        # Explore neighbors (assuming 4-neighbor grid)
        for neighbor in [(curr_node[1] + dx, curr_node[2] + dy) for (dx, dy) in [(1, 0), (-1, 0), (0, 1), (0, -1)]]
            # Check if neighbor is within bounds
            if neighbor[1] > 0 && neighbor[2] > 0 && neighbor[1] <= size(g_matrix, 1) && neighbor[2] <= size(g_matrix, 2)
                new_cost = cost_so_far[curr_node] + g_matrix[neighbor[1], neighbor[2]]
                
                if !(neighbor in cost_so_far) || new_cost < cost_so_far[neighbor]
                    cost_so_far[neighbor] = new_cost
                    priority = new_cost + cost_function(neighbor, end_node)
                    enqueue!(open_set, neighbor => priority)
                    came_from[neighbor] = curr_node
                end
            end
        end
    end

    return nothing  # No path found
end


function get_g_matrix(maze_map)
    rows,cols = sixe(maze_map)
    index_map = Dict()
    current_index = 1
    for i in 1:rows, j in 1:cols
        if maze[i][j] in ['.', 'S', 'E']
            index_map[(i, j)] = current_index
            current_index += 1
        end
    end
    num_nodes = length(index_map)

    # Initialize the adjacency matrix
    adj_matrix = zeros(Int, num_nodes, num_nodes)

    # Function to check valid neighbors
    function get_neighbors(i, j)
        return [(i-1, j), (i+1, j), (i, j-1), (i, j+1)]  # Up, Down, Left, Right
    end

    # Build the adjacency matrix
    for (cell, idx) in index_map
        i, j = cell
        for neighbor in get_neighbors(i, j)
            if haskey(index_map, neighbor)
                neighbor_idx = index_map[neighbor]
                adj_matrix[idx, neighbor_idx] = 1
            end
        end
    end
end

function maze_solver(maze_map)
    rows,cols = sixe(maze_map)
    g_mtrx = get_g_matrix(maze_map)
    start_node = (0,0)
    end_node = (0,0)
    for i in 1:rows
        for j in 1:cols
            if maze_map[i,j] == 'S'
                start_node = (i,j)
            elseif maze_map[i,j] == 'E'
                end_node = (i,j)
            end
        end
    end
    if start_node == (0,0) || end_node == (0,0)
        return nothing #bad setup
    end

    return aStar(g_mtrx,start_node,end_node)
end

input = "test_input.txt"
map = load_as_matrix(input)
maze_solver(map)