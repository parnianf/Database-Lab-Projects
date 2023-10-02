import pymongo
import requests

# Connect to MongoDB server
client = pymongo.MongoClient("mongodb://localhost:27017/")
db = client["WHO"]

# Fetch data from WHO API
url = "https://covid19.who.int/WHO-COVID-19-global-data.csv"
response = requests.get(url)

# Insert data into MongoDB collection
collection = db["covid19_data"]
collection.drop()  # clear collection before inserting new data
data = response.text.splitlines()
headers = data[0].split(",")
for row in data[1:]:
    values = row.split(",")
    document = {}
    for i in range(len(headers)):
        document[headers[i]] = values[i]
    collection.insert_one(document)

print("Data fetched and inserted into MongoDB successfully.")
