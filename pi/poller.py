import requests
import time

BASE_URL = 'http://infinite-fortress-1821.herokuapp.com/'


def turn_on():
    print 'should turn AC on'


def turn_off():
    print 'should turn AC off'


def poll():
    while True:
        command = requests.get(BASE_URL + 'pop_command').content
        if command == 'TURN_ON':
            turn_on()
        elif command == 'TURN_OFF':
            turn_off()
        time.sleep(0.5)


if __name__ == '__main__':
    poll()
