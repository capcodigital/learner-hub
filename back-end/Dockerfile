FROM python:3

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY pull_clean.py .

COPY .env .

COPY data_api.py .

CMD ["uvicorn", "data_api:app", "--host", "0.0.0.0", "--port", "80"]