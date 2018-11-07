@testset "test_utilities.jl" begin

    @testset "sampling" begin
        f = Piecewise([0, 1, 2], ["left", "right"])
        @test sample(f, 3) == ([0, 1, 2], ["left", "right", "right"])
        @test sample(f, 5) == ([0, 0.5, 1, 1.5, 2], ["left", "left", "right", "right", "right"])
    end

    @testset "compress" begin
        f = Piecewise([0, 1], ["test"])
        @test compress(f) == Piecewise([0,1], ["test"])

        f = Piecewise([0, 1, 2, 3], [0, 0, 0])
        @test compress(f) == Piecewise([0,3], [0])

        f = Piecewise([0, 1, 2, 3], [0, 0, 1])
        @test compress(f) == Piecewise([0,2,3], [0, 1])

        f = Piecewise([0, 1, 2, 3, 4], [0, 0, 1, 1])
        @test compress(f) == Piecewise([0,2,4], [0,1])
    end

end
