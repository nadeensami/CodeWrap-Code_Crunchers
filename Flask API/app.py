"""
A sample Hello World server. With a reponame API call
"""
import os, base64, requests, re, ast

from flask import Flask, render_template

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

@app.route('/api', methods = ['GET'])
def return_data():
    username = str(request.args(['username']))
    # Api call
    repos = getRepos(username)

    for repo in repos:
        parseFiles(username, repo)

    # Tokenize the variable
    classifyVariables()

    # Get maximum words used and send to chat GPT
    mostCommonVars = sorted(variableDict, variableDict.get)[-6:]
    
    # Data format
    return output

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

if __name__ == '__main__':
    server_port = os.environ.get('PORT', '8080')
    app.run(debug=False, port=server_port, host='0.0.0.0')
