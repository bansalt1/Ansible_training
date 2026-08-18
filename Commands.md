# Ansible Lab Commands

This document contains commonly used commands for preparing the Ansible Control Node and Managed Nodes, configuring SSH authentication, and testing Ansible connectivity.

---

# 1. Prepare the VMs

## 1.1 Update System Packages

For RHEL-based systems:

```bash
sudo dnf update -y
```

If `dnf` is not available:

```bash
sudo yum update -y
```

> **Note:** `dnf` is the recommended package manager for modern RHEL-based systems. `yum` can be used on systems where it is available.

---

## 1.2 Install Python on the Managed Nodes (if not available)

Ansible requires Python on the Managed Nodes for module execution. Ansible itself does not need to be installed on the Managed Nodes.

Install Python using:

```bash
sudo dnf install -y python3
```

If `dnf` is not available:

```bash
sudo yum install -y python3
```

Verify the installation:

```bash
python3 --version
```

Expected output:

```text
Python 3.x.x
```

> **Note:** Run these commands on all Managed Nodes.

---

# 2. Install Ansible on the Control Node

Ansible is installed only on the **Control Node (Node1)**. The Managed Nodes only require Python and an SSH connection from the Control Node.

## 2.1 Install Python and pip3

Run the following commands on **Node1 (Control Node)**:

```bash
sudo dnf install -y python3 python3-pip
```

If `dnf` is not available:

```bash
sudo yum install -y python3 python3-pip
```

Verify Python:

```bash
python3 --version
```

Verify pip:

```bash
python3 -m pip --version
```

---

## 2.2 Install Ansible

Install the full Ansible package for the current user:

```bash
python3 -m pip install --user ansible
```

> **Note:** The `--user` option installs Ansible under the current user's home directory and avoids modifying the system Python installation.

---

## 2.3 Configure the PATH

The Ansible executables installed with `--user` are normally located under:

```text
~/.local/bin
```

Add this directory to the current user's `PATH`:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Verify Ansible:

```bash
ansible --version
```

Expected output will be similar to:

```text
ansible [core X.XX.X]
  python version = X.X.X
```

> **Note:** If you open a new terminal session and the `ansible` command is no longer available, add the following line to `~/.bashrc`:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Then reload the shell configuration:

```bash
source ~/.bashrc
```

Verify again:

```bash
ansible --version
```

---

# 3. Verify SSH Service

Run the following commands on the Control Node and Managed Nodes.

Check the SSH service:

```bash
sudo systemctl status sshd
```

If required, start and enable the SSH service:

```bash
sudo systemctl enable --now sshd
```

---

# 4. Enable Password Authentication

Password authentication can be enabled initially to allow the Control Node to copy its SSH public key to the Managed Nodes.

Run the following commands on the nodes where password authentication needs to be enabled:

```bash
sudo sed -i -E 's/^#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
sudo sed -i -E 's/^PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config.d/50-cloud-init.conf && \
sudo sshd -t && \
sudo systemctl reload sshd
```

Set the password for `ec2-user`:

```bash
sudo passwd ec2-user
```

## 4.1 Verify Password Authentication

```bash
sudo sshd -T | grep -i passwordauthentication
```

Expected output:

```text
passwordauthentication yes
```

> **Note:** `sudo sshd -t` validates the SSH configuration before the SSH service is reloaded.

---

# 5. Ansible Inventory

## 5.1 Create the Inventory File

Create an inventory file on the Control Node:

```bash
cat > ~/inventory.ini <<EOF
[managed]
node2 ansible_host=<MANAGED_NODE_1_IP>
node3 ansible_host=<MANAGED_NODE_2_IP>
node4 ansible_host=<MANAGED_NODE_3_IP>

[managed:vars]
ansible_user=ec2-user
EOF
```

---

## 5.2 Create the Ansible Configuration File

Create an `ansible.cfg` file so that Ansible automatically uses the inventory file without requiring `-i` on every command:

```bash
cat > ./ansible.cfg <<EOF
[defaults]
inventory = ./inventory.ini
host_key_checking = False
EOF
```

