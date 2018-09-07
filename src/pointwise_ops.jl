"""
Given a function `f` and piecewise functions `pws`, returns the piecewise
function given by `pw(x) = f(pws[1](x), ..., pws[end](x))`. Assumes that the
domain of the given piecewise functions are the same. If there are `N` piecewise
functions and the result has `K` break points, then the running time is
`O(K log N)`.
"""
function pointwise(f::Function, pw::Piecewise)
    Piecewise(copy(pw.boundaries), [f(v) for v in pw.values])
end

function pointwise(f::Function, pws::Vararg{Piecewise})
    boundaries = Float64[]
    ResultT = typeof(f((pw.values[1] for pw in pws)...)) # determine the type of the result
    values = ResultT[]

    pw_queue = DataStructures.PriorityQueue{Int,Float64}()
    for pw_ix in 1:length(pws)
        pw_queue[pw_ix] = pws[pw_ix].boundaries[1]
    end
    current_ix = ones(Int, length(pws))

    while !isempty(pw_queue)
        # Get the location of the next boundary
        next_boundary = DataStructures.peek(pw_queue)[2]
        # Increment the current_ix for each pw whose next boundary is equal to next_boundary
        while !isempty(pw_queue) && DataStructures.peek(pw_queue)[2] <= next_boundary
            pw_ix = DataStructures.dequeue!(pw_queue)
            current_ix[pw_ix] += 1
            if current_ix[pw_ix] < length(pws[pw_ix].boundaries)
                pw_queue[pw_ix] = pws[pw_ix].boundaries[current_ix[pw_ix]]
            end
        end
        push!(boundaries, next_boundary)
        push!(values, f((pws[i].values[current_ix[i]-1] for i in 1:length(pws))...))
    end
    push!(boundaries, pws[1].boundaries[end])

    Piecewise(boundaries, values)
end
