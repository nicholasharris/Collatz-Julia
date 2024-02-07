using Plots

stop_times = []

println("reading data...")
open("collatz_results_total.txt", "r") do f

    line = 0

    while ! eof(f)
        s = readline(f)
        push!(stop_times, parse(Int, split(s,",")[end]))
    end
end


println("making plot...")
#x = 1:length(stop_times)
x =  1:1000000
y = [stop_times[i] for i ∈ 1:1000000]

#println("$y")

scatter(x, y, mc=:red, ma=0.5)
plot!(size=(1080, 1080))
xlabel!("n")
ylabel!("total stopping time")
title!("Collatz(n)")
savefig("plot1000000.png")
