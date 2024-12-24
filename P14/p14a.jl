using CSV
using DataFrames
using Plots
cd(@__DIR__)

function extract_position_and_velocities(filepath)
    results = []
    open(filepath, "r") do file  # Open the file for reading
        for line in eachline(file)
            clean_line = replace(line, r"p=|v=" => ",")
            numbers = split(clean_line, ",")
            push!(results,
            [parse(Int, s) for s in numbers[2:end]]
            )
        end
    end
    pos_dict = Dict()
    vel_dict = Dict()
    for (i,bot) in enumerate(results)
        pos_dict[i] = (bot[1]+1,bot[2]+1) #to make the coordinate th index they are at
        vel_dict[i] = (bot[3],bot[4])
    end
    return pos_dict,vel_dict 
end


function move_bots(pos,vel,rows,cols,n)
    m = length(keys(pos))
    @assert m == length(keys(vel)) "Dictionaries do not have the same number of keys!" #check that the dict have the same lenght 
    for j in 1:n
        for key in keys(pos)
            (x,y) = pos[key]
            vx,vy = vel[key]
            x,y = [x,y]+[vx,vy]
            if x < 1
                x = x + cols
            end
            if y < 1
                y = y + rows
            end
            if x > cols
                x = x - cols
            end
            if y > rows
                y = y - rows
            end
            pos[key] = (x,y)
        end 
        #println(pos[11])
    end
    return pos
end

function built_grid(rows,cols,pos)
    #println(pos)
    matrix = zeros(Int,rows,cols)
    for (i,j) in values(pos)
        matrix[j,i] = matrix[j,i] + 1
    end
    return matrix 
end

function display_matrix(pos,vel,rows,cols,n)
    mtrx = zeros(Int,rows,cols)
    for i in 1:n
        new_pos = move_bots(pos,vel,rows,cols,1)
        mtrx = built_grid(rows,cols,new_pos)
        # if i == n
        #     display(mtrx)
        # end
    end
    return mtrx    
end

function count_bot_in_quadrants(pos,vel,rows,cols,n)
    matrix = display_matrix(pos,vel,rows,cols,n)
    qd1 = matrix[1:Int((rows-1)/2),1:Int((cols-1)/2)]
    qd2 = matrix[1:Int((rows-1)/2), Int((cols-1)/2+2):end]
    qd3 = matrix[Int((rows-1)/2+2):end, 1:Int((cols-1)/2)]
    qd4 = matrix[Int((rows-1)/2+2):end, Int((cols-1)/2+2):end]
    total = 1
    for submatrx in [qd1,qd2,qd3,qd4]
        total *= sum(submatrx)
    end
    return total
end

# input = "test_input.txt"
# pos,vel = extract_position_and_velocities(input)
#move_bots(pos,vel,7,11,5)
#built_grid(7,11,pos)
#display_matrix(pos,vel,7,11,100)
#count_bot_in_quadrants(pos,vel,7,11,100)

#for actual problem
input = "input.txt"
# pos,vel = extract_position_and_velocities(input)
# count_bot_in_quadrants(pos,vel,103,101,100)

##for part b
function check_for_easter_egg()
    for i in 1:3000
        matrix = display_matrix(pos,vel,103,101,i)
        matrix = Matrix{Any}(matrix)
        row_sums = vec(sum(matrix, dims=2))
        col_sums = vec(sum(matrix, dims=1))
        if any(x -> x > cols, row_sums) || any(x -> x > rows, col_sums)
            prinln("East Egg found after $i seconds")  
            matrix[matrix .== 0] .= '.'
            display(heatmap(matrix, color=:grays))
        end
    end    
end

check_for_easter_egg()
#CSV.write("matrix.csv", DataFrame(matrix, :auto)) 