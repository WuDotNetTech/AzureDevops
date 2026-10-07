--login
az login

--group
az group create `
  --name "rg-ao" `
  --location "eastus"

--role contributor
az ad sp create-for-rbac `
  --name "github-actions-dev" `
  --role contributor `
  --scopes "/subscriptions/19403b59-d03f-48ac-98b5-b90898177e10" `
  --json-auth

--storage account role assignment
az role assignment create `
   --assignee "e29b4205-2083-413b-9956-bf04328e3d6c" `
   --role "Storage Account Contributor" `
   --scope "/subscriptions/19403b59-d03f-48ac-98b5-b90898177e10/resourceGroups/rg-ao"

