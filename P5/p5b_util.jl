module p5b_functions
include("p5a_utils.jl")
using Graphs
function reorder(list, rules)
    grph = SimpleDiGraph(length(list))
    index_dict = Dict(x => i for (i, x) in enumerate(list))
    for (a, b) in rules
        if a in keys(index_dict) && b in keys(index_dict)
            add_edge!(grph, index_dict[a], index_dict[b])
        end
    end
    sorted_indices = topological_sort(grph)
    sorted_list = list[sorted_indices]
    
    return sorted_list
end

function is_correct_with_reoder(data,order_list) #built for broadcast
    good_list = []
    for list in data
        i=1
        is_good = []
        while i < length(list)
            if p5a_functions.good_order(list[i],list[i+1],order_list)
                push!(is_good,true)
                i+=1
            else
                push!(is_good,false)
                i+=1
            end
        end
        if !all(is_good)
            sorted_ist = reorder(list,order_list)
            push!(good_list,sorted_ist)
        end
    end
    return good_list
end

end
# for list in list_groups
#     sorted_ist = reorder(list,order_pairs)
#     println(sorted_ist)
# end
