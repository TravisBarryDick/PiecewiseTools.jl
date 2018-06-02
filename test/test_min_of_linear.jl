@testset "test_min_of_linear.jl" begin

    @testset "indmin_of_linear_at" begin
        lfs = [LinearFunction(0,-1), LinearFunction(0,1), LinearFunction(-1,0)]
        @test indmin_of_linear_at(lfs, -Inf) == 2
        @test indmin_of_linear_at(lfs, -1.1) == 2
        @test indmin_of_linear_at(lfs, -1) == 3
        @test indmin_of_linear_at(lfs, 0) == 3
        @test indmin_of_linear_at(lfs, 1) == 1
        @test indmin_of_linear_at(lfs, Inf) == 1
    end

    @testset "single linear function" begin
        lf = LinearFunction(0,1)
        pw = indmin_of_linear([lf])
        @test num_pieces(pw) == 1
        @test pw(0) == 1
        @test pw(10) == 1
    end

    @testset "two functions" begin
        lf_a = LinearFunction(0,1)
        lf_b = LinearFunction(0,-1)
        pw = indmin_of_linear([lf_a, lf_b])
        @test num_pieces(pw) == 2
        @test pw(-1) == 1
        @test pw(0) == 2
        @test pw(1) == 2
    end

    @testset "three functions" begin
        lfs = [LinearFunction(1,-1), LinearFunction(0,0), LinearFunction(1,1)]
        pw = indmin_of_linear(lfs)
        @test num_pieces(pw) == 3
        @test pw(-2) == 3
        @test pw(-1) == 2
        @test pw(0) == 2
        @test pw(1) == 1
        @test pw(2) == 1
    end

    @testset "restricted interval" begin
        lfs = [LinearFunction(1,-1), LinearFunction(0,0), LinearFunction(1,1)]
        pw = indmin_of_linear(lfs, Interval(-1,1))
        @test num_pieces(pw) == 1
        @test pw(0) == 2

        pw = indmin_of_linear(lfs, Interval(-1.1,1))
        @test num_pieces(pw) == 2
        @test pw(-1.1) == 3
        @test pw(0) == 2

        pw = indmin_of_linear(lfs, Interval(-1,1.1))
        @test num_pieces(pw) == 2
        @test pw(0) == 2
        @test pw(1) == 1
    end

end
