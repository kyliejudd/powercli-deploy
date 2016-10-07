#collect variables from user 
$vcentercred = (Get-Credential) 
$csvinput =  
$csv = import-csv $csvinput -UseCulture

#import vmware powershell snapin
add-pssnapin vmware* 

#connect to each vcenter
$vcenter = $csv.vcenter | select -Unique 
foreach ($vcenter in $vcenter){
    connect-viserver -Credential $vcentercred -Server $vcenter -WarningAction SilentlyContinue
    }


foreach ($deploy in $csv){
    get-cluster -name $deploy.cluster -server $deploy.vcenter | new-vm -Name $deploy.vmname -Datastore $deploy.datastore -template $deploy.template
}
