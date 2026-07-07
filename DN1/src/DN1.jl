module DN1

export Zlepek, vrednost

"""
    Zlepek(x, a, b, c, d)

Naravni kubični zlepek. Vektor `x` vsebuje interpolacijske točke,
vektorji `a`, `b`, `c` in `d` pa koeficiente polinomov

    S_i(x) = a_i + b_i(x - x_i) + c_i(x - x_i)^2 + d_i(x - x_i)^3

na podintervalih `[x[i], x[i+1]]`. Vektor `x` ima dolžino `n`,
vektorji koeficientov pa dolžino `n - 1`.
"""
struct Zlepek
  x::Vector{Float64}
  a::Vector{Float64}
  b::Vector{Float64}
  c::Vector{Float64}
  d::Vector{Float64}
end

"""
    y = vrednost(Z, x)

Izračunaj vrednost zlepka `Z` v točki `x`. Točka `x` mora ležati
na interpolacijskem intervalu `[x_1, x_n]`, sicer funkcija sproži napako.
"""
function vrednost(Z::Zlepek, x)
  if x < Z.x[1] || x > Z.x[end]
    throw(DomainError(x, "Točka leži izven interpolacijskega intervala."))
  end
  # poiščemo odsek i, na katerem leži x
  i = 1
  while i < length(Z.x) - 1 && x > Z.x[i+1]
    i = i + 1
  end
  # izvrednotimo polinom (Hornerjeva shema)
  t = x - Z.x[i]
  return Z.a[i] + t * (Z.b[i] + t * (Z.c[i] + t * Z.d[i]))
end

end # module DN1