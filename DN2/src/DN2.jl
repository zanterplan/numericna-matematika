module DN2

export gauss2, sestavljeno

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

end # module DN2
