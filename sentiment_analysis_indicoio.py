import csv
import indicoio

#given csv file of tweets will calculate the sentiment score (from indico) for each

indicoio.config.api_key = "c055aa319b32e209e7862c21f9216377"

data = []


#iterate through rows of csv file and calculate the sentiment score of each cell
csvf = input("Enter a csv file to parse: ")
with open(csvf, 'rb') as csvfile:
    rd = csv.reader(csvfile)
    rownum = 0
    for row in rd:
        if rownum != 0:
            colnum = 0
            for col in row:
                if (colnum != 0) and (col != ""):
                    score = indicoio.sentiment(col)
                    data.append([rownum, col, score])
                colnum += 1
        rownum += 1          
csvfile.close()


#write the score of the tweet into the same csv file
csvfile = open(csvf, 'wb')
wr = csv.writer(csvfile)
wr.writerow(["Tweet", "Sentiment Score"])
for item in data:
    wr.writerow(item)




