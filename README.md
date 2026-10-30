# ccgc5502-terraform-project
# CCGC 5502 Terraform Project – HumberID 9815

**Student:** Oluwaseyi Akinnirun
**Course:** CCGC 5502 Automation – Professor Asghar Ghori

Modular Terraform deployment on Azure: one root module calling 8 child modules, using a remote backend in Azure Storage. A single non-interactive `terraform apply --auto-approve` creates **48 resources**.

## Modules

| Module | Resources |
|---|---|
| rgroup-9815 | Resource group |
| network-9815 | VNet, subnet, NSG (inbound 22, 3389, 5985, 80), subnet–NSG association |
| common-9815 | Log Analytics workspace, Recovery Services vault, storage account (boot diagnostics) |
| vmlinux-9815 | 3 Ubuntu 24.04 VMs (`for_each`), NICs, public IPs, Network Watcher + Azure Monitor extensions, null provisioner (`provisioner.tf`) displaying hostnames |
| vmwindows-9815 | 1 Windows Server 2022 VM (`count`), availability set, NIC, public IP, antimalware extension |
| datadisk-9815 | 4 × 10 GB managed disks, attached one per VM |
| loadbalancer-9815 | Public load balancer, public IP, backend pool, HTTP probe, rule, 3 NIC–pool associations |
| database-9815 | PostgreSQL Flexible Server |

All resources are tagged through `locals` with Project, Name, ExpirationDate (2027-12-31) and Environment (Learning).

## Resource count (48)

Resource group 1 · Network 4 · Common 3 · Linux 18 · Windows 5 · Data disks 8 · Load balancer 8 · Database 1

## How to run

```bash
export ARM_ACCESS_KEY="<backend storage account key>"
terraform init
terraform validate
terraform apply --auto-approve
terraform state list | nl
terraform output
terraform destroy --auto-approve
```

`terraform.tfvars` (subscription ID and passwords) is excluded by `.gitignore` and must be created locally.

## Errors encountered and fixes

| # | Error / issue | Cause | Fix |
|---|---|---|---|
| 1 | Backend `403 Server failed to authenticate` on `terraform init` | Storage access key not set | `export ARM_ACCESS_KEY` before `init` |
| 2 | `domain_name_label must start with a letter` / reserved word | Labels started with a number or contained "windows" | Labels changed to `linuxvm19815`–`linuxvm39815` and `winvm9815abc` |
| 3 | `Cannot create more than 0 IPv4 Basic SKU public IP addresses` | Basic public IP quota exhausted on the subscription | All public IPs use `sku = "Standard"` |
| 4 | VM sizes unavailable or no quota in several regions | Regional capacity and subscription quota limits | Deployed in East US with `Standard_F1ads_v7` (Linux) and `Standard_F2ads_v7` (Windows) |
| 5 | `VM size 'Standard_F1ads_v7' cannot boot with OS image or disk` | CentOS 8.2 is a Gen1 image (and end-of-life); v7 sizes require Gen2 | Linux image changed to Ubuntu 24.04 LTS Gen2, as shown in the project architecture diagram |
| 6 | `Standard_F2ads_v7 cannot be used in generation '1'` | Windows image was Gen1 | Image changed to `2022-datacenter-g2` |
| 7 | Azure Monitor agent: `Unsupported operating system: centos 8` | Agent does not support CentOS 8 | Re-enabled after moving to Ubuntu 24.04, which is supported |
| 8 | PostgreSQL `ParameterOutOfRange: Version should be in: []` | No PostgreSQL Flexible Server offer in East US for this subscription | Database deployed to Canada Central via the `db_location` variable; all other resources stay in East US |
| 9 | Windows WinRM provisioner `i/o timeout` on port 5985 | WinRM not configured for remote access on the Azure image | Removed; the brief requires a provisioner only for the Linux VMs |
| 10 | `Duplicate provider configuration` | Second `provider "azurerm"` block added | Merged all `features` (VM, Key Vault, resource group) into one provider block |
| 11 | Resource group would not delete while it still held resources | Provider safety check | Added `prevent_deletion_if_contains_resources = false` |

## Design decisions and deviations from the brief

- **Linux OS:** Ubuntu 24.04 instead of CentOS 8.2. CentOS 8 is end-of-life and cannot boot on the recommended v7 sizes. The architecture diagram also shows Ubuntu.
- **Linux availability:** the brief asks for both "separate availability zones" and an availability set, and a VM can't be in both. The Linux VMs are in zones 1, 2 and 3, and their data disks are created in the matching zones. The Windows VM uses an availability set.
- **Load balancer:** Standard SKU, because Azure has retired the Basic load balancer.
- **Two regions:** the database is in Canada Central (see error 8), and everything else is in East US.
- **Network Watcher extension:** handler version 1.4 with `auto_upgrade_minor_version = true`.
- **NSG rules:** defined inline in the NSG, and the NSG is associated with the subnet, so it applies to every VM NIC.