module p2b_functions
include("p2a_utils.jl") 

function safe_with_removal(data) #broadcast
    if p2a_functions.is_safe(data)
        return true
    else
        println("not safe: ", data)
        i=1
        while i < (length(data) +1)
            temp = copy(data)
            deleteat!(temp,i)
            println(temp)
            if p2a_functions.is_safe(temp)
                return true
            else
                i += 1
            end
        end
    return false
    end
end

function main(input_data)
    data = p2a_functions.load_data(input_data)
    total = sum(safe_with_removal.(data))
    return total
end

end