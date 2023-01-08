"""
A sample Hello World server. With a reponame API call
"""
import os, requests

from flask import Flask, render_template

# pylint: disable=C0103
app = Flask(__name__)


@app.route('/')
def hello():
    """Return a friendly HTTP greeting."""
    return 'hey'

@app.route('/api', methods = ['GET'])
def return_data():
    input_repo = str(request.args(['reponame']))
    # Api call
    
    # Data format
    return output

def getRepos(username):
  page = 1
  url = f'https://api.github.com/users/{username}/repos?type=all&per_page=10&page={page}'
  r = requests.get(url)
  r.raise_for_status()
  data = r.json()

  repos = [repoObject['name'] for repoObject in data]
  while len(data) > 0:
    page += 1
    url = f'https://api.github.com/users/{username}/repos?type=all&per_page=10&page={page}'
    r = requests.get(url)
    r.raise_for_status()
    data = r.json()
    repos += [repoObject['name'] for repoObject in data]

  return repos

if __name__ == '__main__':
    server_port = os.environ.get('PORT', '8080')
    app.run(debug=False, port=server_port, host='0.0.0.0')
