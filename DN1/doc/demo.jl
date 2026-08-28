# Demo skripta: slike za poročilo o naravnem kubičnem zlepku.
# Slike se shranijo v mapo, ki vsebuje to skripto.

using DN1
using Plots

const MAPA = @__DIR__

# osnovni prikaz risanja zlepka
x1 = [0, 1, 2, 3, 4, 5]
y1 = [0, 2, -1, 1, 3, 0]
Z1 = interpoliraj(x1, y1)

# nariše odseke izmenično rdeče in modro
plot(Z1,
     title = "Naravni kubični zlepek",
     xlabel = "x",
     ylabel = "S(x)")
scatter!(x1, y1,
         color = :black,
         markersize = 5,
         label = "interpolacijske točke",
         legend = :topleft)
savefig(joinpath(MAPA, "slika1_zlepek.png"))

# Rungejeva funkcija
runge(x) = 1 / (1 + 25 * x^2)

x2 = collect(range(-1, 1, length = 11))
y2 = runge.(x2)
Z2 = interpoliraj(x2, y2)

# gosta mreža za primerjavo prave funkcije in zlepka
t2 = range(-1, 1, length = 400)
plot(t2, runge.(t2),
     color = :black,
     linewidth = 2,
     label = "f(x) = 1 / (1 + 25 x^2)",
     title = "Interpolacija Rungejeve funkcije z zlepkom",
     xlabel = "x",
     ylabel = "y",
     legend = :topright)
plot!(t2, [vrednost(Z2, tj) for tj in t2],
      color = :blue,
      linewidth = 2,
      label = "zlepek skozi 11 vozlov")
scatter!(x2, y2,
         color = :black,
         markersize = 4,
         label = "vozli")
savefig(joinpath(MAPA, "slika2_runge.png"))

# empirični red metode
f(x) = sin(x)
a, b = 0.0, 2 * pi

# gosta mreža, na kateri merimo maksimalno napako
t3 = range(a, b, length = 2000)
prava = f.(t3)

nji = [5, 9, 17, 33, 65, 129]
hji = Float64[]
napake = Float64[]

println("n      h              max napaka     red")
for (k, n) in enumerate(nji)
  xk = collect(range(a, b, length = n))
  Zk = interpoliraj(xk, f.(xk))
  h = (b - a) / (n - 1)
  # napaka v neskončni normi na gosti mreži
  napaka = maximum(abs.([vrednost(Zk, tj) for tj in t3] - prava))
  push!(hji, h)
  push!(napake, napaka)
  # ocena reda iz razpolovitve koraka h
  red = k == 1 ? "-" : string(round(log2(napake[k-1] / napaka), digits = 3))
  println(rpad(n, 7), rpad(round(h, digits = 8), 15),
          rpad(round(napaka, sigdigits = 6), 15), red)
end

# referenčna premica
C = napake[1] / hji[1]^4

plot(hji, napake,
     xscale = :log10,
     yscale = :log10,
     marker = :circle,
     color = :blue,
     linewidth = 2,
     label = "izmerjena napaka",
     title = "Empirični red interpolacije z zlepkom",
     xlabel = "h",
     ylabel = "max |S(x) - f(x)|",
     legend = :bottomright)
plot!(hji, C .* hji .^ 4,
      linestyle = :dash,
      color = :black,
      label = "referenca C h^4")
savefig(joinpath(MAPA, "slika3_red.png"))

println("\nSlike shranjene v: ", MAPA)
