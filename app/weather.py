import requests, os

API_KEY = os.getenv("API_KEY")
BASE_URL = os.getenv("BASE_URL")

def get_weather(city):
    params= {"key": API_KEY, "q": city, "lang": "en"}
    r = requests.get(BASE_URL, params=params)
    if r.status_code == 200:
        data = r.json()
        return {
            "city": data["location"]["name"],
            "country": data["location"]["country"],
            "temp": data["current"]["temp_c"],
            "desc": data["current"]["condition"]["text"],
            "icon": data["current"]["condition"]["icon"]
        }
    return {"city": city, "error": "Can not get data"}
