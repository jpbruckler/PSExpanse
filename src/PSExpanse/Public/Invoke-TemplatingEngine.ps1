function Invoke-TemplatingEngine {
    param (
        [string]$Template,
        [hashtable]$SubstitutionData
    )

    $parsedTemplate = ParseTemplate -Template $Template
    $result = ReplacePlaceholders -ParsedTemplate $parsedTemplate -SubstitutionData $SubstitutionData

    return $result
}
