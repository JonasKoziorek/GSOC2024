using Revise, Parameters, Plots
using BifurcationKit
const BK = BifurcationKit

function Pop!(du, X, p, t = 0)
	@unpack r,K,a,ϵ,b0,e,d, = p
	x, y, u, v = X
	p = a * x / (b0 * (1 + ϵ * u) + x)
	du[1] = r * (1 - x/K) * x - p * y
	du[2] = e * p * y - d * y
	s = u^2 + v^2
	du[3] = u-2pi * v - s * u
	du[4] = 2pi * u + v - s * v
	du
end

par_pop = ( K = 1., r = 6.28, a = 12.56, b0 = 0.25, e = 1., d = 6.28, ϵ = 0.2, )

z0 = [0.1,0.1,1,0]

prob = BifurcationProblem(Pop!, z0, par_pop, (@lens _.b0);
	record_from_solution = (x, p) -> (x = x[1], y = x[2], u = x[3]))

opts_br = ContinuationPar(p_min = 0., p_max = 20.0, ds = 0.002, dsmax = 0.01, n_inversion = 6, detect_bifurcation = 3, max_bisection_steps = 25, nev = 4, max_steps = 20000)

using DifferentialEquations
prob_de = ODEProblem(Pop!, z0, (0,200.), par_pop)
sol = solve(prob_de, Rodas5())
prob_de = ODEProblem(Pop!, sol.u[end], (0,3.), par_pop, reltol = 1e-8, abstol = 1e-10)
sol = solve(prob_de, Rodas5())
plot(sol)

argspo = (record_from_solution = (x, p) -> begin
		xtt = get_periodic_orbit(p.prob, x, p.p)
		return (max = maximum(xtt[1,:]),
				min = minimum(xtt[1,:]),
				period = getperiod(p.prob, x, p.p))
	end,
	plot_solution = (x, p; k...) -> begin
		xtt = get_periodic_orbit(p.prob, x, p.p)
		plot!(xtt.t, xtt[1,:]; label = "x", k...)
		plot!(xtt.t, xtt[2,:]; label = "y", k...)
		# plot!(br; subplot = 1, putspecialptlegend = false)
	end)

probsh, cish = generate_ci_problem( ShootingProblem(M=3), prob, prob_de, sol, 2.; alg = Rodas5())

opts_po_cont = setproperties(opts_br, max_steps = 50, tol_stability = 1e-3)
br_fold_sh = continuation(probsh, cish, PALC(tangent = Bordered()), opts_po_cont;
	verbosity = 3, plot = true,
	argspo...
)

scene = plot(br_fold_sh)