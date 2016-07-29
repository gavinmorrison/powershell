function Connect-O365 {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateSet('EXO','CC','MSOL')]
            $Service,
        [Parameter()]
            $Credential = (Get-Credential)
    )
    switch($Service)
    {
        {
            'EXO','CC' -contains $_
        }
            {
                switch($_)
                {
                    {
                        'EXO' -contains $_
                    }
                        {
                            if(Get-Command 'Get-EXOUser' -ErrorAction SilentlyContinue) { $AlreadyConnected = $TRUE } 
                            $ConnectionURI = 'https://outlook.office365.com/powershell-liveid/'
                        }
                    {
                        'CC' -contains $_
                    }
                        {
                            if(Get-Command 'Get-CCUser' -ErrorAction SilentlyContinue) { $AlreadyConnected = $TRUE } 
                             $ConnectionURI = 'https://ps.compliance.protection.outlook.com/powershell-liveid/'
                        }
                }
                if(!$AlreadyConnected)
                {
                    $PSSession = New-PSSession `
                        -ConfigurationName Microsoft.Exchange `
                        -ConnectionUri $ConnectionURI `
                        -Credential $Credential `
                        -Authentication Basic `
                        -ErrorAction Stop `
                        -AllowRedirection
                    $NULL = Import-PSSession -Session $PSSession -ErrorAction Stop -Prefix $_
                }

            }
        {
            'MSOL' -contains $_
        }
            {
                ## We always connect to MSOL service, even if we think one already exists as it's a bit quirky.
                Connect-MsolService -Credential $Credential -ErrorAction Stop
            }
    }
}
