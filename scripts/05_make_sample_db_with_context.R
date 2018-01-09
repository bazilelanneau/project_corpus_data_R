# For qualitative analysis and exclusion procedures it is useful to have a data frame where each row represents a unique token of a noun-noun lemma found in NN_lemma_sample. Here we will create such a data frame and call it NN_db_sample. We will also write it as a txt file as 'sample/NN_db_sample.txt'.
# In this data frame we will also include a column, "context" which provides the compound within the context of the three preceding and following words.
# In the process we will also create a data frame called db_context, which has two columns: 'ID' and 'word'. Each row is a word from COCA. The data frame includes only words that are one of the three words preceding or following a noun-noun pairing in the sample.

library("data.table")
library("dplyr")

# create a subset of the data frame of all consecutive nouns which includes only those whose lemma form is in the sample of 200 NN lemmas
NN_db_sample <- NN_db[NN_db$lemma %in% NN_lemma_sample$lemma,]

# collect the ID numbers of the first noun for each noun-noun pairing
compoundIDs <- NN_db$ID1[NN_db$lemma %in% NN_db_sample$lemma]

# create a vector of all the IDs of the three words that precede and follow the compounds
contextIDs <- c(compoundIDs-3, compoundIDs-2, compoundIDs-1, compoundIDs+2, compoundIDs+3, compoundIDs+4)

# We use these IDs to create subsets of the original COCA data base (db_full) that includes only the IDs for the words surrounding potential compounds
# To do this we subset the previously created set of subsets of db_full (titled "datasub[#].txt")
k <- 1
for (file in list.files("db_subsets")[grep("datasub[0-9]\\.txt", list.files("db_subsets"))]){				# iterate through files with titles of form "datasub[#].txt"
  db_sub <- fread(paste("db_subsets/", file, sep = ''))							# bring in a subset of db_full
  db_sub <- db_sub[db_sub$ID %in% contextIDs,]								# subset that subset to only the rows corresponding to IDs of words surrounding a potential NN compound
  write.table(db_sub, paste('db_subsets/context_db_sub', k, '.txt', sep = ''), row.names = F, quote = F, sep = '\t')		# write this subset to a file of form "context_db_sub[#].txt"
  k <- k + 1
}
rm(file, k, db_sub)

# combine the subsets which contain surrounding context words for consecutive nouns and call it db_context
db_context <- data.frame()
for (file in list.files("db_subsets")[grep("context_db_sub", list.files("db_subsets"))]){
  context_temp <- fread(paste("db_subsets/", file, sep = ''))
  db_context <- rbind(db_context, context_temp)
}
rm(file, context_temp)

# use dplyr::left_join to obtain the actual words that these context IDs correspond to
db_context <- left_join(db_context, lexicon, by = 'wordID')

# include only the columns "word" and "ID"
db_context <- db_context[,c('ID', 'word')]

write.table(db_context, 'sample/db_context.txt', row.names = F, quote = F, sep = '\t')	# write db_context to a text file for safe keeping

# now we write a function, get.context(), that takes an ID1 value from NN_db_sample and generates a string concatenating the 3 preceding words, the compound, and the following 3 words
# we are using the row number from NN_db because this function will be passed to vapply() to generate the new "context" column in NN_db_sample
get.context <- function(x){
  paste(db_context$word[db_context$ID == x - 3], db_context$word[db_context$ID == x - 2], db_context$word[db_context$ID == x - 1], NN_db_sample$compound[NN_db_sample$ID1 == x], db_context$word[db_context$ID == x + 2], db_context$word[db_context$ID == x + 3], db_context$word[db_context$ID == x + 4])
}

# create column in NN_sample for the sentential context
NN_db_sample$context <- vapply(NN_db_sample$ID1, get.context, '')

# save NN_db_sample as a text file for safe keeping
write.table(NN_db_sample, 'sample/NN_db_sample.txt', row.names = F, quote = F, sep = '\t')

# remove objects and functions that are not needed for further analysis
rm(contextIDs, compoundIDs, get.context)