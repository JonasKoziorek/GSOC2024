using DynamicalSystems

struct InitialGuess{U<:AbstractArray{<:Real}, R<:Union{Real, Nothing}}
    u0::U
    T::R
end
InitialGuess(u0) = InitialGuess(u0, nothing)
# if you have several guesses:
guesses = [InitialGuess(u, t) for (u, t) in zip(guesses)]

struct PeriodicPoint{U<:AbstractArray{<:Real}, R<:Real}
    # point of the periodic orbit
    u::U
    # period
    T::R
end

struct PeriodicOrbit{U<:AbstractArray{<:Real}, R}
    points::Vector{U}
    T::R
end


function Base.∈(u0::PeriodicPoint, POs::PeriodicOrbit)
    # custom search
    # (discrete) - linear search through the set
    # (continuous) - distinguish identical periodic orbits
end


function stable(ds, po::PeriodicPoint; jac=autodiff_jac(ds))::Bool
end


function complete_orbit(ds, po::PeriodicPoint)
    # compute trajectory for period po.T
    result :: PeriodicOrbit
    return result
end

# -----------------------------

abstract type PeriodicOrbitDetector end

@kwdef struct Algorithm1 <: PeriodicOrbitDetector
    param1 = 1
    param2 = 2
    param3 = 3
end

function periodic_orbit(ds::DynamicalSystem, alg::PeriodicOrbitDetector, ig::InitialGuess = InitialGuess(ds))
    result::PeriodicOrbit
    return result
end

function periodic_orbits(ds::DynamicalSystem, alg::PeriodicOrbitDetector, igs::Vector{InitialGuess} = [InitialGuess(ds)])
    result::Vector{PeriodicOrbit}
    return result
end

InitialGuess(ds::DynamicalSystem, T = nothing) = InitialGuess(current_state(ds), T)
