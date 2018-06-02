"""
Given a vector of linear functions `lfs` and a point `x`, returns the index
of the function with the minimum value at `x`. If there are ties at `x`, then
the function that is the minimizer in the limit as `y` approaches `x` from the
right is chosen. Correctly handles cases when `x in [-Inf, Inf]`.
"""
function indmin_of_linear_at(lfs::Vector{LinearFunction}, x::Number)
    if x == -Inf
        return indmax(lf.slope for lf in lfs)
    elseif x == Inf
        return indmin(lf.slope for lf in lfs)
    else
        best_ix = 1
        best_value = lfs[1](x)
        for ix in 2:length(lfs)
            value = lfs[ix](x)
            if value < best_value || (value == best_value && lfs[ix].slope < lfs[best_ix].slope)
                best_ix = ix
                best_value = value
            end
        end
        return best_ix
    end
end

"""
Given a vector `lfs` of linear functions and an interval `ivl`, returns a
piecewise constant function mapping points `x` in the interval to the index of
the linear function of minimal value at `x`. Ties are broken by chosing the
linear function of that is the minimizer to the right of the intersection. If
two linear functions are exactly equal, then the tie between them is broken
arbitrarily. Points outside the interval are mapped to the minimizer at the
corresponding end point of the interval. If there are `N` linear functions and
`K` of them appear as the minimizer in the interval `ivl`, then the running time
is `O(KN)`.
"""
function indmin_of_linear(lfs::Vector{LinearFunction}, ivl = Interval(-Inf,Inf))
    x = ivl.lo

    boundaries = Float64[]
    values = Int[indmin_of_linear_at(lfs, x)]

    while x < ivl.hi
        current_minimizer = lfs[values[end]]
        boundary = ivl.hi
        for (i,lf) in enumerate(lfs)
            intersection = intersectionof(current_minimizer, lf)
            if intersection.kind == atpoint && intersection.location > x
                boundary = min(boundary, intersection.location)
            end
        end
        x = boundary
        if (boundary < ivl.hi)
            push!(boundaries, boundary)
            push!(values, indmin_of_linear_at(lfs, x))
        end
    end

    return Piecewise(boundaries, values)
end
