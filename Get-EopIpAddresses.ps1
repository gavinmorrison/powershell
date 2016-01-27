function Get-EopIpAddresses {
	$OutputArray = @()
	$MatchFound = $FALSE
	$WebRequest = (Invoke-WebRequest -URI 'https://technet.microsoft.com/en-us/library/dn163583(v=exchg.150).aspx' | `
		Select -ExpandProperty Content).Split("`n")
	foreach($Line in $WebRequest)
	{
		if($Line -match '(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\/([1-2][0-9]|3[0-2]|[0-9]))')
		{
			$MatchFound = $true
			$OutputArray += $Line
		}
		elseif($MatchFound)
		{
			break
		}
	}
	return $OutputArray
}
