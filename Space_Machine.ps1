$drives = @("C");# we can add more drive here by comma seperated
$minSize = 5GB;

$email_smtp_host = "smtpaddress";
$email_smtp_port = 25;
$email_smtp_SSL = 0;
$email_from_address = "fromemail@abc.com";
$email_to_addressArray = @("tomail1@abc.com", "tomail2@abc.com");

if ($drives -eq $null -Or $drives -lt 1) {
	$localVolumes = Get-WMIObject win32_volume;
	$drives = @();
    foreach ($vol in $localVolumes) {
	    if ($vol.DriveType -eq 3 -And $vol.DriveLetter -ne $null ) {
  		    $drives += $vol.DriveLetter[0];
		}
	}
}
foreach ($d in $drives) {
	Write-Host ("`r`n");
	Write-Host ("Checking drive " + $d + " ...");
	$disk = Get-PSDrive $d;
	if ($disk.Free -lt $minSize) {
		Write-Host ("Drive " + $d + " has less than " + $minSize `+ " bytes free (" + $disk.free + "): sending e-mail...");
		
		$message = new-object Net.Mail.MailMessage;
		$message.From = $email_from_address;
		foreach ($to in $email_to_addressArray) {
			$message.To.Add($to);
		}
		$message.Subject = 	("[LowSpace] WARNING: " + $env:computername + " drive " + $d);
		$message.Subject +=	(" has less than " + $minSize + " bytes free ");
		$message.Subject +=	("(" + $disk.Free + ")");
		$message.Body =		"Team, `r`n`r`n";
		$message.Body +=	"`r`n";
		$message.Body += 	("Machine HostName: " + $env:computername + " `r`n");
		$message.Body += 	"Machine IP Address(es): "+ (gwmi win32_networkadapterconfiguration -filter 'ipenabled=true').IpAddress[0];
		$ipAddresses = (gwmi win32_networkadapterconfiguration -filter 'ipenabled=true').IpAddress[0];
		foreach ($ip in $ipAddresses) {
		    if ($ip.IPAddress -like "127.0.0.1") {
			    continue;
			}
		    $message.Body += ($ip.IPAddress + " ");
		}
		$message.Body += 	"`r`n";
		$message.Body += 	("Used space on drive " + $d + ": " + (($disk.Used/1024)/1024)/1024 + " Giga bytes. `r`n");
		$message.Body += 	("Free space on drive " + $d + ": " + (($disk.Free/1024)/1024)/1024 + " Giga bytes. `r`n");
		$message.Body += 	"--------------------------------------------------------------";
		$message.Body +=	"`r`n`r`n";
		$message.Body += 	"This mail will be sent if the free space in the machine is less than 5GB ";
		$message.Body +=	("than " + $minSize + " bytes `r`n`r`n");
        $message.Body +=        "";

		$smtp = new-object Net.Mail.SmtpClient($email_smtp_host, $email_smtp_port);
		$smtp.EnableSSL = $email_smtp_SSL;
		$smtp.send($message);
		$message.Dispose();
		write-host "... E-Mail sent!" ; 
	}
	else {
		Write-Host ("Drive " + $d + " has more than " + $minSize + " bytes free: nothing to do.");
	}
}
