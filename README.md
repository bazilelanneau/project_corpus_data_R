USING R TO CREATE A FREQUENCY BALANCED RANDOM SAMPLE OF NOUN-NOUN PAIRINGS  
Author: Bazile Lanneau  
Date: January 2018

PURPOSE OF THE PROJECT  
This project contains R scripts used to create a frequency balanced sample of noun-noun pairings (instances from a corpus of two nouns occurring sequentially). A similar sample was constructed for the purpose of qualitative semantic analysis as part of my dissertation, "Schema-guided comprehension of noun-noun compounds: An experimental and corpus-based approach" (see Ch. 4 of Lanneau_dissertation_FINAL_20171016.pdf). For the dissertation, a random sample of 1000 noun-noun pairings was constructed.
 Exclusion principles were then followed to ensure that all noun-noun pairings could justifiably be considered compounds (and not just two nouns that incidentally occur sequentially). The scripts in this repository only deal with creating the sample of noun-noun pairings, and does not include steps for narrowing that down to compounds. Doing so requires case by case consideration by a trained linguist. However, the file 'analysis_functions.R' provides code for functions that were useful for interacting with data objects throughout the exclusion processes.


DIFFERENCES FROM THE DISSERTATION  
Owing to time and storage considerations, the scripts in this version work from a smaller subset of corpus data. The samples constructed are accordingly smaller than the sample created for analysis in the dissertation (200 rather than 1000 noun-noun pairings).



HOW TO USE THIS REPOSITORY  
One can browse the scripts found in the scripts directory and/or run these scripts to see them in action. The first script downloads the necessary corpus data, which totals 251 MB. After the download, running the scripts can take up to a few minutes and produces 73 more MB of data.



INPUT DATA  
The first script downloads three tables that are used by the subsequent scripts, placing them in a directory called 'data'. These tables are db_full.txt, lexicon.txt, and sources.txt.

db_full.txt: contains three columns, 'textID', 'ID', and 'wordID'. Each row represents the occurrence of a word (or punctuation mark) in the corpus. 'textID' identifies what unique text the word came from. 'ID' gives a unique number for each word and punctuation mark in the corpus. They are numbered sequentially so that a phrase of five words would correspond to five consecutive numbers. 'wordID' provides a number that corresponds to a unique case and inflection sensitive word ('Taco', 'taco', and 'tacos' would have distinct 'wordID' values). db_full represents the entire corpus (of course this is just a subsample of COCA. The original 'db_full.txt' was 16 GBs. I have kept the name 'db_full' to make it clear how this project illustration corresponds to the original work for the dissertation).


lexicon: this table serves as a key providing information linking wordID values to specific word forms, lemmas, and part of speech tagging. These columns are titled 'wordID', 'word', 'lemma', and 'PoS'. (for those without a linguistics background, 'lemma' refers to the lexical entry, ignoring case or morphological inflection. So 'Talk', 'talks', and 'talking' are all instances of the lemma 'talk' but would be listed with different word and wordID values because they are orthographically or grammatically distinct versions of 'talk').


sources: this table provides information about the sources identified by 'textID'. The first column is 'textID' and the other columns are 'word_count' (total number of words found in the text), 'year' (year the text was published), 'genre' (identifying whether the source was spoken, written, etc.), 'subgenre' (codes providing more specific genre information: is it news, or fiction, etc.), 'source' (who produced or published this text), 'title' (the title of the text), and 'publication_info' (optional information about volumes, chapters, or page numbers that more specifically identify where the text comes from).



OUTPUT DATA  
The scripts to create the random sample of noun pairings should be run in sequence. Doing so will result in a global environment with four data objects as well as tab delimited txt file versions of each in a folder called 'sample':

NN_lemma_stats: a data frame with two columns, 'lemma' and 'lemma_freq' which respectively provide all the unique noun-noun lemmas found in the corpus and their total number of occurrences. Here, each 'lemma' is a unique pairing of noun lemmas. So if 'horse face' and 'horse faces' each occur, they would both be counted as instances of the lemma "horse face". If no other forms of "horse face" exist in the corpus, then the 'lemma_freq' would be the sum of the number of occurences of each form (both 'horse face' and 'horse faces').


NN_lemma_sample: this is a subset of NN_lemma_stats featuring only rows corresponding to noun-noun lemmas that are included in the final sample


db_context: this data frame also contains just two columns, 'ID' and 'word'. Each row is a unique instance of a word in COCA. Specifically, it provides all the three words that precede and follow every instance of each noun-noun pairing found in the sample. 'ID' provides the unique number representing that token in the corpus. 'word' provides the specific form of the word or punctuation that the ID references. This data frame is used in constructing NN_db_sample (see below) and is used by functions for subsequent analysis of the sample.


NN_db_sample: in this data frame each row is a unique instance of a noun-noun lemma. The first column is titled 'compound' and contains the contatenated string of the two nouns in the forms they occur in in the corpus (respecting morphology and case). The next column is 'PoS', which provides a string concatenating the part of speech tagging for each respective noun (there is different tagging for different noun classes). Next 'lemma' provides the concatenation of the lemma form of each noun. There are additionally the columns 'genre', 'source', and 'textID' which provide the same information they did in the input data tables. Next, columns 'ID1' and 'ID2' provide the unique ID numbers for the first and second nouns of noun-noun pairings respectively. Finally, the column 'context' provides a string of the noun-noun pairing embedded within the context of the three preceding and the three following words.

The scripts also produce a variety of subsets which are placed in a folder called 'subsets'. Once the scripts have been run and the sample has been created, these subsets are no longer needed for analysis. I have designed the scripts to leave these files in place so that the intermediary steps can be more easily understood.





RUNNING THE SCRIPTS  
1. Check requirements: the packages needed to run these scripts are found in requirements.txt. To run the scripts you will also need 250 MB of free space.

2. Set working directory: set your current working directory in R to the directory in which this README file is located.

3. Run scripts: To run the scripts use 'sapply(list.files('scripts'), function(x) {source(paste('scripts/', x, sep = ''))})'


SKILLS DEMONSTRATED  
Throughout the scripts I use functional programming, regular expressions, various forms of subsetting, manipulation between data types (lists, matrices, and data frames), joins among data sets, as well as specific packages that help manage large data (this was especially important for the larger sample created for the dissertation).
