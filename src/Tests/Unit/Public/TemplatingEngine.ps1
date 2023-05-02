class TemplateElement { }

class TextElement : TemplateElement {
    [string]$Content

    TextElement([string]$content) {
        $this.Content = $content
    }
}

class FunctionElement : TemplateElement {
    [string]$FunctionName
    [string[]]$Arguments

    FunctionElement([string]$functionName, [string[]]$arguments) {
        $this.FunctionName = $functionName
        $this.Arguments = $arguments
    }
}




function ParseTemplate {
    param (
        [string]$Template
    )

    $pattern = '\{\{(\w+)\(([^)]*)\)\}\}'
    $patternMatches = [regex]::Matches($Template, $pattern)
    $parsedTemplate = [System.Collections.Generic.List[TemplateElement]]::new()

    $currentIndex = 0

    foreach ($match in $patternMatches) {
        if ($currentIndex -lt $match.Index) {
            $literalText = $Template.Substring($currentIndex, $match.Index - $currentIndex)
            $parsedTemplate.Add([TextElement]::new($literalText))
        }

        $functionName = $match.Groups[1].Value
        $arguments = $match.Groups[2].Value -split '\s*,\s*' -ne ''

        $parsedTemplate.Add([FunctionElement]::new($functionName, $arguments))

        $currentIndex = $match.Index + $match.Length
    }

    if ($currentIndex -lt $Template.Length) {
        $literalText = $Template.Substring($currentIndex)
        $parsedTemplate.Add([TextElement]::new($literalText))
    }

    return $parsedTemplate
}

function ReplacePlaceholders {
    param (
        [System.Collections.Generic.List[TemplateElement]]$ParsedTemplate,
        [hashtable]$SubstitutionData
    )

    $result = [System.Text.StringBuilder]::new()

    foreach ($element in $ParsedTemplate) {
        if ($element -is [TextElement]) {
            $result.Append($element.Content) | Out-Null
        } elseif ($element -is [FunctionElement]) {
            $functionName = $element.FunctionName
            $resolvedArgs = $element.Arguments | ForEach-Object { $SubstitutionData[$_] }

            $function = Get-Command -Name $functionName -Module $currentModule -ErrorAction SilentlyContinue
            if ($function) {
                $functionResult = & $functionName @resolvedArgs
                $result.Append($functionResult) | Out-Null
            } else {
                Write-Warning "Function '$functionName' not found in the current module. Skipping replacement."
            }
        }
    }

    return $result.ToString()
}

function Invoke-TemplatingEngine {
    param (
        [string]$Template,
        [hashtable]$SubstitutionData
    )

    $parsedTemplate = ParseTemplate -Template $Template
    $result = ReplacePlaceholders -ParsedTemplate $parsedTemplate -SubstitutionData $SubstitutionData

    return $result
}
