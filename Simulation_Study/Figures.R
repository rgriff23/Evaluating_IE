
###############################################################################################################
# Preparations
###############################################################################################################

# Either run the code in 'Simulations.R' or load the R workspace 'Simulations.Rdata'

# Load packages
library(ape)

# In case user is running windows and can't use quartz 
if(.Platform$OS.type=="windows") {quartz<-function() windows()}

###############################################################################################################
# Plot the primate phylogeny with labeled branches
###############################################################################################################

quartz()
par(mar=c(0,0,0,0))
plot(tree, cex=0.25, edge.color="gray", label.offset=0.25)
edgelabels(cex=0.25, adj=c(0.5,-0.2), frame="none", bg="white", horiz=T, col="black")

###############################################################################################################
# Make boxplot for ancestral states across nodes (nodes ordered by increasing distance from root)
###############################################################################################################

quartz()
node = c()
nodedist = c()
IE_LOGanc = c()
DC_anc = c()
LOG_anc = c()
for (i in 1:length(branches)) {
	if (branches[[i]]$Source[1] %in% node == F) {
		node = c(node, branches[[i]]$Source)
		nodedist = c(nodedist, branches[[i]]$Nodedist)
		IE_LOGanc = c(IE_LOGanc, log(branches[[i]]$IE_anc))
		DC_anc = c(DC_anc, branches[[i]]$DC_anc)
		LOG_anc = c(LOG_anc, branches[[i]]$LOG_anc)
	}
}
node = node[order(nodedist, decreasing=F)]
node = factor(node, unique(node))
IE_LOGanc = IE_LOGanc[order(nodedist, decreasing=F)]
DC_anc = DC_anc[order(nodedist, decreasing=F)]
LOG_anc = LOG_anc[order(nodedist, decreasing=F)]
layout(matrix(1:3,3,1))
par(mar=c(2,5,3,2))
boxplot(LOG_anc~node, pch=20, cex=0.25, las=2, xaxt="n", col="gray", main="Simulations")
axis(1, at=1:length(unique(node)), labels=unique(node), las=2, cex.axis=0.3, mgp=c(2, 0.7, 0))
abline(h=0, col="red")
mtext("A", adj=0, line=1)
boxplot(DC_anc~node, pch=20, cex=0.25, las=2, xaxt="n", col="gray", main="PIDC estimates")
axis(1, at=1:length(unique(node)), labels=unique(node), las=2, cex.axis=0.3, mgp=c(2, 0.7, 0))
abline(h=0, col="red")
mtext("B", adj=0, line=1)
boxplot(IE_LOGanc~node, pch=20, cex=0.25, las=2, xaxt="n", col="gray", main="IE estimates")
axis(1, at=1:length(unique(node)), labels=unique(node), las=2, cex.axis=0.3, mgp=c(2, 0.7, 0))
abline(h=0, col="red")
mtext("C", adj=0, line=1)

###############################################################################################################
# Boxplot for standardized ancestor-descendent contrasts (branches ordered by increasing distance from root)
###############################################################################################################

