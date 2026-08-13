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
