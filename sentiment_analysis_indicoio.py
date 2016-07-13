import csv
import indicoio
from operator import truediv

#given csv file of tweets will iterate through row and calculate the sentiment score
#(from indico) for each and export to new csv file

#can create a free indico account that will give me 10,0000 free requests 
#indicoio.config.api_key = "c055aa319b32e209e7862c21f9216377"    

#iterate through rows of csv file and calculate the sentiment score of each cell
#csvf = input("Enter a csv file to parse: ")
csvf = "tweets.csv"

#information to write into the new csv file 
data = []

#information to gather from input csv file including column number that tweets,
#retweets and query are in 
header = []
t_idx = None 
q_idx = None
queries = set()

with open(csvf, 'rb') as csvfile:
    rd = csv.reader(csvfile)
    rownum = 0
    tweets = []
    
    for row in rd:
        if rownum == 0:
            #get header information
            
            header = row
            t_idx = header.index("Tweet")
            q_idx = header.index("Query")
            
        else: 
            q = row[q_idx]
            t = row[t_idx]
            if (q not in queries) and (len(queries) != 0):
                #reset when new query reached
                tweets = []

            #do not include repeats                 
            if t in tweets:
                continue
            
            tweets.append(t)
            queries.add(q)
            #calculate the score using indicoio API, 
            score = 1
            #score = indicoio.sentiment(t)
            newrow = row
            newrow.append(score)
            data.append(newrow)

        rownum += 1
        
csvfile.close()

#write original info and sentiment score into new csv file 
csvf = 'tweets_score.csv'
csvfile = open(csvf, 'wb')
wr = csv.writer(csvfile)
header.append("Sentiment Score")
wr.writerow(header)
for item in data:
    wr.writerow(item)

csvfile.close()