quartz()
branch = c()
nodedist2 = c()
IE_LOGcontrasts = c()
DC_SDcontrasts = c()
LOG_SDcontrasts = c()
IE_rvalues = c()
for (i in 1:length(branches)) {
		branch = c(branch, rep(i,1000))
		nodedist2 = c(nodedist2, branches[[i]]$Nodedist)
		IE_LOGcontrasts = c(IE_LOGcontrasts, branches[[i]]$IE_LOGcontrasts)
		DC_SDcontrasts = c(DC_SDcontrasts, branches[[i]]$DC_SDcontrasts)
		LOG_SDcontrasts = c(LOG_SDcontrasts, branches[[i]]$LOG_SDcontrasts)
		IE_rvalues = c(IE_rvalues, branches[[i]]$IE_rvalues)
}
branch = branch[order(nodedist2, decreasing=F)]
branch=factor(branch, unique(branch))
IE_LOGcontrasts = IE_LOGcontrasts[order(nodedist2, decreasing=F)]
DC_SDcontrasts = DC_SDcontrasts[order(nodedist2, decreasing=F)]
LOG_SDcontrasts = LOG_SDcontrasts[order(nodedist2, decreasing=F)]
IE_rvalues = IE_rvalues[order(nodedist2)]
# plot
layout(matrix(1:4,4,1))
par(mar=c(2,2.5,2.5,2))
boxplot(LOG_SDcontrasts~branch, pch=20, cex=0.2, las=2, xaxt="n", col="gray", main="Simulations")
axis(1, at=1:length(unique(branch)), labels=unique(branch), las=2, cex.axis=0.2, mgp=c(2, 0.7, 0))
abline(h=0, col="red")
mtext("A", adj=0, line=1)
boxplot(DC_SDcontrasts~branch, pch=20, cex=0.2, las=2, xaxt="n", col="gray", main="PIDC estimates")
axis(1, at=1:length(unique(branch)), labels=unique(branch), las=2, cex.axis=0.2, mgp=c(2, 0.7, 0))
abline(h=0, col="red")
mtext("B", adj=0, line=1)
boxplot(IE_LOGcontrasts~as.factor(branch), pch=20, cex=0.2, las=2, xaxt="n", col="gray", main="IE estimates")
axis(1, at=1:length(unique(branch)), labels=unique(branch), las=2, cex.axis=0.2, mgp=c(2, 0.7, 0))
abline(h=0, col="red")
mtext("C", adj=0, line=1)
boxplot(IE_rvalues~as.factor(branch), pch=20, cex=0.2, las=2, xaxt="n", col="gray", main="R-values")
axis(1, at=1:length(unique(branch)), labels=unique(branch), las=2, cex.axis=0.2, mgp=c(2, 0.65, 0))
abline(h=0, col="red")
mtext("D", adj=0, line=1)


###############################################################################################################
# Accuracy of R-values on select branches
###############################################################################################################

quartz()
layout(matrix(1:8, 2, 4, byrow=T))
par(mar=c(4.2,4,3,1)+0.1)
for (i in c(1,20,40,60, 80, 100, 120, 140)) {
	if (i %in% c(80, 100, 120, 140)) {X = "Simulated changes"} else {X = ""}
	if (i %in% c(1, 80)) {Y = "R-values"} else {Y = ""}
	plot(IE_rvalues[((i-1)*1000+1):(i*1000)]~LOG_SDcontrasts[((i-1)*1000+1):(i*1000)], ylab=Y, xlab=X, main=paste("Branch", i))
	abline(h=0, col="red")
	abline(a=0, b=1, col="blue")
}

###############################################################################################################
# Estimated vs. Simulated correlation coefficients
###############################################################################################################

quartz()
layout(matrix(1:4,2,2, byrow=TRUE))
plot(PIC_slopes ~ LOG_slopes, data=models_c, xlab="Simulated evolutionary correlation", ylab="PIC slopes", main="", pch=20, xlim=c(-0.25,1.25), ylim=c(-0.25,1.25), cex=0.75)
abline(a=0,b=1)
abline(lm(PIC_slopes ~ LOG_slopes, data=models_c), col="red")
mtext("A", adj=0, line=1, cex=1)
plot(DC_slopes ~ LOG_slopes, data=models_c, xlab="Simulated evolutionary correlation", ylab="PIDC slopes", main="", pch=20, xlim=c(-0.25,1.25), ylim=c(-0.25,1.25), cex=0.75)
abline(a=0,b=1)
abline(lm(DC_slopes ~ LOG_slopes, data=models_c), col="red")
mtext("B", adj=0, line=1, cex=1)
plot(IE_slopes ~ LOG_slopes, data=models_c, xlab="Simulated evolutionary correlation", ylab="IE slopes", main="", pch=20, xlim=c(-0.25,1.25), ylim=c(-0.25,1.25), cex=0.75)
abline(a=0,b=1)
abline(lm(IE_slopes ~ LOG_slopes, data=models_c), col="red")
mtext("C", adj=0, line=1, cex=1)
plot(Rval_slopes ~ LOG_slopes, data=models_c, xlab="Simulated evolutionary correlation", ylab="IE R-value slopes", main="", pch=20, xlim=c(-0.25,1.25), ylim=c(-0.25,1.25), cex=0.75)
abline(a=0,b=1)
abline(lm(Rval_slopes ~ LOG_slopes, data=models_c), col="red")
mtext("D", adj=0, line=1, cex=1)

###############################################################################################################
# End
###############################################################################################################
