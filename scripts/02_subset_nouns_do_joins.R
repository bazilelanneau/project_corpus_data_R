# this script takes the previously created subsets of COCA and creates respective subsets including only nouns (each row of a newly created subset represents an instance of a noun in COCA)

library(data.table)
library(dplyr)
sources <- read.table('data/sources.txt', sep = '\t', header = T, comment.char = "", quote = "")	# load sources.txt into R as a data frame
sources <- subset(sources, select = -c(year, word_count, subgenre, title, publication_info))		# remove unnecessary columns
lexicon <- fread('data/lexicon.txt', sep = '\t', quote = "", header = T)				# load lexicon.txt into R as a data frame
for (subset in list.files('db_subsets')){							# iterate through list of names of previously created subsets
  temp_data <- fread(paste('db_subsets/', subset, sep = ''))
  datajoin <- left_join(temp_data, lexicon, by = 'wordID')
  datajoin <- datajoin[grep('^nn', datajoin$PoS),]						# subset to only nouns (all noun types start with "nn")
  datajoin <- left_join(datajoin, sources, by = 'textID')
  write.table(datajoin, file = paste('db_subsets/', substr(subset, 1, nchar(subset) - 4), 'nouns', '.txt', sep = ''), row.names = F, sep = '\t', quote = F)		# export subset with a name same as imported file's name but with "nouns" just before ".txt"
  rm(temp_data, datajoin)		 								# clear the data and the join from the global environment
}

rm(subset)