using PeriodicOrbits
using CairoMakie
using OrdinaryDiffEq


@inbounds function lorenz_rule(u, p, t)
    du1 = p[1] * (u[2] - u[1])
    du2 = u[1] * (p[2] - u[3]) - u[2]
    du3 = u[1] * u[2] - p[3] * u[3]
    return SVector{3}(du1, du2, du3)
end

function plot_result(res, ds; azimuth = 1.3 * pi, elevation = 0.3 * pi)
    traj, t = trajectory(ds, res.T, res.points[1]; Dt = 0.001)
    fig = Figure()
    ax = Axis3(fig[1,1], azimuth = azimuth, elevation=elevation)
    lines!(ax, traj[:, 1], traj[:, 2], traj[:, 3], color = :blue, linewidth=1.0)
    scatter!(ax, res.points[1])
    display(fig)
end

#%%
ds = CoupledODEs(lorenz_rule, [0.0, 10.0, 0.0], [10.0, 28.0, 8 / 3]; diffeq=(alg=RKO65(), abstol=1e-9, reltol=1e-9, dt=alg.Δt))
ig = InitialGuess(SVector(4.0, 1.0, 5.0), 4.2)
alg = OptimizedShooting(Δt=1e-3, n=3, abstol=1e-6, optim_kwargs=(f_tol=1e-10,))
res = periodic_orbit(ds, alg, ig)

if !isnothing(res)
    println("Converged!")
    plot_result(res, ds; azimuth = 1.7pi, elevation=0.1pi)
else
    println("Diverged!")
end

#%%
ds = CoupledODEs(lorenz_rule, [10.0, 20.0, 10.0], [10.0, 350.0, 8 / 3], diffeq=(alg=RKO65(), abstol=1e-9, reltol=1e-9, dt=alg.Δt))
ig = InitialGuess(current_state(ds), 5.2)
traj, t = trajectory(ds, 1000.0; Dt=0.001)
u0 = traj[end]
traj, t = trajectory(ds, 0.39, u0; Dt=0.001)
fig = Figure()
ax = Axis3(fig[1,1], azimuth = 1.8pi, elevation=0.1pi)
lines!(ax, traj[:, 1], traj[:, 2], traj[:, 3], color = :blue, linewidth=0.7)
scatter!(ax, traj[end])
display(fig)

#%%
ds = CoupledODEs(lorenz_rule, [10.0, 20.0, 10.0], [10.0, 350.0, 8 / 3], diffeq=(alg=RKO65(), abstol=1e-9, reltol=1e-9, dt=alg.Δt))
ig = InitialGuess(traj[end], 0.38) # this is a stable limit cycle
alg = OptimizedShooting(Δt=1e-3, n=3, abstol=1e-6, optim_kwargs=(f_tol=1e-10,))
res = periodic_orbit(ds, alg, ig)

if !isnothing(res)
    println("Converged! $(res.stable)")
    plot_result(res, ds; azimuth = 1.8pi, elevation=0.1pi)
else
    println("Diverged!")
end