function Write-Everything {
[CmdletBinding()]
param()
    Write-Output 'This is an output.'
    Write-Warning 'This is a warning.'
    Write-Verbose 'This is a verbose.'
    Write-Information 'info log!'
    Write-Error 'This is an error.'
}

function Out-LogFile {
    [CmdletBinding()]
    param
    (
        [Parameter(ValueFromPipeline)]$PipelineInput,
        $OutputLogPath,
        $ErrorLogPath,
        $WarningLogPath,
        $VerboseLogPath,
        $DebugLogPath,
        $InfoLogPath,
        $GlobalLogPath,
        [switch]$SuppressOutput
    )
    Begin
    {
        function New-LogOutputString {
            param($LogMessage, $OutputLevel)
            return "[$(Get-Date)][$($OutputLevel)] $($LogMessage)"
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
            }
            'ErrorRecord'
            {
                $LogMessage = $PipelineInput.Exception
                $OutputLevel = 'ERROR'
                if(!$SuppressOutput) { Write-Error -Message $LogMessage -ErrorAction Continue }
            }
            'WarningRecord'
            {
                $LogMessage = $PipelineInput.Message
                $OutputLevel = 'WARN'
                if(!$SuppressOutput) { Write-Warning -Message $LogMessage }
            }
            'VerboseRecord'
            {
                $LogMessage = $PipelineInput.Message
                $OutputLevel = 'VERBOSE'
                if(!$SuppressOutput) { Write-Verbose -Message $LogMessage }
            }
            'DebugRecord'
            {
                $LogMessage = $PipelineInput.Message
                $OutputLevel = 'DEBUG'
                if(!$SuppressOutput) { Write-Debug -Message $LogMessage }
            }
            'InformationRecord'
            {
                $LogMessage = $PipelineInput
                $OutputLevel = 'INFO'
                if(!$SuppressOutput) { Write-Information -MessageData $LogMessage }
            }
        }
        Write-Host (New-LogOutputString -LogMessage $LogMessage -OutputLevel $OutputLevel)
    }
}


Write-Everything -verbose *>&1 | Out-LogFile
