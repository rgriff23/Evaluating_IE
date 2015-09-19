

BranchResults = function (l) {
	
	# list of length equal to the number of branches
	lnew = list()
	
	# loop through each branch
	for (i in 1:nrow(l[[1]]$Branches)) {
		
		branchresults = data.frame()
		# loop through each IErun output in list
		for (j in 1:length(l)) {
			branchresults = rbind(branchresults, l[[j]]$Branches[i,])
		}
		row.names(branchresults) = 1:nrow(branchresults)
		lnew[[i]] = branchresults
		
	}
	return(lnew)
}