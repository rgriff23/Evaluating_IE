# Evaluating the legitimacy of the Independent Evolution method

[Randi H. Griffin]() and [Gabriel S. Yapuncich](http://www.gabrielyapuncich.com/)

___

This repository contains the data and code used to evaluate the legitimacy of IE using simulations. I also provide a synopsis of our study. A complete manuscript is out for review as of May 2015. 

## Manuscript

The **Manuscript** folder contains a synopsis of our manuscript in the file `Synopsis.md`. 

The **Manuscript/figures** folder contains the figures that are included in the synopsis.

## Simulation_Study

The **Simulation_Study** folder contains the data and R code needed to replicate our simulation study. Several R packages must be installed for this code to work.

```
install.packages("ape")
install.packages("adephylo")
install.packages("phytools")
```

### Data 

The only data file is the primate phylogeny, `primates.nexus`, which provides the scaffolding for our simulations of trait evolution. This phylogeny was obtained from Version 3 of the [10kTrees website](http://10ktrees.nunn-lab.org/) (Arnold et al., 2010). 

### Simulations

`Simulations.R` contains code to simulate the evolution of individual traits and pairs of correlated traits along the primate phylogeny according to a Brownian motion model. Simulation results are then processed so they are ready to analyze. 

`Figures.R` contains code to visualize the results from `Simulations.R`. Running the simulations and processing the output takes around 10 minutes, and can be done with the following code (assuming your working directory is `Simulations_Study`):

```
source("Simulations.R")
source("Figures.R")
```

For the impatient, the workspace `Simulations.Rdata` contains processed simulation output that is ready to be visualized with `Figures.R`. Thus, you can obtain the same figures by loading the saved workspace and then running `Figures.R`:

```
load("Simulations.Rdata")
source("Figures.R")
```

### Functions

The **Simulation_Study/functions** folder contains a number of functions for analyzing and processing simulation output. These functions are automatically loaded by the code in `Simulations.R`. 

One of these is a function for the IE method, `IEalgorithm.R`, which I programmed following the description provided in Smaers and Vinicius (2009). It later came to my attention that Jeroen Smaers had made [his own code](https://github.com/JeroenSmaers/evomap/blob/master/R/ie.r) available on Github. I have confirmed that my code produces identical results to Jeroen's code. 

## References

- Arnold C, Matthews LJ, Nunn CL. The 10kTrees Website: a new online resource for primate phylogeny, v3. Evol Anthropol. 2010;19: 114–118.

- Smaers JB, Vinicius L. Inferring macro-evolutionary patterns using an adaptive peak model of evolution. Evol Ecol Res. 2009;11: 991-1015.

