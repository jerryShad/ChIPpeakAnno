findVennCounts <- function(Peaks, NameOfPeaks, maxgap=0,  totalTest)
{
	if (missing(totalTest))
	{
		stop("Missing totalTest which is required! The parameter totalTest is the total number of possible Peaks in the testing space.")
	}
	if (missing(NameOfPeaks) ||  mode(NameOfPeaks) != "character")
	{
		stop("Missing required character vector NameOfPeaks")
	}
	if (missing(Peaks))
	{
		stop("Missing Peaks which is a list of peaks in RangedData!")
	}
	n1 = length(Peaks)
	n2 = length(NameOfPeaks)
	if (n1 <2)
	{
		stop("The number of element in NameOfPeaks is less than 1, need at least 2 peak ranges!")
	}
	if (n1 > n2)
	{
		stop("The number of element in NameOfPeaks is less than the number of elements in Peaks, need to be equal!")
	}
	if (n1 < n2)
	{
		stop("The number of element in NameOfPeaks is larger than the number of elements in Peaks, need to be equal!")
	}
	lapply(seq_len(n1), function(i)
	{
		if (class(Peaks[[i]]) != "RangedData")
		{
			err.msg = paste("Element", i, "in Peaks is not a valid RangedData object", sep=" ")
			stop(err.msg)
		}
	})
	lapply(seq_len(n1), function(i)
	{	
		if (!length(rownames(Peaks[i])))
		{
			rownames(Peaks[[i]]) = formatC(1:dim(Peaks[[i]])[1], width=nchar(dim(Peaks[[i]])[1]), flag='0')
		}		
	})
	if (n1 == 2)
	{
		a1 = cbind(c(0,0,1,1),c(0,1,0,1))
		colnames(a1) = NameOfPeaks
		a2 = vennCounts(a1)
		overlappingPeaks = findOverlappingPeaks(Peaks[[1]],Peaks[[2]], maxgap=maxgap, multiple=F)$OverlappingPeaks
		p1.and.p2 = length(unique(overlappingPeaks[[NameOfPeaks[1]]]))
		p1 = length(rownames(Peaks[[1]]))
		p2 = length(rownames(Peaks[[2]]))
		p1only = length(setdiff(as.character(rownames(Peaks[[1]])), as.character(overlappingPeaks[[NameOfPeaks[1]]])))
		p2only = length(setdiff(as.character(rownames(Peaks[[2]])), as.character(overlappingPeaks[[NameOfPeaks[2]]])))
		p2inp1 = length(unique(overlappingPeaks[[NameOfPeaks[2]]]))
		neither = totalTest - p1only - p2 
		Counts =c(neither,p2only,p1only,p1.and.p2)
		a2[,3] = Counts
		p.value = phyper(p1.and.p2 -1, p2, totalTest-p2, p1, lower.tail = FALSE,log.p = FALSE)
		list(p.value=p.value, vennCounts = a2)
	}
	else
	{
		stop("Larger than 2 list is not implemented yet!") 
	}
}