module DN2

export gauss2, sestavljeno, integral

"""
    gauss2(f, a, b)

Izračuna približek za integral funkcije `f` na intervalu `[a, b]` z
dvotočkovnim Gauss-Legendrovim pravilom. Pravilo je točno za polinome
do stopnje 3.
"""
function gauss2(f, a, b)
  m = (a + b) / 2
  d = (b - a) / 2
  h = d / sqrt(3)
  d * (f(m - h) + f(m + h))
end

"""
    sestavljena(f, a, b, N)

Izračuna približek za integral funkcije `f` na intervalu `[a, b]` s
sestavljenim dvotočkovnim Gauss-Legendrovim pravilom. Interval razdeli
na `N` enakih podintervalov in na vsakem uporabi `gauss2`.
"""
function sestavljeno(f, a, b, N)
  h = (b - a) / N
  vsota = 0.0
  for k in 0:(N - 1)
    # robovi k-tega podintervala
    vsota += gauss2(f, a + k * h, a + (k + 1) * h)
  end
  vsota
end

"""
    integral(f, a, b; tol=1e-10)

Izračuna približek za integral funkcije `f` na intervalu `[a, b]` s
podvajanjem števila podintervalov, dokler ocena napake ne pade pod `tol`.
"""
function integral(f, a, b; tol=1e-10)
  Nmax = 10^6
  N = 2
  Q_N = sestavljeno(f, a, b, N)
  while 2 * N <= Nmax
    Q_2N = sestavljeno(f, a, b, 2 * N)
    # metoda je reda 4
    ocena = (Q_2N - Q_N) / 15
    N *= 2
    Q_N = Q_2N
    if abs(ocena) < tol
      return Q_2N
    end
  end
  Q_N
end

end # module DN2
