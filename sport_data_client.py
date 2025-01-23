import sys
import json
import requests


setting = json.loads(sys.stdin.read())
headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
}

data = {
    'membername': setting['username'],
    'password': setting['password'],
}
login_api_response = requests.post(setting['login_api_url'], headers=headers, json=data)
res_json = login_api_response.json()
access_token = res_json['data']['token']

headers['Authorization'] = f'Bearer {access_token}'
req_data_url = '{}?main_type={}&type={}&data_size={}'.format(
    setting['data_api_url'],
    setting['main_type'],
    setting['type'],
    setting['data_size']
)
retrieve_sport_response = requests.get(req_data_url, headers=headers, json=data)

print(json.dumps(retrieve_sport_response.json()))
