module PiecewiseTools

include("piecewise_type.jl")
export Piecewise, domain, num_pieces, get_piece, get_piece_index
export get_piece_containing, Interval, contains, contains_closed

include("pointwise_ops.jl")
export pointwise

include("piece_iterator.jl")
export PieceIterator, ReversePieceIterator

include("linear_functions.jl")
export LinearFunction

include("min_of_linear.jl")
export indmin_of_linear_at, indmin_of_linear

include("numeric_operations.jl")
export mean

include("utilities.jl")
export sample, get_plot_points, compress

end
