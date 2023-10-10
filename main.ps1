Import-Module ActiveDirectory
Import-Module ImportExcel

$domain_username = Read-Host -Prompt "Enter YOUR ADMIN domain\username"
$credientials = Get-Credential -UserName $domain_username -Message 'Enter Admin Password'


$hostnames = Import-Excel -Path .\Hostnameslist.xlsx

$activeComputers = @()

foreach ($hostname in $hostnames) {
    if (Test-Connection -TargetName $hostname.Names) {
        $activeComputers += $hostname
    }else{
        $name = Get-ADComputer -Identity $hostname.Names
        Remove-ADComputer -Identity $name -Confirm:$false -Credential $credientials
        Write-Output "Removed $name from Active Directory."
    }
              
}

$activeComputers | Export-Excel -Path .\activecomputers.xlsx -WorksheetName "Active Computers"
Write-Output "Script completed!"
