#!/usr/bin/env python3
# 	display-led.py  3.158.300  2018-09-24_22:06:18_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.157  
# 	   complete template.py changes close #28 
# 	display-led.py  3.157.299  2018-09-24_20:09:19_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.156  
# 	   completed display_help for display-led.py #28 
# 	display-led.py  3.155.297  2018-09-24_18:30:14_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.154  
# 	   start working on display_help #28 
# 	display-led.py  3.154.296  2018-09-23_21:01:09_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.153  
# 	   second cut at adding template.py #28 
# 	display-led.py  3.153.295  2018-09-23_20:54:50_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.152  
# 	   first cut at adding template.py #28 
# 	display-led.py  3.152.294  2018-09-23_20:28:29_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.151  
# 	   correct run error close #38 
# 	display-led.py  3.141.283  2018-09-22_13:30:59_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.140  
# 	   set python3 remove \n from logging information 
# 	display-led.py  3.106.248  2018-09-12_21:40:18_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.105  
# 	   display-led.py needs more adding template.py 
# 	display-led.py  3.105.247  2018-09-12_21:04:15_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.104-2-g5f62b1a  
# 	   added python template 
# 	display-led.py  3.104.244  2018-09-12_20:46:52_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.103  
# 	   change sleep from 4 to 10 for display-led 
###
#	The final design should control an Blinkt LED bar and
#		display information for a second
#		So this means it will take 8 seconds to display all LEDS?
#	Each color level function will exit with the primary color on
#	Color brightness controlled in each color level function
#
#	Other containers will update a volume that this container mounts
#		and reads (LED_number, Level)
###
DEBUG = 1       # 0 = debug off, 1 = debug on
#
import subprocess
import sys
import time
import os
###
class color:
   BOLD = '\033[1m'
   END  = '\033[0m'
###
LANGUAGE = os.getenv("LANG")
def display_help():
   LANGUAGE = os.getenv("LANG")
   print ("\n{} - display system status on blinkt".format( __file__))
   print ("\nUSAGE\n   {} [<CLUSTER>] [<DATA_DIR>]".format(__file__))
   print ("   {} [--help | -help | help | -h | h | -?]".format(__file__))
   print ("   {} [--version | -version | -v]".format(__file__))
   print ("\nDESCRIPTION\nThis script displays the system information stored in a file,")
   print ("/usr/local/data/us-tx-cluster-1/<hostname>, on each system.  The system")
   print ("information is displayed using a Raspberry Pi with Pimoroni Blinkt.  The system")
   print ("information includes cpu temperature in Celsius and Fahrenheit, the system")
   print ("load, memory usage, and disk usage.")
   print ("\nEnvironment Variables")
   print ("If using the bash shell, enter; export CLUSTER='<cluster-name>' on the command")
   print ("line to set the CLUSTER environment variable.  Use the command, unset CLUSTER")
   print ("to remove the exported information from the CLUSTER environment variable.")
   print ("Setting an environment variable to be defined at login by adding it to")
   print ("~/.bashrc file or you can just modify the script with your default location")
   print ("for CLUSTER and DATA_DIR.  You are on your own defining environment variables")
   print ("if you are using other shells.")
   print ("   CLUSTER       (default us-tx-cluster-1/)")
   print ("   DATA_DIR      (default /usr/local/data/)")
   print ("\nOPTIONS")
   print ("   CLUSTER       name of cluster directory, default us-tx-cluster-1")
   print ("   DATA_DIR      path to cluster data directory, default /usr/local/data/")
   print ("\nDOCUMENTATION\n   https://github.com/BradleyA/pi-display/tree/master/blinkt")
   print ("\nEXAMPLES\n   Display contents using default file and path\n")
   print ("   {} \n".format(__file__))
#  After displaying help in english check for other languages
   if LANGUAGE != "en_US.UTF-8" :
      print ("{}{} {} {}[WARNING]{}  {}  Your language, {} is not supported, Would you like to help?".format(color.END, __file__, get_line_no(), color.BOLD, color.END, get_date_stamp(), LANGUAGE))
#  elif LANGUAGE != "fr_CA.UTF-8" :
#     print display_help in french
#  else :
   return

#  Line number function
from inspect import currentframe
def get_line_no() :
   cf = currentframe()
   return cf.f_back.f_lineno

#  Date and time function
def get_date_stamp() :
   return time.strftime("%Y-%m-%d-%H-%M-%S-%Z")

#  Default help and version arguments
no_arguments =  int(len(sys.argv))
if no_arguments == 2 :
#  Default help output  
   if sys.argv[1] == '--help' or sys.argv[1] == '-help' or sys.argv[1] == 'help' or sys.argv[1] == '-h' or sys.argv[1] == 'h' or sys.argv[1] == '-?' :
      display_help()
      sys.exit()
#  Default version output  
   if sys.argv[1] == '--version' or sys.argv[1] == '-version' or sys.argv[1] == 'version' or sys.argv[1] == '-v' :
      with open(__file__) as f :
         f.readline()
         line2 = f.readline()
         line2 = line2.split()
         print ("{} {}".format(line2[1], line2[2]))
      sys.exit()

