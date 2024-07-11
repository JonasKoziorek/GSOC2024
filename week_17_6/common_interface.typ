= Common interface for UPO finding algorithms
The common interface will allow the user to easily switch between algorithms.

== Types

=== Initial Guess
User will be able to provide some number of initial guesses represented by `InitialGuess`.
Initial guess can be thought of as a vector in state space for discrete cases.
For continuous cases, initial guess can be thought of as a vector in state space and a period.

```julia
struct InitialGuess where {N<:Int64, T::Real}
    # either u0 = [u1, u2, ..., uN] or u0 = [u1, u2, ..., uN, T]
    u0::SVector{N, T}
end

```
=== Periodic Point
One point of the periodic orbit represented by point in the state space and period.

```julia
struct PeriodicPoint where {N<:Int64, T::Real}
    # point of the periodic orbit
    u0 :: SVector{N, T}
    # period
    T :: T
end
```

We will probide implementations to check stability of the point and to complete the whole orbit.

```julia
function stable(ds, po::PeriodicPoint; jac=autodiff_jac(ds))
end

function complete_orbit(ds, po::PeriodicPoint)
    result :: PeriodicOrbit
    return result
end
```

=== Periodic Orbit
A set of periodic points that form a periodic orbit.
In some cases, several periodic orbits that can be distinguished later by period.

```julia
struct PeriodicOrbit where {N<:Int64, T::Real}
    # this can be changed later for something better
    POs :: Set{PeriodicPoint{N, T}}
end
```

Custom search through the datastructure.
```julia
import Base.∈
function ∈(u0::PeriodicPoint, POs::PeriodicOrbit)
    # custom search
end
```

=== Algorithm
Each algorithm will have its own struct that will hold its parameters (and their combinations).
They will all be a subtype of `PeriodicOrbitDetector`.

```julia
abstract type PeriodicOrbitDetector end

struct Algorithm1 <: PeriodicOrbitDetector
    param1
    param2
    param3
end

function Algorithm1(;param1=1, param2=2, param3=3)
    Algorithm1(param1, param2, param3)
end
```

=== Functions
There will be an implementation of the `periodic_orbits` function for each algorithm (multiple dispatch).
There is an option to use initial guesses or not and to return only one periodic orbit or all of them.
Result will be an instance of `PeriodicOrbit` containing one or more periodic orbits.

```julia
function periodic_orbits(ds::DynamicalSystem, ig::AbstractVector{InitialGuess}, alg::PeriodicOrbitDetector; singlepo=false)
    # check parameters
    # multiple dispatch on concrete alg

    result :: PeriodicOrbit
    return result
end

function periodic_orbits(ds::DynamicalSystem, alg::PeriodicOrbitDetector; singlepo=false)
    # without initial guesses

    result :: PeriodicOrbit
    return result
end
```

In case of timeseries data we can use the following:
```julia
function periodic_orbits(timeseries::StateSpaceSet, alg::PeriodicOrbitDetector; singlepo=false)
    result :: PeriodicOrbit
    return result
end
```

= Questions
- Rather `PeriodicOrbitDetector` or `PeriodicOrbitFinder`?
- How to determine stability of a periodic orbit in continuous ds without poincare map?
- What is a floquet multiplier?
- When is it wise to create your own struct and when not?
- Support for pretty printing of structs?
- Computing stability, sorting, statistics automatically or let the user do it?
- How to integrate with BifurcationKit? I haven't looked deeply at their methods yet.

== Common interface approaches

- https://docs.juliahub.com/CalculusWithJulia/AZHbv/0.0.15/ODEs/solve.html
- https://discourse.julialang.org/t/function-depending-on-the-global-variable-inside-module/64322/10
- Metaheuristics: https://github.com/jmejia8/Metaheuristics.jl/blob/5a14664324935bb0644b8cf20e8948de094ce363/src/algorithms/PSO/PSO.jl#L14-L51