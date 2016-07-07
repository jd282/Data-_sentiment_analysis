import csv

#given csv file of tweets & their info and an integer, will create a new csv file
#containing only the tweets with number of retweets greater than or equal to
#the integer given. 


#finds which column which row the retweets are in from the csv file
def findRetweet(row):
    for i in range(len(row)):
        if row[i] == "Retweets":
            return i
    return None 

csvf = input("Enter csv file to parse: ")
minRetweets = input("Enter a minumum number of retweets a tweet must have: ")
t = []

with open(csvf, 'rb') as csvfile:
    rd = csv.reader(csvfile)
    rowNum = 0

    #only add the tweets that satify a minumum retweet requirement 
    for row in rd:
        if rowNum == 0:
            header = row
            retweetRow = findRetweet(header)
        else:
            if int(row[retweetRow]) > int(minRetweets):
                t.append(row)
        rowNum += 1

csvfile.close()

csvf = 'tweets_cut.csv'
csvfile = open(csvf, 'wb')
wr = csv.writer(csvfile)
wr.writerow(header)
for item in t:
    wr.writerow(item)
    
csvfile.close()
