#Just to print drives with free space available
get-psdrive |where-Object {$_.free -gt 1}  | foreach-object {$c =0; write-host "enter in to for loop `n"} {$c=$c+$_.Free;write-host "inside for loop " $_.root "has free space of " ("{0:N2}" -f ($_.Free/1gb)) "GB" "has used space of " ("{0:N2}" -f ($_.Used/1gb)) "GB"  -foregroundcolor green} {Write-host "`nend of for loop`nTotal Free Space is " ("{0:N2}" -f ($c/1gb)) "GB"}