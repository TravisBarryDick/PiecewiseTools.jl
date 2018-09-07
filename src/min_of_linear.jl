"""
Given a vector of linear functions `lfs` and a point `x`, returns the index
of the function with the minimum value at `x`. If there are ties at `x`, then
the function that is the minimizer in the limit as `y` approaches `x` from the
right is chosen. Correctly handles cases when `x in [-Inf, Inf]`.
"""
function indmin_of_linear_at(lfs::Vector{LinearFunction}, x::Number)
    if x == -Inf
        return argmax([lf.slope for lf in lfs])
    elseif x == Inf
        return argmin([lf.slope for lf in lfs])
    else
        best_ix = 1
        best_value = lfs[1](x)
        for ix in 2:length(lfs)
            value = lfs[ix](x)
            approx_equal = abs(value - best_value) < 1e-6
            if value < best_value || (approx_equal && lfs[ix].slope < lfs[best_ix].slope)
                best_ix = ix
                best_value = value
            end
        end
        return best_ix
    end
end

"""
Given a vector `lfs` of linear functions and an interval `domain`, returns a
piecewise constant function mapping points `x` in the domain to the index of
the linear function of minimal value at `x`. Ties are broken by chosing the
linear function of that is the minimizer to the right of the intersection. If
two linear functions are exactly equal, then the tie between them is broken
arbitrarily. If there are `N` linear functions and `K` of them appear as the
minimizer in the interval `domain`, then the running time is `O(KN)`.
"""
function indmin_of_linear(lfs::Vector{LinearFunction}, domain = Interval(-Inf,Inf))
    x = domain.lo

    boundaries = Float64[domain.lo]
    values = Int[indmin_of_linear_at(lfs, x)]

    while x < domain.hi
        current_minimizer = lfs[values[end]]
        boundary = domain.hi
        for (i,lf) in enumerate(lfs)
            intersection = intersectionof(current_minimizer, lf)
            if intersection.kind == atpoint && intersection.location > x
                boundary = min(boundary, intersection.location)
            end
        end
        x = boundary
        if (boundary < domain.hi)
            push!(boundaries, boundary)
            push!(values, indmin_of_linear_at(lfs, x))
        end
    end

    push!(boundaries, domain.hi)

    return Piecewise(boundaries, values)
end
