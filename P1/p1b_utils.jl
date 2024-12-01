module p1b_functions

include("p1a_utils.jl")

function similarity_score(data)
    freq_dict = Dict{Int, Int}() #initalize the dictionary
    for element in data[2]
        freq_dict[element]  = get(freq_dict,element,0)+1 #get the frequency of each number
                            #get() obtains the element if its there
                            #if not then output 0
    end
    val_vec = [element*get(freq_dict,element,0) for element in data[1]] #return the similarity score for each value in a vector
    return val_vec
end

function main(file)
    data = p1a_functions.load_data(file)
    simil_score = similarity_score(data)
    total = sum(simil_score)
    return total
end

end