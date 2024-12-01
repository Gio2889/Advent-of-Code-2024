include("p1a_utils.jl") #include the file containing all the functions for p1a
include("p1b_utils.jl") #include the file containing all the functions for p1b

cd(@__DIR__) #make sure you are in the correct dir
#input files names
#input_data = "test_input.txt" #testcase
input_data = "input.txt" #real data

data = input_data
println("The minimal distance is: ", p1a_functions.main(data)[1])
#output when using testcase: The minimal distance is: 11
#output when using real data: The minimal distance is: 2057374
println("The similarity score is: ", p1b_functions.main(data))
#output when using testcase: The similarity score  is: 31
#output when using real data: The similarity score  is:


