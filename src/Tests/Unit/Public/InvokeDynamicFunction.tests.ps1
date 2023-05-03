# Import the InvokeDynamicFunction
# . '.\InvokeDynamicFunction.ps1'
BeforeAll {
    #-------------------------------------------------------------------------
    Set-Location -Path $PSScriptRoot
    #-------------------------------------------------------------------------
    $ModuleName = 'ADAM'
    $PathToManifest = [System.IO.Path]::Combine('..', '..', '..', $ModuleName, "$ModuleName.psd1")
    $PathToScript = [System.IO.Path]::Combine('..', '..', '..', $ModuleName, "Private\InvokeDynamicFunction.ps1")
    #-------------------------------------------------------------------------
    if (Get-Module -Name $ModuleName -ErrorAction 'SilentlyContinue') {
        #if the module is already in memory, remove it
        Remove-Module -Name $ModuleName -Force
    }
    Import-Module -Name $PathToManifest -Force
    #-------------------------------------------------------------------------

}

Describe 'Invoke-DynamicFunction' {

    It 'invokes the function with valid arguments' {
        $result = Invoke-DynamicFunction -FunctionName 'SkipFirst' -Arguments 3, 'Hello World'
        $result | Should -Be 'lo World'
    }

    It 'throws an error for non-exported function' {
        { Invoke-DynamicFunction -FunctionName 'NonExistentFunction' -Arguments 1, 2 } | Should -Throw -ExpectedMessage "The function 'NonExistentFunction' is not an exported function of the current module."
    }

    #It 'throws an error for invalid arguments' {
    #    { Invoke-DynamicFunction -FunctionName 'SkipFirst' -Arguments 1,'t','f' } | Should -Throw -ExpectedMessage "Invalid arguments provided for function 'ToDate'."
    #}

    It 'throws an error for missing mandatory parameter' {
        { Invoke-DynamicFunction -FunctionName 'SkipFirst' -Arguments 1 } | Should -Throw -ExpectedMessage "Mandatory parameter 'String' is missing for function 'SkipFirst'."
    }
}
