import numpy as np
from heapq import heappop, heappush
import os
os.chdir(os.path.dirname(os.path.abspath(__file__)))
def read_maze(file_path: str) -> list[str]:
    """
    Reads a maze from a text file and returns it as a list of strings.

    Args:
        file_path (str): The path to the text file containing the maze.

    Returns:
        list[str]: The maze in the required list of strings format.
    """
    with open(file_path, 'r') as file:
        maze = [line.strip() for line in file.readlines()]
    return maze


# Define the grid for test
# grid = [
#     "#####",
#     "###E#",
#     "#...#",
#     "#.###",
#     "#...#",
#     "#.#.#",
#     "#S..#",
#     "#####"
# ]
def make_adj_matrix_and_g_dict(grid):
    rows = len(grid)
    cols = len(grid[0])

    # Filter valid cells
    valid_cells = [(r, c) for r in range(rows) for c in range(cols) if grid[r][c] != "#"]
    print(f"valid cells are {valid_cells}")
    cell_to_index = {cell: idx for idx, cell in enumerate(valid_cells)}
    print(f"cell to index are {cell_to_index}")
    # Initialize adjacency matrix for valid cells
    num_valid_cells = len(valid_cells)
    adj_matrix = np.zeros((num_valid_cells, num_valid_cells), dtype=int)

    # Populate adjacency matrix
    for r, c in valid_cells:
        current = cell_to_index[(r, c)]
        # Check all 4 directions
        for dr, dc in [(-1, 0), (1, 0), (0, -1), (0, 1)]:
            nr, nc = r + dr, c + dc
            if (nr, nc) in cell_to_index:  # Ensure the neighbor is valid
                neighbor = cell_to_index[(nr, nc)]
                adj_matrix[current][neighbor] = 1
    print(f"adj matrix is {adj_matrix}")
    # Convert adjacency matrix to graph dictionary
    graph = {cell: [] for cell in valid_cells}
    for (r, c), idx in cell_to_index.items():
        neighbors = [valid_cells[j] for j in range(num_valid_cells) if adj_matrix[idx][j] == 1]
        graph[(r, c)] = neighbors
    print(f"graph is {graph}")
    return graph
# Define A* function
def astar(g: dict, start_node: tuple[int, int], goal_node: tuple[int, int]) -> list | None:
    open_set = [(0, start_node)]
    came_from = {}
    cost_so_far = {start_node: 0}

    # A commonly used heuristic for maze-solving is the Manhattan distance
    def heuristic(node: tuple[int, int], goal: tuple[int, int]):
        return abs(node[0] - goal[0]) + abs(node[1] - goal[1])

    def rebuild_path(n):
        p = [n]
        while n in came_from:
            n = came_from[n]
            p.append(n)
        return p[::-1],curr_cost

    while len(open_set) > 0:
        print(f"open set is {open_set}")
        print(f"cost so far is: {cost_so_far}")
        print(f"came from is {came_from}")
        curr_cost, curr_node = heappop(open_set)
        print(f"curr_node & curr_cost are {curr_node} & {curr_cost}")
        if curr_node == goal_node:
            print("end found")
            goal_path = rebuild_path(goal_node)
            return goal_path

        for neighbor in g[curr_node]:
            print(f"neighbor is {neighbor}")
            new_cost = cost_so_far.get(curr_node) + 1
            print(f"new cost is {new_cost}")
            if neighbor not in cost_so_far or new_cost < cost_so_far[neighbor]:
                print("cost is lower; upating")
                cost_so_far[neighbor] = new_cost
                print(f"hueristic is {heuristic(neighbor, goal_node)}")
                priority = new_cost + heuristic(neighbor, goal_node)
                print(f"upating priority {priority}")
                heappush(open_set, (priority, neighbor))
                came_from[neighbor] = curr_node

    return None

def main():
    file_path = "test_input.txt"  # Replace with your text file path
    grid = read_maze(file_path)
    print(grid)
    # Define start and goal nodes
    for i,row in enumerate(grid):
        for j,col in enumerate(row):
            if grid[i][j] == 'S':
                start_node = (i,j)  # 'S' location            
            elif grid[i][j] == 'E':
                goal_node = (i,j)   # 'E' location
    print(f"starting A star algorithym with {start_node} and {goal_node}")

    graph =  make_adj_matrix_and_g_dict(grid)
    # Call A* function
    path,cost = astar(graph, start_node, goal_node)

    # Output the path
    print("Path:", path)
    print("Cost:", cost)

if __name__ == '__main__':
    main()
