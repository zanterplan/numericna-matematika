# DN1 - Naravni kubični zlepek

Domača naloga 18.1.8 pri predmetu Numerična matematika.

## Opis naloge

Za dane interpolacijske točke `(x_i, f_i)`, `i = 1, ..., n`, paket izračuna naravni interpolacijski kubični zlepek `S`. To je funkcija, ki je na vsakem podintervalu `[x_i, x_{i+1}]` polinom stopnje 3 ali manj, je dvakrat zvezno odvedljiva, interpolira dane točke (`S(x_i) = f_i`) in zadošča naravnima robnima pogojema `S''(x_1) = S''(x_n) = 0`.

Koeficienti so izračunani z metodo momentov `M_i = S''(x_i)`, kjer notranji momenti rešijo tridiagonalni sistem linearnih enačb.

## Vsebina paketa

- `src/DN1.jl` - tip `Zlepek` ter funkcije `interpoliraj`, `vrednost` in risalni recept za `plot`.
- `test/runtests.jl` - testi.
- `doc/demo.jl` - demo skripta, ki ustvari slike za poročilo.

## Uporaba

Paket je razvit v korenskem okolju repozitorija. Iz korenske mape:

```julia
using DN1

# interpolacijske točke
x = [0.0, 1.0, 2.0, 3.0]
y = [0.0, 2.0, -1.0, 1.0]

# izračun zlepka
Z = interpoliraj(x, y)

# vrednost zlepka v točki
vrednost(Z, 1.5)

# graf zlepka
using Plots
plot(Z)
```

Funkcija `interpoliraj(x, y)` vrne element tipa `Zlepek`, ki hrani interpolacijske točke in koeficiente polinomov. `vrednost(Z, x)` vrne vrednost zlepka v točki `x` znotraj intervala `[x_1, x_n]`. `plot(Z)` nariše graf, pri čemer sosednje odseke pobarva izmenično rdeče in modro.

## Testi

Teste poženeš iz korenskega okolja repozitorija:

```julia
using Pkg
Pkg.test("DN1")
```

ali v paketnem načinu (`]`) z ukazom `test DN1`.

## Poročilo

Slike za poročilo ustvari demo skripta:

```julia
include("DN1/doc/demo.jl")
```

Skripta shrani slike v mapo `doc/`. Poročilo (`doc/porocilo.pdf`) vsebuje matematični opis naloge, opis metode reševanja in primere uporabe s slikami.
