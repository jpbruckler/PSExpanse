Describe 'Regex Pattern for Template Tokens' -Foreach @(
    @{
        InputString = '{{GivenName}}'
        TokenName = 'GivenName'
        TokenValue1 = ''
        TokenValue2 = ''
    },
    @{
        InputString = '{{date:yyyy-MM-dd}}'
        TokenName = 'date'
        TokenValue1 = 'yyyy-MM-dd'
        TokenValue2 = ''
    },
    @{
        InputString = '{{env:CommonProgramFiles(x86)}}'
        TokenName = 'env'
        TokenValue1 = 'CommonProgramFiles(x86)'
        TokenValue2 = ''
    },
    @{
        InputString = '{{env.CommonProgramFiles(x86)}}'
        TokenName = 'env'
        TokenValue1 = ''
        TokenValue2 = '.CommonProgramFiles(x86)'
    },
    @{
        InputString = '{{date.yyyy-MM-dd}}'
        TokenName = 'date'
        TokenValue1 = ''
        TokenValue2 = '.yyyy-MM-dd'
    }
){
    BeforeAll {
        $regexPattern = '\{\{((?:date|env)(?=\:)|[^\}\:\.]+)(?:\:([^\}]+))?(\.(.+))?\}\}'
    }

    It "Matches '<TokenName>'"   {
        [regex]::Matches($InputString, $regexPattern)[0].Groups[1].Value | Should -Be $TokenName
    }

    It "Matches '<TokenValue1>'" {
        [regex]::Matches($InputString, $regexPattern)[0].Groups[2].Value | Should -Be $TokenValue1
    }

    It "Matches '<TokenValue2>'" {
        [regex]::Matches($InputString, $regexPattern)[0].Groups[3].Value | Should -Be $TokenValue2
    }
}