using DN2, Test

@testset "gauss2: točnost do stopnje 3" begin
  # polinomi do stopnje 3 na [0, 2]
  @test gauss2(x -> 1, 0, 2) ≈ 2
  @test gauss2(x -> x, 0, 2) ≈ 2
  @test gauss2(x -> x^2, 0, 2) ≈ 8 / 3
  @test gauss2(x -> x^3, 0, 2) ≈ 4

  # za x^4 pravilo ni vec točno
  @test !isapprox(gauss2(x -> x^4, 0, 2), 32 / 5)
  @test abs(gauss2(x -> x^4, 0, 2) - 32 / 5) > 1e-6

  # še na drugem intervalu
  @test gauss2(x -> x^2, -1, 1) ≈ 2 / 3
end
