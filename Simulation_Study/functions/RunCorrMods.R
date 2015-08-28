
library(ape)

RunCorrMods = function (tree, sims, truecorrs) {

	#store
	ie.slopes = c()
	dc.slopes = c()
	pic.slopes = c()
	rv.slopes = c()
	
	for (i in 1:length(sims)) {
		
		# run Original IE
		ie1 = IEalgorithm(tree, sims[[i]][,1])
		ie2 = IEalgorithm(tree, sims[[i]][,2])
		ie.reg = lm(ie1$Branches$IE_SDLOGcontrasts ~ ie2$Branches$IE_SDLOGcontrasts - 1)
		ie.slopes = c(ie.slopes, summary(ie.reg)$coefficients[1])
		
		# run IE R-values
		rv.reg = lm(ie1$Branches$IE_rvalues ~ ie2$Branches$IE_rvalues - 1)
		rv.slopes = c(rv.slopes, summary(rv.reg)$coefficients[1])
		
		# run DC
		dc1 = DCalgorithm(tree, log(sims[[i]][,1]))
		dc2 = DCalgorithm(tree, log(sims[[i]][,2]))
		dc.reg = lm(dc1$Branches$DC_SDcontrasts ~ dc2$Branches$DC_SDcontrasts - 1)
		dc.slopes = c(dc.slopes, summary(dc.reg)$coefficients[1])
		
		# run PIC
		pic1 = pic(log(sims[[i]][,1]), tree)
		pic2 = pic(log(sims[[i]][,2]), tree)
		pic.reg = lm(pic1~pic2 - 1)
		pic.slopes = c(pic.slopes, summary(pic.reg)$coefficients[1])
		
	}
		
	return(data.frame(IE_slopes=ie.slopes, Rval_slopes=rv.slopes, DC_slopes=dc.slopes, PIC_slopes=pic.slopes, LOG_slopes=truecorrs))
	
}