= Detecting Unstable Periodic Orbits in Chaotic Experimental Data

== Input
- $x_1 dots$ $x_n$ \~ chaotic timeseries data from discrete ds
- $[k_1, k_2, k_3, dots ]$ \~ vector of parameters $k$
- in higher dimensions something related to delay embeddings, eg. embedding dimension


== Output
- PeriodicPoint \~ One periodic points if it can be determined automatically from the histogram or
- histogram data (Vector of Ints corresponding to each bin)


== Overview
- A method is proposed for detecting unstable periodic orbits and their stability properties from chaotic time series.
- paper focuses on finding fixed point (period 1) for discrete systems
- Result for higher dimension is mentioned as well.
- Points that are in the linear neighborhood of the fixed point are transformed near the fixed point.
- Transformation 

$hat(x)_(n) = [x_(n+1) - s_(n)(k) x_(n)] / [1 - s_(n)(k)]$

$s_(n)(k) = (x_(n+2)-x_(n+1))/(x_(n+1)-x_(n)) + k(x_(n+1)-x_(n))$

- We are interested in density function $hat(rho)(hat(x))$. In practice we use the histogram approximation. We look for peaks in the histogram.
- To ensure the correct peaks were found, the histograms are computed for different parameter $k$ and averaged.
- They generated $500$ parameters $k$ as random numbers from $[-5,5]$.
- This method applied to 1D systems and for fixed points.

- There is a general formula for higher dimensional systems in matrix form.
- Again we look at the histogram of the transformed data.
- To asses validity of the peaks we use surrogate data.
- By use of surrogates we can compute the probability that peak has a certain deviation from the mean.
- It seems that it detects the periodic orbits that are on the attractor (not outside of it).


== Questions
What's the input and what is the output?
What is a singularity?
What is delay embedding?
What is surrogate data?

== Notes