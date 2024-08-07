# Currently not functioning, don't know why but this can be tweaked to function the same as the code in the paper

using LinearAlgebra
using LeastSquaresOptim
using PeriodicOrbits
using OrdinaryDiffEq


function f(t, x, T, a)
    """
    Rossler system written in the form of Eq. (7)
    """
    xd = zeros(eltype(x), length(x))
    xd[1] = T * (-x[2] - x[3])
    xd[2] = T * (x[1] + a[1] * x[2])
    xd[3] = T * (a[2] + x[3] * x[1] - a[3] * x[3])
    return SVector{3}(xd)
end

function generate(T)
    return function f(x, a, t)
        """
        Rossler system written in the form of Eq. (7)
        """
        xd = zeros(eltype(x), length(x))
        xd[1] = T * (-x[2] - x[3])
        xd[2] = T * (x[1] + a[1] * x[2])
        xd[3] = T * (a[2] + x[3] * x[1] - a[3] * x[3])
        return SVector{3}(xd)
    end
end

function integrate(t, x, func, h, w, a)
    """
    5th-order Runge-Kutta integration scheme. Input:
    t - initial time
    x - vector of initial conditions at initial time t
    h - integration time step, w - period
    a - additional parameters
    """
    k1 = h * func(t, x, w, a)
    k2 = h * func(t + 0.5 * h, x .+ 0.5 .* k1, w, a)
    k3 = h * func(t + 0.5 * h, x .+ (3.0 * k1 .+ k2) ./ 16.0, w, a)
    k4 = h * func(t + h, x .+ 0.5 * k3, w, a)
    k5 = h * func(t + h, x .+ (-3.0 * k2 .+ 6.0 * k3 .+ 9.0 * k4) ./ 16.0, w, a)
    k6 = h * func(t + h, x .+ (k1 .+ 4.0 * k2 .+ 6.0 * k3 .- 12.0 * k4 .+ 8.0 * k5) ./ 7.0, w, a)
    xp = x .+ (7.0 * k1 .+ 32.0 * k3 .+ 12.0 * k4 .+ 32.0 * k5 .+ 7.0 * k6) ./ 90.0
    return xp
end

function ef(v, x, func, dt, a, p)
    """
    Residual (error vector). Input:
    v - vector containing the quantities to be optimized
    x - vector of initial conditions
    func - function, dt - integration time step
    a - additional parameters
    p - controls length of error vector
    """
    ds = CoupledODEs(generate(v[3]), [x[1], x[2], x[3]], a; diffeq = (alg=RKO65(), abstol = 1e-14, reltol = 1e-14, dt=dt))
    # ds2 = CoupledODEs(generate(v[3]), [x[1], x[2], x[3]], a; diffeq = (alg=Vern7(), abstol = 1e-14, reltol = 1e-14))


    j = Int(2.0 / dt)
    vv = zeros(eltype(x), j, length(x))
    vv[1, 1:2] .= v[1:2]  # set initial condition
    vv[1, 3] = x[3]
    T = v[3]  # set period
    for i in 1:Int(j / 2 + p)
        t = (i - 1) * dt
        # reinit!(ds, vv[i, :])
        # reinit!(ds2, vv[i, :])
        # step!(ds, dt)
        # step!(ds2, dt)
        # o1 = collect(current_state(ds))
        # o3 = collect(current_state(ds2))
        o2 = integrate(t, vv[i, :], func, dt, T, a)
        # println(o1, o2)
        # println(norm(o1 - o2))
        # println(norm(o1 - o3))
        vv[i + 1, :] = o2
    end
    er = vv[Int(j / 2), :] .- vv[1, :]  # creates residual error vector
    for i in 2:p  # of appropriate length
        er = vcat(er, vv[Int(j / 2) + i, :] .- vv[i, :])
    end
    # println(er)
    return er
end

function main()
    a0 = [0.25, 0.2, 3.5]  # predetermined system parameters
    x0 = [3.1, 3.47, 4.0]  # initial conditions (N=3)
    v0 = [x0[1], x0[2], 5.2]  # quantities for optimization
    p = 2  # length of residual is pN
    h = 1.0 / 1024.0  # integration time step
    # LM optimization
    result = optimize(v -> ef(v, x0, f, h, a0, p), v0, LevenbergMarquardt(); x_tol=1e-14)
    v = result.minimizer
    err = ef(v, x0, f, h, a0, p)  # error estimation
    es = sqrt(dot(err, err))
    u0 = (v[1], v[2], x0[3], v[3], es / 1e-13)
    # println(@sprintf("%20.16f %20.16f %20.16f %20.16f %6.2f", u0...))
    return result
end

@time res = main()
println(res.ssr <= 1e-3 ? "Converged!" : "Diverged!")