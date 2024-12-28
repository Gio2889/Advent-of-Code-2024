# Input maze
# maze = [
#     "###############",
#     "#.......#....E#",
#     "#.#.###.#.###.#",
#     "#.....#.#...#.#",
#     "#.###.#####.#.#",
#     "#.#.#.......#.#",
#     "#.#.#####.###.#",
#     "#...........#.#",
#     "###.#.#####.#.#",
#     "#...#.....#.#.#",
#     "#.#.#.###.#.#.#",
#     "#.....#...#.#.#",
#     "#.###.#.#.#.#.#",
#     "#S..#.....#...#",
#     "###############"
# ]

maze = [
    "#####",
    "###E#",
    "#...#",
    "#.###",
    "#.#.#",
    "#.###",
    "#S..#",
    "#####"
]

# Parse the maze to create a mapping of traversable cells to indices
rows = length(maze)
cols = length(maze[1])
index_map = Dict()  # Maps (row, col) -> node index
current_index = 1

# Populate the index_map
for i in 1:rows, j in 1:cols
    if maze[i][j] in ['.', 'S', 'E']
        index_map[(i, j)] = current_index
        global current_index += 1
    end
end

# Number of nodes
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

# Print the adjacency matrix
println(adj_matrix)
