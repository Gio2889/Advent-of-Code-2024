using IterTools

cd(@__DIR__)
test1 = "12345"
test2 = "2333133121414131402"
open("input.txt", "r") do file
    input = read(file, String)
end

function diskmap_to_block(diskmap)
    raw_map = collect(diskmap)
    if mod(length(raw_map),2) != 0 # Add a '0' if the length is odd
        push!(raw_map,'0')
    end
    group_map = [pairs for pairs in partition(raw_map,2)]
    blocks = []
    k=0
    for pair in group_map
        block_size = parse(Int,string(pair[1]))
        free_space = parse(Int,string(pair[2]))
        for i in 1:block_size
            push!(blocks,string(k))
        end
        if free_space != 0
            for j in 1:free_space
                push!(blocks,'.')
            end
        end
        k+=1
    end
    return blocks
end

function rearrange_block(blocks)
    disk_block = copy(blocks)
    #println(disk_block)
    number_of_empty_spaces = length(filter(x-> x=='.',blocks))
    #println("empty spaces ",number_of_empty_spaces)
    popped_empty_spaces = []
    while length(popped_empty_spaces) < number_of_empty_spaces
        mover = pop!(disk_block)
        if mover == '.'
            push!(popped_empty_spaces,mover)
        else
            index_to_pop = findfirst(x -> x == '.',disk_block)
            disk_block[index_to_pop] = mover
            push!(popped_empty_spaces,'.')
        end
    end
    #rearraged_block = vcat(disk_block,popped_empty_spaces)
    #println(disk_block)
    return disk_block
end

function get_check_sum(block)
    checksum = 0
    for i in 1:lastindex(block)
        #println(i," ",parse(Int,block[i])," ",i * parse(Int,block[i]))
        res = (i-1) * parse(Int,block[i])
        checksum += res
    end    
    return checksum
end


println(get_check_sum(rearrange_block(diskmap_to_block(input))))