include("p6a_utils.jl")
#include("p6b_util.jl")
cd(@__DIR__)
# Define the file path
#file_path = "input.txt"
file_path = "test_input.txt"
floor_plan = p6a_functions.load_as_matrix(file_path)
println("Number of unique positions: ",position_counts(floor_plan))

