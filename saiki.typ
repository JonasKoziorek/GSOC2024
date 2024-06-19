= Numerical detection of unstable periodic orbits in continuous-time dynamical systems with chaotic behaviors

== Input
- Continuous ds
- Vector{InitialGuess} \~ initial guesses
- $delta$ \~ damping coefficient


== Output
PeriodicPoint


== Overview
- damped Newton-Raphson-Mees algorithm
- doesn't require a PSOS
- there exist some optimal damping coefficient $delta$
- if the chosen $delta$ is too small, the algorithm doesn't converge, if $delta$ is too big the algorithm takes too long to converge
- this algorithm can detect UPOs that are outside of attractor
- optimal damping coefficient is selected based on Floquet exponent (maximal eigenvalue of the UPO of the corresponding Poincare map) and the period of the UPO
- good damping parameter can be determined by trying out several damping parameters and see their convergence

== Algorithm
We have continuous dynamical system

$(d x)/(d t) = F(x)$

We look for zeros of 

$H(x, t) = phi.alt_(t)(x)-x$

Where $phi.alt_(t)(x)$ is the solution of the system at time $t$ starting from $x$.

When the solution going through $x$ is periodic of period $t$ then $H(x,t)=0$.

1. Choose an initial guess $(X^((0)), T^((0)))$.
2. update the initial guess with iterative scheme

$(X^((i+1)), T^((i+1))) = (X^((i)), T^((i))) + 2^(-m) (Delta X^((i)), Delta T^((i)))$

where $m in NN$ is the damping parameter, $2^(-m)$ is the damping coefficient

$(Delta X^((i)), Delta T^((i)))$ is obtained by solving linear system

$
mat(
  Phi_(T^((i)))(X^((i)))-I, F(phi.alt_(T^((i))))(X^((i))); 
  F(X^((i)))^(T), 0;
) 
vec(Delta x^((i)), Delta T^((i))) = vec(X^((i)) - phi.alt_(T^((i)))(X^((i))), 0)
$

3. Repeat step 2 until convergence or reaching maximum number of iterations. Convergence is checked if $|phi.alt_(T^((i)))(X^((i))) - X^((i))|$ (distance after integrating for T) and $|(Delta X^(i), Delta T^((i)))|$ (newton step correction) are sufficiently small.


== The variational equation (From Parker textbook)
Let's have 

$dot(x)=f(x,t), #h(1cm) x(t_0)=x_0$ 

with solution $phi.alt_(t)(x_0, t_0)$, that is

$dot(phi.alt_(t))(x_0, t_0) = f(phi.alt_(t)(x_0, t_0), t), #h(1cm) phi.alt_(t_0)(x_0, t_0)=x_0$

Differentiate with respect to $x_0$ to obtain

$D_(x_0) dot(phi.alt_(t))(x_0, t_0) = D_(x) f(phi.alt_(t)(x_0, t_0), t) D_(x_0) phi.alt_(t)(x_0, t_0)$

$D_(x_0) phi.alt_(t_0)(x_0, t_0) = I$

Define $Phi_(t)(x_0, t_0) = D_(x_0) phi.alt_(t)(x_0, t_0)$

Then we get

$dot(Phi_(t))(x_0, t_0) = D_(x) f(phi.alt_(t)(x_0, t_0), t) Phi_(t)(x_0, t_0)$

which is called the variational equation.

For autonomous systems $t_0 = 0$.

To solve the equation, we have to solve these two ODEs simultanously

$vec(delim: "{", dot(x), dot(Phi)) =  vec(delim: "{", f(x, t), D_(x) f(x,t) Phi)$

Initial condition is 

$vec(delim: "{", x(t_0), Phi (t_0)) = vec(delim: "{", x_0, I)$

One of the ODEs is Matrix valued, to solve this, we can flatten the matrix and solve this system of coupled ODEs with a standard solver.



== Questions
- How to solve the variational equation numerically?
- What is Floquet exponent?
- What is Floquet multiplier?
- What is Monodromy matrix?