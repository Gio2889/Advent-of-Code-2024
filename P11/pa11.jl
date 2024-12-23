#input = "0 1 10 99 999"
#input = "125 17"
input = "773 79858 0 71 213357 2937 1 3998391"
split_string = split(input, ' ')


function apply_rules(list)
    int_list  = [parse(Int,rock) for rock in list]
    new_list = []
    for rock in int_list
        if rock == 0
            push!(new_list,1)
        elseif mod(length(collect(string(rock))),2) == 0
            rock = collect(string(rock)) #split string 
            mid = div(length(rock),2)
            rock = [rock[1:mid],rock[mid+1:end]]
            for subrock in rock
                push!(new_list,parse(Int,join(subrock)))
            end
        else
            push!(new_list,rock * 2024)
        end
    end
    return [string(rock) for rock in new_list]
end


function process_rocks(rocks, n)
    new_rocks = rocks  # Local variable within the function
    for i in 1:n
        new_rocks = apply_rules(new_rocks)
        println("iter $(i) with length $(length(new_rocks))")
        #println(new_rocks)
    end
end

# Call the function with the necessary inputs
process_rocks(split_string, 25)