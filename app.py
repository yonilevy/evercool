import os
from flask import Flask

app = Flask(__name__)

is_local = os.getenv('MONGOHQ_URL') is None

current_state = None
TURN_ON = 'TURN_ON'
TURN_OFF = 'TURN_OFF'
NOP = ''
EVERCOOL_COMMAND = 'EVERCOOL_COMMAND'


@app.route('/')
def hello():
    command = get_current_command()
    return """Hello World!!!<br>
    Current state: %s<br>
    <a href="turn_on">turn on</a><br>
    <a href="turn_off">turn off</a><br>
    <a href="pop_command">pop command</a><br>
    """ % command


@app.route('/pop_command')
def pop_command():
    command = get_current_command()
    set_current_command(NOP)
    return command


@app.route('/turn_on')
def turn_on():
    set_current_command(TURN_ON)
    return "turning on"


@app.route('/turn_off')
def turn_off():
    set_current_command(TURN_OFF)
    return "turning off"


def get_current_command():
    val = os.getenv(EVERCOOL_COMMAND)
    return val if val else ''


def set_current_command(command):
    os.environ[EVERCOOL_COMMAND] = command


if __name__ == '__main__':
    # Bind to PORT if defined, otherwise default to 5000.
    port = int(os.environ.get('PORT', 5000))
    app.debug = is_local
    app.run(host='0.0.0.0', port=port)