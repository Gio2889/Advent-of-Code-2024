map = "test_map2.txt"
input = "test_input2.txt"
import os
os.chdir(os.path.dirname(os.path.abspath(__file__)))
floor_map = []
with open(map,"r") as file:
    for line in file.readlines():
        floor_map.append([char for char in line.strip()])
print(floor_map)

for row in floor_map_small:
    for cols in row:
        if col = 