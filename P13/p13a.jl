using IterTools
using Printf

# Set high precision
setprecision(2048)
cd(@__DIR__)
# Function to extract integers from a line
function extract_integers_from_line(line)
    matches = eachmatch(r"-?\d+", line)  # Find all integers
    return [parse(Int, m.match) for m in matches]  # Parse matches as integers
end

# Function to process a file and extract integers from each line
function extract_integers_from_file(filepath)
    results = []  # To store the extracted integers
    open(filepath, "r") do file  # Open the file for reading
        for line in eachline(file)
            if isempty(strip(line)) # if line empty skip
                continue
            end
            integers = extract_integers_from_line(line)  # Extract integers from the line
            push!(results, integers)  # Add the result to the list
        end
    end
    return results  # Return all extracted integers
end



function filter_to_integers(elements, tol=1e-3)
    # Check if all elements can be rounded to integers with 8-digit precision
    if all(x -> isapprox(x, round(x), atol=tol), elements)
        return Int.(round.(elements))  # Convert to integers
    else
        return nothing  # Skip the line
    end
end

function get_token_count(machine_info)
    x1,y1 = machine_info[1]
    x2,y2 = machine_info[2]
    b1,b2 = machine_info[3]
    A = BigFloat[x1 x2;y1 y2]
    b = BigFloat[b1 ; b2] #Part A
    #tokens = (A\b) 
    # PArt B change ######################################
    unit = 10000000000000
    b = [BigFloat((unit + b1)/unit) ; BigFloat((unit + b2)/unit)]
    tokens = unit*(A\b)
    # println("----------------")
    # for token in tokens
    #     @printf("%.16f\n", token)
    # end
    # println("----------------")
    #########################################
    return filter_to_integers(tokens)
    #return tokens
end



function get_min_tokens()
    min_tokens = 0 
    for data in grouped_data
        tokens = get_token_count(data)
        #println("tokens $tokens")
        if tokens === nothing
            continue
        else
            #rintln("tokens $tokens")
            min_tokens += 3*tokens[1]+tokens[2]
        end
    end
    return min_tokens
end


input = "input.txt" 
#input = "test_input.txt" 
extracted_data = extract_integers_from_file(input)
grouped_data =  collect(partition(extracted_data,3))

# Print results
#println("Extracted integers: ", extracted_data)
#println("group integers: ", grouped_data)
println(get_min_tokens())
#@printf("%.16f\n",get_min_tokens())