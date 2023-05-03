<#function ParseTemplate {
    param (
        [string]$Template
    )

    $pattern = '\{\{(?<token>\w+)(?:\((?<params>[^)]*)\))?\}\}'
    $patternMatches = [regex]::Matches($Template, $pattern)
    $parsedTemplate = [TemplateElement]::new()

    foreach ($match in $patternMatches) {
        $token  = $match.groups['token'].value
        $params = $match.groups['params'].value -split '\s*,\s*' -ne ''

        if (-not $params) { # basic text match
            $parsedTemplate.add([TextElement]::new($token))
        }
        else {
            $parsedTemplate.add([FunctionElement]::new($token, $params))
        }
    }
    return $parsedTemplate
}#>

function ParseTemplate {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Template
    )

    $parsedTemplate = New-Object 'System.Collections.Generic.List[TemplateElement]'
    $pMatches = [regex]::Matches($Template, '{{(.*?)}}')

    foreach ($match in $pMatches) {
        $innerContent = $match.Groups[1].Value
        if ($innerContent -match '^(?<functionName>\w+)\((?<arguments>.*?)\)$') {
            # function match
            $fe = New-Object 'FunctionElement' -ArgumentList @($Matches['functionName'], (($Matches['arguments'] -split ',')))
            $parsedTemplate.add($fe)
        }
        else {
            # basic text match
            $te = New-Object 'TextElement' -ArgumentList @($innerContent)
            $parsedTemplate.add($te)
        }
    }

    return $parsedTemplate
}
