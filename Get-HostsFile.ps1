function Get-HostsFile {
    param
        (
            $ComputerName = $env:COMPUTERNAME,
            [switch]$DefaultSystem32
        )
    begin
    {
    }
    process
    {
        if($DefaultSystem32)
        {
            $SystemDrive = 'C'
            $SystemDirectory = '\Windows\system32'
        }
        else
        {
            $WMIObject = Get-WmiObject -Class Win32_OperatingSystem -Property SystemDirectory,SystemDrive -ComputerName $ComputerName
            $SystemDrive = $WMIObject.SystemDrive -replace ':',''
            $SystemDirectory = $WMIObject.SystemDirectory -replace "$($SystemDrive):",""
        }
        Get-Content "\\$($ComputerName)\$($SystemDrive)`$$($SystemDirectory)\drivers\etc\hosts" | ? {$_ -notlike "`#*" -and $_.Trim() -ne ''} | % {
            $splitObj = $_ -split '\s+|\t+' # split on spaces and tabs
            [PSCustomObject]@{
                'Name' = $splitObj[1];
                'IPAddress' = $splitObj[0];
            } #end object
        } #end foreach
    } #end process
} #end function
