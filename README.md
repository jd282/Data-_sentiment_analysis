# Data-_sentiment_analysis

Doing sentiment analysis on twitter search results 

gather_tweets.R  - create excel file of tweets for a single seach term
gather_listTweets.R - given txt file of twitter search queries, export n number of tweets for each query 

sentiment_analysis_indicoio.py - give it list of tweets in csv file and outputs csv file with tweets and sentiment score from Indico

means.py - given csv file of tweets and their sentiment score, output csv file that contains mean score and weighted mean score (based on retweets) for each query

limitByRetweets.py - give it csv file of tweets/info and number for minumum number of retweets, output csv file that outputs just the tweets that meet the minumum retweet number. 

sentiment_analysis_naive.R - calculates sentiment score by adding 1 for a positive word occurance and subtracting 1 for a negative word occurance 
