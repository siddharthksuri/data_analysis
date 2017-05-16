setwd("D:/G Drive/04 Career/Interview Prep/THINX/Twitter")
tweets=read.csv("tweets_scored.csv")
library(dplyr)
thinx= filter(tweets, company=="thinx")
lulu= filter(tweets, company=="lulu")

#consider removing tweets by the actual company, not relevant for this data set.


#word cloud analysis
library(tm)
library(SnowballC)
library(wordcloud)

#### Building a word cloud for THINX
#building corpus
thinxCorpus <- Corpus(VectorSource(iconv(thinx$text, to = "utf-8")))

#Converting to plain text document, 
#the second argument is a function from package tm
thinxCorpus <- tm_map(thinxCorpus, PlainTextDocument)
thinxCorpus <- tm_map(thinxCorpus, removePunctuation) #removing punctuations
thinxCorpus <- tm_map(thinxCorpus, removeWords, stopwords('english'))
thinxCorpus <- tm_map(thinxCorpus, stemDocument) #stemming, condensing to the shortest form

#Must redo the VectorSource for datatype compatibility
thinxCorpus<- Corpus(VectorSource(thinxCorpus))
thinx_counts<-as.matrix(TermDocumentMatrix(thinxCorpus))
thinx_counts<-sort(rowSums(thinx_counts), decreasing=TRUE)
wc_thinx<-data.frame(names(thinx_counts))
wc_thinx$freq<-thinx_counts
wc_thinx_l<-wc_thinx
wc_thinx_l$freq<-log(thinx_counts)
#wordcloud
library(wordcloud2)
wordcloud2(wc_thinx_l, gridSize = 50, fontFamily = "roboto", color= ifelse(wc_thinx_l[, 2] > 4, 'blue', 'lightblue'))
wordcloud2(wc_thinx_l, gridSize = 50, fontFamily = "roboto", color= "random-light")

#####rinserepeat for lulu
luluCorpus <- Corpus(VectorSource(iconv(lulu$text, to = "utf-8")))

#Converting to plain text document, 
#the second argument is a function from package tm
luluCorpus <- tm_map(luluCorpus, PlainTextDocument)
luluCorpus <- tm_map(luluCorpus, removePunctuation) #removing punctuations
luluCorpus <- tm_map(luluCorpus, removeWords, stopwords('english'))
luluCorpus <- tm_map(luluCorpus, stemDocument) #stemming, condensing to the shortest form

#Must redo the VectorSource for datatype compatibility
luluCorpus<- Corpus(VectorSource(luluCorpus))
lulu_counts<-as.matrix(TermDocumentMatrix(luluCorpus))
lulu_counts<-sort(rowSums(lulu_counts), decreasing=TRUE)
wc_lulu<-data.frame(names(lulu_counts))
wc_lulu$freq<-lulu_counts
wc_lulu_l<-wc_lulu
wc_lulu_l$freq<-log(lulu_counts)
#wordcloud
wordcloud2(wc_lulu, gridSize = 50, fontFamily = "roboto", color= "random-light")
wordcloud2(wc_lulu_l, gridSize = 50, fontFamily = "roboto", color= "random-light")
