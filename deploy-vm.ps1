#collect variables from user 
$vcentercred = (Get-Credential) 
$csvinput =  .\deploy.csv
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


#waiting for all the VM's to be provisioned 	
do {
    $toolsStatus = (Get-VM -name $csv.vmname).extensiondata.Guest.ToolsStatus
    Start-Sleep -Seconds 10
    } until  ($toolsStatus -match ‘toolsNotRunning’) 


foreach($deploy in $csv){
    get-vm -name $deploy.vmname | set-vm -numcpu $deploy.numcpu -confirm:$false 
    start-sleep -Seconds 3
    get-vm -name $deploy.vmname | set-vm -MemoryGB $deploy.memGB -confirm:$false 
    }

