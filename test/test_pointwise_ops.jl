@testset "test_pointwise_ops.jl" begin

    @testset "unary pointwise" begin
        pw = Piecewise(Float64[-Inf, Inf], [1])
        pw = pointwise(x -> x*2, pw)
        @test num_pieces(pw) == 1
        @test pw(0) == 2
    end

    @testset "binary pointwise" begin
        pw_a = Piecewise([-Inf, -1, Inf], [0,1])
        pw_b = Piecewise([-Inf, 1, Inf], [0,1])
        pw_sum = pointwise(+, pw_a, pw_b)
        @test num_pieces(pw_sum) == 3
        @test pw_sum(-10) == 0
        @test pw_sum(-1) == 1
        @test pw_sum(0) == 1
        @test pw_sum(1) == 2
        @test pw_sum(10) == 2
    end

    @testset "repeated boundaries" begin
        pw_a = Piecewise([-Inf, 0, Inf], [-1,1])
        pw_b = Piecewise([-Inf, 0, Inf], [1,-1])
        pw_c = Piecewise([-Inf, 0, Inf], [0,1])
        pw_sum = pointwise(+, pw_a, pw_b, pw_c)
        @test num_pieces(pw_sum) == 2
        @test pw_sum(-1) == 0
        @test pw_sum(0) == 1
        @test pw_sum(1) == 1
    end

    @testset "interleaved boundaries" begin
        pw_a = Piecewise([-Inf, 0, 2, Inf], ["lo", "hi", "lo"])
        pw_b = Piecewise([-Inf, 1, Inf], ["lo", "hi"])
        pw_pairs = pointwise((a,b) -> (a,b), pw_a, pw_b)
        @test num_pieces(pw_pairs) == 4
        @test pw_pairs(-1) == ("lo", "lo")
        @test pw_pairs(0) == ("hi", "lo")
        @test pw_pairs(1) == ("hi", "hi")
        @test pw_pairs(2) == ("lo", "hi")
        @test pw_pairs(3) == ("lo", "hi")
    end

end
