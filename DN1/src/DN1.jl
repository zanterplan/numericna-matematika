module DN1

using LinearAlgebra

export Zlepek, vrednost, interpoliraj

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
  # izvrednotimo polinom
  t = x - Z.x[i]
  return Z.a[i] + t * (Z.b[i] + t * (Z.c[i] + t * Z.d[i]))
end

"""
    Z = interpoliraj(x, y)

Izračunaj naravni kubični zlepek skozi točke `(x[i], y[i])` in vrni
element tipa `Zlepek`. Uporabi metodo momentov `M_i = S''(x_i)`, kjer
naravna pogoja postavita `M_1 = M_n = 0`, notranje momente pa dobimo
kot rešitev tridiagonalnega sistema.
"""
function interpoliraj(x, y)
  n = length(x)
  # validacija vhodov
  if n < 2
    throw(ArgumentError("Potrebni sta vsaj dve točki."))
  end
  if length(y) != n
    throw(ArgumentError("Vektorja x in y morata biti enako dolga."))
  end
  if !issorted(x)
    throw(ArgumentError("Vektor x mora biti urejen naraščajoče."))
  end

  x = Vector{Float64}(x)
  y = Vector{Float64}(y)

  # razmiki h_i in diferencni kolicniki delta_i
  h = x[2:n] - x[1:n-1]
  delta = (y[2:n] - y[1:n-1]) ./ h

  # momenti M_i
  M = zeros(n)
  if n > 2
    # tridiagonalni sistem za notranje momente
    dl = h[2:n-2]
    dd = 2 .* (h[1:n-2] + h[2:n-1])
    du = h[2:n-2]

    rhs = 6 .* (delta[2:n-1] - delta[1:n-2])
    A = Tridiagonal(dl, dd, du)
    M[2:n-1] = A \ rhs
  end

  # koeficienti odsekov
  a = y[1:n-1]
  b = delta - h ./ 6 .* (2 .* M[1:n-1] + M[2:n])
  c = M[1:n-1] ./ 2
  d = (M[2:n] - M[1:n-1]) ./ (6 .* h)

  return Zlepek(x, a, b, c, d)
end

end # module DN1