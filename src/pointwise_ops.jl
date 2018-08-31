"""
Given a function `f` and piecewise functions `pws`, returns the piecewise
function given by `pw(x) = f(pws[1](x), ..., pws[end](x))`. If there are `N`
piecewise functions and the result has `K` break points, then the running time
is `O(K log N)`.
"""
function pointwise(f::Function, pws::Vararg{Piecewise})
    boundaries = Float64[]
    values = [f((pw.values[1] for pw in pws)...)]

    pw_queue = DataStructures.PriorityQueue{Int,Float64}()
    current_ix = Vector{Int}(undef, length(pws))
    for (pw_ix, pw) in enumerate(pws)
        if length(pw.boundaries) > 0
            pw_queue[pw_ix] = pw.boundaries[1]
            current_ix[pw_ix] = 1
        end
    end

    while !isempty(pw_queue)
        # Get the location of the next boundary
        next_boundary = DataStructures.peek(pw_queue)[2]
        # Increment the current_ix for each pw whose next boundary is equal to next_boundary
        while !isempty(pw_queue) && DataStructures.peek(pw_queue)[2] <= next_boundary
            pw_ix = DataStructures.dequeue!(pw_queue)
            current_ix[pw_ix] += 1
            if current_ix[pw_ix] <= length(pws[pw_ix].boundaries)
                pw_queue[pw_ix] = pws[pw_ix].boundaries[current_ix[pw_ix]]
            end
        end
        push!(values, f((pws[i].values[current_ix[i]] for i in 1:length(pws))...))
        push!(boundaries, next_boundary)
    end

    Piecewise(boundaries, values)
end
