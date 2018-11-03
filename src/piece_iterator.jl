struct PieceIterator{T}
    pw::Piecewise{T}
end

function Base.iterate(pi::PieceIterator, state::Int = 1)
    if state > num_pieces(pi.pw)
        return nothing
    else
        return (get_piece(pi.pw, state), state + 1)
    end
end

Base.eltype(pi::PieceIterator{T}) where {T} = Tuple{Interval,T}

Base.length(pi::PieceIterator) = num_pieces(pi.pw)

struct ReversePieceIterator{T}
    pw::Piecewise{T}
end

function Base.iterate(pi::ReversePieceIterator, state::Int = num_pieces(pi.pw))
    if state <= 0
        return nothing
    else
        return (get_piece(pi.pw, state), state - 1)
    end
end

Base.eltype(pi::ReversePieceIterator{T}) where {T} = Tuple{Interval,T}

Base.length(pi::ReversePieceIterator) = num_pieces(pi.pw)
