
###############################################################################################################
# Preparations
###############################################################################################################

# Load packages
library(ape)
library(adephylo)
library(phytools)

# Set working directory
setwd('~/Desktop/GitHub/Evaluating_IE/Simulation_Study')

# Load functions
invisible(sapply(list.files('./functions', full.names=TRUE), source))

# Load phylogeny
tree = read.nexus("./primates.nexus")

# Set state for random number generation
set.seed(82615)

###############################################################################################################
# Run individual trait simulations and process output
###############################################################################################################

# Number of individual trait simulations
n_i = 1000

# Each column will contain a vector of SIMULATED TRAIT VALUES AT EACH NODE
sims_i = exp(fastBM(tree, internal=TRUE, nsim=n_i))

# Each list in the list corresponds to OUTPUT FROM IE/DC ANALYSIS FOR EACH SIMULATED DATA SET
models_i = IErun(tree, sims_i)

# Dataframes in the list correspond to SUMMARIZE OUTPUT FOR INDIVIDUAL BRANCHES
branches = BranchResults(models_i)
 
# Rows in the dataframe correspond to SUMMARY STATS FOR SIMS ON INDIVIDUAL BRANCH
stats = BranchStats(branches)

###############################################################################################################
# Run correlated trait simulations (exponentiate all results) and process output
###############################################################################################################

# Number of correlated trait simulations
n_c = 500

# Increments for the correlation coefficient
corrs = round(seq(from=0, to=0.999, length.out=n_c), 3)

# Each element will contain a 2D matrix with a pair of simulated trait values for each node
sims_c = list()
for (i in 1:n_c) {
	sims_c[[i]] = exp(sim.corrs(tree, vcv=matrix(c(1,corrs[i],corrs[i],1),2,2)))
	}

# Columns in the dataframe correspond to REGRESSION SLOPES FROM IE, DC, PIC, AND SIMULATIONS
models_c = RunCorrMods(tree, sims_c, corrs)

###############################################################################################################
# End
###############################################################################################################
