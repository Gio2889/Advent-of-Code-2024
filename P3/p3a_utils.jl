module p3a_functions

function load_data(file_path)    
    file_content = open(file_path, "r") do file
        read(file, String)
    end
    return file_content
end


function digit_grab(s)
    ints = []
    temp =[]
    for elem in s
        if isdigit(elem)
            push!(temp,elem)
        end
        if (elem == ',' || elem == ')' ) && !isempty(temp)
            push!(ints,temp)
            temp =[]
        end
    end
    return ints
end

function match_num(pattern,string_input)
    matches = eachmatch(pattern, string_input)
    digits_list = []
    for m in matches
        digits = digit_grab(m.match)
        push!(digits_list,digits)    
    end
    println(digits_list)
    return digits_list
end

function join_digits(digits)
    mult = Int[]
    for sublist in digits
        num = join(sublist)
        push!(mult, parse(Int, num))
    end
    return mult
end

function multiply(mult_list) 
    result = 1
    for num in mult_list
        result *= num
    end
    return result
end

function main(data)
    pattern = r"mul\(\d{1,3},\s*\d{1,3}\)"
    digits_list = match_num(pattern,data)
    joined_digits = join_digits.(digits_list)
    products = multiply.(joined_digits)
    return sum(products)[1]
end

end