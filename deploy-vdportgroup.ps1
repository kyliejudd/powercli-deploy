$csv = 
$vdportgroup = Import-Csv -UseCulture

foreach ($vdportgroup in $vdportgroups){ 
    get-vdswitch $vdportgroup.vdswitch -location $vdportgroup.location | New-VDPortgroup -Name `
    $vdportgroup.Name -VlanId $vdportgroup.vlanid
    }