# Demo skripta: izračuni in slike za poročilo o Magnusovi metodi
# reda 4 za Airyjevo enačbo in iskanju ničel Ai. Slike se shranijo
# v mapo, ki vsebuje to skripto.

using DN3
using SpecialFunctions
using Plots
using Printf

const MAPA = @__DIR__

# vse ničle Ai na [-40, 0]
z = nicle(-40.0, 200000)

println("Ničle Airyjeve funkcije Ai na [-40, 0]")
@printf("%3s  %-16s  %-14s  %-16s  %-12s\n", "n", "ničla a_n",
        "Ai(a_n)", "asimptotika", "razlika")
for (n, an) in enumerate(z)
  # asimptotični približek
  aas = -(3 * pi * (4 * n - 1) / 8)^(2 / 3)
  @printf("%3d  %16.10f  %14.3e  %16.10f  %12.3e\n",
          n, an, airyai(an), aas, an - aas)
end
@printf("Število najdenih ničel na [-40, 0]: %d\n\n", length(z))

# referenca za prvo ničlo z bisekcijo
function ref_nicla()
  lo, hi = -2.5, -2.2
  for _ in 1:200
    m = (lo + hi) / 2
    if airyai(lo) * airyai(m) <= 0
      hi = m
    else
      lo = m
    end
    abs(hi - lo) < 1e-14 && break
  end
  return (lo + hi) / 2
end

a1_ref = ref_nicla()

# bolj groba mreža (drugače napaka zadene strojno natančnost)
nji = [125, 250, 500, 1000, 2000]
hji = Float64[]
napake = Float64[]

@printf("Konvergenca prve ničle na [-10, 0]  (a_1 = %.14f)\n", a1_ref)
@printf("%6s  %10s  %-16s  %-12s  %-8s\n",
        "N", "h", "a_1(N)", "napaka", "razmerje")
prej = NaN
for n in nji
  h = 10 / n
  a1 = nicle(-10.0, n)[1]
  e = abs(a1 - a1_ref)
  # razmerje napak (pri redu 4 blizu 16)
  raz = isnan(prej) ? "-" : @sprintf("%.2f", prej / e)
  @printf("%6d  %10.2e  %16.12f  %12.3e  %8s\n", n, h, a1, e, raz)
  push!(hji, h)
  push!(napake, e)
  global prej = e
end
println()

# numerična rešitev na negativnem in pozitivnem delu
xn, Yn = resi(-15.0, 30000)
xp, Yp = resi(2.0, 4000)
xs = vcat(reverse(xn), xp[2:end])
ys = vcat(reverse(Yn[1, :]), Yp[1, 2:end])

# gosta mreža za primerjavo
xr = range(-15.0, 2.0, length = 1000)

# ničle za oznake na osi x
znic = filter(a -> a >= -15.0, z)

plot(xr, airyai.(xr),
     color = :black,
     linewidth = 2,
     label = "Ai(x)",
     title = "Airyjeva funkcija in Magnusova rešitev",
     xlabel = "x",
     ylabel = "Ai(x)",
     legend = :topleft)
plot!(xs, ys,
      color = :blue,
      linewidth = 1,
      linestyle = :dash,
      label = "numerično")
scatter!(znic, zeros(length(znic)),
         color = :red,
         markersize = 4,
         label = "ničle")
savefig(joinpath(MAPA, "slika1_airy.png"))

# referenčna premica
C = napake[end] / hji[end]^4

plot(hji, napake,
     xscale = :log10,
     yscale = :log10,
     marker = :circle,
     color = :blue,
     linewidth = 2,
     label = "napaka a_1",
     title = "Red konvergence prve ničle",
     xlabel = "h = 10 / N",
     ylabel = "|a_1(N) - a_1|",
     legend = :bottomright)
plot!(hji, C .* hji .^ 4,
      linestyle = :dash,
      color = :black,
      label = "referenca C h^4")
savefig(joinpath(MAPA, "slika2_red.png"))

println("Slike shranjene v: ", MAPA)
