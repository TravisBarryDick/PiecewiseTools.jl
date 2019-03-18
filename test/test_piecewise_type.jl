@testset "test_piecewise_type.jl" begin

    @testset "single piece" begin
        pw = Piecewise(Float64[-Inf,Inf], [0])
        @test num_pieces(pw) == 1
        @test pw(-1) == 0
        @test pw(0) == 0
        @test pw(1) == 0
        @test get_piece_index(pw, 0) == 1
        @test get_piece_containing(pw, 1.0) == (Interval(-Inf, Inf), 0)
        @test get_piece(pw, 1) == (Interval(-Inf, Inf), 0)
    end

    @testset "step function" begin
        step = Piecewise([-Inf, 0, Inf], [0,1])
        @test num_pieces(step) == 2
        @test step(-Inf) == 0
        @test step(-1) == 0
        @test step(0) == 1
        @test step(1) == 1
        @test step(Inf) == 1
        @test get_piece_index(step, -1) == 1
        @test get_piece_containing(step, -1) == (Interval(-Inf, 0), 0)
        @test get_piece(step, 1) == (Interval(-Inf, 0), 0)
        @test get_piece_index(step, 1) == 2
        @test get_piece_containing(step, 1) == (Interval(0, Inf), 1)
        @test get_piece(step, 2) == (Interval(0, Inf), 1)
    end

    @testset "multiple breakpoints" begin
        multiple = Piecewise([-Inf, -1, 1, Inf], ["left", "middle", "right"])
        @test num_pieces(multiple) == 3
        @test multiple(-10) == "left"
        @test multiple(-1) == "middle"
        @test multiple(0) == "middle"
        @test multiple(1) == "right"
        @test multiple(10) == "right"

        @test get_piece_index(multiple, -2) == 1
        @test get_piece_containing(multiple, -2) == (Interval(-Inf, -1), "left")
        @test get_piece(multiple, 1) == (Interval(-Inf, -1), "left")

        @test get_piece_index(multiple, 0) == 2
        @test get_piece_containing(multiple, 0) == (Interval(-1,1), "middle")
        @test get_piece(multiple, 2) == (Interval(-1, 1), "middle")

        @test get_piece_index(multiple, 2) == 3
        @test get_piece_containing(multiple, 2) == (Interval(1, Inf), "right")
        @test get_piece(multiple, 3) == (Interval(1, Inf), "right")
    end

    @testset "domain" begin
        pw = Piecewise([-Inf, 0, Inf], [0,1])
        @test domain(pw) == Interval(-Inf, Inf)

        pw = Piecewise([0, 0.1, 0.2, 0.3, 1], [0,1,2,3])
        @test domain(pw) == Interval(0, 1)
    end

    @testset "contains" begin
        ivl = Interval(0,1)
        @test contains(ivl, 0)
        @test contains(ivl, 0.9)
        @test !contains(ivl, 1)
        @test !contains(ivl, -1)

        @test contains_closed(ivl, 0)
        @test contains_closed(ivl, 0.9)
        @test contains_closed(ivl, 1)
        @test !contains_closed(ivl, -1)
        @test !contains_closed(ivl, 2)
    end

end
