function Set-ZeroTrustPartnerAdminLink
{
    <#
    .SYNOPSIS
        Configures Azure Partner Admin Link in the specified subscriptions.
    .DESCRIPTION
        
    .EXAMPLE
        
    .PARAMETER SubscriptionsCsv

    .PARAMETER PartnerIdentityAppId

    .PARAMETER MpnId

    .NOTES
        General notes
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string] $SubscriptionsCsv,

        [Parameter(Mandatory=$true)]
        [string] $PartnerName,

        [Parameter(Mandatory=$true)]
        [guid] $PartnerIdentityAppId,

        [Parameter(Mandatory=$true)]
        [string] $MpnId
    )

    $ErrorActionPreference = 'Stop'

    if (!(Get-Module -ListAvailable Az)) {
        Install-Module Az -AllowClobber -Repository PSGallery -Force -Scope CurrentUser
    }

    Write-Host "Login with an account that has permissions to manage AAD applications and perform ARM role assignments"
    Connect-AzAccount


    # Create a service principal associated with partner identity
    $customerSp = New-AzADServicePrincipal -DisplayName "$PartnerName Partner Admin Link - DO NOT DELETE" -ApplicationId $PartnerIdentityAppId -SkipAssignment
    $credential = New-AzADServicePrincipalCredential -ObjectId $customerSp.Id


    # Assign the PAL to each of the required subscriptions
    $subscriptions = Import-Csv $SubscriptionsCsv
    Write-Host "The following subscriptions will be registered with the Partner Admin Link:`n$($subscriptions | Format-Table | out-string)"
    $subscriptions | ForEach-Object {
        New-AzRoleAssignment -ObjectId $customerSp.Id -RoleDefinitionName "Contributor" -Scope "/subscriptions/$_"
    }

    # Login with the above service principal and associate the account to the specified MS Partner ID
    if (!(Get-Module -ListAvailable Az.ManagementPartner)) {
        Install-Module Az.ManagementPartner -Repository PSGallery -Force -Scope CurrentUser
    }
    Connect-AzAccount -ServicePrincipal -Credential $credential
    New-AzManagementPartner -PartnerId $MpnId

    # Delete the service principal credential 
    # Remove-AzADServicePrincipalCredential -
}

function New-ZeroTrustPartnerAdminLinkCsv
{
    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $Path
    )

    Connect-AzAccount
    $subscriptions = Get-AzSubscription | Select-Object Name,Id,TenantId

    Write-Host "A file will be generated for the following subscriptions:`n$($subscriptions | Format-Table | out-string)"

    $subscriptions | Export-Csv $Path

    Write-Host "Generated .csv file: $Path"

}

function New-ZeroTrustPartnerAdminLinkPartnerIdentity {
    param (
        [string] $Name = "Microsoft-Partner-Admin-Link-Identity"
    )

    Write-Host "Login with an account that has permissions to manage AAD applications"
    Connect-AzAccount

    $domain = (Get-AzTenant -TenantId (Get-AzContext).Tenant.Id).Domains | Select-Object -First 1

    $aadApp = New-AzADApplication -DisplayName $Name -IdentifierUris @("https://$domain/$Name") -AvailableToOtherTenants

    Write-Host "Partner Admin Link ID: $($aadApp.ApplicationId)"
}
