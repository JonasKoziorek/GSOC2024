using CairoMakie


begin
    N = 8
    x = 10*rand(N+1)
    y = 4.0 .+ 4*rand(N+1)

    A = zeros((N+1, N+1))
    for i in 1:N+1
        for j in 1:N+1
            A[i, j] = x[i]^(j-1)
        end
    end

    a = A \ y
    l = LinRange(minimum(x), maximum(x), 100)
    fig, ax = scatter(x, y, markersize=10, color=:red)
    lines!(ax, l, [sum([a[i]*l[j]^(i-1) for i in 1:N+1]) for j in 1:100])
    display(fig)
end