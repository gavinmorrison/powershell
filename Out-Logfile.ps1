function Out-LogFile {
<#
    .NOTES
        Author: Gavin Morrison (gavin@gavin.pro)

    .DESCRIPTION
        Allows for redirection of PowerShell output to log file(s). Rather than creating seperate logging functions
        (e.g. 'Write-SuperLogFile'), this allows the use of native PowerShell outputs (Write-Output, Write-Verbose etc.)
        and redirects them to file(s) on disk whilst still showing them on the console (if appropiate).

    .EXAMPLE
        .\MyScript.ps1 -Verbose *>&1 | Out-LogFile -LogPath C:\Logs\ -Verbose

    .EXAMPLE
        function Do-Stuff {
            [CmdletBinding()]
            param()
            Write-Verbose "Verbose message."
            Write-Warning "Warning message."
        }
        Do-Stuff -Verbose *>&1 | Out-LogFile -LogPath C:\Logs\ -Verbose   
#>    
    [CmdletBinding()]
    param
    (
        [Parameter(ValueFromPipeline)]
            $PipelineInput,
        [Parameter()]
        [ValidateScript({Test-Path $_})]
            $LogPath, 
        [Parameter()]
            $OutputLogPrefix = @('log'),
        [Parameter()]
            $ErrorLogPrefix = @('error','log'),
        [Parameter()]
            $WarningLogPrefix = @('warning','log'),
        [Parameter()]
            $VerboseLogPrefix = @('log'),
        [Parameter()]
            $DebugLogPrefix = @('debug'),
        [Parameter()]
            $InfoLogPrefix = @('log'),
        [Parameter()]
        [switch]
            $SuppressOutput
    )
    Begin
    {
        function New-LogOutput {
            param($LogMessage, $OutputLevel, $LogPath, $LogPrefix)
            $LogPrefix | ForEach-Object {
                $FullLogPath = ("$($LogPath)\$($_)_$(Get-Date -UFormat %Y%m%d)`.log" -replace '\\','\')
                "[$(Get-Date)][$($OutputLevel)] $($LogMessage)" | Out-File -FilePath $FullLogPath -Append
            }
        }
    }
    Process
    {
        switch($PipelineInput.GetType().Name)
        {
            'String'
            {
                $LogMessage = $PipelineInput
                $OutputLevel = 'LOG'
                if(!$SuppressOutput) { Write-Output -InputObject $LogMessage }
                New-LogOutput -LogMessage $LogMessage -OutputLevel $OutputLevel -LogPath $LogPath -LogPrefix $OutputLogPrefix
            }
            'ErrorRecord'
            {
                $LogMessage = $PipelineInput.Exception.Message
                $OutputLevel = 'ERROR'
                if(!$SuppressOutput) { Write-Error -Message $LogMessage -ErrorAction Continue }
                New-LogOutput -LogMessage $LogMessage -OutputLevel $OutputLevel -LogPath $LogPath -LogPrefix $ErrorLogPrefix
            }
            'WarningRecord'
            {
                $LogMessage = $PipelineInput.Message
                $OutputLevel = 'WARN'
                if(!$SuppressOutput) { Write-Warning -Message $LogMessage }
                New-LogOutput -LogMessage $LogMessage -OutputLevel $OutputLevel -LogPath $LogPath -LogPrefix $WarningLogPrefix
            }
            'VerboseRecord'
            {
                $LogMessage = $PipelineInput.Message
                $OutputLevel = 'VERBOSE'
                if(!$SuppressOutput) { Write-Verbose -Message $LogMessage }
                New-LogOutput -LogMessage $LogMessage -OutputLevel $OutputLevel -LogPath $LogPath -LogPrefix $VerboseLogPrefix
            }
            'DebugRecord'
            {
                $LogMessage = $PipelineInput.Message
                $OutputLevel = 'DEBUG'
                if(!$SuppressOutput) { Write-Debug -Message $LogMessage }
                New-LogOutput -LogMessage $LogMessage -OutputLevel $OutputLevel -LogPath $LogPath -LogPrefix $DebugLogPrefix
            }
            'InformationRecord'
            {
                $LogMessage = $PipelineInput
                $OutputLevel = 'INFO'
                if(!$SuppressOutput) { Write-Information -MessageData $LogMessage }
                New-LogOutput -LogMessage $LogMessage -OutputLevel $OutputLevel -LogPath $LogPath -LogPrefix $InfoLogPrefix
            }
        }
    }
}