Verify the configuration is picked up:

```bash
ansible --version
```

The output should include:

```text
config file = /home/ec2-user/ansible.cfg
```

> **Note:** Ansible looks for `ansible.cfg` in the current working directory first, then `~/.ansible.cfg`, then `/etc/ansible/ansible.cfg`. Creating it in the home directory (`~/ansible.cfg`) means it applies for all commands run from any directory by that user.

---

# 6. Verify Ansible Inventory

List the hosts available in the inventory:

```bash
ansible managed --list-hosts
```

Expected output:

```text
hosts (3):
    node2
    node3
    node4
```

---

# 7. Ansible Ad-Hoc Commands with Password Authentication

These commands can be used before passwordless SSH is configured. Ansible requires `sshpass` to handle password authentication over SSH. The `--ask-pass` flag prompts for the password interactively.

## 7.0 Install sshpass

Run on the **Control Node**:

```bash
sudo dnf install -y sshpass
```

If `dnf` is not available:

```bash
sudo yum install -y sshpass
```

## 7.1 Check Connectivity

```bash
ansible managed -m ping --ask-pass
```

## 7.2 Check Hostname

```bash
ansible managed -m command -a "hostname" --ask-pass
```

## 7.3 Check Uptime

```bash
ansible managed -m command -a "uptime" --ask-pass
```

## 7.4 Check Disk Usage

```bash
ansible managed -m command -a "df -h" --ask-pass
```

---

# 8. Configure Passwordless SSH Authentication

Passwordless SSH authentication allows the Ansible Control Node to connect to the Managed Nodes using an SSH key instead of a password.

The **Control Node** generates the SSH key pair, and only the **public key** is copied to the Managed Nodes.

```text
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

> **Important:** The private key must remain on the Control Node. Only the public key should be copied to the Managed Nodes.

---

## 8.1 Generate SSH Key Pair on the Control Node

Run the following commands on **Node1 (Control Node)**:

```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh

if [ ! -f ~/.ssh/id_ed25519 ]; then
    ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N ""
else
    echo "SSH key already exists."
fi

chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub

echo "SSH key setup completed."
```

The following files will be created:

```text
~/.ssh/id_ed25519
~/.ssh/id_ed25519.pub
```

| File | Purpose |
|---|---|
| `id_ed25519` | Private key — keep on the Control Node |
| `id_ed25519.pub` | Public key — copy to Managed Nodes |

---

## 8.2 Copy the Public Key to the Managed Nodes

Run the following commands from **Node1 (Control Node)**.

### Node2

```bash
ssh-copy-id -i ~/.ssh/id_ed25519.pub ec2-user@<MANAGED_NODE_1_IP>
```

### Node3

```bash
ssh-copy-id -i ~/.ssh/id_ed25519.pub ec2-user@<MANAGED_NODE_2_IP>
```

### Node4

```bash
ssh-copy-id -i ~/.ssh/id_ed25519.pub ec2-user@<MANAGED_NODE_3_IP>
```

Replace the following placeholders with the respective IP addresses of the Managed Nodes:

```text
<MANAGED_NODE_1_IP>
<MANAGED_NODE_2_IP>
<MANAGED_NODE_3_IP>
```

The first time `ssh-copy-id` is executed for each node, you will be prompted for the `ec2-user` password.

The public key will be added to:

```text
/home/ec2-user/.ssh/authorized_keys
```

on each Managed Node.

---

## 8.3 Verify Passwordless SSH

From the **Control Node**, connect to each Managed Node.

### Node2

```bash
ssh ec2-user@<MANAGED_NODE_1_IP>
```

### Node3

```bash
ssh ec2-user@<MANAGED_NODE_2_IP>
```

### Node4

```bash
ssh ec2-user@<MANAGED_NODE_3_IP>
```

The SSH connection should be established without requesting the `ec2-user` password.

---

## 8.4 Verify All Managed Nodes

You can also verify all three Managed Nodes using:

```bash
ssh ec2-user@<MANAGED_NODE_1_IP> hostname
ssh ec2-user@<MANAGED_NODE_2_IP> hostname
ssh ec2-user@<MANAGED_NODE_3_IP> hostname
```

Each command should return the hostname of the corresponding Managed Node without requesting a password.

---

# 9. SSH Authentication Flow

The final SSH authentication flow is:

```text
                         Node1
                  Ansible Control Node
                         |
                         | SSH Private Key
                         | ~/.ssh/id_ed25519
                         |
             +-----------+-----------+
             |           |           |
             v           v           v
          Node2       Node3       Node4
         Managed      Managed      Managed
          Node         Node         Node
