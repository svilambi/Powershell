# Powershell
Powershell

Start-Transcript  --> so store the session in text file
Start-Transcript  -Path c:\test.txt --> so store the session in text file in specified path

Get-Command  --> to list of commands or functions


Get-Command  -Noun service --> to list of commands or functions which has service keyword

get-service  --> to get list of services on local machine

get-help get-service  --> to get details about get-service
get-help get-service  -Examples --> to get Examples about get-service
get-help get-service  -Online --> to view in browser about get-service

get-alias --> to list of alias of the commands, it is used to assign alias name for the command

get-process  --> to get the list of process on local machine

open MicrosoftEdge

get-process  -Name MicrosoftEdge --> to get the MicrosoftEdge of process on local machine

get-process  -Name MicrosoftEdge | select-object * --> to get the MicrosoftEdge all properties ,  here first command get the process and pass it to second command seelct-object *

$test= Get-Process MicrosoftEdge  --> assign the properties to test variable

$test  --> to print properties
$test.name  --> to print name variable
$test.kill()  --> to kill the process of MicrosoftEdge

get-history  --> to get the list of commands for this session

`n  --> to get new line while using write-host

