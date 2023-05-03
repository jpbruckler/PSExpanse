function First {
    <#
    .SYNOPSIS
        Returns the first character of the specified string.
    .DESCRIPTION
        Returns the first character of the specified string.
    .PARAMETER String
        The string to return the first character of.
    .EXAMPLE
        PS C:\> First -String 'Hello World'
        H
    #>
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$String
    )
    return $String.Substring(0, 1)
}


function Last {
    <#
    .SYNOPSIS
        Returns the last character of the specified string.
    .DESCRIPTION
        Returns the last character of the specified string.
    .PARAMETER String
        The string to return the last character of.
    .EXAMPLE
        PS C:\> Last -String 'Hello World'
        d
    #>
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$String
    )
    return $String.Substring($String.Length - 1, 1)
}

function ToDate {
    <#
    .SYNOPSIS
        Returns the current date in the specified format.
    .DESCRIPTION
        Returns the current date in the specified format.
    .PARAMETER DateFormat
        The format of the date to return. Must match one of the following:
            yyyy-MM-dd               # 2023-04-30
            yyyy-MM-dd HH:mm:ss      # 2023-04-30 10:15:19
            yyyy-MM-dd HH:mm:ss.fff  # 2023-04-30 10:15:19.780
            d                        # 4/30/2023
            D                        # Sunday, April 30, 2023
            f                        # Sunday, April 30, 2023 10:15 AM
            F                        # Sunday, April 30, 2023 10:15:19 AM
            g                        # 4/30/2023 10:15 AM
            G                        # 4/30/2023 10:15:19 AM
            m                        # April 30
            M                        # April 30
            o                        # 2023-04-30T10:15:19.7831645-04:00
            O                        # 2023-04-30T10:15:19.7835347-04:00
            r                        # Sun, 30 Apr 2023 10:15:19 GMT
            R                        # Sun, 30 Apr 2023 10:15:19 GMT
            s                        # 2023-04-30T10:15:19
            t                        # 10:15 AM
            T                        # 10:15:19 AM
            u                        # 2023-04-30 10:15:19Z
            U                        # Sunday, April 30, 2023 2:15:19 PM
            y                        # April 2023
            Y                        # April 2023
    #>
    param(
        [Parameter(Mandatory = $true, Position = 0 )]
        [ValidateSet(                   # https://docs.microsoft.com/en-us/dotnet/standard/base-types/custom-date-and-time-format-strings
            'yyyy-MM-dd', # 2023-04-30
            'yyyy-MM-dd HH:mm:ss', # 2023-04-30 10:15:19
            'yyyy-MM-dd HH:mm:ss.fff', # 2023-04-30 10:15:19.780
            'd', # 4/30/2023
            'D', # Sunday, April 30, 2023
            'f', # Sunday, April 30, 2023 10:15 AM
            'F', # Sunday, April 30, 2023 10:15:19 AM
            'g', # 4/30/2023 10:15 AM
            'G', # 4/30/2023 10:15:19 AM
            'm', # April 30
            'M', # April 30
            'o', # 2023-04-30T10:15:19.7831645-04:00
            'O', # 2023-04-30T10:15:19.7835347-04:00
            'r', # Sun, 30 Apr 2023 10:15:19 GMT
            'R', # Sun, 30 Apr 2023 10:15:19 GMT
            's', # 2023-04-30T10:15:19
            't', # 10:15 AM
            'T', # 10:15:19 AM
            'u', # 2023-04-30 10:15:19Z
            'U', # Sunday, April 30, 2023 2:15:19 PM
            'y', # April 2023
            'Y'                         # April 2023
        )]
        [string]$DateFormat
    )
    return (Get-Date).ToString($DateFormat)
}

function Env {
    <#
    .SYNOPSIS
        Returns the value of the specified environment variable.
    .DESCRIPTION
        Returns the value of the specified environment variable.
    .PARAMETER Name
        The name of the environment variable to return.
    #>
    param(
        [Parameter( Mandatory = $true, Position = 0 )]
        [string]$Name
    )
    return [System.Environment]::GetEnvironmentVariable($Name)
}

function SkipFirst {
    <#
    .SYNOPSIS
        Skips the specified number of characters from the beginning of the string.
    .DESCRIPTION
        Skips the specified number of characters from the beginning of the string.
    .PARAMETER String
        The string to return characters from.
    .PARAMETER Count
        The number of characters to return.
    #>
    param(
        [Parameter( Position = 1 )]
        [int]$Count = 0,

        [Parameter( Mandatory = $true,
            Position = 0 )]
        [string]$String
    )
    return $String.Substring($Count, $String.Length - $Count)
}

function FromEnd {
    <#
    .SYNOPSIS
        Returns the specified number of characters from the beginning of the string.
    .DESCRIPTION
        Returns the specified number of characters from the beginning of the string.
    .PARAMETER String
        The string to return characters from.
    .PARAMETER Count
        The number of characters to return.
    #>

    param(
        [Parameter(Position = 1)]
        [int]$Count = 0,

        [Parameter( Mandatory = $true,
            Position = 0 )]
        [string]$String
    )
    return $String.Substring(0, $Count)
}

function Sum {
    <#
    .SYNOPSIS
        Returns the sum of the specified numbers.
    .DESCRIPTION
        Returns the sum of the specified numbers.
    .PARAMETER Numbers
        The numbers to sum.
    .EXAMPLE
        PS C:\> Sum 1 2
        3
    #>
    param(
        [int] $Operand1,
        [int] $Operand2
    )
    return $Numbers | Measure-Object -Sum | Select-Object -ExpandProperty Sum
}

function Concat {
    <#
    .SYNOPSIS
        Concatenates the specified strings.
    .DESCRIPTION
        Concatenates the specified strings.
    .PARAMETER Strings
        The strings to concatenate.
    .EXAMPLE
        PS C:\> Concat "Hello", "World"
        HelloWorld
    #>
    param(
        [string]$String1,
        [string]$String2
    )
    return $Strings -join ''
}

Export-ModuleMember -Function First, Last, ToDate, Env, SkipFirst, FromEnd