```

The Control Node's public key:

```text
~/.ssh/id_ed25519.pub
```

is stored in:

```text
~/.ssh/authorized_keys
```

on each Managed Node.

The private key:

```text
~/.ssh/id_ed25519
```

remains only on the Control Node.

---

# 10. SSH Files and Permissions

## 10.1 Control Node

The Control Node should contain:

```text
~/.ssh/
├── id_ed25519
└── id_ed25519.pub
```

Recommended permissions:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
```

## 10.2 Managed Nodes

Each Managed Node should contain:

```text
~/.ssh/
└── authorized_keys
```

Recommended permissions:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

> **Important:** Never copy the private key (`id_ed25519`) to the Managed Nodes. Only the public key (`id_ed25519.pub`) should be added to `authorized_keys`.

---

# 11. Ansible Inventory

Create an inventory file on the Control Node.

Example:

```ini
[managed]
node2 ansible_host=<MANAGED_NODE_1_IP>
node3 ansible_host=<MANAGED_NODE_2_IP>
node4 ansible_host=<MANAGED_NODE_3_IP>

[managed:vars]
ansible_user=ec2-user
```

---

# 12. Verify Ansible Inventory

List the hosts available in the inventory:

```bash
ansible managed --list-hosts
```

Expected output:

```text
hosts (3):
    node2
    node3
    node4
```

---

# 13. Ansible Connectivity Test

Test connectivity to all Managed Nodes:

```bash
ansible managed -m ping
```

Expected result:

```text
node2 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}

node3 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}

node4 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

---

# 14. Useful Ansible Ad-Hoc Commands

## 14.1 Check Connectivity

```bash
ansible managed -m ping
```

## 14.2 Check Hostname

```bash
ansible managed -m command -a "hostname"
```

## 14.3 Check Uptime

```bash
ansible managed -m command -a "uptime"
```

## 14.4 Check Disk Usage

```bash
ansible managed -m command -a "df -h"
```

## 14.5 Check Memory

```bash
ansible managed -m command -a "free -m"
```

## 14.6 Check OS Information

```bash
ansible managed -m command -a "cat /etc/os-release"
```

## 14.7 Check Current User

```bash
ansible managed -m command -a "whoami"
```

## 14.8 Execute a Command with Sudo

```bash
ansible managed -b -m command -a "whoami"
```

Expected output:

```text
root
```

---

# 15. Summary

The basic setup process is:

1. Update the VM packages.
2. Install Python on the Managed Nodes.
3. Install Python and `pip3` on the Control Node.
4. Install Ansible on the Control Node using `pip`.
5. Configure the Control Node `PATH` for the user-installed Ansible binaries.
6. Verify that the SSH service is running.
7. Enable password authentication temporarily if required.
8. Set the `ec2-user` password.
9. Configure the Ansible inventory.
10. Verify the inventory.
11. Test Ansible connectivity using password-based ad-hoc commands.
12. Generate an SSH key pair on the Control Node.
13. Keep the private key on the Control Node.
14. Copy only the public key to the Managed Nodes using `ssh-copy-id`.
15. Test SSH connectivity from the Control Node to each Managed Node.
16. Verify Ansible connectivity using the `ping` module.
17. Start using Ansible ad-hoc commands and playbooks.

> **Security Recommendation:** Password authentication should ideally be disabled after key-based authentication has been successfully configured and verified. The private SSH key (`~/.ssh/id_ed25519`) should never be copied to the Managed Nodes.
