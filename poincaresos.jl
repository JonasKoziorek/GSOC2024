using DynamicalSystems
using CairoMakie
using ChaosTools
using LinearAlgebra: norm

# ds = Systems.rikitake(zeros(3); μ = 0.47, α = 1.0)
# pmap = poincaremap(ds, (3, 0.0))
# step!(pmap)
# next_state_on_psos = current_state(pmap)

function f_rule(x, p, t)
    r, ϕ = x
    return SVector{2}(r - r^3, 1.0)
end

function transform(x)
    return [x[1] * cos(x[2]), x[1] * sin(x[2])]
end

begin
    ds = ContinuousDynamicalSystem(f_rule, [1.0, 0.0], (0.0,))
    traj, t = trajectory(ds, 100.0, Dt=0.01)
    fig, ax = lines(traj[:, 1], t, color=:red)
    # lines!(ax, traj[:, 2], t, color=:blue)
    lines!(traj[:, 1], traj[:, 2], color=:blue)
    display(fig)
end

begin
    traj2 = [transform(i) for i in traj]
    fig, ax = lines([traj2[i][1] for i = 1:length(traj2)], [traj2[i][2] for i = 1:length(traj2)], color=:red)
    display(fig)
end

begin
    ds2 = PoincareMap(ds, [0.0, 1.0, 0.0])
end


function periodicorbits2(
        ds,
        o::Int,
        ics,
        λs,
        indss,
        singss;
        maxiters::Int = 100000,
        disttol::Real = 1e-10,
        inftol::Real = 10.0,
        roundtol = nothing,
        abstol::Real = 1e-8,
    )
    if !isnothing(roundtol)
        warn("`roundtol` keyword has been removed in favor of `abstol`")
    end

    type = typeof(current_state(ds))
    FP = Set{type}()
    for λ in λs, inds in indss, sings in singss
        Λ = lambdamatrix(λ, inds, sings)
        _periodicorbits2!(FP, ds, o, ics, Λ, maxiters, disttol, inftol, abstol)
    end
    return Dataset(collect(FP))
end

function _periodicorbits2!(FP, ds, o, ics, Λ, maxiter, disttol, inftol, abstol)
    for st in ics
        reinit!(ds, st)
        prevst = st
        for _ in 1:maxiter
            prevst, st = Sk2(ds, prevst, o, Λ)
            norm(st) > inftol && break

            if norm(prevst - st) < disttol
                storefp!(FP, st, abstol)
                break
            end
            prevst = st
        end
    end
end

function Sk2(ds, prevst, o::Int, Λ)
    reinit!(ds, prevst)
    step!(ds, o)
    return prevst, prevst + Λ*(current_state(ds) .- prevst)
end



begin
    indss, signss = lambdaperms(dimension(ds))
    λ = 0.05
end

begin
    u0 = [0.0, 10.0, 0.0]
    ρ = 45.92
    ds = Systems.lorenz(u0; σ = 16.0, ρ = ρ, β = 4.0)
    traj = trajectory(ds, 1000.0, Dt = 0.01)[1]
    ics = [traj[i] for i in 1:100:length(traj)]
    plane = (3, ρ-1)
    pmap = PoincareMap(ds, plane)
    upos = periodicorbits2(pmap, 8, ics, λ, indss, signss)
end

begin
    traj, t = trajectory(pmap, 200, traj[end])
    fig, ax = lines(t, traj[:, 1], color=:red)
    # lines!(t, traj[:, 2], color=:blue)
    # lines!(t, traj[:, 3], color=:green)
    display(fig)
end