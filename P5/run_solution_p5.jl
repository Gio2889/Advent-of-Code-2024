include("p5a_utils.jl")
include("p5b_util.jl")
cd(@__DIR__)
# Define the file path
file_path = "input.txt"
order_pairs,list_groups = p5a_functions.load_data(file_path)
good = p5a_functions.is_correct(list_groups,order_pairs)
println("Adding up the middle numbers of the good updates: ", sum(p5a_functions.get_middle_number.(good)))

good = p5b_functions.is_correct_with_reoder(list_groups,order_pairs)
println("Adding up the middle numbers of the reorder is updates: ", sum(p5a_functions.get_middle_number.(good)))