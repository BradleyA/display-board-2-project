# scrollphat

**create-message.sh** - This script stores system information and Docker information about containers and images in a file on each system in a cluster.  These files are copied to all hosts and the Docker information is totaled in a file, /usr/local/data/\<cluster-name>/MESSAGE.  The MESSAGE file includes the total number of containers, running containers, paused containers, stopped containers, and number of images.  The MESSAGE file is used by a Raspberry Pi Scroll-pHAT and  Scroll-pHAT-HD to display the information.

This script reads /usr/local/data/\<cluster-name>/SYSTEMS file for the FQDN or IP address of the hosts in a cluster.  The file includes one FQDN host or IP address per line.  Lines starting with a '#' are ignored.

System inforamtion about each host is stored in /usr/local/data/\<cluster-name>/\<host> with the Docker information.  The system information includes cpu temperature in Celsius and Fahrenheit, CPU percent used, memory percent used, and disk percent used.  The system information will be used by blinkt to display system information about each system in near real time.

To avoid many login prompts for each host in a cluster, enter the following:  ssh-copy-id uadmin@<host-name>

#### WARNING: These instructions below are incomplete. Consider them as notes quickly drafted on a napkin rather than proper documentation!  I need to complete some cleanup before it is shareable and documented . . .
<img id="Construction" src="../images/construction-icon.gif" width="120">

create-message.sh -> is found in /usr/local/data/cluster-1/SYSTEMS file.  Docker totals from these files are in /usr/local/data/cluster-1/MESSAGE for Scroll-pHAT on each system.  

display-message.py -> uses this information and displays it on Scroll-pHAT

still a lot of work to include blinkt . . .but it has been working for 9 months

[Return to top](https://github.com/BradleyA/pi-display/blob/master/scrollphat/README.md#scrollphat)

## Clone
To Install, change into a directory that you want to download the scripts. Use git to pull or clone these scripts into the directory. If you do not have Git installed then enter; "sudo apt-get install git" if using Debian/Ubuntu. Other Linux distribution install methods can be found here: https://git-scm.com/download/linux. On the GitHub page of this script use the "HTTPS clone URL" with the 'git clone' command.

    git clone https://github.com/BradleyA/pi-display
    cd pi-display/scrollphat

[Return to top](https://github.com/BradleyA/pi-display/blob/master/scrollphat/README.md#scrollphat)

#### ARCHITECTURE TREE

[Return to top](https://github.com/BradleyA/pi-display/blob/master/scrollphat/README.md#scrollphat)

----

#### Contribute
Please do contribute!  Issues and pull requests are welcome.  Thank you for your help improving software.

[Return to top](https://github.com/BradleyA/pi-display/blob/master/scrollphat/README.md#scrollphat)

#### Author
[<img id="github" src="../images/github.png" width="50" a="https://github.com/BradleyA/">](https://github.com/BradleyA/)    [<img src="../images/linkedin.png" style="max-width:100%;" >](https://www.linkedin.com/in/bradleyhallen) [<img id="twitter" src="../images/twitter.png" width="50" a="twitter.com/bradleyaustintx/">](https://twitter.com/bradleyaustintx/)       <a href="https://twitter.com/intent/follow?screen_name=bradleyaustintx"> <img src="https://img.shields.io/twitter/follow/bradleyaustintx.svg?label=Follow%20@bradleyaustintx" alt="Follow @bradleyaustintx" />    </a>          [![GitHub followers](https://img.shields.io/github/followers/BradleyA.svg?style=social&label=Follow&maxAge=2592000)](https://github.com/BradleyA?tab=followers)

[Return to top](https://github.com/BradleyA/pi-display/blob/master/scrollphat/README.md#scrollphat)

#### Tested OS
 * Ubuntu 14.04.6 LTS (amd64,armv7l)
 * Ubuntu 16.04.7 LTS (amd64,armv7l)
 * Ubuntu 18.04.5 LTS (amd64,armv7l)
 * Raspbian GNU/Linux 10 (buster)

[Return to top](https://github.com/BradleyA/pi-display/blob/master/scrollphat/README.md#scrollphat)

#### Design Principles
 * Have a simple setup process and a minimal learning curve
 * Be usable as non-root
 * Be easy to install and configure

[Return to top](https://github.com/BradleyA/pi-display/blob/master/scrollphat/README.md#scrollphat)

#### License
MIT License

Copyright (c) 2020  [Bradley Allen <img src="https://static.licdn.com/scds/common/u/img/webpromo/btn_viewmy_160x25.png" style="max-width:100%;" >](https://www.linkedin.com/in/bradleyhallen)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

[Return to top](https://github.com/BradleyA/pi-display/blob/master/scrollphat/README.md#scrollphat)
