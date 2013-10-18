Evercool
========

Imagine yourself on your way home on a hot sunny day.
Wouldn't you wish someone would turn the AC for you ahead of time?

Evercool - an iPhone app that knows when you're on your way home,
checks the weather, and turns on the AC automatically for you at just the right temperature.

It works by having a raspberry pi connected to an IR LED which can control your AC.
![](https://s3-eu-west-1.amazonaws.com/uploads-eu.hipchat.com/13432/45393/LZixVr0OAKcL3gc/upload.png)

## What you need
* RaspberryPi with LIRC compiled
* Airconditioner / Fan with an IR remote control
* IR Receiver
* IR Transmitter
* Transistors and resistors
* Cables
* a bit of iOS knowledge
* a bit of Python knowledge
* high trolling ability

## What we did to get it working

### Connect the IR receiver / transmitter circuit to the breadboard
The first step is to wire the IR receiver / transmitter circuit to your RaspberryPi.
We combined two different schemas on the same circuit to save some time
#### IR Receiver
![](https://s3-eu-west-1.amazonaws.com/uploads-eu.hipchat.com/13432/91327/6APKXp6w4JSMDLZ/upload.png)

(Taken from http://randomtutor.blogspot.co.il/2013/01/web-based-ir-remote-on-raspberry-pi.html)
#### IR Transmitter
![](https://s3-eu-west-1.amazonaws.com/uploads-eu.hipchat.com/13432/91327/zrlEo3QgICdafrB/upload.png)

(Taken from http://randomtutor.blogspot.co.il/2013/01/web-based-ir-remote-on-raspberry-pi.html)

#### The result circuit
![](https://s3-eu-west-1.amazonaws.com/uploads-eu.hipchat.com/13432/91327/hfvCsJJuFzyYdZR/IMG_2027.png)

### Set up your RaspberryPi and configure LIRC
#### Configure the LIRC module
You'll need to add the following lines to your /etc/modules file -
```
lirc_dev
lirc_rpi gpio_in_pin=23 gpio_out_pin=22
```

You'll also need to setup hardware.conf and some other stuff, for more information you can check the link below

(This assumes the used GPIO ports are 23 and 22, taken from http://alexba.in/blog/2013/01/06/setting-up-lirc-on-the-raspberrypi/)

#### Record the IR signal from the remote
After setting up the circuit and configuring LIRC we'll now need to record the IR signal from the remote control.
Basically the IR signal is just a pulsing light that pulses at different intervals to encode data, the recording process just digitizes these pulses into a configuration file.

After running 
```
irrecord -d /dev/lirc0 ~/lircd.conf
```
The result lircd.conf should look like this -
```

# Please make this file available to others
# by sending it to <lirc@bartelmus.de>
#
# this config file was automatically generated
# using lirc-0.9.0-pre1(default) on Thu Oct 17 10:08:12 2013
#
# contributed by 
#
# brand:                       /home/pi/lircd.conf
# model no. of remote control: 
# devices being controlled by this remote:
#

begin remote

  name  /home/pi/lircd.conf
  flags RAW_CODES|CONST_LENGTH
  eps            30
  aeps          100

  gap          53873

      begin raw_codes

          name BTN_0
             1248     425    1260     423     418    1263
             1258     428    1213     471     371    1317
              412    1265     419    1265     419    1263
              375    1311     417    1266    1261    7157
             1254     430    1264     419     417    1266
             1259     426    1259     423     415    1269
              416    1265     390    1296     416    1268
              415    1268     416    1267    1262

          name BTN_1
             1257     425    1258     423     413    1268
             1261     426    1252     431     417    1265
              420    1264     416    1268    1265     420
              419    1260     424    1262     417    8004
             1212     470    1261     422     417    1263
             1265     422    1266     418     414    1268
              419    1264     418    1264    1262     424
              416    1267     417    1268     417

          name BTN_2
             1252     431    1259     424     419    1262
             1260     426    1213     476     411    1266
              418    1265     417    1266     421    1262
             1216     469     372    1311     417    7999
             1224     463    1213     476     366    1310
             1215     469    1214     470     418    1266
              373    1308     417    1268     415    1267
             1260     426     413    1269     414

          name BTN_3
             1252     431    1260     423     371    1310
             1261     425    1266     418     413    1268
              415    1268     419    1265     372    1312
              416    1268    1220     464     415    7999
             1223     464    1259     425     371    1311
             1215     469    1257     426     374    1310
              379    1302     375    1311     373    1310
              373    1312    1213     471     369

      end raw_codes

end remote
```
(This is the actual configuration file we used in the demo)
#### Testing the transmitter
After copying the result lircd.conf to the right place and restarting the lirc daemon you can test that everything works by running
```
irsend SEND_ONCE BTN_0
````

If everything worked you should get a working ventilator :) woohoo! If something went bad we highly recommend that you follow the guides we referenced, they are more than enough to get everything working.

### iOS Client
#### Geo-fencing
We've used geo-fencing to set and detect entrance to the user "home location".
Apple provides pretty straight-forward APIs for doing this, we used the following classes to get everything up -
* MKMapView - Displaying and selecting the home location
* CLLocationManager - for the actual geographical region changes
* UIApplication / presentLocalNotificationNow - for showing local push notifications to the user
* NSURLConnection - for server side communication and the actual control the the RaspberryPi
* Yahoo weather for local temperature measurement and thresholding

You can always look at the source code if you have any questions on the actual implementation :)

### Server Side
#### Heroku Flusk / Gunicorn application
We've chosen the combination of Flusk & Gunicorn deployed on heroku for the server side.
The server is pretty simple - the RaspberryPi polls the server every second for commands, the iOS client updates the server when the AC/Fan needs to start or stop.


## That's it!

### About us -

#### Yoni "Yoni" Levy
Trolling hacker #1
LinkedIn - http://www.linkedin.com/profile/view?id=11573714

#### David Brailovsky
Trolling hacker #2
https://github.com/davidbrai

#### Nimrod "Guti" Gutman
Trolling hacker #3
LinkedIn - http://lnkd.in/2ET56b

### Some more pictures of us hacking
![](https://s3-eu-west-1.amazonaws.com/uploads-eu.hipchat.com/13432/91327/vl9xy8mKymhs00X/IMG_2026.png)
![](https://s3-eu-west-1.amazonaws.com/uploads-eu.hipchat.com/13432/91327/p3rtb7SE2OkyDmC/IMG_2024.png)
![](https://s3-eu-west-1.amazonaws.com/uploads-eu.hipchat.com/13432/91327/UHYTzXFhfDBPVB5/IMG_2029-2.png)
