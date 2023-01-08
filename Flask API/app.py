"""
A sample Hello World server. With a reponame API call
"""
import os, base64, requests, re, ast

from flask import Flask, render_template
# import openai

def determine_time_of_day(commits):
    morning_commits = 0
    evening_commits = 0
    for commit in commits:
        day, hour, num_commits = commit
        if hour >= 5 and hour < 17:
            morning_commits += num_commits
        else:
            evening_commits += num_commits
    try:
        morning_percentage = morning_commits / (morning_commits + evening_commits)
        evening_percentage = evening_commits / (morning_commits + evening_commits)
    except:
        morning_percentage = 1

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

def generate_poem():
    openai.api_key = os.getenv("OPENAI_API_KEY")
    return poem


# num for loops --> regex
def getNumFor(fileString):
  return len(re.findall("\bfor\b", fileString))

# variable names --> python library for extracting variables
def getVariableNames(fileString):
  root = ast.parse(fileString)
  for node in ast.walk(root):
    if isinstance(node, ast.Name):
      if node.id in variableDict:
        variableDict[node.id] += 1
      else:
        variableDict[node.id] = 1

def classifyVariables():
  for variable in variableDict.keys():
    if '_' in variable:
      varTypeCounts['snakeCase'] += variableDict[variableDict]
    elif '-' in variable:
      varTypeCounts['kebabCase'] += variableDict[variableDict]
    elif variable.islower():
      varTypeCounts['flatCase'] += variableDict[variableDict]
    else:
      varTypeCounts['camelCase'] += variableDict[variableDict]

# indentation depth --> for a file, determine if using tab or space indentations, and
#   find longest substring of indentation characters
def getDeepestIndent(fileString):
  words = re.split("\n|\r", fileString)
  deepestIndent = 0
  for word in words:
      gap = re.findall("^[\t ]+", word)
      for item in gap:
          newlist = re.findall("\t| ", item)
          numTabs = 0
          numSpaces = 0
          for i in newlist:
              if i == " ":
                  numSpaces+=1
              elif i == "\t":
                  numTabs+=1
          newLen = numSpaces + (numTabs * 4)
          if newLen>deepestIndent:
              deepestIndent = newLen
  return deepestIndent

# percentage of comments / numlines: ''', #, """ inline, line, block
def getNumComments(fileString):
    return len(re.findall("#.*?[\n|\r]", fileString))

def readFile(fullName, filePath):
  url = f'https://api.github.com/repos/{fullName}/contents/{filePath}'
  r = requests.get(url)
  r.raise_for_status()
  data = r.json()
  file_content = data['content']
  file_content_encoding = data.get('encoding')
  if file_content_encoding == 'base64':
      file_content = base64.b64decode(file_content).decode()

  return file_content

def getRepos(username):
  page = 1
  url = f'https://api.github.com/users/{username}/repos?type=all&per_page=10&page={page}'
  r = requests.get(url)
  r.raise_for_status()
  data = r.json()

  repos = data
  while len(data) > 0:
    page += 1
    url = f'https://api.github.com/users/{username}/repos?type=all&per_page=10&page={page}'
    r = requests.get(url)
    r.raise_for_status()
    data = r.json()
    repos += data

  return repos

def parseFiles(repoObject):
  dirQueue = ['']

  while len(dirQueue) > 0:
    currDir = dirQueue.pop(0)

    url = f'https://api.github.com/repos/{repoObject["full_name"]}/contents/{currDir}'
    r = requests.get(url)
    r.raise_for_status()
    data = r.json()

    for file in data:
      if file['type'] == 'dir':
        dirQueue.append(file['path'])
      elif file['name'][-3:] == '.py':
        # Get file string
        fileString = readFile(repoObject["full_name"], file['path'])

        # Get number of for loops
        numForLoops += getNumFor(fileString)

        # Get variable names
        getVariableNames(fileString)

        # Get indentation depth
        maxIndent = getDeepestIndent(fileString)
        if maxIndent > maxIndentDepth:
          maxIndentDepth = maxIndent
        
        # Get number of lines of code
        numLines += len(fileString.splitlines())

        # Get number of lines of comments
        numComments += getNumComments(fileString)

# Set the request headers
headers = {
    "Accept": "application/vnd.github+json",
    "Authorization": "Bearer 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"
}

# pylint: disable=C0103
app = Flask(__name__)

# Create global metrics
numLines = 0
numComments = 0
variableDict = {}
numForLoops = 0
maxIndentDepth = 0
varTypeCounts = {'flatCase':0, 'camelCase': 0, 'snakeCase': 0, 'kebabCase': 0}

@app.route('/')
def hello():
    """Return a friendly HTTP greeting."""
    return 'hey'

@app.route('/api/<owner>')
def api(owner):
    # Api call
    print(owner)
    repos = getRepos(owner)
    for repo in repos:
        parseFiles(owner, repo)

    # Tokenize the variable
    classifyVariables()

    # Get maximum words used and send to chat GPT
    mostCommonVars = sorted(variableDict, variableDict.get)[-6:]

    # Set the URL for the request
    total_repo_commits = []
    for repo in repos:
        url_stats = "https://api.github.com/repos/{}/{}/stats/punch_card".format(owner, repo)
        # Make the request
        response = requests.get(url_stats, headers=headers)
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