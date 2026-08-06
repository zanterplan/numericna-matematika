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
  # robni primer x = x_n
  @test vrednost(Z, 2.0) ≈ 0.0 atol = 1e-14
  # vrednost sredi odseka
  @test vrednost(Z, 0.5) ≈ 1.5 * 0.5 - 0.5 * 0.5^3
  # izven intervala vrže napako
  @test_throws DomainError vrednost(Z, -0.1)
  @test_throws DomainError vrednost(Z, 2.1)
end

@testset "interpoliraj: ročni primer" begin
  # ročno izračunani koeficienti
  Z = interpoliraj([0, 1, 2], [0, 1, 0])
  @test Z.a ≈ [0.0, 1.0]
  @test Z.b ≈ [1.5, 0.0]
  @test Z.c ≈ [0.0, -1.5]
  @test Z.d ≈ [-0.5, 0.5]
end

@testset "interpoliraj: lastnosti zlepka" begin
  x = [0, 0.4, 1.1, 1.5, 2.7, 3.0]
  y = [1, -0.5, 2, 1.5, 0, 2.5]
  Z = interpoliraj(x, y)
  n = length(x)

  # interpolacijski pogoji S(x_i) = y_i
  for i in 1:n
    @test vrednost(Z, x[i]) ≈ y[i] atol = 1e-12
  end

  # zveznost S, S' in S'' v notranjih vozlih
  h = x[2:n] - x[1:n-1]
  for i in 1:n-2
    t = h[i]
    # S_i(x_{i+1}) = a_{i+1}
    Si = Z.a[i] + t * (Z.b[i] + t * (Z.c[i] + t * Z.d[i]))
    @test Si ≈ Z.a[i+1] atol = 1e-12
    # S_i'(x_{i+1}) = b_{i+1}
    dSi = Z.b[i] + t * (2 * Z.c[i] + 3 * t * Z.d[i])
    @test dSi ≈ Z.b[i+1] atol = 1e-12
    # S_i''(x_{i+1}) = 2*c_{i+1}
    ddSi = 2 * Z.c[i] + 6 * t * Z.d[i]
    @test ddSi ≈ 2 * Z.c[i+1] atol = 1e-12
  end

  # naravna robna pogoja
  @test 2 * Z.c[1] ≈ 0 atol = 1e-12
  @test 2 * Z.c[n-1] + 6 * Z.d[n-1] * h[n-1] ≈ 0 atol = 1e-12
end

@testset "interpoliraj: linearna funkcija" begin
  # na premici je naravni zlepek kar ta premica
  f(x) = 2 * x - 3
  x = collect(0.0:0.5:3.0)
  Z = interpoliraj(x, f.(x))
  for t in range(x[1], x[end], length = 20)
    @test vrednost(Z, t) ≈ f(t) atol = 1e-12
  end
end

@testset "interpoliraj: dve točki" begin
  # dve točki dasta premico skozi obe
  Z = interpoliraj([1.0, 3.0], [2.0, 6.0])
  @test vrednost(Z, 1.0) ≈ 2.0
  @test vrednost(Z, 3.0) ≈ 6.0
  # premica y = 2x se ujema tudi vmes
  @test vrednost(Z, 2.0) ≈ 4.0
  @test Z.c ≈ [0.0] atol = 1e-12
  @test Z.d ≈ [0.0] atol = 1e-12
end

@testset "interpoliraj: neveljavni vhodi" begin
  # ena sama točka
  @test_throws ArgumentError interpoliraj([1.0], [2.0])
  # različno dolga x in y
  @test_throws ArgumentError interpoliraj([1.0, 2.0], [3.0])
  # neurejen x
  @test_throws ArgumentError interpoliraj([2.0, 1.0], [3.0, 4.0])
end