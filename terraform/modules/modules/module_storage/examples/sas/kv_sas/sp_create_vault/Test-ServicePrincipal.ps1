[CmdletBinding()]
param (
    [Parameter()]
    [Switch]$Dev,
    [Parameter()]
    [Switch]$Stg,
    [Parameter()]
    [Switch]$Prd
)

if ($Dev.IsPresent) {
    $kvName = "kv-sparq-infrastruct-dev"
    $nameAppId = "Service-Principal-Sparq-Infrastructure-Dev-AppId"
    $nameAppSecret = "Service-Principal-Sparq-Infrastructure-Dev-Password"
    $spAppId = $(az keyvault secret show --vault-name "$kvName" --name "$nameAppId" --query "value" -o tsv)
    $spPass = $(az keyvault secret show --vault-name "$kvName" --name "$nameAppSecret" --query "value" -o tsv)
    az login --service-principal -u $spAppId -p $spPass --tenant $(az account show --query tenantId -o tsv)
    terraform apply -auto-approve -var-file dev.tfvars
    az login
}
if ($Stg.IsPresent) {
    $kvName = "kv-sparq-infrastruct-stg"
    $nameAppId = "Service-Principal-Sparq-Infrastructure-Stg-AppId"
    $nameAppSecret = "Service-Principal-Sparq-Infrastructure-Stg-Password"
    $spAppId = $(az keyvault secret show --vault-name "$kvName" --name "$nameAppId" --query "value" -o tsv)
    $spPass = $(az keyvault secret show --vault-name "$kvName" --name "$nameAppSecret" --query "value" -o tsv)
    az login --service-principal -u $spAppId -p $spPass --tenant $(az account show --query tenantId -o tsv)
    terraform apply -auto-approve -var-file stg.tfvars
    az login
}
if ($Prd.IsPresent) {
    $kvName = "kv-sparq-infrastruct-prd"
    $nameAppId = "Service-Principal-Sparq-Infrastructure-Prd-AppId"
    $nameAppSecret = "Service-Principal-Sparq-Infrastructure-Prd-Password"
    $spAppId = $(az keyvault secret show --vault-name "$kvName" --name "$nameAppId" --query "value" -o tsv)
    $spPass = $(az keyvault secret show --vault-name "$kvName" --name "$nameAppSecret" --query "value" -o tsv)
    az login --service-principal -u $spAppId -p $spPass --tenant $(az account show --query tenantId -o tsv)
    terraform apply -auto-approve -var-file prd.tfvars
    az login
}

# $kvName = "kv-sparq-infrastruct-dev"
# $nameAppId = "Service-Principal-Sparq-Infrastructure-Dev-AppId"
# $nameAppSecret = "Service-Principal-Sparq-Infrastructure-Dev-Password"
# $spAddPid = $(az keyvault secret show --vault-name "$kvName" --name "$nameAppId" --query "value" -o tsv)
# $spPass = $(az keyvault secret show --vault-name "$kvName" --name "$nameAppSecret" --query "value" -o tsv)

# # az login --service-principal -u $spAddPid -p $spPass --tenant $(az account show --query tenantId -o tsv)
# $env:ARM_CLIENT_ID=$spAddPid
# $env:ARM_CLIENT_SECRET=$spPass
# $env:ARM_TENANT_ID=$(az account show --query tenantId -o tsv)
# terraform apply -auto-approve -var-file dev.sp.tfvars
