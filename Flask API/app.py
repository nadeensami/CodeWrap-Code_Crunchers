"""
A sample Hello World server. With a reponame API call
"""
import os

from flask import Flask, render_template

# pylint: disable=C0103
app = Flask(__name__)


@app.route('/')
def hello():
    """Return a friendly HTTP greeting."""
    return "hey"

@app.route('/reponame', methods = ['GET'])
def return_data():
    input_repo = str(request.args(['reponame']))
    # Api call
    
    # Data format
    return output

if __name__ == '__main__':
    server_port = os.environ.get('PORT', '8080')
    app.run(debug=False, port=server_port, host='0.0.0.0')
