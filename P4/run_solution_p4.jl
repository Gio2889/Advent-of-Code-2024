include("p4a_utils.jl") #include the file containing all the functions for pa
include("p4b_utils.jl") #include the file containing all the functions for pb``
cd(@__DIR__)
 #make sure you are in the correct dir

#input files names
#input_data = "test_input.txt" #testcase
input_data = "input.txt" #real data
data = p4a_functions.load_as_matrix(input_data)
println("The number of XMAS stringsis:",p4a_functions.xmas_count(data))
#The number of XMAS stringsis:18


#part 2
println("The number of X-MAS is:",p4b_functions.xmas_cross(data))
#The number of X-MAS is:9