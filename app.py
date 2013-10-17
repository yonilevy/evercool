import os
from flask import Flask
from mongo import mongo

app = Flask(__name__)

is_local = os.getenv('MONGOHQ_URL') is None

current_state = None
TURN_ON = "TURN_ON"
TURN_OFF = "TURN_OFF"

@app.route('/')
def hello():
    command = mongo.state.find_one()
    return """Hello World!!!<br>
    Current state: %s<br>
    <a href="turn_on">turn on</a><br>
    <a href="turn_off">turn off</a><br>
    <a href="pop_command">pop command</a>
    """ % command

@app.route('/pop_command')
def pop_command():
    state = mongo.state.find_one()
    if not state:
        return ''
    mongo.state.remove(state)
    return state.get('command')

@app.route('/turn_on')
def turn_on():
    mongo.state.insert({"command": TURN_ON})
    return "turning on"

@app.route('/turn_off')
def turn_off():
    mongo.state.insert({"command": TURN_OFF})
    return "turning off"


if __name__ == '__main__':
    # Bind to PORT if defined, otherwise default to 5000.
    port = int(os.environ.get('PORT', 5000))
    app.debug = is_local
    app.run(host='0.0.0.0', port=port)