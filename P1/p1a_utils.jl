module p1a_functions

using DelimitedFiles

function load_data(file_name)
    """"A function to load data from a file into a list of arrays."""
    #raw_data = readdlm(file_name,' ', Float64, '\n')
    raw_data = readdlm(file_name)
    data = ([Int.(raw_data[:,i]) for i in 1:size(raw_data, 2)]) #broadcast Int to each elements of the 1d while making a list for each column of the raw data``
    return data
end

function minimal_distance(data)
    """A function to calculate the minimal distance between adjacent elements in a sorted list."""
    distance = [abs.(data[i+1]-data[i]) for i in 1:(length(data)-1)]
    return distance
end


function main(file)
    #load data from input files
    data = load_data(file)
    #sort data on inner list
    sorted_data = sort.(data) #"broadcast" sort to each element of the 1d vector
    distance = minimal_distance(sorted_data)
    total = sum.(distance) #sum each element of the 1d vector and return the first element of the resulting 1d vector
    return total
end

end