# ezeelinux-script-collection
Custom scripts and aliases that you can adapt to your own needs.

Introduction

    Thanks for downloading the EzeeLinux BASH Script Collection! These 
are scripts that I use on a daily basis and they've been discussed in 
YouTube videos and Facebook posts. You guys have asked for them and now 
they are all available in one happy .zip file. I will offer a brief 
explanation of each one here. Be aware that some will need to be edited 
to fit your specific needs. For instance, SyncIt is an automated script
that uses rsync to sync data between machines on my network and it has 
directories listed that are peculiar to my setup. To use it on your 
system, you will have to setup static IP addresses, install and 
configure SSH to work with security keys and not passwords and you will 
have to substitute your own directories. All of these are designed to 
work with Ubuntu based Linux. They should work just fine with Linux Mint 
or any other distribution based on Ubuntu. They may or may not work with 
other distributions and I have not been tested on

    BASH scripts don't require installation. All you need to do is 
create a directory in your home directory called "bin" (must be 
lowercase) and then you may have to log out and log back in to get the 
system to see it. Any executable file placed in your personal bin 
directory can then be run by typing its name, just like any other 
command, at a terminal. Make sure the script is executable in a File 
Manager and it's ready to use. Keep in mind that scripts in your bin 
will not be seen by the system if you issue them with sudo. The system 
will prompt you if sudo privileges are required.

The Scripts

    Here is a list of the scripts and a bit about what they do:

	chksys

	This script give you vital system information. I wrote it to quickly
check on the status of my server.

	nr 

	This alias restarts Network Manager in Ubuntu and Linux Mint. It can be
useful if you're working on a bad wi-fi network and you need to reestablish
a connection. 


    SFTPin and SSHin

    These are small scripts that can also be set as aliases or functions 
in your .bashrc file. They work with SSH and make logging into machines 
on your network super easy. You must know the IPv4 address of the 
machine you wish to log into and the script assumes that your LAN is 
using a subnet that uses 192.168.0.xx with the x's standing for the 
specific machine number. Different routers use different schemes so you 
may have to change that. The "$1" represents a variable that contains 
the first argument after the command. So, you would simply type 'sshin 
12' to log into a machine on your LAN that has the address 192.168.0.12. 
The command 'sftpin 12' would open the SFTP file transfer program and 
you can use it to move move file from one machine to another just as you 
would use a public FTP server.

    SyncIt

    This script also works with SSH and let's you sync directories 
across a network. The rsync command used here will make an exact copy of 
whatever is in the local machine's directories on a remote machine. 
Files that have changed or have been added to the local machine will be 
copied or updated on the remote machine. Files that have been deleted 
locally will be removed from the remote host, as well. WARNING! This 
script will also remove files that are on a remote machine that do not 
exist in the local machine you're sending from! It makes an exact copy 
of whatever is in the directory being synced so if you have files on the 
remote machine you want to keep that it's not a good idea to run SyncIt 
before using SFTPin to grab those remote files and make sure they are on 
the local machine first! The directories in the script are the ones I 
have chosen to sync but a bit of editing will make it work for you. Make 
sure that all the IP addresses match your network scheme. Just as in the 
scripts above, the way to issue a SyncIt command is: 'syncit 12' We're 
assuming here that the machine you're wanting to sync to has the IP 
address 192.168.0.12.

	Syncall

	Runs syncit for all the machines on the network. This script will require
you to customize it for your own network.

	rbu

	This is a simplified version of BU that is intended to run on a remote
machine through SSH. You must manually mount the BU_Drive before running this
script.

	firefox-purge.sh

	This script removes the Firefox browser and replaces it with Google CHrome. 
It works on Debian and Ubuntu based systems. 

	Ubuntu Installation Scripts

	These are scripts that automate setting up Ubuntu for my Dell workstation.
They are highly customized to my needs. You can use them as a springboard to
create your own installation scripts. 

	oldkernrm

	This script is for CentOS. It will automatically remove all old kernels.
I use it as a clean-up tool for my server. 

	ocenaudio-installer.sh

	This script installs the Ocenaudio editor. It can also be used to update 
the application without having to go to Ocenaudio's web page.	
	
    Z-Clean and Z-Defrag

    These are Anacron wrapper scripts that work with the Anacron 
scheduling system. You use them by copying them to one of three 
directories on an Ubuntu based system. (Anacron may or may not be 
configured on other Linux distributions. Check the documentation to find 
out before adding these scripts.)  Those directories are: 
/etc/cron.daily /etc/cron.weekly /etc/cron/monthly. Any script placed in 
these directories will run periodically in the background on your 
machine. They must be written for sh and there is a specific format so 
be cautious when editing them. Feel free to change the parameters of the 
commands and also these can be used as templates for commands you'd like 
to have run automatically. They begin with a Z to ensure that they're 
the last scripts to run. This way they will not conflict with system 
scripts that may already be in the Anacron directories. Anacron has 
several advantages over regular cron and you should take time to read 
some documentation before you start playing around with it. The manual 
page is well written and you can access it with the 'man anacron' 
command in a terminal.

    Conclusion

    Have fun with these! Feel free to do with them as you will but keep 
in mind that I have not tested them on every other Linux distribution 
available and I cannot offer support to you if they don't work on yours. 
I would love to hear your comments and I will happily look at any 
suggestions for new features or code fixes but I do not have the time or 
inclination to run and test your modified versions, act as a beta tester 
or even offer useful advice if your changes are not working. I am NOT an 
expert; I am simply sharing tools that I use everyday.

    :)

    Joe Collins


Please be sure to give EzeeLinux a 'Like' on Facebook! Thanks! 
https://www.facebook.com/EzeeLinux Check out http://www.ezeelinux.com 
and http://www.freedompenguin.com for more about Linux. YouTube: 
https://www.youtube.com/user/BadEditPro


THIS SOFTWARE IS PROVIDED BY EZEELINUX "AS IS" AND ANY EXPRESS OR 
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
DISCLAIMED. IN NO EVENT SHALL EZEELINUX BE LIABLE FOR ANY DIRECT, 
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES 
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, 
STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN 
ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
POSSIBILITY OF SUCH DAMAGE.


