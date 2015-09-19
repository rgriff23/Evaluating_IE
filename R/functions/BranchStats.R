
# branchresults is an object created with BranchResults, which has simulation results for each branch
# If exporting plots, input to 'export.plots' the path to the folder where the plots will go (as a character string)

BranchStats = function(branchresults) {
	
	# store summary stats for each branch
	new_dat = data.frame()
	
	# loop through each branch of the tree
	for (i in 1:length(branchresults)) {
		
		# regression through origin
		mod.IE = lm(IE_SDLOGcontrasts ~ LOG_SDcontrasts - 1, data=branchresults[[i]])
		mod.DC = lm(DC_SDcontrasts ~ LOG_SDcontrasts - 1, data=branchresults[[i]])
		
		# create new row for data frame 
		dat = data.frame(Source = branchresults[[i]]$Source[1],
		Sink = branchresults[[i]]$Sink[1],
		Nodedepth = branchresults[[i]]$Nodedepth[1],
		Nodedist = branchresults[[i]]$Nodedist[1],
		Branchlength = branchresults[[i]]$Branchlength[1],
		mean.IE = mean(branchresults[[i]]$IE_SDLOGcontrasts), 
		mean.DC = mean(branchresults[[i]]$DC_SDcontrasts), 
		mean.LOG = mean(branchresults[[i]]$LOG_SDcontrasts), 
		sd.IE = sd(branchresults[[i]]$IE_SDLOGcontrasts), 
		sd.DC = sd(branchresults[[i]]$DC_SDcontrasts), 
		sd.LOG = sd(branchresults[[i]]$LOG_SDcontrasts), 
		slope.IE = summary(mod.IE)$coefficients[,"Estimate"][1],
		slope.DC = summary(mod.DC)$coefficients[,"Estimate"][1], 
		R2.IE = summary(mod.IE)$r.squared, 
		R2.DC = summary(mod.DC)$r.squared)
		
		# add to data frame
		new_dat = rbind(new_dat, dat)
		
	}

	return(new_dat)
	
}