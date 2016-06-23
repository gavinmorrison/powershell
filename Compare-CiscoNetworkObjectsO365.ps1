function Compare-CiscoNetworkObjectsO365 {
<#
.SYNOPSIS
	Compares the published list of O365 IP addresses against a group of Cisco network objects.
.PARAMETER Product
	The product(s) for which you want IP addresses for. Naming is based on the naming in the XML file.
.PARAMETER AddressType
	The type of address (IPv4, IPv6 or URL) required.
.EXAMPLE
	Get-O365IPAddresses
.EXAMPLE
	Get-O365IPAddresses -Product 'O365','EOP' -AddressType 'IPV4'
.NOTES
	DO NOT USE A LEVEL 15 ACCOUNT WITH THIS SCRIPT IF RUNNING AS A SCHEDULED TASK. 
	The credentials will be encrypted using PowerShell's 'Secure String' functionality, but this is vunerable to 
	exploitation if a third party gains access to the Windows user account being used to run the script / scheduled task.

	Author:	Gavin Morrison (gavin <at> gavin.pro)
	Version: 0.1

	0.1		11/03/2016	Initial version.
	0.2		13/03/2016	Added comment based help.
	0.3		08/06/2016	Added ability to use local XML file and updated product validation.
#>

}