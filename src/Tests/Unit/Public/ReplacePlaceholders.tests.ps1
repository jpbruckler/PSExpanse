BeforeAll {
    #-------------------------------------------------------------------------
    Set-Location -Path $PSScriptRoot
    #-------------------------------------------------------------------------
    $ModuleName = 'ADAM'
    $PathToModule = [System.IO.Path]::Combine('..', '..', '..', $ModuleName, "$ModuleName.psd1")
    $PathToClass = [System.IO.Path]::Combine('..', '..', '..', $ModuleName, "Classes", "TemplateElement.class.ps1")
    $PathToPrivateScript = [System.IO.Path]::Combine('..', '..', '..', $ModuleName, "Private", "ReplacePlaceholders.ps1")
    #-------------------------------------------------------------------------
    if (Get-Module -Name $ModuleName -ErrorAction 'SilentlyContinue') {
        #if the module is already in memory, remove it
        Remove-Module -Name $ModuleName -Force
    }
    Import-Module $PathToModule -Force
    . $PathToClass
    . $PathToPrivateScript
    #-------------------------------------------------------------------------
    function SkipCharacters {
        param (
            [int]$count,
            [string]$inputString
        )

        return $inputString.Substring($count)
    }
}

Describe "ReplacePlaceholders" {

    It "Replaces placeholders with the corresponding values from the substitution data" {
        $template = "Hello, {{Name}}!"
        $data = @{
            "Name" = "John Doe"
        }
        $result = ReplacePlaceholders -Template $template -SubstitutionData $data
        $result | Should -Be "Hello, John Doe!"
    }

    It "Calls functions in placeholders and replaces them with the returned values" {
        $template = "ID: {{SkipCharacters(1, ID)}}"
        $data = @{
            "ID" = "A12345"
        }
        $result = ReplacePlaceholders -Template $template -SubstitutionData $data
        $result | Should -Be "ID: 12345"
    }

    It "Handles multiple placeholders" {
        $template = "{{Greeting}}, {{Name}}! Your ID is {{SkipCharacters(1, ID)}}."
        $data = @{
            "Greeting" = "Hi"
            "Name" = "John Doe"
            "ID" = "A12345"
        }
        $result = ReplacePlaceholders -Template $template -SubstitutionData $data
        $result | Should -Be "Hi, John Doe! Your ID is 12345."
    }

    It "Ignores unknown functions in placeholders and outputs a warning" {
        $template = "{{UnknownFunction()}}"
        $data = @{}
        $result = ReplacePlaceholders -Template $template -SubstitutionData $data
        $result | Should -Be ""
        $warning = Get-Warning -TestMode -CommandName ReplacePlaceholders
        $warning.Message | Should -Be "Function 'UnknownFunction' not found in the current module. Skipping replacement."
    }

    It "Handles missing substitution data gracefully" {
        $template = "Hello, {{Name}}! Your ID is {{ID}}."
        $data = @{}
        $result = ReplacePlaceholders -Template $template -SubstitutionData $data
        $result | Should -Be "Hello, ! Your ID is ."
    }
}
