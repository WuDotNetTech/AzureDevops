#Create a storage account
#DEMO1
New-AzStorageAccount -ResourceGroupName RG-AO `
  -Name 'saao' `
  -Location eastus `
  -SkuName Standard_LRS `
  -Kind StorageV2

$errorlast = $Error[0]
$errorlast | Format-List * -Force
if ($errorlast.Exception.Response.Content) {
    $errorlast.Exception.Response.Content | ConvertFrom-Json | ConvertTo-Json -Depth 100
}


#Bicep deploy
#DEMO2
cd .\Part06IaC
New-AzResourceGroupDeployment -TemplateFile "storageaccount.bicep" -ResourceGroupName RG_AO `
    -TemplateParameterFile "storageaccount-dev.bad.parameters.json" `
    -WhatIf

New-AzResourceGroupDeployment -TemplateFile "storageaccount.bicep" -ResourceGroupName RG_AO `
    -TemplateParameterFile "storageaccount-dev.parameters.json" `
    -WhatIf

#Actually deploy
New-AzResourceGroupDeployment -TemplateFile "storageaccount.bicep" -ResourceGroupName RG_AO `
    -TemplateParameterFile "storageaccount-dev.parameters.json"

#Declarative so can run again and update my new desired state
New-AzResourceGroupDeployment -TemplateFile "storageaccount.bicep" -ResourceGroupName RG_AO `
    -TemplateParameterFile "storageaccount-dev.parameters.json" `
    -storageSku 'Standard_GRS'