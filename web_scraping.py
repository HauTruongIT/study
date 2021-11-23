import requests
from bs4 import BeautifulSoup
from pymongo import MongoClient

url = "https://stackoverflow.com/questions"
client = MongoClient(host="localhost", port=27017)

# Config MongoDB
db = client.webscraping
questions = db.questions

# Handle Web Scraping
t = requests.get(url).text
soup = BeautifulSoup(t, features="html.parser")
data = []

trs = soup.find_all("div", class_="question-summary")
for i in range(len(trs)):
    try:
        question = {
            'title' : trs[i].find("h3").text,
            'votes' : trs[i].find("span", class_="vote-count-post").text,
            'answers' : trs[i].find("div", class_="status").strong.text,
            'views' : trs[i].find("div", class_="views").text.split(" ")[4],
            'times' : trs[i].find("span", class_="relativetime").text,
        }
        data.append(question)
    except:
        continue

questions.insert_many(data)
client.close()