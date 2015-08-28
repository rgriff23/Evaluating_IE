
IErun = function (tree, sims) {
	l = list()
	for (i in 1:ncol(sims)) {
		
		# Edit branches dataframe
		l[[i]] = IEalgorithm(tree, sims[,i][1:length(tree$tip)])
		dc = DCalgorithm(tree, log(sims[,i][1:length(tree$tip)]))
		actual = Actual(tree, sims[,i])
		l[[i]]$Branches = data.frame(l[[i]]$Branches, dc$Branches[,3:ncol(dc$Branches)], actual)
		
		# Edit ancestral state dataframe
		a = data.frame(l[[i]]$AncestralStates)
		dc_anc = data.frame(dc$AncestralStates)
		actuals = data.frame(sims[,i][(length(tree$tip)+1):nrow(sims)])
		dc_anc_actuals = merge(dc_anc, actuals, by="row.names")
		row.names(dc_anc_actuals) = dc_anc_actuals$Row.names
		dc_anc_actuals = dc_anc_actuals[,-1]
		merged = merge(a, dc_anc_actuals, by="row.names")
		row.names(merged) = merged$Row.names
		l[[i]]$AncestralStates = merged[,-1]
		names(l[[i]]$AncestralStates) = c("IEancestors", "DCancestors", "ActualAncestors")

	}
	return(l)
}