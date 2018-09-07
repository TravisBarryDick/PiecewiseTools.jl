@testset "test_piece_iterator.jl" begin

    @testset "single piece" begin
        pw = Piecewise(Float64[-Inf, Inf], [0])
        pwi = PieceIterator(pw)
        @test length(pwi) == 1
        @test first(pwi) == (Interval(-Inf,Inf), 0)
    end

    @testset "two pieces" begin
        pw = Piecewise([-Inf, 0, Inf], [0,1])
        ps = collect(PieceIterator(pw))
        @test length(ps) == 2
        @test typeof(ps) == Vector{Tuple{Interval,Int}}
        @test ps[1] == (Interval(-Inf, 0), 0)
        @test ps[2] == (Interval(0, Inf), 1)
    end

end
