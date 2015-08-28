
# Compute actual changes on branches given a tree and single set of simulated values at all nodes
# Returns a data frame with contrasts on each branch, in both arithmetic and log-space

Actual = function (tree, sims) {
	
	# convert species names to tip numbers for indexing
	names(sims)[1:length(tree$tip.label)] = as.character(1:length(tree$tip.label))
	
	# define empty vectors to store ancestors/descendents/contrasts
	anc <- desc <- contrast <- logcontrast <- c()
	
	# go through each branch in edge list, compute and store ancestors/descendents/contrasts
	for (i in 1:nrow(tree$edge)) {	
		anc[i] = sims[as.character(tree$edge[i,1])]
		desc[i] = sims[as.character(tree$edge[i,2])]
		contrast[i] = desc[i] - anc[i]
		logcontrast[i] = log(desc[i] ) - log(anc[i])
	}
	
	# combine results into data frame 
	dat = data.frame(RAW_anc=anc, RAW_desc=desc, RAW_contrasts = contrast, RAW_SDcontrasts = contrast/sqrt(tree$edge.length), LOG_anc=log(anc), LOG_desc=log(desc), LOG_contrasts=logcontrast, LOG_SDcontrasts = logcontrast/sqrt(tree$edge.length))
	
	return(dat)
	
}