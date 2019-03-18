import DataStructures

"""
Represents an interval on the real line. Conventionally, the interval is closed
on the left and open on the right.
"""
struct Interval
    lo::Float64
    hi::Float64
end

"Tests if `x` is contained in `[ivl.lo, ivl.hi)`."
contains(ivl::Interval, x) = ivl.lo <= x < ivl.hi

"Tests if `x` is contained in `[ivl.lo, ivl.hi]`."
contains_closed(ivl::Interval, x) = ivl.lo <= x <= ivl.hi

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

"Returns the index of the piece of `pw` containing `x`."
function get_piece_index(pw::Piecewise, x)
    if !contains_closed(domain(pw), x)
        throw(DomainError(x, "The argument is outside the domain of the piecewise function"))
    end
    ix = searchsortedlast(pw.boundaries, x)
    # We do this so that the upper end of `domain(pw)` belongs to the final piece
    if ix == length(pw.boundaries)
        ix -= 1
    end
    ix
end

"Returns the `(ivl, value)` pair describing the piece of `pw` containing `x`."
function get_piece_containing(pw::Piecewise, x)
    get_piece(pw, get_piece_index(pw, x))
end

"Evaluates the piecewise function `pw` at `x`."
function (pw::Piecewise)(x::Number)
    ix = get_piece_index(pw, x)
    pw.values[ix]
end

import Base.==
function ==(a::Piecewise, b::Piecewise)
    all(a.boundaries .== b.boundaries) && all(a.values .== b.values)
end
