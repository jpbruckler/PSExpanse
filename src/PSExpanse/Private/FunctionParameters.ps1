<#
.SYNOPSIS
    Retrieves the list of parameters for a PowerShell function.
.DESCRIPTION
    The Get-FunctionParameters function retrieves the list of parameters for a specified PowerShell function, excluding common parameters.
.PARAMETER FunctionName
    The name of the PowerShell function to retrieve the parameters for.
.EXAMPLE
    Get-FunctionParameters -FunctionName "Get-Process"
    This example retrieves the list of parameters for the Get-Process function.
.INPUTS
    None
.OUTPUTS
    System.String[]
    An array of strings containing the names of the parameters for the specified function.
#>
function Get-FunctionParameters {
    param (
        [Parameter( Mandatory,
                    ValueFromPipeline)]
        [string[]]$FunctionName
    )

    process {
        foreach ($Function in $FunctionName) {
            $Output = @{
                FunctionName = $Function
                Parameters = $null
            }
            $commonParams = [System.Management.Automation.PSCmdlet]::CommonParameters
            $commonParams += [System.Management.Automation.PSCmdlet]::OptionalCommonParameters

            $paramArray = @(
                (Get-Command $Function).Parameters.Values |
                Where-Object { $_.Name -notin $commonParams } |
                Select-Object -ExpandProperty Name
            )

            $Output.Parameters = $paramArray
            Write-Output $Output
        }
    }
}
