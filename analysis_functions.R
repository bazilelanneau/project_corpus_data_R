# we can use NN_db_sample and custom functions to analyze the surrounding context of an aribtrary number of tokens for a given NN lemma

# context() takes a lemma and generates a random sample of sentential contexts that it occurs in.
# This is useful for determining if the noun pairing meets syntactic and semantic criteria for inclusion in the qualitative analysis

context <- function(lemma, num = 5){
  NN_db_sample$context[NN_db_sample$lemma == lemma][sample(1:NN_lemma_stats$lemma_freq[NN_lemma_stats$lemma == lemma], num)]
}


# Another useful function is collocate(), which takes a lemma and outputs an ordered table of the frequency with which different words precede or follow the compound. By default it gives the 10 most common words that precede the compound but both the number of collocates and whether it is the preceding or following collocates can be specified within collocate(). This function helps determine if the noun-noun pairing is better understood as part of a larger stock phrase.
collocate <- function(lemma, num = 10, loc = 'preceding'){
  lemma_IDs <- NN_db_sample$ID1[NN_db_sample$lemma == lemma]			# get the ID values for the modifiers of NN lemmas
  if (loc == 'preceding'){								# if the preceding collocate is specified, generate the IDs of words preceding instances of the lemma
    lemma_IDs <- lemma_IDs - 1
  }
  if (loc == 'following'){								# if the following collocate is specified, generate the IDs of words following instances of the lemma
    lemma_IDs <- lemma_IDs + 2
  }
  if (num > length(unique(db_context$word[db_context$ID %in% lemma_IDs]))){		# if the number of collocates specified is greater than the number of unique collocates, change num to the number of unique collocates
    num <- length(unique(db_context$word[db_context$ID %in% lemma_IDs]))
  }
  return(sort(table(db_context$word[db_context$ID %in% lemma_IDs]), decreasing = T)[1:num])	# return a sorted table of the most common collocates and the number of time they occur
}