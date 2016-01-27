function Get-LyncVersion {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$True)]
        [string]$Domain
    )
    $returnObj = New-Object -Type PSObject -Property @{
        'Version' = 'Undetermined'
        'Hosted' = $false
    }
    try
    {
        $lyncdiscoverWebRequest = Invoke-WebRequest -Uri "https://lyncdiscover.$($Domain)" -ErrorAction 'Stop'
    }
    catch [System.Net.WebException]
    {
        Write-Warning "Failed to make HTTPS request: $_"
    }
    catch
    {
        Write-Error $_
        break    
    }
    if(!$lyncdiscoverWebRequest)
    {
        try
        {
            $lyncdiscoverWebRequest = Invoke-WebRequest -Uri "http://lyncdiscover.$($Domain)" -ErrorAction 'Stop'
        }
        catch
        {
            Write-Error "Failed to make HTTP request: $_"
            break
        }
    }
    try
    {
        $dialinUri = ('https://' + (((ConvertFrom-Json $lyncdiscoverWebRequest.Content)._links.self.href).Split('/'))[2] + '/dialin')
        Write-Verbose "Dial-in URI: $dialinUri"
        if($dialinUri -like "*lync.com*")
        {
            Write-Verbose "Lync.com detected in URI, assuming hosted."
            $returnObj.Hosted = $true
        }
        $dialinWebRequest = Invoke-WebRequest -Uri $dialinUri -ErrorAction 'Stop'
        $dialinPageTitle = $dialinWebRequest.ParsedHtml.title
        Write-Verbose "Page title: $dialinPageTitle"
    }
    catch
    {
        Write-Error "Failed to query / parse dialin page: $_"
        break
    }
    switch($dialinPageTitle)
    {
        'Conferencing Dial-In Page - Skype for Business 2015' {$returnObj.Version = '2015'}
        'Microsoft Lync 2013' {$returnObj.Version = '2013'}
        'Microsoft Lync 2010' {$returnObj.Version = '2010'}
    }
    return $returnObj
}
