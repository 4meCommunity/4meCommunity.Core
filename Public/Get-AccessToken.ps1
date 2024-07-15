Function Get-AccessToken
{
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter(Mandatory = $True, ParameterSetName = "Default")]
        [Parameter(Mandatory = $True, ParameterSetName = "Plain")]
        [ValidateSet('Production', "Quality", "Demo")]
        [String] $EnvironmentType,

        [Parameter(Mandatory = $True, ParameterSetName = "Default")]
        [Parameter(Mandatory = $True, ParameterSetName = "Plain")]
        [ValidateSet('EU', 'AU', 'UK', 'US', 'CH')]
        [String] $EnvironmentRegion,
    
        [Parameter(Mandatory = $True, ParameterSetName = "Default")]
        [PSCredential] $Credential,

        [Parameter(Mandatory = $True, ParameterSetName = "Plain")]
        [String] $ClientId,

        [Parameter(Mandatory = $True, ParameterSetName = "Plain")]
        [String] $ClientSecret
    )

    Begin
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Start"

        If ($Null -ne $Credential)
        {
            $ClientId = $Credential.UserName
            $ClientSecret = $Credential.GetNetworkCredential().Password
        }
    }

    Process
    {
        $OAuthHost = "4me.com"
        If ($EnvironmentType -eq 'Quality')
        {
            $OAuthHost = "4me.qa"
        }
        ElseIf ($EnvironmentType -eq 'Demo')
        {
            $OAuthHost = "4me-demo.com"
        }

        $OAuthUrl = "https://oauth.$($EnvironmentRegion.ToLower()).$($OAuthHost)/token"
        If ($EnvironmentRegion -eq 'EU')
        {
            $OAuthUrl = "https://oauth.$($OAuthHost)/token"
        }

        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Getting token for $($ClientId) on $($OAuthUrl)"

        $TokenRequestParameters = @{
            "client_id"     = $ClientId
            "client_secret" = $ClientSecret
            "grant_type"    = "client_credentials"
        }

        $TokenResponse = Invoke-WebRequest -Uri $OAuthUrl -Method POST -Body $TokenRequestParameters -UseBasicParsing
        $AccessToken = ($TokenResponse.Content | ConvertFrom-Json).access_token

        Return $AccessToken
    }

    End
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] End"
    }
}