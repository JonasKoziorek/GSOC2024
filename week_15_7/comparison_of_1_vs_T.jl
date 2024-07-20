using LeastSquaresOptim: optimize, LevenbergMarquardt
using OrdinaryDiffEq


"""
    OptimizedShooting(; kwargs...)

A shooting method [Dednam2014](@cite) combined with Levenberg-Marquardt optimization 
to find periodic orbits of continuous systems.

## Keyword arguments
- `Δt::Float64 = 1e-6`: explicit ODE solver time step. This should correspond to the time step used in the ODE solver specified in the `CoupledODEs` object.
- `n::Int64 = 2`: `n*dimension(ds)` is the number of points in the residual `R`.
- `optim_kwargs::NamedTuple = (x_tol=1e-10,)`: keyword arguments to pass to the optimizer. The optimizer used is the `optimize` from `LeastSquaresOptim.jl`. For details on the keywords see the respective package documentation.
- `abstol::Float64 = 1e-3` : absolute tolerance for sum of squares `ssr` of the residual `R`. The method converged if `ssr <= abstol`.

## Description

Continuous dynamical system 

```math
\\frac{dx}{dt} = f(x, p, t)
```

can be rewritten in terms of the dimensionless time ``\\tau = t/T`` as

```math
\\frac{dx}{dt} = Tf(x, p, T\\tau)
```
where ``T`` is a period of some periodic orbit. The boundary conditions for the 
periodic orbit now are ``x(\\tau = 0) = x(\\tau = 1)``. Dednam and Botha [Dednam2014](@cite) 
suggest minimizing the residual ``R`` defined as 

```math
R = (x(1)-x(0), x(1+\\Delta \\tau)-x(\\Delta \\tau), ..., x(1+(n-1)\\Delta \\tau)-x((n-1)\\Delta \\tau))
```

 with respect to ``x(0)`` and ``T`` using Levenberg-Marquardt optimization.

In our implementation keyword argument `n` corresponds to ``n`` in the residual ``R``. 
The keyword argument `Δt` corresponds to ``\\Delta \\tau`` in the residual ``R``.

## Important note

For now we recommed using the `RKO65` ODE solver and setting the stepsize `dt` the 
same as `Δt`. For example

```
alg = OptimizedShooting(Δt=1/(2^6), n=3)
ds = CoupledODEs(dynamic_rule, state, params; diffeq = (alg=RKO65(), dt=alg.Δt))
```

Using other ODE solvers may lead to divergence.

Solvers that seem to be working: RKO65, Anas5, RKM, MSRK6
Solvers that seem to don't bother about the period: Heun, Ralston, Midpoint
Checkout: Anas5, OwrenZen3

"""
@kwdef struct OptimizedShooting <: PeriodicOrbitFinder
    Δt::Float64 = 1e-6
    n::Int64 = 2
    optim_kwargs::NamedTuple = (x_tol=1e-10,)
    abstol::Float64 = 1e-3
end

function new_rule(rule, T)
    return (u, p, t) -> T * rule(u, p, T * t)
end

function periodic_orbit(ds::CoupledODEs, alg::OptimizedShooting, ig::InitialGuess)
    res = optimize(v -> costfunc(v, ds, alg), [ig.u0..., ig.T], LevenbergMarquardt(); alg.optim_kwargs...)
    if res.ssr <= alg.abstol
        u0 = res.minimizer[1:dimension(ds)]
        T = res.minimizer[end]
        return PeriodicOrbit(ds, u0, T, 0.01; jac=nothing)
    end
    return nothing
end

function periodic_orbits(ds::CoupledODEs, alg::OptimizedShooting, igs::Vector{<:InitialGuess})
    # TODO: annotate `pos` with correct type
    pos = []
    for ig in igs
        res = periodic_orbit(ds, alg, ig)
        if !isnothing(res)
            push!(pos, res)
        end
    end
    return pos
end

function costfunc(v, ds, alg)
    u0 = v[1:dimension(ds)]
    T = v[end]

    f = dynamic_rule(ds)
    nds = CoupledODEs(new_rule(f, T), current_state(ds), current_parameters(ds); diffeq=ds.diffeq)
    # nds2 = CoupledODEs(dynamic_rule(ds), current_state(ds), current_parameters(ds); diffeq=(alg=Heun(), abstol=ds.diffeq.abstol, reltol=ds.diffeq.reltol, dt=alg.Δt*1e-0))

    len = alg.n * dimension(ds)
    u1s = zeros(len)
    u2s = zeros(len)
    err = zeros(len)

    reinit!(nds, u0)
    # reinit!(nds2, u0)
    for i in 0:alg.n-1
        u1 = current_state(nds)
        # u11 = current_state(nds2)
        # println("i: $i, 0 $(norm(u1-u11))")

        u1s[i*dimension(ds)+1:(i+1)*dimension(ds)] .= u1
        step!(nds, alg.Δt)
        # step!(nds2, alg.Δt * T)
    end

    reinit!(nds, u0)
    # reinit!(nds2, u0)
    step!(nds, 1)
    # step!(nds2, T)
    for i in 0:alg.n-1
        u2 = current_state(nds)
        # u22 = current_state(nds2)
        # println("i: $i, 1 $(norm(u2-u22))")

        u2s[i*dimension(ds)+1:(i+1)*dimension(ds)] .= u2
        step!(nds, alg.Δt)
        # step!(nds2, alg.Δt * T)
    end
    # println()
    err = u2s .- u1s
    # println("err: $err")
    return err
end