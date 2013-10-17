Evercool
========

Imagine yourself on your way home on a hot sunny day.
Wouldn't you wish someone would turn the AC for you ahead of time?

Evercool - an iPhone app that knows when you're on your way home,
checks the weather, and turns on the AC automatically for you at just the right temperature.

It works by having a raspberry pi connected to an IR LED which can control your AC.


## Steps

### Connect the IR receiver / transmitter circuit to the breadboard
The first step is to wire the IR receiver / transmitter circuit to your RaspberryPi.
We combined two different schemas on the same circuit to save some time
#### IR Receiver
![](https://s3-eu-west-1.amazonaws.com/uploads-eu.hipchat.com/13432/91327/6APKXp6w4JSMDLZ/upload.png)

(Taken from http://randomtutor.blogspot.co.il/2013/01/web-based-ir-remote-on-raspberry-pi.html)
#### IR Transmitter
![](https://s3-eu-west-1.amazonaws.com/uploads-eu.hipchat.com/13432/91327/zrlEo3QgICdafrB/upload.png)

(Taken from http://randomtutor.blogspot.co.il/2013/01/web-based-ir-remote-on-raspberry-pi.html)

### The result circuit
![](https://s3-eu-west-1.amazonaws.com/uploads-eu.hipchat.com/13432/91327/hfvCsJJuFzyYdZR/IMG_2027.png)

### Set up your RaspberryPi and configure LIRC
