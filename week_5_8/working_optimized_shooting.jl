using PeriodicOrbits
using LinearAlgebra: norm
using CairoMakie

@kwdef struct OptimizedShooting{T} <: PeriodicOrbitFinder
    Δt::Float64 = 1e-6
    n::Int64 = 2
    nonlinear_solve_kwargs::T = (reltol=1e-6, abstol=1e-6, maxiters=1000)
end

function periodic_orbit(ds::CoupledODEs, alg::OptimizedShooting, ig::InitialGuess)
    D = dimension(ds)
    f = (err, v, p) -> begin
        if isinplace(ds) 
            u0 = @view v[1:D]
        else
            u0 =  SVector{D}(v[1:D])
        end
        T = v[end]

        bounds = zeros(eltype(v), alg.n*2)
        for i in 0:alg.n-1
            bounds[i+1] = i*alg.Δt
            bounds[i+alg.n+1] = T + i*alg.Δt
        end
        tspan = (0.0, T + alg.n*alg.Δt)

        sol = solve(SciMLBase.remake(ds.integ.sol.prob; u0=u0, 
        tspan=tspan); DynamicalSystemsBase.DEFAULT_DIFFEQ..., ds.diffeq..., saveat=bounds)
        if (length(sol.u) == alg.n*2)
            for i in 1:alg.n
                err[D*i-(D-1):D*i] = (sol.u[i] - sol.u[i+alg.n])
            end
        else
            fill!(err, Inf)
        end
    end

    prob = NonlinearLeastSquaresProblem(
        NonlinearFunction(f, resid_prototype = zeros(alg.n*dimension(ds))), [ig.u0..., ig.T])

    sol = solve(prob, NonlinearSolve.LevenbergMarquardt(); alg.nonlinear_solve_kwargs...)
    if sol.retcode == ReturnCode.Success
        u0 = sol.u[1:end-1]
        T = sol.u[end]
        Δt = 0.1
        return PeriodicOrbit(ds, u0, T, Δt)
    else
        return nothing
    end
end

function plot_result(res, T, ds; azimuth = 1.3 * pi, elevation = 0.3 * pi)
    traj, t = trajectory(ds, T, res; Dt = 0.001)
    fig = Figure()
    ax = Axis3(fig[1,1], azimuth = azimuth, elevation=elevation)
    lines!(ax, traj[:, 1], traj[:, 2], traj[:, 3], color = :blue, linewidth=1.7)
    scatter!(ax, res)
    return fig
end

@inbounds function lorenz_rule(u, p, t)
    du1 = p[1] * (u[2] - u[1])
    du2 = u[1] * (p[2] - u[3]) - u[2]
    du3 = u[1] * u[2] - p[3] * u[3]
    return SVector{3}(du1, du2, du3)
end

@inbounds function roessler_rule(u, p, t)
    du1 = -u[2]-u[3]
    du2 = u[1] + p[1]*u[2]
    du3 = p[2] + u[3]*(u[1] - p[3])
    return SVector{3}(du1, du2, du3)
end

#%%
u0 = [1.1, 0.0, 0.0]
T = 3.9
p0 = [10.0, 28.0, 8/3]
alg = OptimizedShooting(Δt=1e-4, n=5)
ds = CoupledODEs(lorenz_rule, zeros(3), p0)
@time res = periodic_orbit(ds, alg, InitialGuess(u0, T))


u = SVector{3}(res[1:3])
T = res[end]
ds = CoupledODEs(lorenz_rule, u, p0, diffeq=(abstol=1e-14, reltol=1e-14))
plot_result(u, 1*T, ds; azimuth = 1.8pi, elevation=0.1pi)


#%%
u0 = [2.1, 10.0, 3.0, 5.0]
p0 = [10.0, 28.0, 8/3, 0.0]
alg = OptimizedShooting(Δt=1e-4, n=3)
ds = CoupledODEs(lorenz_rule, zeros(3), p0[1:3])
@time res = detect(u0, p0, alg, ds)


u = SVector{3}(res[1:3])
T = res[end]
ds = CoupledODEs(lorenz_rule, u, p0[1:end-1], diffeq=(abstol=1e-14, reltol=1e-14))
plot_result(u, 1*T, ds; azimuth = 1.8pi, elevation=0.1pi)

#%%
u0 = [3.1, 4.0, 3.0]
T = 11.0
p0 = [0.2, 0.2, 3.6, 0.0]
alg = OptimizedShooting(Δt=1e-4, n=3)
ds = CoupledODEs(roessler_rule, zeros(3), p0[1:3])
ig = InitialGuess(u0, T)
@time res = periodic_orbit(ds, alg, ig)

u = SVector{3}(res[1:3])
T = res[end]
ds = CoupledODEs(roessler_rule, u, p0[1:end-1], diffeq=(abstol=1e-14, reltol=1e-14))
plot_result(u, 1*T, ds; azimuth = 1.3pi, elevation=0.1pi)
