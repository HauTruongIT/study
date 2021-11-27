FROM tomcat

WORKDIR /app

EXPOSE 8080

RUN apt-get update && apt-get install -y python3 python3-pip
RUN pip install fastapi uvicorn pymongo

COPY ./main.py ./main.py

CMD ["python3", "./main.py"]