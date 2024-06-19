= Exploring Chaotic Motion Through periodic Orbits

== Input
- $x_1 dots$ $x_n$ \~ chaotic timeseries data from discrete ds
- $r_1$ \~ disttol1
- $r_2$ \~ disttol2
- $[n_1, n_2, n_3, dots ]$ \~ vector of periods to be checked

== Output
- Vector{PeriodicOrbit}(undef, n) \~ periodic orbits for each of the checked periods
- eigenvalues and eigenvectors for each periodic orbit

== Overview
- Algorithm for extracting periodic orbits and their stability from chaotic timeseries is presented.
- Properties like topological entropy or Hausdorff dimension can be subsequently calculated.
- They calculate topological entropy with POs
- Timeseries is scanned for n-pairs of points that would form the n-periodic orbit
- All points that return close to themselves after n steps are grouped into n-periodic orbits
- In order to decide whether two nearly periodic orbits are the same, their positions relative to each other are checked
- Parameters $r_1$, $r_2$ are used in the process of determining almost periodic sequences and grouping them into cycles
- $r_1$ equivalent to disttol, if distance between two points (separated by n steps) is less than $r_1$, they belong to n-periodic orbit
- $r_1$ is chosen large enough to include several sequences corresponding to a particular periodic orbit

- To distinguis whether two nearly periodic orbits belong to distinct periodic orbits, $r_2$ is used
- If corresponding pairs of points of the two orbits are less than $r_2$ apart, they are the same orbit
- $r_2$ the distance between cycles, is set small enough as to distinguish between distinct periodic orbits under the condition that $r_2 > r_1$.
- The position of the whole periodic orbit can be calculated as average of all the points in the orbit. This average can be compared with another orbit. If the distance is less than $r_2$, the orbits are the same.

- I don't understand fully how to compute the eigenvalues and eigenvectors of the periodic orbits


== Notes
- They needed $10^5$ data points to extract PO of order $1$-$10$

== Questions
- What is lyapunov exponent?
- Is lyapunov exponent the stability indicator of a periodic orbit?