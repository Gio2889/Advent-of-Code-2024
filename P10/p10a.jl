using DelimitedFiles
using IterTools
using Graphs
using GraphPlot

cd(@__DIR__)


function load_as_matrix(file_name)
    lines = readlines(file_name)
    int_matrix = [parse(Int, char) for char in reduce(vcat, permutedims.(collect.(lines)))]
    rows = length(lines)
    cols = length(lines[1])
    return reshape(int_matrix, rows, cols)  # Reshape into the original 2D matrix
    # char_matrix = reduce(vcat, permutedims.(collect.(lines)))
    # return char_matrix
end


#display(topo_map)

function search_map(array)
    rows,cols = size(array)
    count = 0
    positions = [(i, j) for i in 1:rows, j in 1:cols]
    # Map positions to node IDs
    position_to_id = Dict(pos => id for (id, pos) in enumerate(positions))
    id_to_position = Dict(id => pos for (pos, id) in position_to_id)
    trails = []
    num_nodes = length(positions)
    
    function search_for_trail(ci, cj, val, graph)
        # Temporary storage for edges in the current traversal
        temp_edges = []
        ends = []
        branches = 0
        
        # Recursive helper function for traversal
        function dfs(ci, cj, val, edges)
            if val == 9
                # Add all stored edges to the graph when reaching the end
                for edge in edges
                    add_edge!(graph, edge[1], edge[2])
                end
                if  !any(x -> x ==(ci,cj), ends)
                    push!(ends,(ci,cj))
                    branches +=1
                end
                return
            end
    
            # Find valid neighbors
            neighbors = [(ci + di, cj + dj) for (di, dj) in [(-1, 0), (1, 0), (0, -1), (0, 1)]
                         if 1 ≤ ci + di ≤ rows && 1 ≤ cj + dj ≤ cols]
            for (ni, nj) in neighbors
                if array[ni, nj] == val + 1  # Check if this is the next step
                    # Store the edge temporarily
                    edge = (position_to_id[(ci, cj)], position_to_id[(ni, nj)])
                    push!(edges, edge)
    
                    # Recur to explore the next step
                    dfs(ni, nj, val + 1, edges)
    
                    # Backtrack: remove the edge from the temporary storage
                    pop!(edges)
                end
            end
        end
    
        # Start the recursive search
        dfs(ci, cj, val, temp_edges)
    
        # Return the graph (updated if the path was valid)
        return graph,branches
    end

    
    for i in 1:rows
        for j in 1:cols
            pos = array[i,j]
            if pos == 0
                grid_graph = SimpleGraph(num_nodes)
                #grid_graph = path_digraph(num_nodes)
                push!(trails,search_for_trail(i,j,pos,grid_graph))
            else
                continue
            end
        end
    end
    return trails,id_to_position
end

good_trails,id_to_pos = search_map(topo_map)

#using LightGraphs


# Function to print graphs
function print_graphs(trails, id_to_position)
    for (i, graph) in enumerate(trails)
        println("Graph $i:")
        println("Number of vertices: ", nv(graph))
        println("Number of edges: ", ne(graph))
        println("Number of selfloop: ", num_self_loops(graph))
        println("Number of out deg: ", outdegree(graph))
        println("Number of deg: ", degree(graph))
        println("Edges:")
        for edge in edges(graph)
            start_node, end_node = edge.src, edge.dst
            println("  $(id_to_position[start_node]) -> $(id_to_position[end_node])")
        end
        println("\n")
    end
end

function plot_graphs(trails, id_to_position)
    for (i, graph) in enumerate(trails)
        println("Plotting Graph $i...")
        
        # Map node IDs to their positions
        positions = [(id_to_position[node][1], id_to_position[node][2]) for node in 1:nv(graph)]
        x_coords = [pos[1] for pos in positions]
        y_coords = [pos[2] for pos in positions]
        
        # Plot using GraphPlot
        display(gplot(graph, x_coords, y_coords, nodelabel=1:nv(graph)))
    end
end

function find_branches(graph::AbstractGraph, id_to_position)
    branches = []

    # Iterate through all nodes in the graph
    for node in 1:nv(graph)
        if degree(graph, node) > 2  # Node has more than 2 connections
            push!(branches, node)
        end
    end

    # Map branch node IDs back to their (row, col) positions
    branch_positions = [id_to_position[node] for node in branches]
    return branch_positions
end


input = "test_input.txt"
input = "input.txt"
topo_map =  load_as_matrix(input)
# # Call the print_graphs function after generating the trails
#print(good_trails)
result = sum(trail[2] for trail in good_trails)
#print([trail[2] for trail in good_trails])
println("Sum of second elements: $result")
#print_graphs([trail[1] for trail in good_trails], id_to_pos)
# #find_branches(good_trails, id_to_pos)
#plot_graphs([trail[1] for trail in good_trails], id_to_pos)
