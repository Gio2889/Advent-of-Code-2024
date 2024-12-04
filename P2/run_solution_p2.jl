include("p2a_utils.jl") #include the file containing all the functions for p2a
include("p2b_utils.jl") #include the file containing all the functions for p1b
cd(@__DIR__)
 #make sure you are in the correct dir
#input files names

function load_data(file_name)
    """A function to load data from a file into a list of arrays. This works if the number of element in each row is different."""
    data = []
    open(file_name, "r") do file
        for line in eachline(file)
            elements = split(line)
            numbers = parse.(Int, elements)
            push!(data, numbers)
        end
    end
    return data
end

#input_data = "test_input.txt" #testcase
input_data = "input.txt" #real data
println("number of safe levels is:",p2a_functions.main(input_data))
#output for testcase: number of safe levels is:2

println("number of safe levels with one removal is:",p2b_functions.main(input_data))
#output for testcase: number of safe levels with one removal is:4


