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
