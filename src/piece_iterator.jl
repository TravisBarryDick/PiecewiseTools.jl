struct PieceIterator{T}
    pw::Piecewise{T}
    ivl::Interval
    first_ix::Int
    last_ix::Int
end

function PieceIterator(pw::Piecewise, ivl::Interval)
    first_ix = searchsortedlast(pw.boundaries, ivl.lo) + 1
    last_ix = searchsortedfirst(pw.boundaries, ivl.hi)
    return PieceIterator(pw, ivl, first_ix, last_ix)
end

function Base.iterate(pi::PieceIterator, state::Int = pi.first_ix)
    if state > pi.last_ix
        return nothing
    else
        lo = state == pi.first_ix ? pi.ivl.lo : pi.pw.boundaries[state-1]
        hi = state < pi.last_ix ? pi.pw.boundaries[state] : pi.ivl.hi
        return ((Interval(lo,hi), pi.pw.values[state]), state+1)
    end
end

Base.eltype(pi::PieceIterator{T}) where {T} = Tuple{Interval,T}

Base.length(pi::PieceIterator) = pi.last_ix - pi.first_ix + 1

"""
Returns an iterator over the pieces of `pw`. Each piece is represented as a
`Tuple{Interval,T}`. The pieces are iterated from left to right.
"""
piecesof(pw::Piecewise, ivl::Interval = Interval(-Inf,Inf)) = PieceIterator(pw, ivl)
