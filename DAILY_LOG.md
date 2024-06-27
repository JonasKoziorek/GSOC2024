# Daily Log

In this document I will be writing down what I worked on during the specific days.

# 6.6.2024

## Goals for today
1. Set up a personal blog where I will track my progress. ✅︎
2. Write a post to Julia discourse about my GSOC. ❌
3. Start reading and implementing the CD algorithm. ❌
4. Read about numerical bifurcation analysis before meeting with Romain Veltz next week. ✅︎

## Today's activity
* I set up some simple blank blog via github pages.
* I am reading `Practical Bifurcation and Stability Analysis` from `Seydel`. I studied:

    * classification of equilibrium points (nodes, saddles, foci)
    * linearization near equilibrium points via taylor
    * analysis of eigvals of jacobian at equilibrium points
    * nullclines
    * perturbations

## Work hours
4.5

# 7.6.2024 

## Today's activity
* Learning how to correctly set up ChaosTools.jl docs
* Fixing typos in the docs
* reading `Seydel`
* Tracking a bug in one test, potential bug in `davidchacklai`, WIP


## Unfinished Tasks
1. Write a post to Julia discourse about my GSOC.
2. Start reading and implementing the CD algorithm.

## Work hours
5.75

# 8.6.2024 

## Today's activity
* Tracking the bug from yesterday
    
    * The `RBTree` implementation sometimes had duplicates. I could not figure out why. The equality `==` would simply fail in some cases. For some reason porting `RBTree` to vector and then back to `RBTree` would sometimes fix the issue but that was unclean. I tried to implement the datastructure as a `Set` while still using `VectorWithEpsRadius` however there was some problem with the fact that `==` of a custom type has to be equivalent to `hash` of a custom type and I could not get it to work. If it worked, insertion and search in hashed set would take `O(1)`. I tried to implement my own binary search tree and also to use `Set` with linear search for duplicated. After benchmarking `Set` with linear search seemed like a best option. It won both in runtime and allocation count.


## Unfinished Tasks
1. Write a post to Julia discourse about my GSOC.
2. Start reading and implementing the CD algorithm.

## Work hours
8.25


# 10.6.2024 

## Today's activity
* playing with bifurcation diagrams, implementing a bifurcation diagram that displays bifurcation curves of UPOs of a logistic map
* writing post to discourse about my GSOC
* reading Seydel

    * implicit function theorem
    * saddle node bifurcation


## Unfinished Tasks
1. Start reading and implementing the CD algorithm.

## Work hours
6.0

# 11.6.2024 

## Today's activity
* reading seydel

    * transcritical bifurcation
    * subcritical and supercritical pitchfork bifurcation
    * hysteresis, isola centers, multiple bifurcation points
    * normal forms for bifurcations
    * Hopf bifurcation

* trying out `BifurcationKit.jl`, trying out to display bif diag of normal forms and also continue periodic orbit that gets formed after Hopf bifurcation


## Unfinished Tasks
1. Start reading and implementing the CD algorithm.

## Work hours
6.75

# 12.6.2024 

## Today's activity
* reading the CD and Saiki papers
* meeting with George and Romain

## Work hours
3.5

# 16.6.2024

## Today's activity
* Reading about PSOS
* Reading the paper about continuous time Schmelcher-Diakonos
* Trying to detect UPOs of Lorenz system via Schmelcher-Diakonos and PSOS - unsuccessful

## Work hours
4.25

# 17.6.2024

## Today's activity
* Thinking about the unified interface, writing drafts of it

## Work hours
3.00

# 18.6.2024

## Today's activity
* Finishing the common interface
* Reading papers, writing overview reports on them
* collecting inputs and outputs for the table

## Work hours
8.00

# 19.6.2024

## Today's activity
* meeting
* reviewing my notes before the meeting

## Work hours
2.25

# 23.6.2024

## Today's activity
* Coding Saiki algorith (not working yet)

## Work hours
3.00

# 24.6.2024

## Today's activity
* Implementing the common interface format for Saiki (WIP)

## Work hours
2.00

# 25.6.2024

## Today's activity
* Implementing common interface for Davidchacklai and SchmelcherDiakonos

## Work hours
4.50

# 25.6.2024

## Today's activity
* Meeting
* Implementing common interface
* Improving saiki, introducing backward time stepping, tracking where the code is hanging (solver is diverging to infinity)
* Trying out whether poincare maps work by default with our algorithms


## Work hours
8.50

# 25.6.2024

## Today's activity
* trying to improve Saiki so that the algorithms is not hanging. I still couldn't find any UPO with Saiki, only fixed points.


## Work hours
1.75
