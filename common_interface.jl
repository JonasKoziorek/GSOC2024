using DynamicalSystems

struct InitialGuess where {N<:Int64, T::Real}
    # either u0 = [u1, u2, ..., uN] or u0 = [u1, u2, ..., uN, T]
    u0::SVector{N, T}
end

struct PeriodicPoint where {N<:Int64, T::Real}
    # point of the periodic orbit
    u0 :: SVector{N, T}
    # period
    T :: T
end

struct PeriodicOrbit where {N<:Int64, T::Real}
    # this can be changed later for something better
    POs :: Set{PeriodicPoint{N, T}}
end

import Base.∈
function ∈(u0::PeriodicPoint, POs::PeriodicOrbit)
    # custom search
    # (discrete) - linear search through the set
    # (continuous) - distinguish identical periodic orbits
end


function stable(ds, po::PeriodicPoint; jac=autodiff_jac(ds))
end

function complete_orbit(ds, po::PeriodicPoint)
    # compute trajectory for period po.T
    result :: PeriodicOrbit
    return result
end

# -----------------------------

abstract type PeriodicOrbitDetector end

struct Algorithm1 <: PeriodicOrbitDetector
    param1
    param2
    param3
end

function Algorithm1(;param1=1, param2=2, param3=3)
    Algorithm1(param1, param2, param3)
end
# similar approach as in meta heuristics: https://github.com/jmejia8/Metaheuristics.jl/blob/5a14664324935bb0644b8cf20e8948de094ce363/src/algorithms/PSO/PSO.jl#L14-L51

# -----------------------------

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

function periodic_orbits(timeseries::StateSpaceSet, alg::PeriodicOrbitDetector; singlepo=false)
    result :: PeriodicOrbit
    return result
end