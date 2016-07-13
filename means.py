import csv
from operator import truediv

#Also calculates the mean sentiment score and weighted mean (based on number of retweets)
#for each query and exports to csv file


def weight(retweets):
    #calcute the weights of the tweets based on number of retweets it has
    if retweets < 10:
        return 1
    elif retweets < 50:
        return 2
    elif retweets < 100:
        return 3
    elif retweets < 250:
        return 4
    elif retweets < 500:
        return 5
    else:
        return 6

csvf = "tweets_score.csv"
csvfile = open(csvf, 'rd')
rd = csv.reader(csvfile)

r_idx = None 
q_idx = None
s_idx = None
header = []
queries = set()
sums = []
counts = []
w_sums = []

rownum = 0
total = 0
w_total = 0 
count = 0
    
for row in rd:
    if rownum == 0:
        #get header information
        
        header = row
        r_idx = header.index("Retweets")
        q_idx = header.index("Query")
        s_idx = header.index("Score")
        
    else: 
        q = row[q_idx]
        r = row[r_idx]
        s = int(row[s_idx])
        if (q not in queries) and (len(queries) != 0):
            #if iteration reaches a new query add current total and count
            #to sums and counts lists, and then reset the total and count
            #for the next query

            sums.append(total)
            counts.append(count)
            w_sums.append(w_total) 
            total = 0
            count = 0
            w_total = 0 

        queries.add(q)
        w = weight(r)

        total += s
        w_total += (s * w) 
        count += 1
                
    rownum += 1
    
#add the value for the last query 
sums.append(total)
w_sums.append(w * s)
counts.append(count)

csvf = "sentiment_mean.csv"
csvfile = open(csvf, "wb")
wr = csv.writer(csvfile)
wr.writerow(["Number", "Query", "Mean", "Weighted"])

means = map(truediv, sums, counts)
w_means = map(truediv, w_sums, counts)
i = 0 
for q in queries:
    wr.writerow([i+1, q, means[i], w_means[i]])
    i += 1

csvfile.close()



                  
