function mean(fs::Vector{Piecewise{N}}) where {N <: Number}
    pointwise(vs::Vararg{N} -> sum(vs)/length(vs), fs...)
end
