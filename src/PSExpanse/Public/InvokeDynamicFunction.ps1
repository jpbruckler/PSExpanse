function Invoke-DynamicFunction {
    <#
    .SYNOPSIS
        Invokes a module-exported function dynamically, providing a list of arguments.

    .DESCRIPTION
        Invoke-DynamicFunction takes a function name and an array of arguments as input. It checks if the provided function is exported by the current module and then matches the given arguments to the function's parameters. The function is then invoked with the matched arguments.

    .PARAMETER FunctionName
        The name of the function to be invoked.

    .PARAMETER Arguments
        An array of arguments to be passed to the function.

    .EXAMPLE
        Invoke-DynamicFunction -FunctionName 'Add-Numbers' -Arguments 4, 6
        Invokes the Add-Numbers function with arguments 4 and 6.

    .INPUTS
        None

    .OUTPUTS
        The output of the invoked function.

    .NOTES
        Ensure the provided function is exported by the current module.
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$FunctionName,

        [Parameter(Mandatory = $true)]
        [array]$Arguments
    )

    begin {
        function ArgumentMatchesParameterType ([object]$arg, [System.Management.Automation.ParameterMetadata]$parameter) {
            try {
                [void][System.Convert]::ChangeType($arg, $parameter.ParameterType)
                return $true
            }
            catch {
                return $false
            }
        }

    }
    process {
        $currentModule = $PSCmdlet.MyInvocation.MyCommand.Module
        $function = $currentModule.ExportedCommands[$FunctionName]

        if (-not $function) {
            throw "The function '$FunctionName' is not an exported function of the current module."
        }

        $commonParams = [System.Management.Automation.PSCmdlet]::CommonParameters
        $commonParams += [System.Management.Automation.PSCmdlet]::OptionalCommonParameters

        $functionParameters = $function.Parameters.Values | Where-Object { $_.Name -notin $commonParams }

        $splatArguments = @{}
        $nonMatchedArguments = @()

        for ($i = 0; $i -lt $Arguments.Count; $i++) {
            $arg = $Arguments[$i]
            # Check if the argument matches any parameter.
            $matched = $false
            foreach ($parameter in $functionParameters) {
                if (ArgumentMatchesParameterType $arg $parameter) {
                    $splatArguments[$parameter.Name] = $arg
                    $matched = $true
                    break
                }
            }

            # If the argument was not matched, add it to the non-matched list.
            if (-not $matched) {
                $nonMatchedArguments += $arg
            }
        }

        # Update the $Arguments array.
        $Arguments = $nonMatchedArguments

        if ($Arguments.Count -gt 0) {
            throw "Invalid arguments provided for function '$FunctionName'."
        }

        foreach ($mandatoryParam in $functionParameters | Where-Object { $_.Attributes.Mandatory }) {
            if (-not $splatArguments.ContainsKey($mandatoryParam.Name)) {
                throw "Mandatory parameter '$($mandatoryParam.Name)' is missing for function '$FunctionName'."
            }
        }

        return & $FunctionName @splatArguments
    }
}

Export-ModuleMember -Function Invoke-DynamicFunction
