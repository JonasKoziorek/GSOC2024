using CairoMakie

function norm(x)
    sqrt(sum(x.^2))
end

function f(x, p)
    return [x+p + 3*sin(x)]
end

function J(x, p)
    return [1 + 3*cos(x)]
end

function newton(x0, p, eps, maxiter)
    x = x0
    for k in 1:maxiter
        Δx = J(x, p) \ (-f(x, p))
        prevx = x
        x = prevx + Δx
        if norm(prevx-x) < eps
            println("Number of iters: $k")
            return x
        end
    end
    println("Number of iters: $maxiter")
    return x
end

begin
    x = LinRange(-5, 5, 100)
    p = 3
    
    y = newton(0, p, 1e-6, 500)

    fig, ax = lines(x, [i[1] for i in f.(x, p)])
    lines!(ax, [-5, 5], [0, 0])
    scatter!(ax, [(y, f(y, p)[1])])
    display(fig)
end

function f(x, p)
    x, y = x
    return [
        x^2+y,
        x^2+4.0*y^2-1.0
    ]
end

function J(x, p)
    x, y = x
    return [
        2.0*x 1.0;
        2.0*x 8.0*y
    ]
end

begin
    p = 3
    y = newton([2, -1], p, 1e-5, 500)
end