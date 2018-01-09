# This script takes the previously generated tables of noun pairings and creates the random sample.
# Two important data objects are created within the R environment and additionally output as txt files into a new directory 'sample'. These are R object NN_lemma_stats and its respective file NN_lemma_stats.txt as well as R object NN_lemma_sample and its respective file NN_lemma_sample.
# NN_lemma_stats is a table with two columns 'lemma' and 'lemma_freq'. Each row gives a unique noun-noun lemma and the total number of times it occurs. (For those without a linguistics background: the term "lemma" refers to the general lexical item, ignoring inflections and capitalization so "basketball team", "basketball teams", and "Basketball team" are all categorized as instances of the same noun-noun lemma, "basketball team").
# NN_lemma_sample is a subset of NN_lemma_stats that only includes the rows of noun-noun lemmas randomly selected for the sample.

library(data.table)

# concatenate the subsets of consecutive nouns into one data frame in R
NN_db <- data.frame()						# start with an empty data frame
for (file in list.files('db_subsets')[grep("NN", list.files('db_subsets'))]){		# iterate through files with "NN" in the title
  data <- fread(paste('db_subsets/', file, sep = ""))				# read in data frame
  NN_db <- rbind(NN_db, data)					# bind to the previously compiled data frames
}

# remove temporary objects
rm(file, data)

# write the data frame of pairs of nouns to a text file for safe keeping
write.table(NN_db, "db_subsets/NN_db.txt", row.names = F, sep = '\t', quote = F)

# We next want to use the data base of consecutive nouns (NN_db) to create a data frame where each row is a unique lemma. We also want columns that give a lemma's frequency (raw count), total number of genres the lemma occurs in, and the total number of texts the lemma occurs in.

# create a data frame with two columns, "lemma" and "lemma_freq". Each row provides a unique pairing of noun lemmas and the nuber of times it occurs in the corpus.
NN_lemma_stats <- as.data.frame(table(NN_db$lemma))
names(NN_lemma_stats) <- c("lemma", "lemma_freq")


# We then use this table of unique NN lemmas and their frequencies to create a frequency balanced sample of NN compounds
# To ensure that the compounds analyzed are arguably lexicalized, in the analysis for the dissertation I excluded NN lemmas that occur less than 20 times. But with the smaller subsample of the corpus used here, this would reduce the number of NN lemmas to only 50. For the purposes of this portfolio, only NN lemmas that occur less than 8 times will be removed and we will only grab 50 NN lemmas from each quartile

NN_lemma_stats <- subset(NN_lemma_stats, lemma_freq >= 8)


# create a directory for saving NN_lemma_stats and other data that is useful for subsequent analysis (functions in 'analysis_functions.R' rely on this data, albeit in R object form)
dir.create(paste(getwd(), '/sample', sep = ''))

# write NN_lemma_stats to text file for safe keeping
write.table(NN_lemma_stats, 'sample/NN_lemma_stats.txt', row.names = F, quote = F, sep = '\t')

floor <- 8								# this is the starting point for the floor which determines the lowest frequency from which noun pairings will be drawn for a given quartile
NN_lemma_sample <- data.frame()                          				# create an empty data frame that will be our sample of NN lemmas
for (quartile in quantile(NN_lemma_stats$lemma_freq, c(.25, .5, .75, 1), names = F)){        	# iterate through the four quartiles of NN_lemma_stats$lemma_freq
  ceiling <- quartile
  temp_subset <- subset(NN_lemma_stats, lemma_freq >= floor & lemma_freq < ceiling)	# create subset based on quartile values
  temp_sample <- temp_subset[sample(1:nrow(temp_subset), 50),]			# take a random sample of 50 rows from the subset
  NN_lemma_sample <- rbind(NN_lemma_sample, temp_sample)			# concatenate the rows just drawn with the in progress NN_lemma_sample
  floor <- quartile
}

# write NN_lemma_sample to a text file for safe keeping
write.table(NN_lemma_sample, 'sample/NN_lemma_sample.txt', row.names = F, quote = F, sep = '\t')

rm(temp_subset, temp_sample, ceiling, floor, quartile)
