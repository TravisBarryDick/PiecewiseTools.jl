"""
Samples the function `f` at `n` evenly spaced points in the domain of `f`.
Returns both the sampling points `xs` and the corresponding function values
`ys`.
"""
function sample(f::Piecewise{T}, n) where {T}
    d = domain(f)
    xs = LinRange{Float64}(d.lo, d.hi, n)
    ys = f.(xs)
    xs, ys
end

"""
Returns two vectors `xs` and `ys` that encode the graph of the function `f`.
This is very helpful for plotting `Piecewise{Float64}` instances.
"""
function get_plot_points(f::Piecewise{T}) where {T}
    xs = Float64[]
    ys = T[]
    for (ivl, v) in PieceIterator(f)
        push!(xs, ivl.lo)
        push!(xs, ivl.hi)
        push!(ys, v)
        push!(ys, v)
    end
    xs, ys
end

"""
Given a piecewise constant function `f`, returns a new piecewise constant
function `g` such that `g(x) == f(x)` for all `x`, but the number of pieces
in the definition of `g` is minimal. In other words, it removes consecutive
pieces in `f` with the same value.
"""
function compress(f::Piecewise{T}) where {T}
    boundaries = Float64[]
    values = T[]
    push!(boundaries, f.boundaries[1])
    push!(values, f.values[1])
    for i in 2:length(f.values)
        if f.values[i] != f.values[i-1]
            push!(boundaries, f.boundaries[i])
            push!(values, f.values[i])
        end
    end
    push!(boundaries, f.boundaries[end])
    Piecewise{T}(boundaries, values)
end
