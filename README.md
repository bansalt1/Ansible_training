# Ansible Training

A hands-on training repository for learning Ansible fundamentals. It covers everything from provisioning lab infrastructure on AWS to running your first ad-hoc commands, writing playbooks, and completing a graded assessment.

---

## Repository Structure

```
Ansible_training/
├── infra/               # Terraform configuration — provisions AWS EC2 lab nodes
├── Beginner/            # Step-by-step Ansible lab guide (setup → ad-hoc → playbooks)
└── Assessment/          # Final assessment — MCQs, ad-hoc tasks, and YAML fixing
```

---

## Quick Start

### 1 — Provision the Lab Environment

Use the Terraform configuration in [`infra/`](./infra/) to spin up an AWS EC2 lab with one control node and three managed nodes.

```bash
cd infra
terraform init
terraform apply --auto-approve
```

Once applied, retrieve the SSH connection commands:

```bash
terraform output ssh_login_commands
```

See [`infra/README.md`](./infra/README.md) for full prerequisites and usage.

---

### 2 — Set Up Ansible on the Lab Nodes

Follow the step-by-step guide in [`Beginner/commands.md`](./Beginner/commands.md) to:

- Install Python and Ansible on the control node
- Configure SSH key-based authentication from the control node to the managed nodes
- Create an inventory file and `ansible.cfg`
- Run your first ad-hoc commands and playbooks

See [`Beginner/README.md`](./Beginner/README.md) for an overview of this section.

---

### 3 — Take the Assessment

Complete the final assessment in [`Assessment/Assessment.md`](./Assessment/Assessment.md) once you have finished the beginner exercises.

See [`Assessment/README.md`](./Assessment/README.md) for submission instructions.

---

## Prerequisites

| Tool | Version | Required On |
|------|---------|-------------|
| Terraform | v1.x or later | Local machine |
| AWS CLI / credentials | — | Local machine |
| Python 3 | 3.x | Control node + managed nodes |
| Ansible | Latest stable | Control node only |

---

## Notes

- The `infra/` directory generates a private key file (`generated-key.pem`) that is **git-ignored by default** — never commit it.
- All Ansible commands in the beginner guide are designed for **RHEL/Amazon Linux** nodes. Adjust package manager calls (`dnf`/`yum` → `apt`) if you are using Ubuntu-based nodes.
- For the assessment, managed nodes use **Ubuntu** (`apt`), which differs from the beginner lab. Read each section carefully.
