library(Biostrings)
library(sqldf)

matc <- readDNAStringSet("maternal.fa")
patc <- readDNAStringSet("paternal.fa")
qtlexons <- read.table("exons.txt",header=T)

q_f <- qtlexons[qtlexons$direction=="forward",]
q_r <- qtlexons[qtlexons$direction=="reverse",]

genes <- sqldf("select min(Start) as start, max(End) as end, Gene_ID, direction from qtlexons group by Gene_ID")
g_f <- sqldf("select min(Start) as start, max(End) as end, Gene_ID, direction from qtlexons where direction='forward' group by Gene_ID")
g_r <- sqldf("select min(Start) as start, max(End) as end, Gene_ID, direction from qtlexons where direction='reverse' group by Gene_ID")

getAAStringSet <- function(chr,exons,rev=F) {
	ir <- IRanges(c(exons$Start),c(exons$End), names=exons$Gene_ID)
	v <- Views(unlist(chr),ir)
	dna <- DNAStringSet(v) 
	dna <- DNAStringSet(sapply(unique(dna@ranges@NAMES),function(x) c(unlist(dna[dna@ranges@NAMES==x]))))
	if (rev) {
		return(translate(reverseComplement(dna),if.fuzzy.codon="solve"))
	}
	return(translate(dna,if.fuzzy.codon="solve"))
}

getFirstStop <- function(aa,genelist,colname) {
	aas <- sapply(aa,function(x)  regexpr("\\*",x)[1])
	temp <- as.data.frame(cbind(Gene_ID=names(aas),aas))
	temp[,2] <- as.integer(levels(temp[,2])[temp[,2]])
	colnames(temp)[2] <- colname
	return(merge(genelist,temp,by="Gene_ID"))
}

mat_aa_f <- getAAStringSet(matc,q_f)
pat_aa_f <- getAAStringSet(patc,q_f)
mat_aa_r <- getAAStringSet(matc,q_r,T)
pat_aa_r <- getAAStringSet(patc,q_r,T)

g_f <- getFirstStop(mat_aa_f,g_f,"mat_stop")
g_f <- getFirstStop(pat_aa_f,g_f,"pat_stop")
g_r <- getFirstStop(mat_aa_r,g_r,"mat_stop")
g_r <- getFirstStop(pat_aa_r,g_r,"pat_stop")

diff_f2 <- g_f[g_f[,5]-g_f[,6]!=0,]
diff_r2 <- g_r[g_r[,5]-g_r[,6]!=0,]

tf_m <- mat_aa_f[diff_f2$Gene_ID]
tf_p <- pat_aa_f[diff_f2$Gene_ID]
tr_m <- mat_aa_r[diff_r2$Gene_ID]
tr_p <- pat_aa_r[diff_r2$Gene_ID]

align_f <- pairwiseAlignment(tf_m,tf_p)
align_r <- pairwiseAlignment(tr_m,tr_p)

diff_f2 <- cbind(diff_f2,match=nmatch(align_f),mis=nmismatch(align_f),mat=as.character(tf_m),pat=as.character(tf_p))
diff_r2 <- cbind(diff_r2,match=nmatch(align_r),mis=nmismatch(align_r),mat=as.character(tr_m),pat=as.character(tr_p))

nonsense <- rbind(diff_f2,diff_r2)
