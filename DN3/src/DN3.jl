module DN3

using LinearAlgebra
using SpecialFunctions

export zacetni_pogoj, magnusov_korak, resi

"""
    zacetni_pogoj()

Vrne začetni vektor stanja [Ai(0), Ai'(0)].
"""
function zacetni_pogoj()
  ai0 = 1 / (3^(2/3) * gamma(2/3))
  dai0 = -1 / (3^(1/3) * gamma(1/3))
  return [ai0, dai0]
end

"""
    magnusov_korak(x, y, h)

Naredi en Magnusov korak reda 4 dolžine h iz stanja y v točki x.
"""
function magnusov_korak(x, y, h)
  # matrika sigma v zaprti obliki
  sigma = [-h^3/12       h;
           h*(x + h/2)   h^3/12]
  return exp(sigma) * y
end

"""
    resi(b, N)

Integrira Airyjevo enačbo od 0 do b z N Magnusovimi koraki.
"""
function resi(b, N)
  N >= 1 || throw(ArgumentError("N mora biti vsaj 1"))
  b != 0 || throw(ArgumentError("b ne sme biti nič"))
  h = b / N
  # mreža tock x_k
  x = collect(range(0.0, b, length = N + 1))
  Y = zeros(2, N + 1)
  Y[:, 1] = zacetni_pogoj()
  # korak za korakom
  for k in 1:N
    Y[:, k + 1] = magnusov_korak(x[k], Y[:, k], h)
  end
  return x, Y
end

end # module DN3
