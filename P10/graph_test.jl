using Graphs
using GraphPlot
#using Colors  # For colors

# Step 1: Define the grid size and positions
rows, cols = 4, 4  # Example grid dimensions
positions = [(i, j) for i in 1:rows, j in 1:cols]

# Map positions to node IDs
position_to_id = Dict(pos => id for (id, pos) in enumerate(positions))
id_to_position = Dict(id => pos for (pos, id) in position_to_id)

# Step 2: Add edges based on adjacency
function add_grid_edges!(graph, rows, cols, position_to_id)
    for i in 1:rows
        for j in 1:cols
            current = (i, j)
            if j < cols  # Add edge to the right neighbor
                add_edge!(graph, position_to_id[current], position_to_id[(i, j+1)])
            end
            if i < rows  # Add edge to the bottom neighbor
                add_edge!(graph, position_to_id[current], position_to_id[(i+1, j)])
            end
        end
    end
end

# Step 3: Create the graph and add edges
num_nodes = length(positions)
grid_graph = SimpleGraph(num_nodes)
add_grid_edges!(grid_graph, rows, cols, position_to_id)

# Step 4: Prepare layout and visualize the graph
# Define the node positions for visualization as a vector of tuples
layout = [(pos[2], pos[1]) for pos in values(id_to_position)]

# Plot the graph
gplot(grid_graph)
