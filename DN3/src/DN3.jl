module DN3

using LinearAlgebra
using SpecialFunctions

export zacetni_pogoj, magnusov_korak

"""
    zacetni_pogoj()

Vrne zacetni vektor stanja [Ai(0), Ai'(0)].
"""
function zacetni_pogoj()
  ai0 = 1 / (3^(2/3) * gamma(2/3))
  dai0 = -1 / (3^(1/3) * gamma(1/3))
  return [ai0, dai0]
end

"""
    magnusov_korak(x, y, h)

Naredi en Magnusov korak reda 4 dolzine h iz stanja y v tocki x.
"""
function magnusov_korak(x, y, h)
  # matrika sigma v zaprti obliki
  sigma = [-h^3/12       h;
           h*(x + h/2)   h^3/12]
  return exp(sigma) * y
end

end # module DN3
