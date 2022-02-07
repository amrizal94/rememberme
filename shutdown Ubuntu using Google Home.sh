https://askubuntu.com/questions/1146814/how-can-i-remotely-shutdown-ubuntu-using-google-homeOK. After some time I got it working.

I achieved turning off Ubuntu by using IFTTT, Dropbox and inotifywait (inotifywait is a tool that can run scripts or commands when some file or folder changes).

It looks something like this: I ask Google Home to turn off PC -> Google Home asks IFTTT to change file in Dropbox -> inotifywait sees the change in the file and make PC power-off.

Step by step:

Go to https://www.dropbox.com and register if you don't have account.

Go to https://www.dropbox.com/install Download package for ubuntu, install this package by double clicking.

Open Dropbox in apps menu, go through the process of connecting your account. Now you should have a "Dropbox" folder in your "Home" folder. Create folder "RemoteTurnOff" in "Dropbox" folder. Inside "RemoteTurnOff" folder create file "fileToWatch.txt" You can do this by going to your apps, open "Text Editor" now choose 3 dots menu, press "Save as" and find and choose RemoteTurnOff folder. Don't forget to change file name to "fileToWatch.txt"

Inside "RemoteTurnOff" folder create file "script.sh" You can do this by going to your apps, open "Text Editor". Paste this code to editor:

#!/bin/sh
### BEGIN INIT INFO
# Provides:          filenotifier
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Something
# Description:       Something else
### END INIT INFO
cd /home/YOUR_USER_NAME/Dropbox/RemoteTurnOff
inotifywait -e close_write,moved_to,create -m . |
while read -r directory events filename; do
  if [ "$filename" = "fileToWatch.txt" ]; then
    systemctl poweroff
  fi
done
Important: Change YOUR_USER_NAME to your user name. If you don't know your user name: open Terminal and type

whoami
Now press on 3 dots menu in text editor, press "Save as" and find and choose RemoteTurnOff folder. Don't forget to change file name to "script.sh"

Right click on script.sh -> Properties -> Permissions -> click on "Allow executing file as program" (it should be checked).
To be sure it's executable do this: Right click on empty space inside RemoteTurnOff folder. Choose "Open In Terminal" Run this command:

sudo chmod +x script.sh
You can now test if script works. Open RemoteTurnOff folder, right click on empty space, choose "Open in Terminal", type:
./script.sh

Don't close the terminal, open "fileToWatch.txt" in editor, type some text, save the changes. Your computer should shutdown. If it did shutdown then everything's OK - continue.

Lets make the script run in background on startup. Open terminal, past command:
cd /etc

past command

sudo nano rc.local
You should now be in text editor mode. Paste this text to editor:

#!/bin/sh -e
sh '/home/YOUR_USER_NAME/Dropbox/RemoteTurnOff/script.sh' &
exit 0
You need to change YOUR_USER_NAME to your name (use whoami command in another terminal window to get the name, if you don't know it). Don't forget "&" sign at the end of second line!

Press Ctrl+O to save it. Press Enter to confirm name. It should look like this: pic

Press Ctrl+X to exit text editor mode in terminal.

Now run this command to make rc.local executable:

sudo chmod +x rc.local
Now the script should start at startup in background. Test it: reboot, than go to Dropbox -> RemoteTurnOff open "fileToWatch.txt", paste some text and save. The PC should reboot. All hard work is done. Next we'll connect Dropbox to Google Home.

Go to https://ifttt.com/ Register (it's better to use google account for registration)

Go to https://ifttt.com/services/google_assistant/settings Connect to your Google Home. Make sure the status is active.

Go to https://ifttt.com/services/dropbox/settings Connect your Dropbox. Make sure the status is active.

On IFTTT site lets create new applet. Click on "My applets" and then on "Create applet".

Press on "+ this", search for "assistant", click on "Google Assistant"

Choose "Say a simple phrase".

On next screen fill in phrase you will use to talk to google home. In my case it looks something like this: pic Then press on "Create trigger"

Press on "+ that" Search for "Dropbox", choose "Dropbox". On next screen choose third option: "Append to a text file"

Fill info:

file name -> "fileToWatch.txt"

content -> "#" (it can be any symbol)

dropbox folder path -> "RemoteTurnOff/"

pic

Click on "Create action". It's better to disable notification - it gets annoying.

Now tell your google home to "turn Off computer".

I may have forgotten some steps. Please tell me if it didn't work, I'll help you and fix instruction. Tested on Ubuntu 18.04 LTS. I didn't create question just to answer it. I didn't knew the answer when I created the question.

To turn PC on using Google Home you don't need to do anything in ubuntu: there is a lot of instructions how to do it using WOL and android. Just type "turn on PC with google home" in google search.
