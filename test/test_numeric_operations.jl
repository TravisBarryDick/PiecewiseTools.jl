@testset "numeric_operations.jl" begin

    @testset "mean" begin
        f1 = Piecewise([0, 1], [1])
        f2 = Piecewise([0, 1], [2])
        @test mean([f1, f2]) == Piecewise([0,1], [1.5])
        f3 = Piecewise([0, 1/2, 1], [1, 2])
        @test mean([f1, f2, f3]) == Piecewise([0, 1/2, 1], [(1+2+1)/3, (2+2+1)/3])
    end

    @testset "rational mean" begin
        f1 = Piecewise([0,1], [1//1])
        f2 = Piecewise([0,1], [2//1])
        @test mean([f1, f2]) == Piecewise{Rational{Int}}([0,1], [3//2])
    end

end