#  DEBUG example
import platform
if DEBUG == 1 : print ("> {}DEBUG{} {}  {}  Name of command >{}<  Version of python >{}<".format(color.BOLD, color.END, get_line_no(), get_date_stamp(), __file__, platform.python_version()))

#  if argument; use argument -> do not use environment variables or default for CLUSTER
if no_arguments >= 2 :
   CLUSTER = sys.argv[1]
   if DEBUG == 1 : print ("> {}DEBUG{} {}  {}  Using 1 argument CLUSTER >{}<".format(color.BOLD, color.END, get_line_no(), get_date_stamp(), CLUSTER))
elif "CLUSTER" in os.environ :
   #  Check CLUSTER; set using os environment variable
   CLUSTER = os.getenv("CLUSTER")
   if DEBUG == 1 : print ("> {}DEBUG{} {}  {}  Using environment variable CLUSTER >{}<".format(color.BOLD, color.END, get_line_no(), get_date_stamp(), CLUSTER))
else :
   #  Set CLUSTER with default
   CLUSTER = "us-tx-cluster-1/"
   if DEBUG == 1 : print ("> {}DEBUG{} {}  {}  Environment variable CLUSTER NOT set, using default >{}<".format(color.BOLD, color.END, get_line_no(), get_date_stamp(), CLUSTER))

#  if argument; use argument -> do not use environment variables or default for DATA_DIR
if no_arguments == 3 :
   DATA_DIR = sys.argv[2]
   if DEBUG == 1 : print ("> {}DEBUG{} {}  {}  Using 2 argument DATA_DIR >{}<".format(color.BOLD, color.END, get_line_no(), get_date_stamp(), DATA_DIR))
elif "DATA_DIR" in os.environ :
   #  Check DATA_DIR; set using os environment variable
   DATA_DIR = os.getenv("DATA_DIR")
   if DEBUG == 1 : print ("> {}DEBUG{} {}  {}  Using environment variable DATA_DIR >{}<".format(color.BOLD, color.END, get_line_no(), get_date_stamp(), DATA_DIR))
else :
   #  Set DATA_DIR with default
   DATA_DIR = "/usr/local/data/"
   if DEBUG == 1 : print ("> {}DEBUG{} {}  {}  Environment variable DATA_DIR NOT set, using default >{}<".format(color.BOLD, color.END, get_line_no(), get_date_stamp(), DATA_DIR))

#  Return a fully qualified domain name
import socket
LOCALHOST = socket.getfqdn()

#
FILE_NAME = DATA_DIR + "/" + CLUSTER + "/" + LOCALHOST
if DEBUG == 1 : print (">{} DEBUG{} {}  FILE_NAME >{}<".format(color.BOLD, color.END, get_line_no(), FILE_NAME, FILE_NAME))

###
from blinkt import set_clear_on_exit, set_pixel, show, clear
#
set_clear_on_exit()

def status1(LED_number):
#   Normal services and operations
#	GREEN : no known incidents
#   LED_number argument 0-7
    set_pixel(LED_number, 0, 255, 0, 0.2)
    show()
    return();

def status2(LED_number):
#   Incidents causing no disruption to overall services and operations
#	LIGHT GREEN : an incident (watch)
#   LED_number argument 0-7
    for i in range(0, 5):
        set_pixel(LED_number, 0, 0, 0, 0)
        show()
        time.sleep(0.05) # 1 = 1 second
        set_pixel(LED_number, 50, 205, 50, 0.1)
        show()
        time.sleep(0.15) # 1 = 1 second
    return();

def status3(LED_number):
#  Active incident with minimal affect to overall services and operations
#	YELLOW : additional incidents WARNING (alert)
#   LED_number argument 0-7
    for i in range(0, 5):
        set_pixel(LED_number, 0, 255, 0, 0.8)
        show()
        time.sleep(0.05) # 1 = 1 second
        set_pixel(LED_number, 0, 0, 0, 0)
        show()
        time.sleep(0.03) # 1 = 1 second
        set_pixel(LED_number, 255, 255, 0, 0.2)
        show()
        time.sleep(0.15) # 1 = 1 second
    return();

def status4(LED_number):
#   Active emergency incidents causing significant impact to operations and possiable service disruptions
#	ORANGE : CRITICAL ERROR
#   LED_number argument 0-7
    for i in range(0,10):
        set_pixel(LED_number, 255, 255, 0, 0.8)
        show()
        time.sleep(0.05) # 1 = 1 second
        set_pixel(LED_number, 0, 0, 0, 0)
        show()
        time.sleep(0.03) # 1 = 1 second
        set_pixel(LED_number, 255, 35, 0, 0.1)
        show()
        time.sleep(0.05) # 1 = 1 second
    return();

