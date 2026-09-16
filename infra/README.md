# infra — Terraform Lab Infrastructure

Terraform configuration that provisions AWS EC2 instances for the Ansible training lab: one **control node** and one or more **managed nodes**, all accessible over SSH using an auto-generated key pair.

---

## Directory Structure

```
infra/
├── main.tf        # Resources: key pair, security group, EC2 instances
├── variables.tf   # Input variable declarations
├── outputs.tf     # Output values (IPs, SSH commands, VM names)
└── provider.tf    # Terraform settings and AWS provider configuration
```

---

## Resources Provisioned

| Resource | Description |
|----------|-------------|
| `tls_private_key.ssh_key` | Generates a 4096-bit RSA SSH key pair |
| `local_file.private_key` | Saves the private key to `generated-key.pem` (mode `0400`) |
| `aws_key_pair.generated` | Uploads the public key to AWS as `terraform-generated-key` |
| `aws_security_group.ssh` | Security group allowing inbound SSH (port 22) and all outbound traffic |
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
|------|------|---------|-------------|
| `region` | `string` | `ap-south-1` | AWS region to deploy into |
| `ami` | `string` | `ami-02cada047ebd954cf` | AMI ID for EC2 instances (Amazon Linux 2 / RHEL, ap-south-1) |
| `instance_type` | `string` | `t2.medium` | EC2 instance type |
| `vm_count` | `number` | `4` | Total VMs (1 control node + remaining are managed nodes) |

---

## Outputs

| Name | Description |
|------|-------------|
| `private_key_path` | Local path to the generated `generated-key.pem` file |
| `vm_names` | List of all VM names in order |
| `public_ips` | Map of VM name → public IP address |
| `ssh_login_commands` | Map of VM name → ready-to-use `ssh` command |

Example output after `terraform apply`:

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

- [Terraform](https://developer.hashicorp.com/terraform/downloads) v1.x or later
- An AWS account with permissions to create EC2 instances, key pairs, and security groups
- AWS credentials configured (see below)

---

## Usage

### 1 — Clone the Repository

```bash
git clone https://github.com/bansalt1/Ansible_training.git
cd Ansible_training/infra
```

### 2 — Configure AWS Credentials

```bash
export AWS_ACCESS_KEY_ID=<your-access-key>
export AWS_SECRET_ACCESS_KEY=<your-secret-key>
export AWS_DEFAULT_REGION=ap-south-1
```

### 3 — Initialize Terraform

```bash
terraform init
```

### 4 — Review the Execution Plan

```bash
terraform plan
```

### 5 — Deploy the Infrastructure

```bash
terraform apply --auto-approve
```

Terraform will create **4 EC2 instances** (1 control node + 3 managed nodes) along with the SSH key pair and security group.

### 6 — Connect to the Control Node

```bash
terraform output ssh_login_commands
```

Copy the `control-node` command from the output and run it. For example:

```bash
ssh -i ./generated-key.pem ec2-user@<control-node-ip>
```

### 7 — Verify All Resources

```bash
terraform state list
```

### 8 — Destroy the Infrastructure

When the lab is no longer needed:

```bash
terraform destroy --auto-approve
```

---

## Notes

- `generated-key.pem` is written to the `infra/` directory with `0400` permissions and is **git-ignored by default** — do not commit it.
- To change the number of VMs, update `vm_count` in `variables.tf` or pass it at apply time with `-var="vm_count=5"`. The first VM is always the control node.
- The security group allows SSH from `0.0.0.0/0`. For production use, restrict `cidr_blocks` to a known IP range.
- The default AMI (`ami-02cada047ebd954cf`) targets the `ap-south-1` (Mumbai) region. If you change `region`, update `ami` to a matching AMI in that region.
