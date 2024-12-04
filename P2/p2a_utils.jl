module p2a_functions

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

function cal_delta(data)
    delta = [(data[i]-data[i+1]) for i in 1:(length(data)-1)]
    return delta
end

function is_delta_safe(data)
    #check if all elements are below 4 and above 0
    safe = all([all(x-> 0 < abs(x) < 4, d) for d in data])
    return safe
end

function monotic(data)
    #check to see if all deltas are negative or postive
    if all(x-> x > 0,data) || all(x-> x < 0,data) 
        return true
    else
        return false 
    end
end

function is_safe(data) #broadcast not pass
    deltas = cal_delta(data)
    are_mono = monotic(deltas)
    safe_deltas = is_delta_safe(deltas)
    safe = are_mono .& safe_deltas #and combination of bool arrays
    return safe
end

function main(input_data)
    data = load_data(input_data)
    total = sum(is_safe.(data))
    return total
    
end

end