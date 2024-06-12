# Saiki (Continuous)

## Input

ds, damping coefficient m (it has a default value), initial guess of point X and period T, (maxiter, tolerance)

## Output

A point X which is part of periodic solution of period T

# Schmelcher-Diakonos (Discrete)

## Input
ds, period, seeds, (maxiter, disttol, inftol, roundtol, abstol)

## Output
Dataset( vector of PO )

# Davidchack-Lai (Discrete)

## Input
ds, period, seeds, maximal period to use seeds with, (beta, maxiters, disttol, abstol)

## Output
vector of n vectors containing PO, each vector corresponds to one one period 1..n

# Crofts' algorithm (Discrete)

## Input
ds, seeds, (beta, maxiter, disttol, abstol)

## Output
vector of n vectors containing PO, each vector corresponds to one one period 1..n

# Crofts' algorithm (Continuous)

Works a bit differently, as far as I understand, he searches for equilibrium solutions of an ODE and applies stabilising transformations again to stabilize this equilibrium.
