function Get-O365IPAddresses {
<#
.SYNOPSIS
	Downloads the Office 365 IP addresses from Microsoft and returns them as PowerShell objects.
.PARAMETER Product
	The product(s) for which you want IP addresses for. Naming is based on the naming in the XML file.
.PARAMETER AddressType
	The type of address (IPv4, IPv6 or URL) required.
.EXAMPLE
	Get-O365IPAddresses
.EXAMPLE
	Get-O365IPAddresses -Product 'O365','EOP' -AddressType 'IPV4'
.NOTES
	Author:	Gavin Morrison (gavin <at> gavin.pro)
	Version: 0.3

	0.1		11/03/2016	Initial version.
	0.2		13/03/2016	Added comment based help.
	0.3		08/06/2016	Added ability to use local XML file and updated product validation.
#>
[CmdletBinding()]
param
(
	[ValidateSet('o365','LYO','Planner','ProPlus','OneNote','WAC','Yammer','EXO','identity','SPO','RCA','Sway','Office365Video','OfficeMobile','CRLs','OfficeiPad','EOP')]
	[String[]]
	$Product,
	[ValidateSet('IPV4','IPV6','URL')]
	[String[]]
	$AddressType,
	[String]
	$LocalPath
)
	if($LocalPath)
	{
		$O365IPAddresses = [xml](Get-Content -Path $LocalPath)	
	}
	else
	{
	    $O365IPAddresses = [xml](Invoke-WebRequest -UseBasicParsing -Uri 'https://support.content.office.net/en-us/static/O365IPAddresses.xml')	
	}
	$Updated = ([datetime]$O365IPAddresses.products.updated)
	$O365IPAddresses.products.product | % {if($Product.Count -ge 1 -and $Product -eq $_.name) {$_} elseif($Product.Count -lt 1) {$_}} | % {
		$xmlProduct = $_.name
		$_.addresslist | % {if($AddressType.Count -ge 1 -and $AddressType -eq $_.type) {$_} elseif($AddressType.Count -lt 1) {$_}} | % {
			$xmlAdressType = $_.type
			$_.address | % {
				[PSCustomObject]@{
					'Product' = $xmlProduct;
					'AddressType' = $xmlAdressType;
					'Address' = $_;
					'Updated' = $Updated;
				}
			}
		}
	}
}