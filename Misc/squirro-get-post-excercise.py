import requests

API_URL = 'https://jsonplaceholder.typicode.com/posts' #post requests

r = requests.get(API_URL)

json = r.json()

print(len(json))
print(json[0].keys())