module PiecewiseTools

include("piecewise_type.jl")
export Piecewise, num_pieces, get_piece, Interval

include("pointwise_ops.jl")
export pointwise

include("piece_iterator.jl")
export piecesof

include("linear_functions.jl")
export LinearFunction

include("min_of_linear.jl")
export indmin_of_linear_at, indmin_of_linear

end
