# This script CREATES SUBSETS of db_full. Though the original COCA data base (which is 16 GB) could be loaded into R, joining this data frame with lexicon was not possible given memory constraints.
# The smaller sized db_full.txt would of course permit such joins without breaking the task into chunks. To illustrate how the sample was constructed using the entire COCA data base, the same subsetting procedures are followed here.
# makesubs() takes a data frame ("data") and a specification of the number of rows ("sublength") each subset should contain

library(data.table)

dir.create(paste(getwd(), '/db_subsets', sep = ''))		# create directory for database subsets
data <- fread('data/db_full.txt')
makesubs <- function(data,sublength = 500000){	# the default sublength is 500000. This should enable a computer with 8 gigs of RAM to handle the subsequent joins that will be done with each subset.
  subnum <- ceiling(nrow(data)/sublength)		# based on hardware constrainsts desired subset size, find the number of subsets to be created
  for (i in 1:subnum){
    start <- 1 + (sublength*i - sublength)		# use multiples of sublength to determine the start index for a subset
    if (sublength*i <= nrow(data)){			# if there are sublength or more number of rows remaining to be subsetted, use multiples of sublength to determine index of end of subset
      finish <- sublength*i
    }
    else{						# otherwise use the last row of data as the end of the current subset
      finish <- nrow(data)
    }
    datasub <- data[start:finish,]			# generate the subset
    write.table(datasub, file = paste('db_subsets/datasub', i, '.txt', sep = ''), quote = F, row.names = F)		# output the subset as a text file with name of form "datasub[##].txt"
  }
}
makesubs(data)

# remove unneeded objects and functions
rm(data, makesubs)