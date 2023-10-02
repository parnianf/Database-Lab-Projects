from elasticsearch import Elasticsearch
es = Elasticsearch("http://localhost:9200")

first_car = {
      "model": "saipa",
      "name": "tiba",
      "year": 1402,
      "mileage": 5000,
      "city": "Tehran",
      "price": 500000000}

es.index(index='cars', document=first_car)
