# This script takes the subsets of nouns and spits out respective tables where each row represents an instance of a noun-noun pairing.


# For subsetting the tables of nouns, it is useful to have a function that we can pass through sapply() in order to obtain indeces of nouns that are part of a noun-noun pairing.
# consecutive() does this by checking whether the value of a particular column for a given row within a data frame is one more than the value for the previous row or one less than the following row. If either case is true the function returns True. Otherwise False.
consecutive <- function(vector, index){
  # if you are on the first index only check whether the value is one less than the value for the subsequent row (do not compare to the "previous row" since that does not exist)
  if (index == 1){
    ifelse(vector[index] == vector[index + 1] - 1, T, F)
  }
  # if on neither the first nor last index, compare to the value of the variable in question for both the previous row and the following row
  else if (index > 1 && index < length(vector)){
    ifelse(vector[index] == vector[index + 1] - 1 || vector[index] == vector[index - 1] + 1, T, F)
  }
  # if on the final index, compare the value of the variable in question to the previous row's value but not the subsequent (since it doesn't exist)
  else{
    ifelse(vector[index] == vector[index - 1] + 1, T, F)
  }
}

library(data.table)

# getNNcompounds() takes one of the previously generated subsets of the database that include only subsequent nouns and turns it into a data frame where each row represents a noun pairing. There is also a column called "compounds" which is a concatenation of the consecutive noun strings.
getNNcompounds <- function(file){
  temp_data <- fread(file)
  constituent_indeces <- sapply(1:length(temp_data$ID), function(x){consecutive(temp_data$ID,x)}) 					# get a logical vector that can be used to index only the rows that represent nouns that occur consecutively within the corpus
  temp_data <- temp_data[constituent_indeces,]										# subset to only rows that contain part of a consecutive noun sequence using the logical vector generated on the previous line
  NN_indeces <- which(sapply(1:(length(temp_data$ID)-1), function(x) {ifelse(temp_data$ID[x] == temp_data$ID[x + 1] - 1, T, F)}))	# get just the row indeces of the first noun of each noun pairing (the modifier noun if it is indeed a noun-noun compounds)
  temp_data_list <- sapply(NN_indeces, function(i){list(c(paste(temp_data[[i,'word']], temp_data[[(i + 1), 'word']]), paste(temp_data[[i,'PoS']], temp_data[[(i + 1), 'PoS']]), paste(temp_data[[i,'lemma']], temp_data[[(i + 1), 'lemma']]), temp_data[[i, 'genre']], temp_data[[i, 'source']], temp_data[[i, 'textID']], temp_data[[i,'ID']], temp_data[[(i + 1), 'ID']]))})		# create a list of vectors, each of which represents a row of new data (the concatenation of the noun on the a NN indexed row and the noun on the subsequent row, as well as the values of the other previously existing columns for that row)
  newdf <- as.data.frame(matrix(unlist(temp_data_list), nrow = length(temp_data_list), byrow = T))					# turn this list into a data frame
  colnames(newdf) <- c('compound', 'PoS', 'lemma', 'genre', 'source', 'textID', 'ID1', 'ID2')						# rename columns
  write.table(newdf, file = paste(gsub('noun', 'NN', file), sep = ""), row.names = F, sep = '\t', quote = F)				# output new text file whose name is the same as the input data except that "nouns" is replaced with "NN"
}

# apply this function to all subsets with the word "nouns" in the title
sapply(list.files('db_subsets')[grep("nouns", list.files('db_subsets'))], function(x) {getNNcompounds(paste('db_subsets/', x, sep = ""))})

# remove functions that are not necessary for further scripts or analysis
rm(getNNcompounds, consecutive)