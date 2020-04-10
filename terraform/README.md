# Deploying the server with Terraform

## Authenticating Azure

Follow the guide for tha Azure provider to generate a service principle in your Azure account and then
set these credentials as environment variables.

https://www.terraform.io/docs/providers/azurerm/guides/service_principal_client_secret.html

## Running the Terraform

```
terraform init

Initializing the backend...

Initializing provider plugins...
- Checking for available provider plugins...
- Downloading plugin for provider "azurerm" (hashicorp/azurerm) 2.5.0...

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, it is recommended to add version = "..." constraints to the
corresponding provider blocks in configuration, with the constraint strings
suggested below.

* provider.azurerm: version = "~> 2.5"
```

```
terraform plan

Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.


------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_container_group.minecraft will be created
  + resource "azurerm_container_group" "minecraft" {
```

```
terraform apply

```