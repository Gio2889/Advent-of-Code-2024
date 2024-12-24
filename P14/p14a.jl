cd(@__DIR__)

function extract_position_and_velocities(filepath)
    results = []
    open(filepath, "r") do file  # Open the file for reading
        for line in eachline(file)
            clean_line = replace(line, r"p=|v=" => ",")
            numbers = split(clean_line, ",")
            push!(results,numbers[2:end])
        end
    end
    return results
end

input = "test_input.txt"
numbers = extract_position_and_velocities(input)
f
end
println(extract_position_and_velocities(input))