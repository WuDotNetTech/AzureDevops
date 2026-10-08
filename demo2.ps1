--login
az login

--group
az group create `
  --name "rg-ao" `
  --location "eastus"

# -- create a service principal without role assignment
az ad sp create-for-rbac `
  --name "github-actions-dev" `
  --skip-assignment `
  --json-auth

# --storage account role assignment
az role assignment create `
   --assignee "8b1044f0-4748-4b6e-b0d4-b4a84a062ab4" `
   --role "Storage Account Contributor" `
   --scope "/subscriptions/19403b59-d03f-48ac-98b5-b90898177e10/resourceGroups/rg-ao"

# # --list service principal
# az role assignment list --assignee 8b1044f0-4748-4b6e-b0d4-b4a84a062ab4 --all --query "[].{Role:roleDefinitionName, Scope:scope}" --output table

# # --Remove role assignment
# az role assignment delete `
#   --assignee 8b1044f0-4748-4b6e-b0d4-b4a84a062ab4 `
#   --role "Storage Account Contributor" `
#   --scope "/subscriptions/19403b59-d03f-48ac-98b5-b90898177e10/resourceGroups/rg-ao"


# -- assign built-in policies to the rg-ao resource group
# -- assign the built-in 'Storage accounts should be limited by allowed SKUs' policy to the rg-ao resource group
$resourceGroupScope = az group show `
  --name "rg-ao" `
  --query "id" `
  --output tsv

$allowedLocationsPolicyName = az policy definition list `
  --query "[?displayName=='Allowed locations'] | [0].name" `
  --output tsv

az policy assignment create `
  --name "allowed-locations-rg-ao" `
  --display-name "Allowed locations for rg-ao" `
  --scope $resourceGroupScope `
  --policy $allowedLocationsPolicyName `
  --params '{"listOfAllowedLocations":{"value":["eastus"]}}'

$allowedStorageSkusPolicyName = az policy definition list `
  --query "[?displayName=='Storage accounts should be limited by allowed SKUs'] | [0].name" `
  --output tsv

az policy assignment create `
  --name "allowed-storage-skus-rg-ao" `
  --display-name "Storage accounts should be limited by allowed SKUs for rg-ao" `
  --scope $resourceGroupScope `
  --policy $allowedStorageSkusPolicyName `
  --params '{"listOfAllowedSKUs":{"value":["Standard_LRS","Standard_GRS"]}}'

