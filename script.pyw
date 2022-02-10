# Check file for new data.
import os
import time
import datetime

init = os.path.getmtime(r'C:\Users\Administrator\Dropbox\RemoteTurnOff\fileToWatch.txt')
a = datetime.datetime.now()
b = a + datetime.timedelta(0,3) # days, seconds, then other fields.
while True:
    check = os.path.getmtime(r'C:\Users\Administrator\Dropbox\RemoteTurnOff\fileToWatch.txt')
    if init == check:
        time.sleep(1)
        print('nothing changed')
    else:
        c = datetime.datetime.now()
        if b < c:
            os.system("shutdown /s /t 1")