# Start-SWTOR-w-Password

## Legal
You the executor, runner, user accept all liability.
This code comes with ABSOLUTELY NO WARRANTY.
This is free and unencumbered software released into the public domain.
Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

## Notes:
Unsupported. I am not likely to update the code for this script. This was a one-off/request from someone.

## Instructions:
Copy "launchSwtor.bat" and "Start-SWTOR-w-Password.ps1" to the same directory. Double click "launchSwtor.bat".  
The first time you run the script you will be prompted for your password. Please type it carefully.  
Your password is stored in an encrypted string in a file. Default location: "Documents\Star Wars - The Old Republic\account.key".  
The encryption method used is non-portable. Non-portable in this case means the file cannot be reliably decrypted between Windows users and or systems. Recreate the key file per Windows user or system.  

In the event that you change your password on the Star Wars - The Old Republic website or mistyped your password you will need to delete the "key file" and rerun the script. Default location: "Documents\Star Wars - The Old Republic\account.key".

## Optional Instructions - Pin to taskbar/Start menu
Unpin any existing apps with the name "Star Wars - The Old Republic" from your taskbar/Start menu. Alternatively you can ammend the instructions below and rename the shortcut to a different name. Example: "Star Wars - The Old Republic Auto Login"

Download "launchSwtor.bat" and "Start-SWTOR-w-Password.ps1" to your "Documents\Star Wars - The Old Republic" folder.  
![alt text](https://raw.githubusercontent.com/awurthmann/Start-SWTOR-w-Password/main/optional/pics/1.%20Download%20to%20Folder.png)

Right Click "launchSwtor.bat" and select "Create shortcut"  
![alt text](https://raw.githubusercontent.com/awurthmann/Start-SWTOR-w-Password/main/optional/pics/2.%20Create%20Shortcut.png)

Rename Shortcut to "Star Wars - The Old Republic" or a name of your chosing.  
![alt text](https://raw.githubusercontent.com/awurthmann/Start-SWTOR-w-Password/main/optional/pics/3.%20Rename%20Shortcut.png)

Right Click the new Shortcut, click Properties and Click the "Change Icon" button  
![alt text](https://raw.githubusercontent.com/awurthmann/Start-SWTOR-w-Password/main/optional/pics/4.%20Right%20click%2C%20Change%20icon.png)

Click "OK"  
![alt text](https://raw.githubusercontent.com/awurthmann/Start-SWTOR-w-Password/main/optional/pics/5.%20Click%20ok.png)

Navitate to where SWTOR is installed, current default: "C:\Program Files (x86)\Electronic Arts\BioWare\Star Wars - The Old Republic"
Select "launcher.exe"  
![alt text](https://raw.githubusercontent.com/awurthmann/Start-SWTOR-w-Password/main/optional/pics/6.%20Nav%20to%20swtor%20Select%20launcher.png)

Click "OK"  
![alt text](https://github.com/awurthmann/Start-SWTOR-w-Password/blob/main/optional/pics/7.%20Click%20ok.png)

Add "cmd /c" to the "Target" field in the Shortcut and click "OK" to close the Shortcuts properties  
![alt text](https://raw.githubusercontent.com/awurthmann/Start-SWTOR-w-Password/main/optional/pics/8.%20Add%20cmd%20c%20to%20Target%20Click%20ok.png)

The three files in the directory should appear as such:  
![alt text](https://raw.githubusercontent.com/awurthmann/Start-SWTOR-w-Password/main/optional/pics/9.%20New%20Icon%20Look.png)

Right Click the Shortcut and select "Pin to taskbar" or "Pin to start"  
![alt text](https://raw.githubusercontent.com/awurthmann/Start-SWTOR-w-Password/main/optional/pics/10.%20Right%20click%20and%20pin%20to%20task%20or%20start.png)
