using DynamicalSystems
using CairoMakie


begin
    ds = Systems.lorenz()
    pmap = PoincareMap(ds, [-1.0, 1.0, 0.0, 0.0])
    pmap2 = PoincareMap(ds, [1.0, -1.0, 0.0, 0.0])

    traj, t = trajectory(pmap, 50000, current_state(pmap))
    traj2, t = trajectory(pmap2, 50000, current_state(pmap))
    fig, ax = scatter(traj[:, 1], traj[:, 3], markersize=1.5)
    scatter!(ax, traj2[:, 1], traj2[:, 3], markersize=1.5)
    display(fig)
end