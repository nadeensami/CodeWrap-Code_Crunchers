"""
A sample Hello World server. With a reponame API call
"""
import os
import requests
import ast
from flask import Flask, render_template

def determine_time_of_day(commits):
    morning_commits = 0
    evening_commits = 0
    for commit in commits:
        day, hour, num_commits = commit
        if hour >= 5 and hour < 17:
            morning_commits += num_commits
        else:
            evening_commits += num_commits

    morning_percentage = morning_commits / (morning_commits + evening_commits)
    evening_percentage = evening_commits / (morning_commits + evening_commits)

    if morning_percentage > evening_percentage:
        return "morning"
    else:
        return "evening"

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
    print(repos)
    return repos

# Set the request headers
headers = {
    "Accept": "application/vnd.github+json",
    "Authorization": "Bearer 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"
}

# pylint: disable=C0103
app = Flask(__name__)


@app.route('/')
def hello():
    """Return a friendly HTTP greeting."""
    return 'hey'

@app.route('/api/<owner>')
def api(owner):
    # Api call
    print(owner)
    repos = getRepos(owner)
    # Set the URL for the request
    total_repo_commits = []
    for repo in repos:
        url_stats = "https://api.github.com/repos/{}/{}/stats/punch_card".format(owner, repo)
        # Make the request
        response = requests.get(url_stats, headers=headers)
        print(response.content)
        byte_array_str = response.content.decode()
        # Use ast.literal_eval to parse the string and return the corresponding value
        normal_list = ast.literal_eval(byte_array_str)
        if isinstance(normal_list, list):
            for commits_list in normal_list:
                total_repo_commits.append(commits_list)
    
    time_of_day = determine_time_of_day(total_repo_commits)
    # Function to determine if someone is a night owl or early bird

    # Data format
    
    return time_of_day

if __name__ == '__main__':
    server_port = os.environ.get('PORT', '8080')
    app.run(debug=False, port=server_port, host='0.0.0.0')