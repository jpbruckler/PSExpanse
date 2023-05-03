function ReplacePlaceholders {
    param (
        [TextElement]$ParsedTemplate,
        [hashtable]$SubstitutionData
    )

    $result = [System.Text.StringBuilder]::new()

    foreach ($element in $ParsedTemplate) {
        if ($element -is [TextElement]) {
            if ($SubstitutionData.ContainsKey($element.Content)) {
                $result.Append($SubstitutionData.Get_Item($element.Content)) | Out-Null
            }
            else {
                $result.Append($element.Content) | Out-Null
            }
        }
        elseif ($element -is [FunctionElement]) {
            # First, is one of the arguments a property of the substitution data?
            $resolvedArgs = $element.Arguments | ForEach-Object {
                if ($SubstitutionData.ContainsKey($_)) {
                    $SubstitutionData.Get_Item($_)
                }
                else {
                    $_
                }
            }

            $Invocation = InvokeDynamicFunction -Name $element.Name -Arguments $resolvedArgs
            $result.Append($Invocation) | Out-Null
        }
    }

    return $result.ToString()
}

