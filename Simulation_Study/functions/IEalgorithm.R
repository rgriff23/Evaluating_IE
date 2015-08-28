
# Function to run IE, computing AP values for all nodes as a first step

# Load packages
library(ape)
library(adephylo)

IEalgorithm = function (tree, data) {
	
	# Definitions
	data = data[tree$tip.label]
	ntip = length(tree$tip.label)
	Branches = data.frame(Source=tree$edge[,1], Sink=tree$edge[,2], Nodedepth=rep(NA, 2*ntip-2), Nodedist=rep(NA, 2*ntip-2), Branchlength=tree$edge.length, IE_anc=rep(NA, 2*ntip-2), IE_desc=unname(data)[tree$edge[,2]], IE_rvalues=rep(NA, 2*ntip-2), IE_contrasts=rep(NA, 2*ntip-2), IE_SDcontrasts=rep(NA, 2*ntip-2), IE_LOGcontrasts=rep(NA, 2*ntip-2), IE_SDLOGcontrasts=rep(NA, 2*ntip-2))
	
	# Compute AP for internal nodes
	distNodes = dist.nodes(tree)[(ntip+1):(ntip+tree$Nnode),1:ntip]
	AP = colSums(data/t(distNodes))/rowSums(1/distNodes)
	
	# Redefine distNodes for computing ancestral states
	distNodes = dist.nodes(tree)
	
	# Traverse tree from tips to root to compute ancestral states
	for (i in (ntip+tree$Nnode):(ntip+1)) {
		
		# Define sister taxa and node
		br = which(tree$edge[,1]==i)
		tax1 = tree$edge[,2][br][1]
		tax2 = tree$edge[,2][br][2]
		
		# IE algorithm
		x1 = Branches$IE_desc[tree$edge[,1]==i][1]	# tax1 value
		x2 = Branches$IE_desc[tree$edge[,1]==i][2]	# tax2 value
		b1 = distNodes[i,tax1]	# branch length 1
		b2 = distNodes[i,tax2]	# branch length 2
		S1 = abs(x1-x2)/((x1+x2)/2)	# S-distance 1
		S2 = abs(x2-AP[i-ntip])/((x2+AP[i-ntip])/2)	# S-distance 2
		S3 = abs(x1-AP[i-ntip])/((x1+AP[i-ntip])/2)	# S-distance 3
		T1 = ((S1+S3)-S2)/2	# T-distance 1
		T2 = ((S1+S2)-S3)/2	# T-distance 2
		T3 = ((S2+S3)-S1)/2	# T-distance 3
		R1 = T1 * ((b1/(b1+b2)) * 2)	# R-value 1
		R2 = T2 * ((b2/(b1+b2)) * 2)	# R-value 2
		A = ((x1/R1)+(x2/R2))/((1/R1)+(1/R2))	# Ancestral state
		
		# Store information
		Branches$Nodedepth[br] = node.depth(tree)[i] 	# node depth
		Branches$Nodedist[br] = node.depth.edgelength(tree)[i] 	# node distance from root
		Branches$IE_anc[br] = A	# ancestors
		Branches$IE_desc[which(Branches$Sink==i)] = A	# desendent
		Branches$IE_rvalues[br] = c(R1, R2)	# R-values
		if (A > x1) {Branches$IE_rvalues[br[1]] = -1*Branches$IE_rvalues[br[1]]}	# post-hoc rate
		if (A > x2) {Branches$IE_rvalues[br[2]] = -1*Branches$IE_rvalues[br[2]]}	# post-hoc rate
		Branches$IE_contrasts[br] = Branches$IE_desc[br] - Branches$IE_anc[br]	# IE contrasts
		Branches$IE_SDcontrasts[br] = Branches$IE_contrasts[br]/c(sqrt(b1), sqrt(b2))	# SD contrasts
		Branches$IE_LOGcontrasts[br] = log(Branches$IE_desc[br]) - log(Branches$IE_anc[br])	# LOG contrasts
		Branches$IE_SDLOGcontrasts[br] = Branches$IE_LOGcontrasts[br]/c(sqrt(b1), sqrt(b2))	# SD LOG contrasts
		
	}
	
	AncestralStates = unique(Branches[,c("Source", "IE_anc")])[,2]
	names(AncestralStates) = unique(Branches[,c("Source", "IE_anc")])[,1]
	return(list(AncestralStates = AncestralStates, Branches=Branches))
	
}