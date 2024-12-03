include("p3a_utils.jl") #include the file containing all the functions for p2a
#include("p3b_utils.jl") #include the file containing all the functions for p1b
cd(@__DIR__)
 #make sure you are in the correct dir

 #pattern to match

#input files names
input_data = "test_input.txt" #testcase
#input_data = "input.txt" #real data
data = p3a_functions.load_data(input_data)
println("the result from instructions is:",p3a_functions.main(data))
#the result from instructions is:161
