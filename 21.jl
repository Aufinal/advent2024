const coords_num = Dict([
    '0' => (1, 0),
    'A' => (2, 0),
    ('0' + i => ((i + 2) % 3, 1 + (i - 1) ÷ 3) for i in 1:9)...
])
const coords_arr = Dict([
    '^' => (1, 1),
    '>' => (2, 0),
    '<' => (0, 0),
    'v' => (1, 0),
    'A' => (2, 1)
])

const dir_arr = Dict([
    '^' => (0, 1),
    '>' => (1, 0),
    '<' => (-1, 0),
    'v' => (0, -1),
])

function move_to(p1, p2)
    dx, dy = p2 .- p1
    c_x = dx ≥ 0 ? '>' : '<'
    c_y = dy ≥ 0 ? '^' : 'v'
    return c_x^abs(dx) * c_y^abs(dy) * 'A'
end

function type(str, dict)
    rev = Dict(val => key for (key, val) in dict)
    pos = dict['A']
    res = ""
    for c in str
        if haskey(dir_arr, c)
            pos = pos .+ dir_arr[c]
        else
            res *= rev[pos]
        end
    end
    return res
end

function advance(dict, (acc, pos), c)
    new_pos = dict[c]
    return (acc * move_to(pos, new_pos), new_pos)
end
advance_num(x...) = advance(coords_num, x...)
advance_arr(x...) = advance(coords_arr, x...)

function move_check(str)
    res = move_arr(str)
    check = type(res, coords_arr)
    str != check && println("ERROR : ", res, " ", check, " ", str)
    return res
end

check(s) = type(type(type(s, coords_arr), coords_arr), coords_num)

move_num(str) = first(foldl(advance_num, str, init=("", coords_num['A'])))
move_arr(str) = first(foldl(advance_arr, str, init=("", coords_arr['A'])))
move = move_check ∘ move_check ∘ move_num

score(str) = length(move(str)) * parse(Int, str[1:end-1])

open(ARGS[1]) do file
    println(coords_num)
    println(coords_arr)
    # for line in readlines(file)
    #     res = move(line)
    #     println(check(res))
    #     println(length(move(line)))
    # end
    println(sum(score, readlines(file)))
end