library("twitteR")
library("httpuv")
library("RMySQL")
setwd("D:/G Drive/04 Career/Interview Prep/brand/Twitter")

#I've removed my personal token. Please replace the placeholders
#Access latest documentation on the Twitter API website to obtain access token
myapp<-setup_twitter_oauth("your_key","your_secret",access_token=NULL, access_secret=NULL)

#Query 1 - 89/96 tweets , 65 unique users from 89 tweets
tweets<-searchTwitter("@brand_name", n=1500, since='2011-01-01', resultType = 'mixed')
tweets<-searchTwitter("@brand_name", n=1500, since='2011-01-01')
brandtweets= twListToDF(tweets)
length(unique(brandtweets$screenName))

#Query 2 - 199 tweets, the function has a cap of 200 statuses, 158 unique users
fav<-favorites("brand_name", n = 900, max_id = NULL, since_id = NULL)
fav<-twListToDF(fav)
length(unique(fav$screenName))
length(unique(c(brandtweets$screenName,fav$screenName)))

#there maybe some common tweets between the different queries
intersect(fav$screenName, brandtweets$screenName)
common<-data.frame(intersect(fav$text, brandtweets$text))
common<-data.frame(intersect(fav, brandtweets))

brandtweets<-(unique(rbind(brandtweets,fav)))

#Query 3 - 216 tweets, these are all tweeted by brand_name. Ignored.
brand_timeline<-userTimeline("brand_name", n=2000, maxID=NULL, sinceID=NULL, includeRts=FALSE, 
             excludeReplies=FALSE)
time<-twListToDF(brand_timeline)

#homeTimeline retrieves tweets from the users home
#home<-homeTimeline(n=25, maxID=NULL, sinceID=NULL)
#home<-twListToDF(home)


## A much cleaner approach if the brand has adequate volume of tweets
# Here I'm using @lululemon

tweets<-searchTwitter("@lululemon", n=1500)
tweetsdf= twListToDF(tweets)
lulutweets=tweetsdf

write.csv(brandtweets, file="brandtweets.csv")

a_tweet=tweets[[1]]

#change data.frame as appropriate, when combining with an older data set.
write.csv(brandtweets, file="brandtweets.csv")

