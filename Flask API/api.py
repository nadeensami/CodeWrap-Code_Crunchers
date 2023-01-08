from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello_world():
    return "Hey Yall"
@app.route('/reponame', methods = ['GET'])
def return_data():
    input_repo = str(request.args(['reponame']))
    # Api call
    # Data format
    return output


if __name__=="__main__":
    app.debug = True
    app.run(host = '0.0.0.0', port = 5000)