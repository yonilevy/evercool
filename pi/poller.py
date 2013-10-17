import requests
import time
import os

BASE_URL = 'http://infinite-fortress-1821.herokuapp.com/'


def turn_on():
    print 'turning AC on'
    os.system('irsend SEND_ONCE /home/pi/lircd.conf BTN_3')


def turn_off():
    print 'turning AC off'
    os.system('irsend SEND_ONCE /home/pi/lircd.conf BTN_0')


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
