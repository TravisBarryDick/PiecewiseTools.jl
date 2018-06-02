@testset "test_piece_iterator.jl" begin

    @testset "single piece" begin
        pw = Piecewise(Float64[], [0])
        pwi = piecesof(pw)
        @test length(pwi) == 1
        @test first(pwi) == (Interval(-Inf,Inf), 0)
    end

    @testset "two pieces" begin
        pw = Piecewise([0], [0,1])
        ps = collect(piecesof(pw))
        @test length(ps) == 2
        @test typeof(ps) == Vector{Tuple{Interval,Int}}
        @test ps[1] == (Interval(-Inf, 0), 0)
        @test ps[2] == (Interval(0, Inf), 1)
    end

    @testset "clipped pieces" begin
        pw = Piecewise([0,1], [0,1,2])

        ps = collect(piecesof(pw, Interval(-1,2)))
        @test length(ps) == 3
        @test ps[1] == (Interval(-1,0), 0)
        @test ps[2] == (Interval(0,1), 1)
        @test ps[3] == (Interval(1,2), 2)

        ps = collect(piecesof(pw, Interval(-1,1)))
        @test length(ps) == 2
        @test ps[1] == (Interval(-1,0), 0)
        @test ps[2] == (Interval(0,1), 1)

        ps = collect(piecesof(pw, Interval(-1,0)))
        @test length(ps) == 1
        @test ps[1] == (Interval(-1,0), 0)

        ps = collect(piecesof(pw, Interval(0,1)))
        @test length(ps) == 1
        @test ps[1] == (Interval(0,1), 1)

        ps = collect(piecesof(pw, Interval(0.5,1.5)))
        @test length(ps) == 2
        @test ps[1] == (Interval(0.5,1), 1)
        @test ps[2] == (Interval(1,1.5), 2)
    end

end
