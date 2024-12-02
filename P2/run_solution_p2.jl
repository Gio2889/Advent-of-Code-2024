include("p2a_utils.jl") #include the file containing all the functions for p2a
#include("p2b_utils.jl") #include the file containing all the functions for p1b
cd(@__DIR__)
 #make sure you are in the correct dir
#input files names
#input_data = "test_input.txt" #testcase
input_data = "input.txt" #real data
data = load_data(input_data)
println("number of safe levels is:", is_safe(data))
#output for testcase: number of safe levels is:2


