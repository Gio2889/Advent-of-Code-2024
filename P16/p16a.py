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


def visualize_path_with_directions(grid, path):
    """
    Visualizes the given path on the grid with directional arrows.

    Args:
        grid (list[str]): The original grid as a list of strings.
        path (list[tuple[int, int]]): The list of coordinates representing the path.

    Returns:
        None: Prints the grid with the path and directions.
    """
    # Convert the grid to a list of lists for mutability
    grid_visual = [list(row) for row in grid]

    # Helper function to determine direction between two points
    def get_direction(prev, curr):
        dr, dc = curr[0] - prev[0], curr[1] - prev[1]
        if dr == -1: return '↑'  # Up
        if dr == 1: return '↓'  # Down
        if dc == -1: return '←'  # Left
        if dc == 1: return '→'  # Right
        return '*'

    # Mark the path with directions
    for i in range(len(path) - 1):
        prev = path[i]
        curr = path[i + 1]
        direction = get_direction(prev, curr)
        if grid_visual[prev[0]][prev[1]] not in ('S', 'E'):  # Keep the start and end markers
            grid_visual[prev[0]][prev[1]] = direction

    # Convert back to strings and print the grid
    grid_visual = [''.join(row) for row in grid_visual]
    for row in grid_visual:
        print(row)

def make_adj_matrix_and_g_dict(grid):
    rows = len(grid)
    cols = len(grid[0])

    # Filter valid cells
    valid_cells = [(r, c) for r in range(rows) for c in range(cols) if grid[r][c] != "#"]
    #print(f"valid cells are {valid_cells}")
    cell_to_index = {cell: idx for idx, cell in enumerate(valid_cells)}
    #print(f"cell to index are {cell_to_index}")
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
    #print(f"adj matrix is {adj_matrix}")
    # Convert adjacency matrix to graph dictionary
    graph = {cell: [] for cell in valid_cells}
    for (r, c), idx in cell_to_index.items():
        neighbors = [valid_cells[j] for j in range(num_valid_cells) if adj_matrix[idx][j] == 1]
        graph[(r, c)] = neighbors
    #print(f"graph is {graph}")
    return graph
# Define A* function
def astar(g: dict, start_node: tuple[int, int], goal_node: tuple[int, int]) -> list | None:
    open_set = [(0, start_node,"RIGHT")]
    came_from = {}
    came_from_with_dir = {}
    cost_so_far = {start_node: 0}

    # A commonly used heuristic for maze-solving is the Manhattan distance
    def heuristic(node: tuple[int, int], goal: tuple[int, int]):
        return abs(node[0] - goal[0]) + abs(node[1] - goal[1])

    def get_direction(prev, curr):
        dr, dc = curr[0] - prev[0], curr[1] - prev[1]
        if dr == -1: return "UP"
        if dr == 1: return "DOWN"
        if dc == -1: return "LEFT"
        if dc == 1: return "RIGHT"
        return None

    def rebuild_path(n):
        p = [n]
        while n in came_from:
            n = came_from[n]
            p.append(n)
        return p[::-1],curr_cost

    while len(open_set) > 0:
        #print(f"open set is {open_set}")
        #print(f"cost so far is: {cost_so_far}")
        #print(f"came from is {came_from}")
        curr_cost, curr_node, curr_dir = heappop(open_set)
        #print(f"curr_node & curr_cost are {curr_node} & {curr_cost}")
        if curr_node == goal_node:
            print("end found")
            goal_path = rebuild_path(goal_node)
            return goal_path

        for neighbor in g[curr_node]:
            #print(f"neighbor is {neighbor}")
            new_direction = get_direction(curr_node, neighbor)
            #print(f"new direction is {new_direction}")
            if curr_dir != new_direction:
                direction_penalty = 1001
            else:
                direction_penalty = 1
            new_cost = cost_so_far.get(curr_node) + direction_penalty
            #new_cost = cost_so_far.get(curr_node) + 1
            #print(f"new cost is {new_cost}")
            if neighbor not in cost_so_far or new_cost < cost_so_far[neighbor]:
                #print("cost is lower; upating")
                cost_so_far[neighbor] = new_cost
                #print(f"hueristic is {heuristic(neighbor, goal_node)}")
                priority = new_cost + heuristic(neighbor, goal_node)
                
                #print(f"upating priority {priority}")
                heappush(open_set, (priority, neighbor,new_direction))
                came_from[neighbor] = curr_node

    return None





def main():
    #file_path = "input.txt"  # Replace with your text file path
    file_path = "test_input2.txt"  # Replace with your text file path
    grid = read_maze(file_path)
    #print(grid)
    # Define start and goal nodes
    for i,row in enumerate(grid):
        for j,col in enumerate(row):
            if grid[i][j] == 'S':
                start_node = (i,j)  # 'S' location            
            elif grid[i][j] == 'E':
                goal_node = (i,j)   # 'E' location
    #print(f"starting A star algorithym with {start_node} and {goal_node}")

    graph =  make_adj_matrix_and_g_dict(grid)
    # Call A* function
    path,cost = astar(graph, start_node, goal_node)

    # Output the path
    print("Path:", path)
    print("Cost:", cost)

    #visualize_path(grid,path)
    visualize_path_with_directions(grid,path)
if __name__ == '__main__':
    main()