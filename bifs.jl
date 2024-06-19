using BifurcationKit, Plots


begin
    F(x, p) = @. p.μ + x - x^3/3
    prob = BifurcationProblem(F, [-2.5], (μ = -2.,), (@lens _.μ);
            record_from_solution = (x,p) -> (x = x[1]))
    br = continuation(prob, PALC(), ContinuationPar(p_min = -2.0, p_max = 1.0, dsmax = 0.02, max_steps = 1000))
    plot(br)
end

begin

    Fbp(u, p) = @. u * (p.μ + u)

    # bifurcation problem
    prob = BifurcationProblem(Fbp, [0.0], (μ = -0.2,),
        # specify the continuation parameter
        (@lens _.μ),
        record_from_solution = (x, p) -> x[1])
        # options for continuation
    opts_br = ContinuationPar(
        # parameter interval
        p_max = 0.2, p_min = -0.2,
        # detect bifurcations with bisection method
        # we increase the precision of the bisection
        n_inversion = 4)

    # automatic bifurcation diagram computation
    diagram = bifurcationdiagram(prob, PALC(),
        # very important parameter. This specifies the maximum amount of recursion
        # when computing the bifurcation diagram. It means we allow computing branches of branches
        # at most in the present case.
        2,
        (args...) -> opts_br,
        )
    plot(diagram)
end

    function Fsl(X, p)
        λ=p[1]
        y1, y2 = X
        term = λ - y1^2 - y2^2
        [
            -y2 + y1 * term
            y1 + y2 * term
        ]
    end
    par_sl = (λ=-0.5, )
    u0 = zeros(2)
    prob = BifurcationProblem(Fsl, u0, par_sl, (@lens _.λ))
    br = continuation(prob, PALC(), ContinuationPar(), bothside = true)
    br_po = continuation(br, 2, ContinuationPar(),
        PeriodicOrbitOCollProblem(20, 5)
        )
    br_po[1]
    plot(br, br_po, branchlabel = ["equilibria", "periodic orbits"])
    sol = get_periodic_orbit(br_po, 10)
    plot(sol.t, sol[1,:], label = "u", xlabel = "time")
    plot!(sol.t, sol[2,:], label = "v", xlabel = "time")