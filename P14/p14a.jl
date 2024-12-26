using CSV
using DataFrames
using Plots
using Base.Threads
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

# changed for parallel version for part 2
# function display_matrix(pos,vel,rows,cols,n)
#     mtrx = zeros(Int,rows,cols)
#     for i in 1:n
#         new_pos = move_bots(pos,vel,rows,cols,1)
#         mtrx = built_grid(rows,cols,new_pos)
#         # if i == n
#         #     display(mtrx)
#         # end
#     end
#     return mtrx    
# end

function display_matrix(pos, vel, rows, cols, n)
    local_pos = deepcopy(pos)  # Each thread gets its own copy of `pos`
    local_vel = deepcopy(vel)  # Each thread gets its own copy of `vel`
    mtrx = zeros(Int, rows, cols)
    new_pos =Dict()
    for i in 1:n
        new_pos = move_bots(local_pos, local_vel, rows, cols, 1)
        mtrx = built_grid(rows, cols, new_pos)
    end
    return mtrx,new_pos    
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
pos,vel = extract_position_and_velocities(input)
# count_bot_in_quadrants(pos,vel,103,101,100)


##for part b

function check_for_easter_egg_serial(rows,cols)
    good_matrices = []
    old_pos = pos
    for i in 1:10000
        matrix,temp_pos = display_matrix(old_pos,vel,rows,cols,1) #only iterate eaach second  
        matrix = Matrix{Any}(matrix)
        row_sums = vec(sum(matrix, dims=2))
        col_sums = vec(sum(matrix, dims=1))
        if any(x -> x >= 30, row_sums) || any(x -> x >= 30, col_sums)
            #println("$i")
            push!(good_matrices,matrix)
            #   
        end
        old_pos = temp_pos #save the curent position for next iteraation
        #end
          
    end
    println("serial version found $(length(good_matrices)) setups")
    for matrx in good_matrices
        display(heatmap(matrx, color=:grays, title="Matrix for i=$i"))
    end
end

function check_for_easter_egg_parallel(rows, cols, pos, vel)
    #If you for some reason want to do every time evolution separate you can use this parallel version
    println("Number of available threads: ", Threads.nthreads())

    #thread_results = [Vector{Matrix{Any}}() for _ in 1:Threads.nthreads()]
    thread_results = [Dict{Int, Matrix{Int}}() for _ in 1:Threads.nthreads()]
    Threads.@threads for i in 1:5000
        matrix = display_matrix(pos, vel, rows, cols, i)
        #println("Thread $(threadid()) - Generated matrix for i=$i")
        row_sums = vec(sum(matrix, dims=2))
        col_sums = vec(sum(matrix, dims=1))
        if any(x -> x >= 30, row_sums) || any(x -> x >= 30, col_sums)
            #println(i)
            # println("Thread $(threadid()) - Found valid matrix for i=$i")
            #push!(thread_results[threadid()], matrix)
            thread_id = threadid()
            thread_results[thread_id][i] = matrix
        end
    end

    # good_matrices = vcat(thread_results...)
    # println("$(length(good_matrices)) setups found")
    # for matrx in good_matrices
    #     display(heatmap(matrx, color=:grays))
    # end

    good_matrices = Dict()
    for thread_dict in thread_results
        merge!(good_matrices, thread_dict) 
    end

    println("parallel version found $(length(good_matrices)) setups")
    for (i, matrx) in good_matrices
        display(heatmap(matrx, color=:grays, title="Matrix for i=$i"))
    end
end


println("--------------------------------")
check_for_easter_egg_serial(103,101)
println("--------------------------------")
#check_for_easter_egg_parallel(103,101,pos,vel)
