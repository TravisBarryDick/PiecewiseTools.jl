import DataStructures

"""
Represents a piecewise constant function from the real numbers to elements of
`T`. Note that this can be used to represent piecewise defined functions by
choosing the type `T` to represent the function class (e.g., polynomials). The
piecewise constant function is encoded by a vector of `boundaries` or
discontinuities, and a vector of `values` which has length `length(bounaries) +
1`. Each constant interval of the function is closed on the left and open on
the right.
"""
struct Piecewise{T}
    boundaries::Vector{Float64}
    values::Vector{T}
end

function Piecewise(boundaries::Vector{N}, values::Vector{T}) where {N <: Number, T}
    return Piecewise(convert(Vector{Float64}, boundaries), values)
end

"Returns the number of pieces in `pw`."
num_pieces(pw::Piecewise) = length(pw.values)

"Evaluates the piecewise function `pw` at `x`."
function (piecewise::Piecewise)(x::Number)
    ix = searchsortedlast(piecewise.boundaries, x) + 1
    piecewise.values[ix]
end

"""
Represents an interval on the real line. Conventionally, the interval is closed
on the left and open on the right.
"""
struct Interval
    lo::Float64
    hi::Float64
end
