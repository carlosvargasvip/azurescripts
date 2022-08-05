##########################################
# Name: AzureADAppRegistration.ps1
# Author: Carlos E. Vargas
# Version: 1.0
#
##########################################

#### Varibles 
# App Name
$appname = "Datto Secure Edge"
#callback uri
$DattoSecureEdgeCallBackUri = "https://datosecureedge.us.auth0.com/login/callback"

# Step 1 Register App In Azure AD
# Connect-AzureAD # There is a bug in the cloudshell Connect-AzureAD command and it errors out. Need to run it this way. 

import-module AzureAD.Standard.Preview
AzureAD.Standard.Preview\Connect-AzureAD -Identity -TenantID $env:ACC_TID
$TenantDetails = Get-AzureADTenantDetail
$TenantObjectId = $TenantDetails.ObjectId

#Send Message to Console 
Write-Host "Please Wait While we configure the App Registration..."
# Step 2 Create Azure Ad App Registration
$AzureADAppRegistration = New-AzureADApplication -DisplayName $appname

# Step 3 Update App Registration with Datto Secure Edge URI
Update-AzADApplication -ApplicationID $AzureADAppRegistration.AppId -ReplyUrl $DattoSecureEdgeCallBackUri

# Step 4 Create an Client Secret
$startDate = Get-Date
$endDate = $startDate.AddYears(3)
$aadAppSecret01 = New-AzureAdApplicationPasswordCredential -ObjectId $AzureAdAppRegistration.ObjectId -CustomKeyIdentifier "DattoSecureEdgeSecret" -StartDate $startDate -EndDate $endDate

# Step 5 Get Service EndPoint For App Registration
clear
Write-Host "Datto Secure Edge AzureAD App Registration Script" -ForegroundColor Black -BackgroundColor Cyan
Write-Host "Application Client Id: " $AzureADAppRegistration.AppId
Write-Host "Application Client Secret: " $aadAppSecret01.Value
Write-Host "OpenID Connect Metadata Document: https://login.microsoftonline.com/$TenantObjectId/v2.0/.well-known/openid-configuration"
