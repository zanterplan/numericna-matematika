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

@testset "sestavljeno: pravilnost in red" begin
  # polinomi do stopnje 3 so točni
  @test sestavljeno(x -> x^3, 0, 2, 1) ≈ 4
  @test sestavljeno(x -> x^3, 0, 2, 5) ≈ 4
  @test sestavljeno(x -> 1, 0, 2, 7) ≈ 2
  @test sestavljeno(x -> x^2, 0, 2, 3) ≈ 8 / 3

  # analitično znan integral
  n1 = abs(sestavljeno(sin, 0, pi, 4) - 2)
  n2 = abs(sestavljeno(sin, 0, pi, 8) - 2)
  @test n1 < 1e-3
  @test n2 < n1

  # napaka pada kot O(h^4)
  prava = exp(1) - 1
  e1 = abs(sestavljeno(exp, 0, 1, 10) - prava)
  e2 = abs(sestavljeno(exp, 0, 1, 20) - prava)
  razmerje = e1 / e2
  @test 10 < razmerje < 20
end

@testset "integral: samodejna natančnost" begin
  # analitično znani integrali
  @test integral(exp, 0, 1) ≈ exp(1) - 1 atol = 1e-9
  @test integral(sin, 0, pi) ≈ 2 atol = 1e-9
  @test integral(x -> x^3, 0, 2) ≈ 4 atol = 1e-9

  # privzeti tol da vsaj 10 decimalk
  @test abs(integral(exp, 0, 1) - (exp(1) - 1)) < 1e-9
  @test abs(integral(sin, 0, pi) - 2) < 1e-9

  # ohlapnejša zahteva je še vedno izpolnjena
  @test abs(integral(exp, 0, 1; tol=1e-6) - (exp(1) - 1)) < 1e-6

  # robni primer
  @test integral(exp, 1, 1) == 0
end
