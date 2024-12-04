module p3b_functions
include("p3a_utils.jl")


function match_num_and_dos(pattern,string_input)
    matches = eachmatch(pattern, string_input)
    println(matches)
    digits_list = []
    do_add = true
    for m in matches
        mtch = m.match
        if mtch == "don't()"
            do_add = false
        elseif mtch == "do()"
            do_add = true
        end
        if do_add &&  mtch != "do()"
            digits = p3a_functions.digit_grab(mtch)
            push!(digits_list,digits)
        end   
    end
    println(digits_list)
    return digits_list
end


function main(data)
    #pattern = r"mul\(\d{1,3},\s*\d{1,3}\)" # for reference
    #pattern_do = r"do\(\)" # for reference
    #pattern_dont = r"don\'t\(\)" # for reference
    combined_pattern = r"mul\(\d{1,3},\s*\d{1,3}\)|don\'t\(\)|do\(\)"
    digits_list = match_num_and_dos(combined_pattern,data)
    joined_digits = p3a_functions.join_digits.(digits_list)
    products = p3a_functions.multiply.(joined_digits)
    return sum(products)[1]
end

end