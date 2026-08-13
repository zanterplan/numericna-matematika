using DN3, Test, SpecialFunctions

@testset "magnusov korak" begin
  # začetni pogoj
  y0 = zacetni_pogoj()
  @test y0[1] ≈ airyai(0.0) atol=1e-14
  @test y0[2] ≈ airyaiprime(0.0) atol=1e-14

  # korak nazaj
  y = magnusov_korak(0.0, y0, -0.1)
  @test y[1] ≈ airyai(-0.1) atol=1e-8
  # ohlapnejša toleranca
  @test y[2] ≈ airyaiprime(-0.1) atol=1e-7

  h = -0.2
  e1 = abs(magnusov_korak(0.0, y0, h)[1] - airyai(h))
  e2 = abs(magnusov_korak(0.0, y0, h/2)[1] - airyai(h/2))
  razmerje = e1 / e2
  @test 20 < razmerje < 80

  # pozitivni h
  yp = magnusov_korak(0.0, y0, 0.1)
  @test yp[1] ≈ airyai(0.1) atol=1e-8
end

@testset "integracija in globalni red" begin
  # oblika
  x, Y = resi(-1.0, 10)
  @test length(x) == 11
  @test size(Y) == (2, 11)
  @test x[1] == 0.0
  @test x[end] ≈ -1.0

  # prvi stolpec je začetni pogoj
  @test Y[:, 1] == zacetni_pogoj()

  # pravilnost na koncu intervala
  x, Y = resi(-2.0, 200)
  @test Y[1, end] ≈ airyai(-2.0) atol=1e-9
  @test Y[2, end] ≈ airyaiprime(-2.0) atol=1e-9

  # vmesne točke
  for k in (50, 100, 150)
    @test Y[1, k] ≈ airyai(x[k]) atol=1e-8
  end

  # globalni red
  _, Y50 = resi(-2.0, 50)
  _, Y100 = resi(-2.0, 100)
  e50 = abs(Y50[1, end] - airyai(-2.0))
  e100 = abs(Y100[1, end] - airyai(-2.0))
  razmerje = e50 / e100
  @test 10 < razmerje < 25

  # pozitiven b
  _, Yp = resi(1.0, 100)
  @test Yp[1, end] ≈ airyai(1.0) atol=1e-9

  # validacija
  @test_throws ArgumentError resi(-1.0, 0)
  @test_throws ArgumentError resi(0.0, 10)
end
