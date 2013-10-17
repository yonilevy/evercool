import json
import requests

BASE_YQL_URL = "http://query.yahooapis.com/v1/public/yql"


def run_yql(q):
    params = {'q': q, 'format': 'json'}
    response = requests.get(BASE_YQL_URL, params=params)
    data = json.loads(response.content)
    return data


def get_woeid(lat, lon):
    q = 'select place.woeid from flickr.places where lat=%s and lon=%s and api_key="344059df5f5ca82843acb56de75cd9e9"' \
            % (lat, lon)
    data = run_yql(q)
    return data['query']['results']['places']['place']['woeid']


def get_weather(lat, lon):
    woeid = get_woeid(lat, lon)
    q = "select * from weather.forecast where woeid=%s and u='c'" % woeid
    data = run_yql(q)
    return data['query']['results']['channel']['item']['condition']['temp']
