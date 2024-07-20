using PeriodicOrbits
using CairoMakie
using OrdinaryDiffEq

@inbounds function roessler_rule(u, p, t)
    du1 = -u[2]-u[3]
    du2 = u[1] + p[1]*u[2]
    du3 = p[2] + u[3]*(u[1] - p[3])
    return SVector{3}(du1, du2, du3)
end
function roessler_jacob(u, p, t)
    return SMatrix{3,3}(0.0,1.0,u[3],-1.0,p[1],0.0,-1.0,0.0,u[1]-p[3])          
end

function plot_result(res, ds; azimuth = 1.3 * pi, elevation = 0.3 * pi)
    traj, t = trajectory(ds, res.T, res.points[1]; Dt = 0.01)
    fig = Figure()
    ax = Axis3(fig[1,1], azimuth = azimuth, elevation=elevation)
    lines!(ax, traj[:, 1], traj[:, 2], traj[:, 3], color = :blue, linewidth=1.7)
    scatter!(ax, res.points[1])
    display(fig)
end


#%%
a = 0.15; b=0.2; c=3.5
ig = InitialGuess(SVector(2.0, 5.0, 10.0), 10.2)
alg = OptimizedShooting(Δt=1/(2^6), p=3)
ds = CoupledODEs(roessler_rule, [1.0, -2.0, 0.1], [a, b, c]; diffeq = (alg=RKO65(), abstol = 1e-14, reltol = 1e-14, dt=alg.Δt))
@time res = periodic_orbit(ds, alg, ig)

if !isnothing(res)
    println("Converged!")
    plot_result(res, ds; azimuth = 1.3pi, elevation=0.1pi)
else
    println("Diverged!")
end

#%%
a = 0.25; b=0.2; c=3.5
ig = InitialGuess(SVector(5.0, 2.0, 1.0), 55.2)
alg = OptimizedShooting(Δt=1e-4, p=2)
ds = CoupledODEs(roessler_rule, [1.0, -2.0, 0.1], [a, b, c]; diffeq = (alg=RKO65(), abstol = 1e-14, reltol = 1e-14, dt=alg.Δt))
@time res = periodic_orbit(ds, alg, ig)

if !isnothing(res)
    println("Converged!")
    plot_result(res, ds; azimuth = 1.3pi, elevation=0.1pi)
else
    println("Diverged!")
end

#%%
a = 0.15; b=0.2; c=1.5
ig = InitialGuess(SVector(5.0, 5.0, 5.0), 50.2)
alg = OptimizedShooting(Δt=1e-3, p=1)
ds = CoupledODEs(roessler_rule, [1.0, -2.0, 0.1], [a, b, c]; diffeq = (alg=RKO65(), abstol = 1e-14, reltol = 1e-14, dt=alg.Δt))
@time res = periodic_orbit(ds, alg, ig)

if !isnothing(res)
    println("Converged!")
    plot_result(res, ds; azimuth = 1.3pi, elevation=0.1pi)
else
    println("Diverged!")
end


function lorenz(u0=[0.0, 10.0, 0.0]; σ = 10.0, ρ = 28.0, β = 8/3)
    return CoupledODEs(lorenz_rule, u0, [σ, ρ, β])
end
@inbounds function lorenz_rule(u, p, t)
    du1 = p[1]*(u[2]-u[1])
    du2 = u[1]*(p[2]-u[3]) - u[2]
    du3 = u[1]*u[2] - p[3]*u[3]
    return SVector{3}(du1, du2, du3)
end

#%%
σ = 10.0; ρ = 28.0; β = 8/3
ig = InitialGuess(SVector(5.0, 5.0, 5.0), 5.2)
alg = OptimizedShooting(Δt=1e-4, p=1, abstol=1e-5)
ds = CoupledODEs(lorenz_rule, [0.0, 10.0, 0.0], [σ, ρ, β]; diffeq = (alg=RKO65(), abstol = 1e-14, reltol = 1e-14, dt=alg.Δt))
@time res = periodic_orbit(ds, alg, ig)

if !isnothing(res)
    println("Converged!")
    plot_result(res, ds; azimuth = 0.7pi, elevation=0.1pi)
else
    println("Diverged!")
end

#%%
σ = 10.0; ρ = 28.0; β = 8/3
ig = InitialGuess(SVector(1.0, 2.0, 5.0), 8.2)
alg = OptimizedShooting(Δt=1e-4, p=1, abstol=1e-5, optim_kwargs=(f_tol=1e-10,))
ds = CoupledODEs(lorenz_rule, [0.0, 10.0, 0.0], [σ, ρ, β]; diffeq = (alg=RKO65(), abstol = 1e-14, reltol = 1e-14, dt=alg.Δt))
@time res = periodic_orbit(ds, alg, ig)

if !isnothing(res)
    println("Converged!")
    plot_result(res, ds; azimuth = 0.7pi, elevation=0.1pi)
else
    println("Diverged!")
end

#%%
σ = 10.0; ρ = 28.0; β = 8/3
ig = InitialGuess(SVector(1.0, 2.0, 5.0), 10.2)
alg = OptimizedShooting(Δt=1e-4, p=1, abstol=1e-5, optim_kwargs=(f_tol=1e-10,))
ds = CoupledODEs(lorenz_rule, [0.0, 10.0, 0.0], [σ, ρ, β]; diffeq = (alg=RKO65(), abstol = 1e-14, reltol = 1e-14, dt=alg.Δt))
@time res = periodic_orbit(ds, alg, ig)

if !isnothing(res)
    println("Converged!")
    plot_result(res, ds; azimuth = 0.7pi, elevation=0.1pi)
else
    println("Diverged!")
end

#%%
σ = 10.0; ρ = 28.0; β = 8/3
ig = InitialGuess(SVector(1.0, 2.0, 5.0), 4.2)
alg = OptimizedShooting(Δt=1e-4, p=1, abstol=1e-5, optim_kwargs=(f_tol=1e-10,))
ds = CoupledODEs(lorenz_rule, [0.0, 10.0, 0.0], [σ, ρ, β]; diffeq = (alg=RKO65(), abstol = 1e-14, reltol = 1e-14, dt=alg.Δt))
@time res = periodic_orbit(ds, alg, ig)

if !isnothing(res)
    println("Converged!")
    plot_result(res, ds; azimuth = 0.7pi, elevation=0.1pi)
else
    println("Diverged!")
end