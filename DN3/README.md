# DN3 - Ničle Airyjeve funkcije

Domača naloga 18.3.1 pri predmetu Numerična matematika.

## Opis naloge

Airyjeva funkcija `Ai` je rešitev začetnega problema `Ai''(x) = x Ai(x)` z danima vrednostma `Ai(0)` in `Ai'(0)`. Paket enačbo prevede na sistem prvega reda `y' = A(x) y` in ga rešuje z Magnusovo metodo reda 4. Ničle funkcije `Ai` poišče na 10 decimalk, spremembe predznaka na mreži izostri z Newtonovo metodo. Za preverjanje se uporablja `airyai` iz paketa `SpecialFunctions.jl`.

## Vsebina paketa

- `src/DN3.jl` - funkcije `zacetni_pogoj`, `magnusov_korak`, `resi` in `nicle`.
- `test/runtests.jl` - testi.
- `doc/demo.jl` - demo skripta z glavnim izračunom in slikami za poročilo.

## Uporaba

Iz korenskega okolja repozitorija:

```julia
using DN3

# resitev na intervalu [-10, 0] z 1000 koraki
x, Y = resi(-10.0, 1000)

# vse nicle Ai na [-10, 0] na 10 decimalk
z = nicle(-10.0, 10000)
```

Funkcija `resi(b, N)` vrne mrežo točk `x` in matriko `Y`, katere stolpci so vrednosti `[Ai(x_k), Ai'(x_k)]`. Funkcija `nicle(b, N)` vrne vse ničle funkcije `Ai` na intervalu `[b, 0]`, urejene padajoče.

## Testi

Iz korenskega okolja repozitorija:

```julia
using Pkg
Pkg.test("DN3")
```

ali v paketnem načinu (`]`) z ukazom `test DN3`.

## Poročilo

Glavni izračun in slike za poročilo ustvari demo skripta:

```julia
include("DN3/doc/demo.jl")
```

Skripta izpiše tabelo ničel (s primerjavo z `airyai` in asimptotično formulo) in tabelo konvergence ter shrani slike v mapo `doc/`. Poročilo (`doc/porocilo.pdf`) vsebuje izpeljavo metode in rezultate.