def status5(LED_number):
#   Active emergency incidents causing multiple impaired operations amd unavoidable severe service disruptions
#	RED : Emergency Conditions : FATAL ERROR : 
#   LED_number argument 0-7
    for i in range(0,10):
        set_pixel(LED_number, 255, 35, 0, 0.8)
        show()
        time.sleep(0.05) # 1 = 1 second
        set_pixel(LED_number, 0, 0, 0, 0)
        show()
        time.sleep(0.03) # 1 = 1 second
        set_pixel(LED_number, 255, 0, 0, 0.2)
        show()
        time.sleep(0.05) # 1 = 1 second
    return();

def status6(LED_number):
#
#       VIOLET : the statistic is  WARNING (alert)
#   LED_number argument 0-7
    set_pixel(LED_number, 127, 0, 255, 0.1)
    show()
    time.sleep(2) # 1 = 1 second
    return();

def process(line):
#   process information
#    print("in process information function")
    if 'celsius:' in line.lower():
        #   print(line[line.find(':')+2:])
        VALUE = float(line[line.find(':')+2:])
        LED_number = 7
        if DEBUG == 1 : print ("> {}DEBUG{} {}  {}  celsius: VALUE >{}< LED_number >{}<".format(color.BOLD, color.END, get_line_no(), get_date_stamp(), VALUE, LED_number))
        if   VALUE < 48.5 : # < 48.5 C 119.3  1
            status1(LED_number)
        elif VALUE < 59   : # < 59 C   138.2  2
            status2(LED_number)
        elif VALUE < 69.5 : # < 69.5 C 157.1  3
            status3(LED_number)
        elif VALUE < 80   : # < 80 C   176    4
            status4(LED_number)
        elif VALUE >= 80  :   # > 80 C 176    5
            status5(LED_number) 
    if 'cpu_usage:' in line.lower():
        #   print(line[line.find(':')+2:])
        VALUE = int(line[line.find(':')+2:])
        LED_number = 6
        if DEBUG == 1 : print ("> {}DEBUG{} {}  {}  cpu_usage: VALUE >{}< LED_number >{}<".format(color.BOLD, color.END, get_line_no(), get_date_stamp(), VALUE, LED_number))
        if   VALUE < 70 : # < 70 %
            status1(LED_number)
        elif VALUE < 80 : # < 80 %
            status2(LED_number)
        elif VALUE < 85 : # < 85 %
            status3(LED_number)
        elif VALUE < 90 : # < 90 %
            status4(LED_number)
        elif VALUE >= 90 : # >= 95 %
            status5(LED_number) 
    if 'memory_usage:' in line.lower():
        #   print(line.split(' ')[2])
        VALUE = int(line.split(' ')[2])
        LED_number = 5
        if DEBUG == 1 : print ("> {}DEBUG{} {}  {}  memory_usage: VALUE >{}< LED_number >{}<".format(color.BOLD, color.END, get_line_no(), get_date_stamp(), VALUE, LED_number))
        if   VALUE < 70 : # < 70 %
            status1(LED_number)
        elif VALUE < 80 : # < 80 %
            status2(LED_number)
        elif VALUE < 85 : # < 85 %
            status3(LED_number)
        elif VALUE < 90 : # < 90 %
            status4(LED_number)
        elif VALUE >= 90 : # >= 95 %
            status5(LED_number) 
    if 'disk_usage:' in line.lower():
        #   print(line.split(' ')[2])
        VALUE = int(line.split(' ')[2])
        LED_number = 4
        if DEBUG == 1 : print ("> {}DEBUG{} {}  {}  disk_usage: VALUE >{}< LED_number >{}<".format(color.BOLD, color.END, get_line_no(), get_date_stamp(), VALUE, LED_number))
        if   VALUE < 70 : # < 70 %
            status1(LED_number)
        elif VALUE < 80 : # < 80 %
            status2(LED_number)
        elif VALUE < 85 : # < 85 %
            status3(LED_number)
        elif VALUE < 90 : # < 90 %
            status4(LED_number)
        elif VALUE >= 90 : # >= 95 %
            status5(LED_number) 
    return();

#####
#   read file and process information
# >>>  need to replace path and file name with variables
#	>> how to find hostname and set variable
#	with open('/usr/local/data/us-tx-cluster-1/two-rpi3b.cptx86.com') as f:
with open(FILE_NAME) as f:
   print ("{}{} {} {}[INFO]{}  {} {} ".format(color.END,__file__,get_line_no(),color.BOLD,color.END,time.strftime("%Y-%m-%d-%H-%M-%S-%Z"),FILE_NAME))
   for line in f:
      process(line)

time.sleep(10) # 1 = 1 second

# >>>  need to replace path and file name with variables
#    file = open(FILE_NAME,"r")
#    print file.read()
#    file_data = fp.readlines()
#    file.close()

#		while TRUE:
#		#   loop through leds on blinkt
#		    for LED in range(0,7):
#		#       if file-information(LED) == 1 then status1(LED)
#		       if 
###	Led test functions
#	status1(0)
#	status2(1)
#	status3(2)
#	status4(3)
#	status5(4)
#	status6(5)
#   status6(6)
#   status6(7)
###
print ("\n{}{} {} {}[INFO]{}  {}  Done.\n".format(color.END, __file__, get_line_no(), color.BOLD, color.END, get_date_stamp()))
###
