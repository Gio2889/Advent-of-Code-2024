using DelimitedFiles
using Printf
cd(@__DIR__)
function load_data(file)
    lines = readlines(file)
    data = []
    for line in lines
        split1= split(line, ":")
        result = strip(split1[1])
        values = split(strip(split1[2])," ")
        push!(data,(result,values))
    end
    return data
end


function evaluate_line(data_tuple)
    result, values = data_tuple[1],data_tuple[2]
    result =  parse(Int64,result)
    values =  [parse(Int64,value) for value in values]
    a = popfirst!(values)
    b = popfirst!(values)
    #println("after float transform: ",a," ",b," ",result)
    function iterate_operations(a,b,remaining_values)
        # if b!=0
        #     operations = Dict(
        #             "add" =>  a+b,
        #             #"sub" => a-b,
        #             #"div" => a/b,
        #             "mul" => a*b
        #         )
        # else
        #     operations = Dict(
        #             "add" =>  a+b,
        #             #"sub" => a-b,
        #             "mul" => a*b
        #         )
        # end
        operations = Dict(
                    "add" =>  a+b,
                    "mul" => a*b
                )
        #println("operations for: ",a," ",b," ",operations)
        for (op,res) in operations
            #println("Trying operation: ", op, " with result ", result, " for a=", a, ", b=", b)
            if res ==  result
                return true
            elseif !isempty(remaining_values)
                new_remaining = copy(remaining_values)
                a = res
                b = popfirst!(new_remaining)
                if  iterate_operations(a,b,new_remaining)
                    return true
                end 
            end
        end
        return false #nothing worked 
    end
    if iterate_operations(a, b, values)
        return result
    end
end


# Load and process the input data
data = load_data("input.txt")
good_data = evaluate_line.(data)
println(good_data)
filtered_data = filter(x -> x !== nothing, good_data)
print(filtered_data)
# Sum up the good results
total = sum(filtered_data)
println(total)
#res 303876515419