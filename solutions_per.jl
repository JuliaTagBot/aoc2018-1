# ----------------------------- Day  1 ---------------------------------------

scan(::Val{1}, line) = parse(Int, line)

function solve(day::Val{1}, part, lines)
    data = scan.(day, lines)
    if part === Val(1)
        sum(data)
    else
        f = 0
        s = Set([0])
        for d in Iterators.cycle(data)
            f += d
            f ∈ s && return f
            push!(s, f)
        end
    end
end

# ----------------------------- Day  2 ---------------------------------------

scan(::Val{2}, line) = Vector{Char}(line)

function solve(day::Val{2}, part, lines)
    data = scan.(day, lines)
    if part === Val(1)
        ismatch(v, n) = any(map(c -> sum(v .== c) == n, v))
        sum(ismatch.(data, 2)) * sum(ismatch.(data, 3))
    else # part 2
        for a in data, b in data
            sum(a .!= b) == 1 && return String(a[a .== b])
        end
    end
end

# ----------------------------- Day  3 ---------------------------------------

function scan(::Val{3}, line)
    m = match(r"#(\d*) @ (\d*),(\d*): (\d*)x(\d*)", line)
    parse.((Int, Int, Int, Int, Int), Tuple(m.captures))
end

function solve(day::Val{3}, part, lines)
    data = scan.(day, lines)
    mx = reduce((a,b) -> max.(a,b), data)
    M = zeros(Int, mx[2]+mx[4], mx[3]+mx[5])
    for c in data
        M[c[2]+1:c[2]+c[4], c[3]+1:c[3]+c[5]] .+= 1
    end
    if part === Val(1)
        sum(M .> 1)
    else # part 2
        for c in data
            all(M[c[2]+1:c[2]+c[4], c[3]+1:c[3]+c[5]] .== 1) && return c[1]
        end
    end
end

# ----------------------------- Day  4 ---------------------------------------

function scan(::Val{4}, line)
    m = match(r"\[(\d*)-(\d*)-(\d*) (\d*):(\d*)\] (.*)", line)
    s = parse.(Int, m.captures[1:5])
    g = match(r"Guard #(\d*) begins shift", m.captures[6])
    id = g === nothing ? 0 : parse(Int, g.captures[1])
    (366*s[1] + 31*s[2] + s[3]+(s[4]==23), s[5]-60*(s[4]==23), id, m.captures[6]=="falls asleep")
end

function solve(day::Val{4}, part, lines)
    data = scan.(day, lines)
    sort!(data, by=i->256*i[1]+i[2])
    id = 0
    t = 0
    N = maximum(x->x[3], data)
    s = zeros(Int, N, 60)
    sleeps = false
    for (xx, m, i, sl) in data
        if i > 0
            if sleeps # last guard slept at end of hour
                # This never happened in the input data
                s[id, t+1:end] .+= 1
            end
            id = i
            sleeps = false
        elseif sl
            t = m
            sleeps = true
        else # wakes up
            s[id, t+1:m] .+= 1
            sleeps = false
        end
    end
    if part === Val(1)
        (xx, ix) = findmax(vec(sum(s, dims=2)))
        (xx, mn) = findmax(s[ix,:])
        ix*(mn-1)
    else # part 2
        (xx, ix) = findmax(s)
        ix[1]*(ix[2]-1)
    end
end