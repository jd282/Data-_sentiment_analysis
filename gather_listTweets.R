library(twitteR)
library(xlsx)

### Takes a hashtag or search term and outputs the search results on Twitter into an csv file 

#twitter authorization (from my twitter account when I create an application in apps.twitter.com)
api_key = "ahlcqH8WtwV2DtEcZiEvvrHfX"
api_secret = "nk7dP1L1PuenXmIK0YjY2tFoBu5MdHus2xypr9uefJ8ZBFjbI3"
access_token = "746420255426129924-16KXlZgdbQqRTs0snJZko3ckBwGtnSv"
access_token_secret = "cZOlWLvvwfjUgQiOdKbvhO6qkwflAkdMDS1tezo2XmxHn"
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)

#gather search results for hashtag/term
#can change n to whatever number of search results you want returned 
get_tweets = function(q){
  tweets = searchTwitter(q, n=10, lang='en') 
  Tweets.text = lapply(tweets,function(t)t$getText())
  Tweets.id = lapply(tweets, function(t)t$getId())
  Tweets.text = sapply(Tweets.text, function(row) iconv(row, "latin1", "ASCII", sub="")) #gets rid of emojis (temp)
  Tweets.retweet = lapply(tweets, function(t)t$getRetweetCount())
  Tweets.user = lapply(tweets, function(t)t$getScreenName())
  
  clean_text = function(some_txt){
    some_txt = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", some_txt)
    some_txt = gsub("@\\w+", "", some_txt)
    some_txt = gsub("[[:punct:]]", "", some_txt)
    sentence = gsub('[[:cntrl:]]', '', some_txt)
    #some_txt = gsub("[[:digit:]]", "", some_txt)
    some_txt = gsub("http\\w+", "", some_txt)
    some_txt = gsub("[\t]{2,}", "", some_txt)
    some_txt = gsub("^\\s+|\\s+$", "", some_txt)
    
    # define "tolower error handling" function
    try.tolower = function(x)
    {
      y = NA
      try_error = tryCatch(tolower(x), error=function(e) e)
      if (!inherits(try_error, "error"))
        y = tolower(x)
      return(y)
    }
    
    some_txt = sapply(some_txt, try.tolower)
    some_txt = some_txt[some_txt != ""]
    names(some_txt) = NULL
    return(some_txt)
  }
  
  #create table with each row as a tweet 
  df_tweets = data.frame(
    Query = list(rep(q, length(Tweets.text))),
    Tweet = sapply(Tweets.text, clean_text),
    Retweets = sapply(tweets, function(t)t$getRetweetCount())
  )
  colnames(df_tweets) <- c("Query", "Tweet", "Retweets")
  return(df_tweets)
  
}

#input txt file containing list of search terms 
searchTerms = readLines("/Users/jenniferdu/Documents/Duke/DataPlus2016/SentimentAnalysis/shampoos.txt")

#initialize a data from that will contain the tweets from all the queries 
df.master = data.frame(
  Query = character(),
  Tweet= character(), 
  Retweets=character()
)
colnames(df.master) <- c("Query", "Tweet", "Retweets")


#test 
#df_iphone = get_tweets("iphone")
#df_mcgraw = get_tweets("tim mcgraw")
#df_hillary = get_tweets("hillary clinton")
#lst = list(df_iphone, df_mcgraw, df_hillary)
#df.merge = ldply(lst, data.frame)

#list of dataframes produced from get_tweeets for a list of queries 
dflist =list(length(searchTerms))

#append data frame from each query to dflist
for(i in 1:length(searchTerms)){
  query = searchTerms[i]
  df.t = get_tweet(query)
  colnames(df.t) <- c("Query", "Tweet", "Retweets")
  dflist[[i]] = df.t
}

#merge all the data frames together
df.master = ldply(dflist, data.frame)

#save tweets into excel file 
write.xlsx(df.master, "/Users/jenniferdu/Documents/Duke/DataPlus2016/SentimentAnalysis/tweets.xlsx")