function Write-Everything {
[CmdletBinding()]
param()
    Write-Output 'This is an output.'
    Start-Sleep -Seconds 2
    Write-Warning 'This is a warning.'
    Start-Sleep -Seconds 4
    Write-Verbose 'This is a verbose.'
}

function PipelineExplorer {
    Process
    {
        $InputFromPipeline = $_
        switch($_.GetType().Name)
        {
            'String' {$OutputMessage = $InputFromPipeline; $LogLevel = 'INFO'; Write-Output $OutputMessage}
            'WarningRecord' {$OutputMessage = $InputFromPipeline.Message; $LogLevel = 'WARN'; Write-Warning $OutputMessage}
            'VerboseRecord' {$OutputMessage = $InputFromPipeline.Message; $LogLevel = 'VERBOSE'; Write-Verbose $OutputMessage}
        }

        Write-Output "[$(Get-Date)][$($LogLevel)] $($OutputMessage)"
    }
}

Write-Everything -verbose *>&1 | PipelineExplorer