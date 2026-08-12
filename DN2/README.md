# DN2 - Gauss-Legendrove kvadrature

Domača naloga 18.2.13 pri predmetu Numerična matematika.

## Opis naloge

Paket računa določene integrale z dvotočkovnim Gauss-Legendrovim pravilom. Osnovno pravilo na intervalu `[-1, 1]` uporablja vozla `+-1/sqrt(3)` in obe uteži enaki 1 ter je točno za polinome stopnje 3 ali manj. Z linearno zamenjavo ga prenesemo na poljuben interval, s sestavljanjem po podintervalih pa dobimo sestavljeno pravilo reda 4 (napaka pada kot `O(h^4)`).

Paket uporabimo za izračun integrala `sin(x)/x na [0, 5]` na 10 decimalk in za oceno števila potrebnih izračunov funkcijskih vrednosti.

## Vsebina paketa

- `src/DN2.jl` - funkcije `gauss2`, `sestavljena` in `integral`.
- `test/runtests.jl` - testi.
- `doc/demo.jl` - demo skripta z glavnim izračunom in slikami za poročilo.

## Uporaba

Iz korenskega okolja repozitorija:

```julia
using DN2

# dvotočkovno pravilo na enem intervalu
gauss2(sin, 0, pi)

# sestavljeno pravilo z N podintervali
sestavljena(sin, 0, pi, 100)

# samodejno doseganje zahtevane natančnosti
integral(sin, 0, pi)              # privzeta toleranca 1e-10
integral(sin, 0, pi; tol=1e-6)    # poljubna toleranca
```

Funkcija `gauss2(f, a, b)` vrne približek integrala `f` na `[a, b]` z enim korakom pravila. `sestavljena(f, a, b, N)` razdeli interval na `N` podintervalov. `integral(f, a, b; tol)` podvaja število podintervalov, dokler ocena napake ne pade pod `tol`, in vrne dobljeni približek.

## Testi

Iz korenskega okolja repozitorija:

```julia
using Pkg
Pkg.test("DN2")
```

ali v paketnem načinu (`]`) z ukazom `test DN2`.

## Poročilo

Glavni izračun in slike za poročilo ustvari demo skripta:

```julia
include("DN2/doc/demo.jl")
```

Skripta izpiše vrednost integrala in tabelo konvergence ter shrani slike v mapo `doc/`. Poročilo (`doc/porocilo.pdf`) vsebuje izpeljavo pravila, formulo za napako, opis sestavljenega pravila in rezultate.
