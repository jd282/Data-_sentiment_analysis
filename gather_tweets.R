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
query = readline(prompt="Enter Twitter query: ")
#can change n to whatever number of search results you want returned 
tweets = searchTwitter(query, n=200, lang='en') 
Tweets.text = lapply(tweets,function(t)t$getText())
Tweets.text = sapply(Tweets.text, function(row) iconv(row, "latin1", "ASCII", sub="")) #gets rid of emojis (temp)

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
  Tweet = sapply(Tweets.text, clean_text)
)

#save tweets into excel file 
write.xlsx(df_tweets, "/Users/jenniferdu/Documents/Duke/DataPlus2016/SentimentAnalysis/tweets.xlsx")