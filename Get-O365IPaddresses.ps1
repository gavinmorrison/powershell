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
#>
[CmdletBinding()]
param
(
	[ValidateSet('o365','LYO','ProPlus','SPO','WAC','EX-Fed','OfficeiPad','OfficeMobile','Yammer','RCA','EOP')]
	[String[]]
	$Product,
	[ValidateSet('IPV4','IPV6','URL')]
	[String[]]
	$AddressType
)
	$O365IPAddresses = [xml](Invoke-WebRequest -UseBasicParsing -Uri 'https://support.content.office.net/en-us/static/O365IPAddresses.xml')
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