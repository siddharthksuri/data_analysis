setwd("D:/G Drive/04 Career/Interview Prep/THINX/Twitter")

thinx= read.csv("thinxtweets.csv")
lulu= read.csv("lulutweets.csv")

#readymade dictionaries for scoring 
hlpos=scan("D:/G Drive/04 Career/Interview Prep/THINX/Twitter/dict/positive-words.txt" 
           , what='character', comment.char=';')
hlneg=scan("D:/G Drive/04 Career/Interview Prep/THINX/Twitter/dict/negative-words.txt" 
                 , what='character', comment.char=';')
# This is a custom function written by Jeffrey Breen
# score.sentiment(), must be loaded from a separate script

trial<-c("accolade I recieved","thrilled to be here","beautiful is the world",
         "dismayed Yoda was","angry I am","unhappy we all are")
score.sentiment(trial, hlpos, hlneg)

#scoring the actual tweets

thinx$sentiment = score.sentiment(thinx$text, hlpos, hlneg)$score
lulu$sentiment = score.sentiment(lulu$text, hlpos, hlneg)$score

#exploring the scores
range(thinx$sentiment)
range(lulu$sentiment)

hist(thinx$sentiment)
hist(lulu$sentiment)

mean(thinx$sentiment)
mean(lulu$sentiment)

# Using sentimentr package by Tler Rinker
# Returns a score for each sentence in string input.
library(sqldf)
library(sentimentr)

thinx_rscore<-sentiment(thinx$text, polarity_dt = lexicon::hash_sentiment_jockers,
          valence_shifters_dt = lexicon::hash_valence_shifters, hyphen = "",
          amplifier.weight = 0.8, n.before = 5, n.after = 2,
          question.weight = 1, adversative.weight = 0.85, missing_value = 0)

thinx_rscore<-sentiment(thinx$text)
lulu_rscore<-sentiment(lulu$text)

#aggregating the scores to tweet level.
thinx_rscore<-sqldf("select sum(sentiment) 
              from thinx_rscore              
              group by element_id
              ")

thinx<-cbind(thinx,thinx_rscore,"thinx")
colnames(thinx)[19:20]<-c("sentiment2","company")
#thinx$sentiment1<-NULL

lulu_rscore<-sqldf("select sum(sentiment) 
              from lulu_rscore              
              group by element_id
              ")
lulu<-cbind(lulu,lulu_rscore,"lulu")
colnames(lulu)[19:20]<-c("sentiment2","company")

#Some more stats just to see if anything odd shows up
cor(thinx$sentiment, thinx$sentiment1)
cor(lulu$sentiment, lulu$sentiment1)

range(thinx$sentiment1)
range(lulu$sentiment1)


hist(thinx$sentiment1$`sum(sentiment)`)
hist(lulu$sentiment1$`sum(sentiment)`)

mean(thinx$sentiment1$`sum(sentiment)`)
mean(lulu$sentiment1$`sum(sentiment)`)


### Output the file
write.csv(lulu,"lulu_scored.csv")
write.csv(thinx,"thinx_scored.csv")

tweet_scored<-rbind(thinx,lulu)

write.csv(tweet_scored,"tweets_scored.csv")