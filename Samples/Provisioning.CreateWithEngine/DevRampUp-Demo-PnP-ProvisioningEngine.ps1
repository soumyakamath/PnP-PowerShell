#SPO Sample
$cred = Get-Credential -UserName '<User>@<Tenant>.onmicrosoft.com' -Message "Enter SPO credentials"

#Connect to SPO
Connect-SPOService -Url 'https://<Tenant>-admin.sharepoint.com' -Credential $cred

#Create new site collection
New-SPOSite -Url 'https://<Tenant>.sharepoint.com/sites/pnpdemo' -Title 'Dev Rampup Demo' -Template 'STS#0' -Owner <User>@<Tenant>.onmicrosoft.com -NoWait -StorageQuota 100 -ResourceQuota 50 

#wait for site provision
Start-Sleep -Seconds 60

#Connect to new site and validate 
Connect-SPOnline -Url 'https://<Tenant>.sharepoint.com/sites/pnpdemo' -Credentials $cred -ErrorAction Stop

Get-SPOProvisioningTemplate  -Out <Local Drive Location>\pnptemplate.xml -Force

#Insert xml snippet into pnptemplate.xml 

Apply-SPOProvisioningTemplate -Path <Local Drive Location>\pnptemplate.xml

#**********************************************************************************************************************************************
#clean up
Remove-SPOSite -Identity https://<Tenant>.sharepoint.com/sites/pnpdemo -NoWait -Confirm:$false 
Start-Sleep -Seconds 60
get-spodeletedsite | where-Object -FilterScript {$_.url -eq "https://<Tenant>.sharepoint.com/sites/pnpdemo" } | Remove-SPODeletedSite -Confirm:$false
Disconnect-SPOnline 
Disconnect-SPOService
