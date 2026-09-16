# Ansible Training — Infrastructure

Terraform configuration that provisions AWS EC2 instances for an Ansible lab environment: one **control node** and one or more **managed nodes**, all accessible over SSH using a generated key pair.

---

## Directory Structure

```
infra/
├── main.tf            # Resources: key pair, security group, EC2 instances
├── variables.tf       # Input variable declarations
├── outputs.tf         # Output values (IPs, SSH commands, VM names)
├── provider.tf        # Terraform settings and AWS provider configuration
└── terraform.tfvars   # Default variable values
```

---

## Resources Provisioned

| Resource | Description |
|---|---|
| `tls_private_key.ssh_key` | Generates a 4096-bit RSA SSH key pair |
| `local_file.private_key` | Saves the private key to `generated-key.pem` (mode `0400`) |
| `aws_key_pair.generated` | Uploads the public key to AWS |
| `aws_security_group.ssh` | Security group allowing inbound SSH (port 22) from anywhere |
| `aws_instance.vm` | EC2 instances — 1 control node + N managed nodes |

### VM Naming Convention

The first VM (`index 0`) is named **`control-node`**. All subsequent VMs are named **`managed-node-1`**, **`managed-node-2`**, **`managed-node-3`**, and so on.

With the default `vm_count = 4`:

```
control-node
managed-node-1
managed-node-2
managed-node-3
```

---

## Variables

| Name | Type | Default | Description |
|---|---|------------|---|
| `region` | `string` | `ap-south-1` | AWS region to deploy into |
| `ami` | `string` | `ami-02cada047ebd954cf` | AMI ID for EC2 instances |
| `instance_type` | `string` | `t2.medium` | EC2 instance type |
| `vm_count` | `number` | `3` | Total VMs (1 control node + rest as managed nodes) |

---

## Outputs

| Name | Description |
|---|---|
| `private_key_path` | Local path to the generated `generated-key.pem` file |
| `vm_names` | List of all VM names in order |
| `public_ips` | Map of VM name → public IP address |
| `ssh_login_commands` | Map of VM name → ready-to-use SSH command |

Example output:

```
public_ips = {
  "control-node"   = "13.x.x.v"
  "managed-node-1" = "13.x.x.x"
  "managed-node-2" = "13.x.x.y"
  "managed-node-3" = "13.x.x.z"
}

ssh_login_commands = {
  "control-node"   = "ssh -i ./generated-key.pem ec2-user@13.x.x.v"
  "managed-node-1" = "ssh -i ./generated-key.pem ec2-user@13.x.x.x"
  "managed-node-2" = "ssh -i ./generated-key.pem ec2-user@13.x.x.y"
  "managed-node-3" = "ssh -i ./generated-key.pem ec2-user@13.x.x.z"
}
```

---

## Prerequisites

Before you begin, ensure you have the following installed:

- Terraform (v1.x or later)
- Git
- Access to your cloud provider (AWS/Azure/GCP)
- Appropriate cloud credentials

## Clone the Repository

Clone the repository from GitHub:

```bash
git clone https://github.com/bansalt1/Ansible_training.git
```

Navigate to the Terraform configuration directory:

```bash
cd Ansible_training/infra
```

## Configure Cloud Credentials

Export your cloud provider credentials before running Terraform.

### AWS

```bash
export AWS_ACCESS_KEY_ID=<your-access-key>
export AWS_SECRET_ACCESS_KEY=<your-secret-key>
export AWS_DEFAULT_REGION=<your-region>
```

> **Note:** Export the credentials for the cloud provider you are using.

## Initialize Terraform

Download the required providers and initialize the working directory.

```bash
terraform init
```

## Review the Execution Plan

Generate and review the execution plan.

```bash
terraform plan
```


## Deploy the Infrastructure

Provision the infrastructure by running:

```bash
terraform apply --auto-approve
```

Terraform will create **4 Virtual Machines** along with any associated infrastructure defined in the configuration.

## Verify Resources

After deployment, verify that the resources have been created successfully in your cloud provider console.

You can also verify using:

```bash
terraform state list
```

### SSH into the control node

```bash
terraform output ssh_login_commands 
```

Or simply copy the command from the `ssh_login_commands` output.

## Destroy the Infrastructure

When the resources are no longer required, remove them using:

```bash
terraform destroy --auto-approve
```

## Project Structure

```text
Ansible_training/
└── infra/
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    ├── provider.tf
    └── terraform.tfvars (if used)
```
---


## Notes

- The private key file `generated-key.pem` is written to the `infra/` directory and is **git-ignored by default** — do not commit it.
- To change the number of VMs, update `vm_count` in `terraform.tfvars`. The first VM is always the control node.
- The security group allows SSH from `0.0.0.0/0`. For production use, restrict the `cidr_blocks` to a known IP range.
