Get-Module Microsoft.Graph.DeviceManagement
$Tenant = ""
$clientid = ""
$clientSecret = ""
$teamsURI = ''
$alerts = $true

Try{
    $serial = (Get-CimInstance win32_bios).SerialNumber

    $username = "$clientid"
    $password = "$clientSecret"
    $secstr = New-Object -TypeName System.Security.SecureString
    $password.ToCharArray() | ForEach-Object {$secstr.AppendChar($_)}
    $cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $secstr

    Connect-MGGraph -TenantId $Tenant -ClientSecretCredential $cred

    $managedDeviceId = Get-MgDeviceManagementManagedDevice -Filter "serialNumber eq '$serial'" | Select-Object -ExpandProperty Id
    Remove-MgDeviceManagementManagedDevice -ManagedDeviceId $managedDeviceId

    if($alerts -eq $true){
     # Force TLS 1.2 protocol. Invoke-RestMethod uses 1.0 by default. Required for Teams notification to work
     Write-Verbose -Message ('{0} - Forcing TLS 1.2 protocol for invoking REST method.' -f $MyInvocation.MyCommand.Name)
     [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
     
     $body = ConvertTo-Json -Depth 4 @{
         title    = "Intune Removal Status"
         text   = " "
         sections = @(
           @{
             activityTitle    = 'Succesful Deletion of Intune Object'
             activitySubtitle = "Device with Serial $serial deleted succesfully."
             activityText   = ' '
             activityImage    = 'https://i.imgur.com/NtPeAoY.png' # this value would be a path to a nice image you would like to display in notifications
           }
         )
       }
       Invoke-RestMethod -uri $teamsURI -Method Post -body $body -ContentType 'application/json'
    }
    }
    catch {
        
        $errMsg = $_.Exception.Message
        write-host $errMsg
        if($alerts -eq $true){                
     # Force TLS 1.2 protocol. Invoke-RestMethod uses 1.0 by default. Required for Teams notification to work
     Write-Verbose -Message ('{0} - Forcing TLS 1.2 protocol for invoking REST method.' -f $MyInvocation.MyCommand.Name)
     [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
     
     $body = ConvertTo-Json -Depth 4 @{
         title    = "Intune Removal Status"
         text   = "$errMsg "
         sections = @(
           @{
             activityTitle    = 'Deletion of Intune Object Failure'
             activitySubtitle = "Review error message"
             activityText   = ' '
             activityImage    = 'https://i.imgur.com/N39eDrY.png' # this value would be a path to a nice image you would like to display in notifications
           }
         )
       }
       Invoke-RestMethod -uri $teamsURI -Method Post -body $body -ContentType 'application/json'
    }
}
