= Detecting unstable periodic orbits in chaotic continuous-time dynamical systems

== Input
- Vector{PeriodicPoint} \~ initial guesses
- Choice of PSOS
- choice of parameter $lambda$

== Output


== Overview

Let's have a system of ODEs

$ dot(x) = G(x)$

We introduce a Poincare surface of section (PSS). The latter can be constructed by recoding successive intersections of the continuous trajectories with the hyperplane in the same direction. This yields a poincare map (discrete dynamical system) $g_(G)(x)$. UPOs of the continuous system are periodic points of the poincare map.

If high resolution of the position of the UPO with long period is required, SD method with combination of Newton method has to be used.

During the iteration of the SD method, when the step length of the SD is short enough, they try to converge to a UPO with Newton method.

I need to read more on how to comine newton with SD and how to tune parameter $lambda$.

(Equation 1 page 4 is not clear to me)

== Questions
- DL alg will not work out of the box because autodiff of `step!` is a loop doesn't work
- SD doesn't work because it accepts deterministic iterated map right now
- Why is `davidchacklai` not visible when I install the package?
- I haven't found any periodic orbits via poincare section, let's try it with the simple example