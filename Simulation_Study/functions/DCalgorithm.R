

# This code computes 2N - 2 directional contrasts for N species and a phylogeny
# Felsenstein's (1985) PIC algorithm is used to reconstruct ancestral states
# Data should of course be logged before if they scale exponentially

DCalgorithm = function (tree, data) {
	
	# Load packages
	library(ape)
	
	# Reconstruct ancestral states with PIC
	states = suppressWarnings(ace(data, tree, type="continuous", method="pic"))$ace

	# Compute ancestor-descendent contrasts for each edge
	ancestors <- descendents <- dc <- sdc <- c()
	for (i in 1:nrow(tree$edge)) {
		anc = states[as.character(tree$edge[i,1])]
		ancestors[i] = anc
		if (tree$edge[i,2] > length(data)) {	# descendent is internal
			dec = states[as.character(tree$edge[i,2])]
			descendents[i] = dec
			dc[i] = dec - anc
			sdc[i] = (dec - anc)/sqrt(tree$edge.length[i])
		} else {	# descendent is terminal
			dec = data[tree$tip.label[tree$edge[i,2]]]
			descendents[i] = dec
			dc[i] = dec - anc
			sdc[i] = (dec - anc)/sqrt(tree$edge.length[i])
		}
	}
	
	# Return results
	branches = data.frame(Source=tree$edge[,1], Sink=tree$edge[,2], DC_anc=ancestors, DC_dec=descendents, DC_contrasts=dc, DC_SDcontrasts=sdc)
	return(list(AncestralStates=states, Branches=branches))
	
}