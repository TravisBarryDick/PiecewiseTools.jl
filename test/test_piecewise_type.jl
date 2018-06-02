@testset "test_piecewise_type.jl" begin

    @testset "single piece" begin
        pw = Piecewise(Float64[], [0])
        @test num_pieces(pw) == 1
        @test pw(-1) == 0
        @test pw(0) == 0
        @test pw(1) == 0
    end

    @testset "step function" begin
        step = Piecewise([0], [0,1])
        @test num_pieces(step) == 2
        @test step(-Inf) == 0
        @test step(-1) == 0
        @test step(0) == 1
        @test step(1) == 1
        @test step(Inf) == 1
    end

    @testset "multiple breakpoints" begin
        multiple = Piecewise([-1,1], ["left", "middle", "right"])
        @test num_pieces(multiple) == 3
        @test multiple(-10) == "left"
        @test multiple(-1) == "middle"
        @test multiple(0) == "middle"
        @test multiple(1) == "right"
        @test multiple(10) == "right"
    end
    
end
