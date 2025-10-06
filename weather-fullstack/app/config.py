import os 
from urllib.parse import quote_plus
from dotenv import load_dotenv

load_dotenv()

class config:
    dbUser = os.getenv('POSTGRES_USER')
    dbPass = os.getenv('POSTGRES_PASSWORD')
    dbHost = os.getenv('dbHost')
    dbPort = os.getenv('dbPort')
    dbName = os.getenv('dbName')


    SQLALCHEMY_DATABASE_URI = (f"postgresql://{dbUser}:{quote_plus(dbPass)}@{dbHost}:{dbPort}/{dbName}?sslmode=disable")
    SQLALCHEMY_TRACK_MODIFICATIONS = False