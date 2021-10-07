FROM python:3.8

COPY requirements.txt /requirements.txt

RUN apt-get update -y && apt-get install
RUN pip install -r requirements.txt

COPY calculator.db calculator.db
COPY app /app

CMD ["python3", "/app/main.py"]
