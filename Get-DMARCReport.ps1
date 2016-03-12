function Get-DMARCReport {
	param
	(
		[Parameter(ValueFromPipelineByPropertyName, Mandatory)]
		[Alias('FullName','Path')]
		$Name
	)
	Begin
	{
		function Convert-PassFailToBoolean($PassFail) {
			switch($PassFail) 
			{
				'Pass' {$true}
				'Fail' {$false}
			} #end switch
		} #end function
	} #end begin
	Process
	{
		$XmlReport = [xml](Get-Content -Path $Name)
		$ReportingOrganization = $XmlReport.feedback.report_metadata.org_name
		$StartDate = (Get-Date '1970-01-01 00:00:00').AddSeconds($XmlReport.feedback.report_metadata.date_range.begin)
		$EndDate = (Get-Date '1970-01-01 00:00:00').AddSeconds($XmlReport.feedback.report_metadata.date_range.end)
		$XmlReport | Select-Xml -XPath '/feedback/record' | Select-Object -ExpandProperty Node | % {
			$SourceIP = $Count = $DKIMPass = $SPFPass = $EnvelopeFrom = $HeaderFrom = $DKIMDomain = $SPFDomain = $DKIMDomainPass = $SPFDomainPass = $null
			$SourceIP = $_.row.source_ip
			$Count = $_.row.count
			$DKIMPass = (Convert-PassFailToBoolean $_.row.policy_evaluated.dkim)
			$SPFPass = (Convert-PassFailToBoolean $_.row.policy_evaluated.spf)
			$EnvelopeFrom = $_.identifiers.envelope_from
			$HeaderFrom = $_.identifiers.header_from
			$DKIMDomain = $_.auth_results.dkim.domain
			$SPFDomain = $_.auth_results.spf.domain
			$DKIMDomainPass = $_.auth_results.dkim.result
			$SPFDomainPass = $_.auth_results.spf.result
			[PSCustomObject]@{
				'ReportingOrganization' = $ReportingOrganization;
				'StartDate' = $StartDate;
				'EndDate' = $EndDate
				'SourceIP' = $SourceIP;
				'Count' = $Count;
				'DKIMPass' = $DKIMPass;
				'SPFPass' = $SPFPass;
				'EnvelopeFrom' = $EnvelopeFrom;
				'HeaderFrom' = $HeaderFrom;
				'DKIMDomain' = $DKIMDomain;
				'SPFDomain' = $SPFDomain;
				'DKIMDomainPass' = $DKIMDomainPass;
				'SPFDomainPass' = $SPFDomainPass;
			} #end object
		} #end foreach
	} #end process
} #end function
