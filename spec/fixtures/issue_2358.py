# See the console after running this

import requests

head = {'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/65.0.3325.181 Chrome/65.0.3325.181 Safari/537.36'}

r = requests.get('https://www.oxfordlearnersdictionaries.com/us/wordlists/oxford3000-5000', headers=head)

print(r.text)
