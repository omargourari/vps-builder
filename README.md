## Usage
1. add variables to setup.conf file
2. add cloudflare origin certificates
3. modify and push /files/nginx/nginx-sitename
4. ```source setup.conf && ssh ubuntu@151.80.148.22 -p 22 -o "PreferredAuthentications=password" -o "StrictHostKeyChecking=accept-new" 'sudo su && sudo bash ' < ./setup.sh```

## Features
1.  update the whole system and upgrade apt packages
2.  install grafana, java, jenkins, logwatch (without mail setup), nginx, promethesu, supervisord, tmux, tmuxinator, 
3.  find a way to enable autosuggestions on vps shell from the start   
4.  create local private/public keys with server keys
5.  create .ssh/config record for new server
6.  add keys to agent
7.  create alias to local .zshrc
8.  add download .zshrc file
9.  add hosts management https://gist.github.com/irazasyed/a7b0a079e7727a4315b9
10. check failtoban and set it up (https://gist.github.com/smaffulli/de8f6eb097fdedad0e8c3487953967ff)
11. modify sudo ask time
12. add chmod to home and websites folder
13. solve jenkins not sudo users doing the jobs
14. install python and pyenv ```sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev git```
15. move change ssh port over ufw
16. delete user ubuntu after reboot
17. reboot and re-login
18. install let's encrypt
19. how much sudo apt-get update run before installation of single packages?
20. iptables?
21. sudo permissions for new user
22. change user to new user
23. modify hosts file and add 127.. plius subdomains
    
## Done
- modificato /etc/ssmtp/ssmtp.conf e aggiunto credenziali account google
- creata nuova password per sendmail trmaite gmail da qua(https://myaccount.google.com/apppasswords?rapt=AEjHL4M08gXnA6Gu4g_8elFhvtCYP8bsH8RT8660pkuk6FfpKkYm1I6mL1jYZFm83_VTwEBPVYRJt3JK1dzBFbun8K4tGp7Aag)

------------------------------------------------------------------------------------------------------------------------
## What does it do ?

Script performs the following operations:-
1. [Create non-root user and give it "sudo" privilege](https://github.com/pratiktri/init-li-harden#1-create-non-root-user-and-give-it-sudo-privilege "Goto details of the step")
2. [Generate passphrage protected *ed25519* SSH Keys](https://github.com/pratiktri/init-li-harden#2-generate-passphrage-protected-ed25519-ssh-keys-private--public "Goto details of the step")
3. [Secure "authorized_keys" file](https://github.com/pratiktri/init-li-harden#3-secure-authorized_keys-file "Goto details of the step")
4. [[Optionally] Reset the url for apt repo from VPS provided CDN to OS provided ones](https://github.com/pratiktri/init-li-harden#4-optionally-reset-the-url--for-apt-repo-from-vps-provided-cdn-to-os-provided-ones "Goto details of the step")
5. [Update + Upgrade + Install softwares (sudo curl screen ufw fail2ban)](https://github.com/pratiktri/init-li-harden#5-updates--upgrades--installs-required-softwares-sudo--screen-ufw-fail2ban "Goto details of the step")
6. [Configure UFW](https://github.com/pratiktri/init-li-harden#6-configure-ufw "Goto details of the step")
7. [Configure Fail2Ban](https://github.com/pratiktri/init-li-harden#7-configure-fail2ban "Goto details of the step")
8. [Schedule cron for daily system update](https://github.com/pratiktri/init-li-harden#8-schedule-cron-for-daily-system-update "Goto details of the step")
9.  [[Optionally] Reset *root* password](https://github.com/pratiktri/init-li-harden#9-optionally-reset-root-password "Goto details of the step")
10. [Alter SSH options(/etc/ssh/sshd_config) to do the following:-](https://github.com/pratiktri/init-li-harden#10-alter-ssh-options "Goto details of the step")
   * Disable SSH login for *root* (PermitRootLogin no)
   * Disable SSH login through password for all users (PasswordAuthentication no) 
   * Updates path for *authoried_keys* file
11. [On successfully completing above operations, display the following on screen:-](https://github.com/pratiktri/init-li-harden#11-display-summary "Goto details of the step")
    * Username
    * User Password
    * SSH Private Key's path on the server
    * SSH Public Key's path on the server
    * SSH Private Key's passphrase
    * (If so opted) New *root* password
    * SSH Private Key
    * SSH Public Key


Step 2 & Step 5 are most time consuming operations. 

If you are stuck on Step 5 for more than 10 minutes, something went wrong in Step 4. Stop (ctrl + c) the script and check log file to see what went wrong.

Step 8 is the most dangerous operation. 

## Error Handling
Since the script has the potential to make you loose access to your server, it takes a number of steps to recover from an error.

### Back up files
Script creates a back of every file that it changes. 

Back up files are stored in the same directory as the original file. 

Back up file name = (Original File Name) + "." + (Script start timestamp in '%d_%m_%Y-%H_%M_%S' format) + "_bak"

So, if the original file name was *sshd_config* and the script was started at 25th January 2019 09:15:25, then the backup files name would be *sshd_config.25_01_2019-09_15_25_bak*

### Recovery
Script *tries* to recover from an error if it can determine that an error has occured. What it does to recover depends on which step the error has occured.

**Step 9 (Alter /etc/ssh/sshd_config) is where most danger resides. If this step fails & script can not successfully recovery - then you'll most likely loose all access to your system**.


## Details of each operation
### 1. Create non-root user and give it "sudo" privilege
You can specify your own username with "--username" or "-u" flag.

If the username provided already exists, then the script will terminate without doing any operation.

When accepting username through "--username", __*script actively rejects special characters in the name*__ because bash does not act well with special characters. The values accepted by the script [a-zA-Z0-9_-] i.e., alphanumeric and [_] and [-]

If "--username" is not provided, __*script will randomly generate an username for you*__. Script generated usernames are 9 character long and are alphanumeric (i.e., numbers & English characters).

Password for the user is __always__ randomly generated. Passwords are 15 character long and are alphanumeric as well.

#### Error Handling

> __Failure Impact__ - Minimal. An additional user on system. 
>
> __Restoration__ - Script tries to delete the user along with user's home directory
>
> __Impact of Restoration Failure__ - If the user will linger around in the system. You might have to manually delete the user and its home directory. 
>
> __After Error__ - Script will be terminated.


### 2. Generate passphrage protected *ed25519* SSH Keys (Private & Public)
Since password authentications are bad security practice, script will generate a SSH Key and use that for user authentication. 

You need the following 3 to be able to access the server after the script is done:-
* Public Key
* Private Key
* Passphrase for the Key

 These 3 will be diplayed on screen at the end of the script. Copy them and __keep them safe. Without these you won't be able to access the server.__

We use OpenSSH keyformat and ed25519 algorithm to generate ours. You can read the reason for that [here](https://security.stackexchange.com/a/144044) and [here](https://stribika.github.io/2015/01/04/secure-secure-shell.html). For additional security the key is secured by a passphrase. This passphrase is randomly generated. Passphrase are 15 character long and are alphanumeric. Algorithm used for user's password and SSH Private Key's passphrase are the same.

Generated keys are placed in ".ssh" sub-directory of the user's (created in step 1 above) home-directory, i.e., /home/*__[username]__*/.ssh/

SSH Public Key is then *appended* to /home/*__[username]__*/.ssh/authorized_keys file.

#### Error Handling

> __Failure Impact__ - Minimal. An additional user on system. 
> 
> __Restoration__ - Script tries to delete the user along with user's home directory.
> 
> __Impact of Restoration Failure__ - If restoration of step 2 failed - most probably restoration on step 1 failed as well. At any case - just delete the user's home directory to rid your system of garbage files.
> 
> __After Error__ - Script will be terminated.


### 3. Secure "authorized_keys" file
"authorized_keys" file present in user's .ssh sub-directory contains the Public Key values. These Public Key values are used to authenticate user logins. Since, this is an important file we need to secure it tight. 

Following are the file access restrictions that the script applies:-
* Make *root* user the owner of /home/*__[username]__*/.ssh/ directory and all files inside it.
* Give *root* group access to /home/*__[username]__*/.ssh/ directory and all files inside it.
* Make the /home/*__[username]__*/.ssh/ directory and all files inside it visible only to the *root* user.
* Remove the editing rights on /home/*__[username]__*/.ssh/authorized_keys file from every user - including *root*.
* Make the /home/*__[username]__*/.ssh/authorized_keys file immutable.

#### Error Handling

> __Failure Impact__ - Minimal. An additional user on system. 
> 
> __Restoration__ - Reset the attributes of "authorized_keys" file. Then deletes the user and its home directory.
> 
> __Impact of Restoration Failure__ - User and its home directory would persist. Delete them manually. Some of the files have their attributes modified to make them immutable (i.e. *chattr +i* ), so while deleting user's home directory manually, remember to remove this attribute (i.e. "*chattr -i* ).
> 
> __After Error__ - Script will be terminated.


### 4. [Optionally] Reset the url  for apt repo from VPS provided CDN to OS provided ones

Most VPS provider change the location from which operating system downloads software from (i.e. *apt* repository); usually to CDNs that are maintained by them. While, this greatly improves time taken to install applications, it does come with its security implications (what if they insert tracker/sniffer in application?). 

However, one can also argue that if the OS (i.e. Linux) is installed by the providers, then OS itself is a more likely place where they might want to insert something dirty.

Depending on which argument you find valid, __you can use this option in the script to ensure the default OS-provided CDNs are used__. This is done by updating the [/etc/apt/sources.list](https://linoxide.com/debian/configure-sources-list-debian-9/) file.

If the script is started with --defaultsourcelist option, then for Debian http://deb.debian.org/debian is used and for Ubuntu http://archive.ubuntu.com/ubuntu/ is used.

This is disabled by default.

#### Error Handling

> __Failure Impact__ - In the worst case, you will not be able to update or install applications through *apt*. In the best case, Service providers CDN will continue to be used for *apt* to install & update applications. Script will continue to next step after restoration
> 
> __Restoration__ - Before execution, a back up of sources.list file was made. During restoration, this back up file is copied (over-written) over to sources.list file.
> 
> __Impact of Restoration Failure__ - You may not be able to install or update the system. Manually check if any *_bkp file exists in /etc/apt/ directory. If multiple file exist - use the most recent file and rename it to /etc/apt/sources.list
> 
> __After Error__ - Script continues to next step after restoration.


### 5. Updates + Upgrades + Installs required softwares (sudo  screen ufw fail2ban)
Pretty self-explanatory. 

#### Error Handling

> __Failure Impact__ - Both UFW and Fail2ban CANNOT be configured. So, major part of server hardening will not be successful.
> 
> __Restoration__ - Nothing to restore. However, do check the log file to see that went wrong. 
> 
> __Impact of Restoration Failure__ - None.
> 
> __After Error__ - Script continues to next step.
NOTE - As it is evident from above script does not uninstalled already installed programs even when error occors in this step or any other steps. Cause, you might have installed those programs before running the script or those programs might have been preloaded by the OS itself - too many variables to consider.



### 6. Configure UFW
[UFW(**U**ncomplicated **F**ire**W**all)](https://www.digitalocean.com/community/tutorials/how-to-setup-a-firewall-with-ufw-on-an-ubuntu-and-debian-cloud-server) makes it easy to manage what kind of internet traffic enters or leaves the server. Without this program you would have to deal with Linux's iptables (which I can not understand at all).

This script sets up UFW so that only __ssh__(required for user login), __http__(required for any web application) & __https__(also required for any web application) __traffic are allowed in and out__ of the server. All other traffic are blocked.

#### Error Handling

> __Failure Impact__ - Less secure server.
> 
> __Restoration__ - Disable UFW
> 
> __Impact of Restoration Failure__ - Most probably UFW was not installed properly. Check log file for details. 
> 
> __After Error__ - Continue to next step after restoration.


### 7. Configure Fail2Ban
While UFW restricts access to ports, the ports that are required (and are allowed by UFW in above step) for our purpose can be exploited by nefarious actors.

Fail2ban watches traffic coming through the allowed ports to determine if it is indeed a legitimate one. This determination is usually done by analyzing various *log files* being generated by Linux and other applications running on the server. If anything suspicious is found then after a certain number of illegitimate attempts the intruder(IP) is banned. Ban is then lifted after a desired amount of time.

This script sets up Fail2ban as following:-
* default ban time is 5 hours, 
* Whitelists your server's IP from detection (uses https://ipinfo.io/ip to determine the IP),
* sets (backend = polling). *polling* is an algoritm used to check if the *log files* are updated. This algorithm does not require any additional software and is faster option to choose for our configuration.
* Explicitly enables protection for *ssh* with (maxretry = 3) & (bantime = 2592000)

#### Error Handling

> __Failure Impact__ - Less secure server.
> 
> __Restoration__ - If back up of /etc/fail2ban/jail.local file found, then that is restored; else back up of /etc/fail2ban/jail.conf is restored. Also, back up of /etc/fail2ban/jail.d/defaults-debian.conf file restored if available.
> 
> __Impact of Restoration Failure__ - Potential corruption of Fail2ban configuration. Check log file for details.
> 
> __After Error__ - Continue to next step after restoration.


### 8. Schedule cron for daily system update
While it is a bad idea to schedule automatic installation of updates ([read more here](https://debian-administration.org/article/162/A_short_introduction_to_cron-apt)), sizable amount of server administration time can be saved by *downloading* updates when no one is looking.

In this step we schedule a daily crontab (/etc/cron.daily/linux_init_harden_apt_update.sh) to download updates. You would want to manually do the installation running the below command.

```console
user@host:~$ sudo apt-get dist-upgrade
```
#### Error Handling

> __Failure Impact__ - Minimal. No auto download of software updates
> 
> __Restoration__ - Remove the script file (/etc/cron.daily/linux_init_harden_apt_update.sh).
> 
> __Impact of Restoration Failure__ - The cron job might execute once a day and *fail*. You might have to delete the file (/etc/cron.daily/linux_init_harden_apt_update.sh) manually.
> 
> __After Error__ - Continue to next step.

### 9. [Optionally] Reset root password
Since, VPS providers sends you the password of your VPS's *root* user in email in plain text. So, password needs to be changed immediately. **But, since we will disable *root* login AND password login in the next step, changing *root* password might be an overkill**. But, still...

Also most VPS providers these days allow you to provide SSH Public Key in their website. If you have done that you can skip this step. **It is disabled by default anyways**.

To change your *root* password provide option *-r* or *--resetrootpw*. *root* password will be randomly generated. Passwords are 15 character long and are alphanumeric.

#### Error Handling

> __Failure Impact__ - None. Continue using existing password.
> 
> __Restoration__ - Nothing to restore.
> 
> __Impact of Restoration Failure__ - None.
> 
> __After Error__ - Continue to next step.

  
### 10. Alter SSH options
This step contines from step 3 to harden our ssh login. Here, we edit */etc/ssh/sshd_config* file to achieve the following:-
* Disable *root* login (**PermitRootLogin no**). No one needs to work on *root*. The new user created already has *root* privileges anyways.
* Disable password login (**PasswordAuthentication no**). This ensures we can ONLY login though SSH Keys.
* Specify where to find authorized public keys which are granted login (\\.ssh\authorized_keys %h\\.ssh\authorized_keys)

#### Error Handling

> __Failure Impact__ - Potentially __CATASTROPHIC__.
> 
> __Restoration__ - Delete user and its home directory; Disable UFW: If back up of /etc/fail2ban/jail.local file found, then that is restored; else back up of /etc/fail2ban/jail.conf is restored. Also, back up of /etc/fail2ban/jail.d/defaults-debian.conf file restored if available. Restore the /etc/ssh/sshd_config file from backup file created before the operation.
> 
> __Impact of Restoration Failure__ - Fatal. DO NOT logout of the session. If you do then, you may not be able to log back in. Check the log file to see what went wrong. Issue the following command and see what is the out put. Search the error message on internet for solution.
> ```console
> root@host:~# service sshd restart
> ```
> __After Error__ - Script will be terminated.