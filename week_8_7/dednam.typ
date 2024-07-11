 = Optimized shooting method for finding periodic orbits of nonlinear dynamical systems

- They propose a method to find POs of continuous autonomous and nonautonomous systems using Levenberg-Marquardt algorithms (non-linear least squares optimization)
- The chaotic trajectories of a chaotic attractor can be understood as continuous repulsion from the unstable periodic orbits that are embedded withing the basin of attraction
- looking for POs is in principle a boundary value problem, someone has specified the possible solving options to these:
  - integration : you integrate and hope to converge to a stable cycle
  - shooting : you shoot trajectories from a guess and hope to get to the same point, root finding methods are used to improve guess
  - global methods : for example collocation (popular these days)

- the article mentions several other recent papers on the same topic
- these paper provides alternative shooting method which is an extension of the method of Li and Xu, they extend it with LMO (Levenberg-Marquardt optimization)
- they mention comparison in efficiency with other methods is difficult and depends on the problem
- They call the method Optimized Shooting Method



== Numerical experiments
- Found out that the method can find period which is not minimal, an example of this is as such:
```julia
using PeriodicOrbits
using CairoMakie

@inbounds function roessler_rule(u, p, t)
    du1 = -u[2]-u[3]
    du2 = u[1] + p[1]*u[2]
    du3 = p[2] + u[3]*(u[1] - p[3])
    return SVector{3}(du1, du2, du3)
end
function roessler_jacob(u, p, t)
    return SMatrix{3,3}(0.0,1.0,u[3],-1.0,p[1],0.0,-1.0,0.0,u[1]-p[3])          
end

#%%
a = 0.15; b=0.2; c=3.5
ds = CoupledODEs(roessler_rule, [1.0, -2.0, 0.1], [a, b, c]; diffeq = (abstol = 1e-16, reltol = 1e-16))
u0 = SVector(3.8966771398506923, 2.7513144402617069, 3.1000000000000001)
T = 11.8406804963826424 # minimal period seems to be somewhere around 6
traj, t = trajectory(ds, T, u0; Dt = 0.01)


#%%
fig = Figure()
ax = Axis3(fig[1,1], azimuth = 1.3 * pi)
lines!(ax, traj[:, 1], traj[:, 2], traj[:, 3], color = :blue)
display(fig)
```


