module p5a_functions
    
function load_data(file_path)    
    # Initialize dictionaries for both types of data
    order_pairs = []
    list_groups = []

    open(file_path, "r") do file
        for line in eachline(file)
            if occursin('|', line)
                key, value = split(line, '|')
                push!(order_pairs,(parse(Int, key),parse(Int, value)))
            elseif occursin(',', line)
                values = parse.(Int, split(line, ','))
                push!(list_groups, values)
            end
        end
    end
    return order_pairs,list_groups
end

function good_order(number1,number2,order_list)
    order = filter(x -> number1 in x,order_list) #get tuples with the correct number for testing
    order = [x[2] for x in order] #get testing numbers
    #println(number1," : ",number2," : ",order)
    if number2 in order
        return true
    else
        return false
    end
end


function is_correct(data,order_list) #built for broadcast
    good_list = []
    for list in data
        i=1
        is_good = []
        while i < length(list)
            if good_order(list[i],list[i+1],order_list)
                push!(is_good,true)
                i+=1
            else
                push!(is_good,false)
                i+=1
            end
        end
        if all(is_good)
            push!(good_list,list)
        end
    end
    return good_list
end

function get_middle_number(data)
    n = length(data)/2
    i = 1
    while  i < n
        i+=1
    end
    return data[i] 
end

end
