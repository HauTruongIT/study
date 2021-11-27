from typing import Optional

from bson.py3compat import iteritems

from fastapi import FastAPI
from pymongo import MongoClient
import uvicorn

# Config
app = FastAPI()

client = MongoClient(host="app-db", port=27017, username='root', password='example')
db = client['app']
items = db['items']

# Route
@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def read_item(item_id: int):
    items.insert_one({"item": item_id})
    for item in items.find():
        print(item)
    return item_id

if __name__ == '__main__':
    uvicorn.run(app, port=8080, host="0.0.0.0")
