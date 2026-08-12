# Demo skripta: slike in izračuni za poročilo o dvotočkovni
# Gauss-Legendrovi kvadraturi. Slike se shranijo v mapo, ki
# vsebuje to skripto.

using DN2
using Plots
using Printf

const MAPA = @__DIR__

# integrand z odpravljivo singularnostjo v 0
f(x) = x == 0 ? 1.0 : sin(x) / x

a, b = 0.0, 5.0

# graf integranda na gosti mreži
t1 = range(a, b, length = 400)
plot(t1, f.(t1),
     color = :blue,
     linewidth = 2,
     label = "f(x) = sin(x) / x",
     title = "Integrand na [0, 5]",
     xlabel = "x",
     ylabel = "f(x)",
     legend = :topright)
savefig(joinpath(MAPA, "slika1_integrand.png"))

# integral na 10 decimalk
tol = 1e-10
I = integral(f, a, b, tol = tol)
@printf("Integral f na [0, 5] = %.10f\n\n", I)

# ocena števila potrebnih izračunov funkcijskih vrednosti
function tabela(f, a, b, tol)
  println("N       Q_N                   ocena napake")
  N = 1
  Q_N = sestavljeno(f, a, b, N)
  @printf("%-8d%-22.12f%s\n", N, Q_N, "-")
  while true
    Q_2N = sestavljeno(f, a, b, 2 * N)
    # metoda je reda 4
    ocena = (Q_2N - Q_N) / 15
    N *= 2
    Q_N = Q_2N
    @printf("%-8d%-22.12f%.3e\n", N, Q_N, abs(ocena))
    if abs(ocena) < tol
      return N
    end
  end
end

N = tabela(f, a, b, tol)
@printf("\nNatancnost %.0e dosezena pri N = %d, torej %d izracunov f.\n\n",
        tol, N, 2 * N)

# empirični red sestavljenega pravila
prava = integral(f, a, b, tol = 1e-13)

nji = [2^k for k in 0:9]
hji = Float64[]
napake = Float64[]

for n in nji
  push!(hji, (b - a) / n)
  push!(napake, abs(sestavljeno(f, a, b, n) - prava))
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
     title = "Empirični red sestavljenega pravila",
     xlabel = "h = 5 / N",
     ylabel = "|Q_N - I|",
     legend = :bottomright)
plot!(hji, C .* hji .^ 4,
      linestyle = :dash,
      color = :black,
      label = "referenca C h^4")
savefig(joinpath(MAPA, "slika2_red.png"))

println("Slike shranjene v: ", MAPA)
