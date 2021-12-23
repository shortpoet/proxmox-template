# terraform-azure-module_keyvault

- This is a module to create key vaults in Azure in each of the different subscription environments.

## examples

- gets existing groups access policies and applies
  - [innovationnorway/terraform-azurerm-key-vault - variables.tf](https://github.com/innovationnorway/terraform-azurerm-key-vault/blob/master/variables.tf)
- similar/identical to above with better doc
  - [kumarvna/terraform-azurerm-key-vault](https://github.com/kumarvna/terraform-azurerm-key-vault)
- simple/general
  - [JamesDLD/terraform](https://github.com/JamesDLD/terraform/tree/master/module/Az-KeyVault)
- terratest
  - [avinor/terraform-azurerm-key-vault](https://github.com/avinor/terraform-azurerm-key-vault)
- network ACLs
  - [claranet/terraform-azurerm-keyvault](https://github.com/claranet/terraform-azurerm-keyvault)
- archived azure CAF - complete examples
  - [aztfmod/terraform-azurerm-caf-keyvault](https://github.com/aztfmod/terraform-azurerm-caf-keyvault/blob/master/module.tf)
- quite basic with dynamic block access policy creation
  - [dfar-io/terraform-azurerm-key-vault](https://github.com/dfar-io/terraform-azurerm-key-vault/blob/master/main.tf)
- complete basic example with azdo library integration and blog post
  - [cdennig/azure-pipeline-with-keyvault.yaml](https://gist.github.com/cdennig/4866a74b341a0079b5a59052fa735dbc)
  - [Azure DevOps Terraform Provider](https://partlycloudy.blog/2020/08/05/azure-devops-terraform-provider/)
  - [GH - Christian Dennig - cdennig](https://github.com/cdennig)
- example with access differentiation and blog
  - [guillermo-musumeci/terraform-azure-key-vault-module](https://github.com/guillermo-musumeci/terraform-azure-key-vault-module)
  - [How to Manage Azure Key Vault with Terraform](https://gmusumeci.medium.com/how-to-manage-azure-key-vault-with-terraform-943bf7251369)
- kv secret deployments script, access differentiation, blog & pipelines
  - [jungopro/terraform-azurerm-keyvault-advanced](https://github.com/jungopro/terraform-azurerm-keyvault-advanced)
  - [Securely Provision Azure Infrastructure using Terraform and Azure Key Vault](https://codevalue.com/securely-provision-azure-infrastructure-using-terraform-and-azure-key-vault/)
  - [jungopro/createsecrets.sh](https://gist.github.com/jungopro/d55960482c987f0ece4b2fe13bdc472f)
- module example in github issue
  - [KeyVault access policy for Service Principal doesn't work as expected and doesn't provide access to secrets #1569](https://github.com/hashicorp/terraform-provider-azurerm/issues/1569#issuecomment-461843863)

## progress

- v0.1.0
  - Active Directory duplicates prevent usage of azuread_group for now
  - key vault
  - default access policies for admin and reader
  - creates keys based on input or random pw generator
  - option to use CAF naming module for name validation
  - uses tagging module 'context' for name 'id' and tags
  - add default variables option that reads from a central keyvault
  - implemented az ad lookup
  - implemented upload of known secrets scripts from local powershell or pass vault
  - add merge of locals.secrets to provided variables to add Subscription Id, possibly client id and secret, and tenant based on data script
  - removed azure credentials from variables (not needed) except for subscription id for provider
  - added depends_on variable so module can be called and data source referenced correctly
    - it works with also passing in resource_group_location but is a good example of how to use depends on for data as well if depends_on already needed for resource
    - it simplifies the config variable

## TODO

- az ad groups still have duplicates
- add examples directory and usage in readme
- add/test additional/different tags for secrets
- add unit tests
- **ACCOUNT FOR RANDOM ERRORS IN TERRAFORM APPLY - E.G. RESOURCE EXISTS MUST BE IMPORTED - BUT NOT ACTUALLY TRYING TO CREATE IT AND WAS NOT REPORTED IN PLAN**

## results

### output

```powershell
terraform output -json | clip
```

```json
{
  "access_policies": {
    "sensitive": false,
    "type": [
      "map",
      [
        "object",
        {
          "certificate_permissions": [
            "list",
            "string"
          ],
          "key_permissions": [
            "list",
            "string"
          ],
          "object_id": "string",
          "secret_permissions": [
            "list",
            "string"
          ],
          "storage_permissions": [
            "list",
            "string"
          ],
          "tenant_id": "string"
        }
      ]
    ],
    "value": {}
  },
  "id": {
    "sensitive": false,
    "type": "string",
    "value": "/subscriptions/*/resourceGroups/rg-sparq-stg-terraformtest-centralus/providers/Microsoft.KeyVault/vaults/kv-stg-tf-test-cnus"
  },
  "name": {
    "sensitive": false,
    "type": "string",
    "value": "kv-stg-tf-test-cnus"
  },
  "references": {
    "sensitive": false,
    "type": [
      "object",
      {
        "message": "string",
        "vmpass": "string"
      }
    ],
    "value": {
      "message": "@Microsoft.KeyVault(SecretUri=https://kv-stg-tf-test-cnus.vault.azure.net/secrets/message/b2b3e42cb89f450dad151ebd9e2fd16a)",
      "vmpass": "@Microsoft.KeyVault(SecretUri=https://kv-stg-tf-test-cnus.vault.azure.net/secrets/vmpass/a8b6ffb75c0848cfadac3b56fc5a4268)"
    }
  },
  "secrets": {
    "sensitive": false,
    "type": [
      "object",
      {
        "message": "string",
        "vmpass": "string"
      }
    ],
    "value": {
      "message": "https://kv-stg-tf-test-cnus.vault.azure.net/secrets/message/b2b3e42cb89f450dad151ebd9e2fd16a",
      "vmpass": "https://kv-stg-tf-test-cnus.vault.azure.net/secrets/vmpass/a8b6ffb75c0848cfadac3b56fc5a4268"
    }
  },
  "sub_info": {
    "sensitive": false,
    "type": [
      "object",
      {
        "client_id": "string",
        "id": "string",
        "object_id": "string",
        "sub_id": "string",
        "tenant_id": "string"
      }
    ],
    "value": {
      "client_id": "*",
      "id": "2021-09-18 20:59:25.8110069 +0000 UTC",
      "object_id": "*",
      "sub_id": "*",
      "tenant_id": "*"
    }
  },
  "tenand_id": {
    "sensitive": false,
    "type": "string",
    "value": "04b07795-8ddb-461a-bbee-02f9e1bf7b46"
  },
  "uri": {
    "sensitive": false,
    "type": "string",
    "value": "https://kv-stg-tf-test-cnus.vault.azure.net/"
  }
}
```

### created secrets

```powershell
$kvName = "kv-stg-tf-test-cnus"
az keyvault secret show --name "message" --vault-name "$kvName" --query "value"
# "Hello, world!"
az keyvault secret show --name "vmpass" --vault-name "$kvName" --query "value"
# "IM69x<1!:k@pW>Y+RG(TSwp1"
```

```powershell
$nameAppId = "Service-Principal-Sparq-Infra-Stg-AppId"
$namePassword = "Service-Principal-Sparq-Infra-Stg-Password"
$kvName = "kv-terraformtest-stg"
az keyvault secret show --name "message" --vault-name "$kvName" --query "value"
az keyvault secret show --name "vmpass" --vault-name "$kvName" --query "value"
az keyvault secret show --name $nameAppId --vault-name "$kvName" --query "value"
az keyvault secret show --name $namePassword --vault-name "$kvName" --query "value"
```

## Commands

- format all

```powershell
gci -Directory | % {cd $_;terraform fmt; cd ..}
```

## Usage

- **Do not recreate access policies that match the object_id of the default policy**
  - Doing this will result in an unsuccessful destroy process because the depends_on is tied to the default policy which gets overwritten by the new policy that doesn't have a set dependency
