# PowerShell
A selection of assorted PowerShell utilities that are too small for a repo of their own.

**CAUTION:** Some of these are quick and dirty functions written for a specific purpose, use them at your own risk. 

## ConvertFrom-CidrNotation
Converts strings written in CIDR notation (e.g. 127.0.0.1/8) to an object with the address and subnet mask.

## Get-DMARCReport
Parses the output of a DMARC report and returns a PowerShell object.

## Get-EopIpAddresses
Scrapes TechNet for the Exchange Online Protection IP addresses.

## Get-HostsFile
Reads the Windows hosts file and returns the contents as an object.

## Get-LyncVersion
Queries a given SIP domain and attempts to determine the version of Lync / Skype for Business being used.

## Get-O365IPaddresses
Parses the Office 365 IP addresses file published by Microsoft and returns the contents as an object.
