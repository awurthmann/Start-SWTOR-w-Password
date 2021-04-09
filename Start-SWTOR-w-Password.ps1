#powershell.exe


# Written by: Aaron Wurthmann
#
# You the executor, runner, user accept all liability.
# This code comes with ABSOLUTELY NO WARRANTY.
# This is free and unencumbered software released into the public domain.
# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a compiled
# binary, for any purpose, commercial or non-commercial, and by any
# means.
#
# --------------------------------------------------------------------------------------------
# Name: Start-SWTOR-w-Password.ps1
# Version: 2021.04.08.181901
# Description: Stores password in a non-portable encrypted format within a file. Uses file to 
#	retrieve and unencrypt the password, copies it to the clipboard then launches SWTOR and pastes it.
#	Clears the clipboard for good measure.
#	Non-portable in this case means the file cannot be reliably decrypted between Windows users and or systems.
#	Recreate the key file per Windows user or system.
# 
# Instructions: 
#	Copy launchSwtor.bat and Start-SWTOR-w-Password.ps1 to the same directory. Double click launchSwtor.bat
#
# Tested with: 
#	Microsoft Windows [Version 10.0.19042.804]
#	PowerShell [Version 5.1.19041.610]
#	SWTOR Launcher [Version 3.2.6.0]
# Arguments: [optional] KeyFile 
#						
# Output: None
#
# Notes: Unsupported. I am not likely to update the code for this script. This was a one-off/request from someone.
# --------------------------------------------------------------------------------------------

Param ([string]$KeyFile=$([Environment]::GetFolderPath("MyDocuments"))+"\Star Wars - The Old Republic\account.key")

##Admin Check##
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))  {  
  $arguments = "& '" +$myinvocation.mycommand.definition + "'"
  Start-Process powershell -Verb runAs -ArgumentList $arguments
  Break
}
##End Admin Check##

##Show-Process##
function Show-Process($Process, [Switch]$Maximize) {
  $sig = '
    [DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
    [DllImport("user32.dll")] public static extern int SetForegroundWindow(IntPtr hwnd);
  '
  
  if ($Maximize) { $Mode = 3 } else { $Mode = 4 }
  $type = Add-Type -MemberDefinition $sig -Name WindowAPI -PassThru
  $hwnd = $process.MainWindowHandle
  $null = $type::ShowWindowAsync($hwnd, $Mode)
  $null = $type::SetForegroundWindow($hwnd) 
}
##End Show-Process##

##Create File##
If (!(Test-Path $KeyFile)) {
	$Password = Read-Host "Enter Password"
	$SecureString = $Password | ConvertTo-SecureString -AsPlainText -Force
	$SecureString | ConvertFrom-SecureString | Out-File $KeyFile
	Clear-Variable Password,SecureString
}
##End Create File##

##Main##
If (Test-Path $KeyFile) {
	Write-Progress -Activity "Start SWTOR with Stored Password" -Status "Locating SWTOR install directory"	
	$regKey="HKLM:\SOFTWARE\WOW6432Node\BioWare\Star Wars-The Old Republic"
	$launcher=$((Get-ItemProperty $regKey)."Install Dir")+"\launcher.exe"
	
	If (Test-Path $launcher) {
		Write-Progress -Activity "Start SWTOR with Stored Password" -Status "Launcher.exe located"
		$launcherStarted=$False
		Write-Progress -Activity "Start SWTOR with Stored Password" -Status "Starting Launcher.exe"
		$procLauncher=Start-Process $launcher -PassThru
		
		$WaitCounter=0
		$WaitLimit=10

		While ($launcherStarted -eq $False){
			If ((Get-Process).ProcessName -contains "launcher") {
				$launcherStarted=$True
				Start-Sleep -Seconds 1
				break
			}
			Else {
				$WaitCounter++
				$percCounter=$WaitCounter*(100/$WaitLimit)
				Write-Progress -Activity "Start SWTOR with Stored Password" -Status "Starting Launcher.exe" -PercentComplete $percCounter
				If ($WaitCounter -gt $WaitLimit){
					break
				}
				Start-Sleep -Seconds 1
			}
		}
		
		If ($launcherStarted){
			Write-Progress -Activity "Start SWTOR with Stored Password" -Status "Launcher Started"
			add-type -AssemblyName Microsoft.VisualBasic
			add-type -AssemblyName System.Windows.Forms
			
			Write-Progress -Activity "Start SWTOR with Stored Password" -Status "Getting Password"
			$SecureString=Get-Content $KeyFile | ConvertTo-SecureString
			$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString)
			$Password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
			
			Set-Clipboard $Password
			If($Password){Clear-Variable Password}
			If($BSTR){Clear-Variable BSTR}
			If($SecureString){Clear-Variable SecureString}
			
			Show-Process -Process $procLauncher
			
			$waitSecs=5
			for ($i = 1; $i -le $waitSecs; $i++ ){
				Write-Progress -Activity "Start SWTOR with Stored Password" -Status "Waiting $waitSecs seconds..." -PercentComplete $($i*(100/$waitSecs))
				Start-Sleep -Seconds 1
			}
			
			Write-Progress -Activity "Start SWTOR with Stored Password" -Status "Sending password"
			[System.Windows.Forms.SendKeys]::SendWait("^v")
			[System.Windows.Forms.Clipboard]::Clear()
			
			$StarParse=$($env:LOCALAPPDATA)+"\StarParse\StarParse.exe"
			If (Test-Path $StarParse){
				
				Write-Progress -Activity "Start SWTOR with Stored Password" -Status "StarParse Found"
				If ((Get-Process).ProcessName -notcontains "StarParse"){
					$swtorStarted=$False
					$WaitCounter=0
					$WaitLimit=30
					while ($swtorStarted -eq $False) {
						If ((Get-Process).ProcessName -contains "swtor") {
							$swtorStarted=$True
							Start-Sleep -Seconds 1
							break
						}
						Else {
							$WaitCounter++
							$percCounter=$WaitCounter*(100/$WaitLimit)
							Write-Progress -Activity "Start StarParse After Login Complete" -Status "Waiting for login to be completed" -PercentComplete $percCounter

							If ($WaitCounter -gt $WaitLimit){
								break
							}
							Start-Sleep -Seconds 1
						}
					}
					
					If ($swtorStarted) {$procStarParse=Start-Process $StarParse -PassThru}
					
				}
				Else {
					Write-Progress -Activity "Start SWTOR with Stored Password" -Status "StarParse already running"
				}
			}
			
			
		}
		Else {
			Write-Progress -Completed
			$msg="`nERROR: launcher.exe was not detected."
			Write-Error -Message $msg -Category OperationTimeout
		}
	}
	Else {
		Write-Progress -Completed
		$msg="`nERROR: SWTOR Installation was not found"
		Write-Error -Message $msg -Category OpenError
	}
	
}
##End Main##

