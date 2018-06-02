@testset "test_linear_functions.jl" begin
    intersectionof = PiecewiseTools.intersectionof
    LinearIntersection = PiecewiseTools.LinearIntersection
    nowhere = PiecewiseTools.nowhere
    everywhere = PiecewiseTools.everywhere
    atpoint = PiecewiseTools.atpoint

    @testset "creation and evaluation" begin
        lf = LinearFunction(0, 1)
        @test lf(0) ≈ 0
        @test lf(1) ≈ 1
        @test lf(2) ≈ 2
    end

    @testset "non-zero intercept" begin
        lf = LinearFunction(10, -1)
        @test lf(0) ≈ 10
        @test lf(1) ≈ 9
        @test lf(10) ≈ 0
    end

    @testset "adding linear functions" begin
        lf_a = LinearFunction(0,1)
        lf_b = LinearFunction(1,0)
        lf_sum = lf_a + lf_b
        @test lf_sum.intercept ≈ 1
        @test lf_sum.slope ≈ 1
    end

    @testset "subtracting linear functions" begin
        lf_a = LinearFunction(0,1)
        lf_b = LinearFunction(1,0)
        lf_diff = lf_a - lf_b
        @test lf_diff.intercept ≈ -1
        @test lf_diff.slope ≈ 1
    end

    @testset "intersection of linear functions" begin
        lf_a = LinearFunction(0,1)
        lf_b = LinearFunction(1,1)
        # Parallel lines do not intersect and so we should return NaN
        @test intersectionof(lf_a, lf_b) == LinearIntersection(nowhere)

        lf_a = LinearFunction(0,1)
        lf_b = LinearFunction(0,1)
        @test intersectionof(lf_a, lf_b) == LinearIntersection(everywhere)

        lf_a = LinearFunction(0,1)
        lf_b = LinearFunction(1,0)
        @test intersectionof(lf_a, lf_b) == LinearIntersection(atpoint, 1)
    end

end
