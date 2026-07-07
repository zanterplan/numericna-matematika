using DN1, Test

@testset "Zlepek in vrednost" begin
  # ročno izračunan zlepek za točke (0,0), (1,1), (2,0)
  Z = Zlepek([0.0, 1.0, 2.0],
             [0.0, 1.0],
             [1.5, 0.0],
             [0.0, -1.5],
             [-0.5, 0.5])

  # interpolacijski pogoji
  @test vrednost(Z, 0.0) ≈ 0.0
  @test vrednost(Z, 1.0) ≈ 1.0
  @test vrednost(Z, 2.0) ≈ 0.0 atol = 1e-14 # robni primer x = x_n
  # vrednost sredi odseka: S_1(x) = 1.5x - 0.5x^3
  @test vrednost(Z, 0.5) ≈ 1.5 * 0.5 - 0.5 * 0.5^3
  # izven intervala vrže napako
  @test_throws DomainError vrednost(Z, -0.1)
  @test_throws DomainError vrednost(Z, 2.1)
end