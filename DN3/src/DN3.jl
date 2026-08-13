module DN3

using LinearAlgebra
using SpecialFunctions

export zacetni_pogoj, magnusov_korak, resi, nicle

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

"""
    nicle(b, N)

Poišče vse ničle funkcije Ai na intervalu [b, 0], urejene padajoče.
"""
function nicle(b, N)
  b < 0 || throw(ArgumentError("b mora biti negativen"))
  N >= 2 || throw(ArgumentError("N mora biti vsaj 2"))
  x, Y = resi(b, N)
  z = Float64[]
  for k in 1:N
    # sprememba predznaka
    Y[1, k] * Y[1, k + 1] < 0 || continue
    # oklepajoči interval
    lo, hi = x[k + 1], x[k]
    plo = sign(Y[1, k + 1])
    t = (lo + hi) / 2
    for _ in 1:50
      # Ai(t) in Ai'(t) z Magnusovim korakom
      v = magnusov_korak(x[k], Y[:, k], t - x[k])
      # posodobi oklep
      if sign(v[1]) == plo
        lo = t
      else
        hi = t
      end
      # Newtonov korak
      tn = t - v[1] / v[2]
      # izven podintervala bisekcija
      if !(x[k + 1] <= tn <= x[k])
        tn = (lo + hi) / 2
      end
      if abs(tn - t) < 1e-13
        t = tn
        break
      end
      t = tn
    end
    push!(z, t)
  end
  return z
end

end # module DN3
