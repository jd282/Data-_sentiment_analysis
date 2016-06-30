library(twitteR)
library(plyr)
library(stringr)

#twitter authorization (from my twitter account when I create an application in apps.twitter.com)
api_key = "ahlcqH8WtwV2DtEcZiEvvrHfX"
api_secret = "nk7dP1L1PuenXmIK0YjY2tFoBu5MdHus2xypr9uefJ8ZBFjbI3"
access_token = "746420255426129924-16KXlZgdbQqRTs0snJZko3ckBwGtnSv"
access_token_secret = "cZOlWLvvwfjUgQiOdKbvhO6qkwflAkdMDS1tezo2XmxHn"
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)

#code adapated from http://thinktostart.com/sentiment-analysis-on-twitter/
#Positive and Negative words cited from: 
# ;   Minqing Hu and Bing Liu. "Mining and Summarizing Customer Reviews." 
# ;       Proceedings of the ACM SIGKDD International Conference on Knowledge 
# ;       Discovery and Data Mining (KDD-2004), Aug 22-25, 2004, Seattle, 
# ;       Washington, USA, 

#enter hashtag or keyword 
tweets = searchTwitter("Sassy Mitchell", n=200, lang='en') 
Tweets.text = lapply(tweets,function(t)t$getText())
Tweets.text = sapply(Tweets.text, function(row) iconv(row, "latin1", "ASCII", sub="")) #gets rid of emojis (temp)

#change below to wherever you saved positive-words.txt and negative-words.txt to locally 
pos = scan('/Users/jenniferdu/Documents/Duke/DataPlus2016/positive-words.txt', what='character', comment.char=';')
neg = scan('/Users/jenniferdu/Documents/Duke/DataPlus2016/negative-words.txt', what='character', comment.char=';')

score.sentiment = function(sentences, pos.words, neg.words){
  scores = lapply(sentences, function(sentence, pos.words, neg.words) {
    
    # clean up sentences, remove puncutation 
    sentence = gsub('[[:punct:]]', '', sentence)
    sentence = gsub('[[:cntrl:]]', '', sentence)
    sentence = gsub('\\d+', '', sentence)

    sentence = tolower(sentence)
    # split into words. str_split is in the stringr package
    word.list = str_split(sentence, '\\s+')
    # sometimes a list() is one level of hierarchy too much
    words = unlist(word.list)
    
    # compare our words to the dictionaries of positive & negative terms
    # match() returns the position of the matched term or NA
    pos.matches = match(words, pos.words)
    neg.matches = match(words, neg.words)
    
    #turns to TRUE/FALSE
    pos.matches = !is.na(pos.matches)
    neg.matches = !is.na(neg.matches)
    
    #TRUE/FALSE will be treated as 1/0 by sum():
    #super simple way to calculate score: needs improvement 
    score = sum(pos.matches) - sum(neg.matches) #score is # positive words - # negative words
    return(score)
  }, pos.words, neg.words)
  
  #puts tweets and its sentiment score into table
  df = data.frame(
    text = sentences 
  )
  df$score = scores 
  return(df)
}

analysis = score.sentiment(Tweets.text, pos, neg)

mean(as.numeric(analysis$score))
