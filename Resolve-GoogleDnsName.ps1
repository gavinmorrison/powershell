function Resolve-GoogleDnsName {
<#
.SYNOPSIS
	Provides a PowerShell interface to Google's DNS-over-HTTPS API.
.DESCRIPTION
	Google's DNS-over-HTTPS API allows DNS queries to be made using HTTPS. This is useful in environments where direct 
	DNS lookups are not possible. The parameters are similar to the 'Resolve-DnsName' cmdlet, but the output is not.
.PARAMETER Name
	The name to resolve.
.PARAMETER Type
	The RR type to resolve as a string (defaults to 'A').
.PARAMETER DisableDNSSECValidation
	Disables DNSSEC validation.
.PARAMETER IncludePadding
	Sends pseduo-random data with the request in order to obfuscate the request. 
.EXAMPLE
	Resolve-GoogleDnsName -Name 'example.com'
.EXAMPLE
	Resolve-GoogleDnsName -Name 'example.com' -Type 'MX'
.EXAMPLE
	Resolve-GoogleDnsName -Name 'example.com' -Type 'MX' -DisableDNSSECValidation -IncludePadding
.NOTES
	Author: Gavin Morrison (gavin <at> gavin.pro)
	API: https://developers.google.com/speed/public-dns/docs/dns-over-https
#>
	[CmdletBinding()]
	param
	(
	[Parameter(Mandatory)]
	[String]
	[ValidateScript({$_.Length -le 253})]
	$Name,
	[Parameter()]
	[String]
	[ValidateSet('A','NS','MD','MF','CNAME','SOA','MB','MG','MR','NULL','WKS','PTR','HINFO','MINFO','MX','TXT','RP','AFSDB','X25','ISDN','RT','NSAP','NSAP-PTR','SIG','KEY','PX','GPOS','AAAA','LOC','NXT','EID','NIMLOC','SRV','ATMA','NAPTR','KX','CERT','A6','DNAME','SINK','OPT','APL','DS','SSHFP','IPSECKEY','RRSIG','NSEC','DNSKEY','DHCID','NSEC3','NSEC3PARAM','TLSA','SMIMEA','HIP','NINFO','RKEY','TALINK','CDS','CDNSKEY','OPENPGPKEY','CSYNC','SPF','UINFO','UID','GID','UNSPEC','NID','L32','L64','LP','EUI48','EUI64','TKEY','TSIG','IXFR','AXFR','MAILB','MAILA','*','URI','CAA','AVC','TA','DLV')]
	$Type = 'A',
	[Parameter()]
	[Alias('DnssecCd')]
	[switch]
	$DisableDNSSECValidation,
	[Parameter()]
	[switch]
	$IncludePadding
	)
	$RequestUri = 'https://dns.google.com/resolve?name=' + $Name
	if($Type)
	{
		$RequestUri = $RequestUri + '&type=' + $Type
	}
	if($DisableDNSSECValidation)
	{
		$RequestUri = $RequestUri + '&cd=true'
	}
	if($IncludePadding)
	{
		$PaddingString = ''
		foreach($i in (1..(Get-Random -Minimum 10 -Maximum 100)))
		{
			$PaddingString = $PaddingString + (([GUID]::NewGuid()).ToString()).Replace('-','')
			$RequestUri = $RequestUri + '&random_padding=' + $PaddingString
		}
		Write-Output $PaddingString
	}
	(Invoke-RestMethod -Method GET -Uri $RequestURI).Answer
}
