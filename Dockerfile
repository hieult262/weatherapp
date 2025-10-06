FROM python:3.10.12-slim

RUN apt-get update && apt-get install -y libpq-dev gcc 

WORKDIR /app

COPY ./app/requirement.txt requirements.txt

RUN pip3 install -r requirements.txt

RUN useradd -u 1000 appuser

RUN chown -R appuser:appuser /app

EXPOSE 5000

USER 1000

COPY ./app/ /app/

ENTRYPOINT ["python3"]

CMD ["app.py"] 