= Schmelcher-Diakonos (Discrete)

== Input
ds, period, seeds, (maxiter, disttol, inftol, roundtol, abstol)

== Output
StateSpaceSet of POs



= Schmelcher-Diakonos (Continuous)
== Input
ds \~ Poincare surface of section, Vector{InitialGuess}, $lambda$, parameters for SD algorithm, parameters for Newton algorithm. 

== Output
`PeriodicOrbit` \~ Periodic orbits with certain number of intersections of the hyperplane and their periods.




= Davidchack-Lai (Discrete)

== Input
ds, period, seeds, maximal period to use seeds with, (beta, maxiters, disttol, abstol)

== Output
Vector{PeriodicOrbit} \~ vector of n vectors containing PO, each vector corresponds to one period 1..n




= Crofts' algorithm (Discrete)

== Input
ds, seeds, (beta, maxiter, disttol, abstol)

== Output
Vector{PeriodicOrbit} \~ vector of n vectors containing PO, each vector corresponds to one period 1..n




= Crofts' algorithm (Continuous)

Works a bit differently, as far as I understand, he searches for equilibrium solutions of an ODE and applies stabilising transformations again to stabilize this equilibrium.