Function Get-GraphQLUrl
{
    Param
    (
        [Parameter(Mandatory = $True)]
        [ValidateSet('Production', "Quality", "Demo")]
        [String] $EnvironmentType,

        [Parameter(Mandatory = $True)]
        [ValidateSet('EU', 'AU', 'UK', 'US', 'CH')]
        [String] $EnvironmentRegion
    )

    Begin
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Start"
    }

    Process
    {
        $ApiHost = "4me.com"
        If ($EnvironmentType -eq 'Quality')
        {
            $ApiHost = "4me.qa"
        }
        ElseIf ($EnvironmentType -eq 'Demo')
        {
            $ApiHost = "4me-demo.com"
        }

        $ApiUrl = "https://graphql.$($EnvironmentRegion.ToLower()).$($ApiHost)"
        If ($EnvironmentRegion -eq 'EU')
        {
            $ApiUrl = "https://graphql.$($ApiHost)"
        }
        
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Generated API Url: $($ApiUrl)"

        Return $ApiUrl
    }

    End
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] End"
    }
}