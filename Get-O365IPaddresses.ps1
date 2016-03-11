function Get-O365IPAddresses {
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
	$O365IPAddresses.products.product | % {if($Product.Count -ge 1 -and $Product -eq $_.name) {$_} elseif(!($Product.Count -ge 1)) {$_}} | % {
		$xmlProduct = $_.name
		$_.addresslist | % {if($AddressType.Count -ge 1 -and $AddressType -eq $_.type) {$_} elseif(!($AddressType.Count -ge 1)) {$_}} | % {
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