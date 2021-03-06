#!/usr/bin/env python
# 	blinkt/blinkt.mine/warn_colors_2.py  3.267.421  2019-01-01T21:59:21.402826-06:00 (CST)  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.266-1-gbccfccb  
# 	   copied to blinkt.mine 
# 	warn_colors_2.py  3.08.85  2018-03-14_21:59:15_CDT  https://github.com/BradleyA/pi-display  uadmin  two-rpi3b.cptx86.com 3.07-2-g5f6290c  
# 	   added more prices, first draft of display-led.py 
# 	warn_colors_2.py  2.7.39  2018-02-27_18:52:21_CST  https://github.com/BradleyA/pi-display-board  uadmin  two-rpi3b.cptx86.com 2.6-1-ge4f399b  
# 	   moved this test cases to github 
#	warn_colors_2.py	1.0	2017-12-19_13:30:13_CST uadmin
#	Initial check in

#	This containers' final design should control an Blinkt LED bar and
#		display information for a second
#		So this means it will take 8 seconds to display all LEDS?
#	Each color level function will exit with the primary color on
#	Color brightness controlled in each color level function
#
#	Other containers will update a volume that this container mounts
#		and reads (LED_number, Level)
#

from blinkt import set_clear_on_exit, set_pixel, show, clear
import time

set_clear_on_exit()
LED_number = 0

#	GREEN : no known incidents
set_pixel(LED_number, 0, 255, 0, 0.5)
show()
time.sleep(1) # 1 = 1 second

#	BLUE : an incident (watch)
for i in range(0, 5):
   set_pixel(LED_number + 1, 0, 255, 0, 0.1)
   show()
   time.sleep(0.40) # 1 = 1 second
   set_pixel(LED_number + 1, 50, 205, 50, 0.2)
#   set_pixel(LED_number + 1, 125, 255, 0, 0.2)
#   set_pixel(LED_number + 1, 0, 0, 255, 0.2)
   show()
   time.sleep(0.10) # 1 = 1 second

#	YELLOW : additional incidents WARNING (alert)
for i in range(0, 5):
   set_pixel(LED_number + 2, 0, 255, 0, 0.1)
   show()
   time.sleep(0.20) # 1 = 1 second
   set_pixel(LED_number + 2, 255, 255, 0, 0.2)
   show()
   time.sleep(0.30) # 1 = 1 second

#	ORANGE : CRITICAL ERROR
set_pixel(LED_number + 3, 255, 35, 0, 0.1)
show()
time.sleep(1) # 1 = 1 second

#	RED : FATAL ERROR
for i in range(0,10):
   set_pixel(LED_number + 4, 0, 0, 0, 0)
   show()
   time.sleep(0.02) # 1 = 1 second
   set_pixel(LED_number + 4, 255, 0, 0, 0.5)
   show()
   time.sleep(0.1) # 1 = 1 second

#       VIOLET : the statistic is  WARNING (alert)
set_pixel(LED_number + 5, 127, 0, 255, 0.1)
show()
time.sleep(15) # 1 = 1 second

