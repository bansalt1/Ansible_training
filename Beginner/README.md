# Beginner — Ansible Lab Setup Guide

This directory contains the complete step-by-step guide for setting up an Ansible lab environment and running your first commands and playbooks on AWS EC2 nodes.

---

## Contents

| File | Description |
|------|-------------|
| [`commands.md`](./commands.md) | Full walkthrough: VM prep → Ansible install → SSH setup → ad-hoc commands → playbooks |

---

## What You Will Learn

By following [`commands.md`](./commands.md) you will be able to:

1. Prepare RHEL/Amazon Linux VMs (update packages, install Python)
2. Install Ansible on the **control node** using `pip`
3. Configure SSH key-based authentication from the control node to managed nodes
4. Create an Ansible inventory (`inventory.ini`) and configuration file (`ansible.cfg`)
5. Run ad-hoc commands with and without password-based SSH
6. Write and run Ansible playbooks (Nginx install, web directory setup, cron jobs, conditional tasks)
7. Understand and demonstrate **Ansible idempotency**

---

## Lab Architecture

```
                 Ansible Control Node
                        Node1
                          |
              +-----------+-----------+
              |           |           |
              v           v           v
           Node2       Node3       Node4
          Managed      Managed      Managed
           Node         Node         Node
```

- **Node1** — control node; Ansible is installed here
- **Node2, Node3, Node4** — managed nodes; only Python and SSH are required

> Provision these nodes using the Terraform configuration in [`../infra/`](../infra/).

---

## Guide Structure

| Section | Topic |
|---------|-------|
| 1 | Prepare the VMs (update packages, install Python) |
| 2 | Install Ansible on the control node |
| 3 | Verify the SSH service |
| 4 | Enable password authentication (temporary, for initial key copy) |
| 5 | Create the Ansible inventory file |
| 6 | Verify the inventory |
| 7 | Ad-hoc commands with password authentication |
| 8 | Configure passwordless SSH authentication |
| 9 | SSH authentication flow reference |
| 10 | SSH file and permission reference |
| 11 | Ansible connectivity test |
| 12 | Useful ad-hoc commands reference |
| 13 | Create and run an Nginx playbook |
| 14 | `configure.yml` — web directory and symlink setup |
| 15 | `regular_tasks.yml` — cron job playbook |
| 16 | `handlers_tasks.yml` — conditional tasks by group |
| 17 | Summary and security recommendations |

---

## Final Directory Structure (on the control node)

After completing the exercises, the control node will have:

```text
/home/ec2-user/
├── ansible.cfg
├── inventory.ini
└── playbooks/
    ├── nginx.yml
    ├── configure.yml
    ├── regular_tasks.yml
    └── handlers_tasks.yml
```

---

## Prerequisites

- Lab nodes provisioned and running (see [`../infra/`](../infra/))
- SSH access to the control node
- All nodes are RHEL/Amazon Linux (`dnf`/`yum`); adjust to `apt` for Ubuntu/Debian nodes

---

## Security Note

> Password authentication should be disabled after key-based authentication has been successfully configured and verified.  
> The private SSH key (`~/.ssh/id_ed25519`) must **never** be copied to the managed nodes — only the public key goes into each node's `authorized_keys`.
