import DataStructures

"""
Represents an interval on the real line. Conventionally, the interval is closed
on the left and open on the right.
"""
struct Interval
    lo::Float64
    hi::Float64
end

"""
Represents a piecewise constant function from the real numbers to elements of
`T`. Note that this can be used to represent piecewise defined functions by
choosing the type `T` to represent the function class (e.g., polynomials). The
piecewise constant function is encoded by a vector of `boundaries` or
discontinuities, and a vector of `values` which has length `length(bounaries) -
1`. Each constant interval of the function is closed on the left and open on
the right. The domain of the function is `[boundaries[1], boundaries[end]]`,
which can be equal to `[-Inf, Inf]`.
"""
struct Piecewise{T}
    boundaries::Vector{Float64}
    values::Vector{T}
end

function Piecewise(boundaries::Vector{N}, values::Vector{T}) where {N <: Number, T}
    return Piecewise(convert(Vector{Float64}, boundaries), values)
end

"""
Creates a piecewise constant function whose domain is the entire real line with
discontinuities at the locations in `boundaries` and the given `values`. The
values and boundaries should satisfy `length(boundaries) = length(values) - 1`.
"""
function unconstrained_piecewise(boundaries, values)
    return Piecewise(vcat(-Inf, boundaries, Inf), values)
end

"Returns the domain of the piecewise constant function `pw`."
domain(pw::Piecewise) = Interval(pw.boundaries[1], pw.boundaries[end])

"Returns the number of pieces in `pw`."
num_pieces(pw::Piecewise) = length(pw.values)

"Returns the `ix`th piece as an `(Interval, T)` pair."
function get_piece(pw::Piecewise, ix)
    ivl = Interval(pw.boundaries[ix], pw.boundaries[ix+1])
    value = pw.values[ix]
    (ivl, value)
end

"Evaluates the piecewise function `pw` at `x`."
function (piecewise::Piecewise)(x::Number)
    ix = searchsortedlast(piecewise.boundaries, x)
    if ix == 0
        throw(DomainError(x, "The argument is outside the domain of the piecewise function"))
    end
    # We do this to allow evaluation of the function at the right end-point
    # of its domain.
    if ix == length(piecewise.boundaries)
        ix -= 1
    end
    piecewise.values[ix]
end
