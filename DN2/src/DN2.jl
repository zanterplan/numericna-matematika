module DN2

export gauss2

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

end # module DN2
