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

Run the following commands on all the nodes (including control and managed) where password authentication needs to be enabled:

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

# 11. Ansible Connectivity Test

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

# 12. Useful Ansible Ad-Hoc Commands

## 12.1 Check Connectivity

```bash
ansible managed -m ping
```

## 12.2 Check Hostname

```bash
ansible managed -m command -a "hostname"
```

## 12.3 Check Uptime

```bash
ansible managed -m command -a "uptime"
```

## 12.4 Check Disk Usage

```bash
ansible managed -m command -a "df -h"
```

## 12.5 Check Memory

```bash
ansible managed -m command -a "free -m"
```

## 12.6 Check OS Information

```bash
ansible managed -m command -a "cat /etc/os-release"
```

## 12.7 Check Current User

```bash
ansible managed -m command -a "whoami"
```

## 12.8 Execute a Command with Sudo

```bash
ansible managed -b -m command -a "whoami"
```

Expected output:

```text
root
```

---

# 13. Create and Run an Ansible Nginx Playbook

This section demonstrates how to create an Ansible playbook that installs and starts Nginx on all Managed Nodes.

The existing inventory contains the `managed` group. We will create an additional `webservers` group containing the same three nodes.

The final directory structure will be:

```text
/home/ec2-user/
├── ansible.cfg
├── inventory.ini
└── playbooks/
    └── nginx.yml
```

> **Important:** The playbook uses `hosts: webservers`, so the `webservers` group must exist in the Ansible inventory.

---

## 13.1 Add the `webservers` Group

Go to the directory containing the Ansible configuration and inventory files:

```bash
cd /home/ec2-user
```

Update the inventory file:

```bash
cat > inventory.ini <<'EOF'
[managed]
node2 ansible_host=3.110.90.44
node3 ansible_host=65.1.148.99
node4 ansible_host=13.233.104.229

[managed:vars]
ansible_user=ec2-user

[webservers]
node2
node3
node4

[webservers:vars]
ansible_user=ec2-user
EOF
```

The inventory now contains two groups:

```text
managed
 ├── node2
 ├── node3
 └── node4

webservers
 ├── node2
 ├── node3
 └── node4
```

The existing `managed` group is retained so that previously created Ansible commands continue to work.

The new `webservers` group will be used by the Nginx playbook.

---

## 13.2 Verify the `webservers` Group

Verify that Ansible recognizes all three nodes as members of the `webservers` group:

```bash
ansible webservers --list-hosts
```

Expected output:

```text
hosts (3):
  node2
  node3
  node4
```

If all three nodes are displayed, the inventory is configured correctly.

You can also view the complete inventory structure:

```bash
ansible-inventory --graph
```

Expected output will include:

```text
@webservers:
  |--node2
  |--node3
  |--node4
```

---

## 13.3 Test Ansible Connectivity

Before creating or running the playbook, verify that the Control Node can communicate with all three Managed Nodes.

Run:

```bash
ansible webservers -m ping
```

Expected output:

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

All three nodes should return `SUCCESS`.

> **Note:** The `ping` module does not use ICMP ping. Ansible connects to the Managed Nodes over SSH and executes the Ansible module remotely.

---

## 13.4 Create the Playbooks Directory

Create a directory to store Ansible playbooks:

```bash
mkdir -p /home/ec2-user/playbooks
```

Change to the playbooks directory:

```bash
cd /home/ec2-user/playbooks
```

Verify the current directory:

```bash
pwd
```

Expected:

```text
/home/ec2-user/playbooks
```

---

## 13.5 Create the Nginx Playbook

Create the playbook:

```bash
cat > nginx.yml <<'EOF'
---
- name: Install and start nginx
  hosts: webservers
  become: true

  tasks:

    - name: Install nginx package
      ansible.builtin.dnf:
        name: nginx
        state: present

    - name: Ensure nginx is running
      ansible.builtin.service:
        name: nginx
        state: started
        enabled: true
EOF
```

Verify the playbook:

```bash
cat nginx.yml
```

The playbook contains two tasks.

### Task 1 — Install Nginx

```yaml
- name: Install nginx package
  ansible.builtin.dnf:
    name: nginx
    state: present
```

This ensures that the Nginx package is installed on all hosts in the `webservers` group.

Because the Managed Nodes are RHEL-based systems, the `dnf` module is used instead of the `apt` module used by Debian/Ubuntu systems.

The following:

```yaml
state: present
```

means that Nginx must be installed. If it is already installed, Ansible does not reinstall it.

### Task 2 — Start and Enable Nginx

```yaml
- name: Ensure nginx is running
  ansible.builtin.service:
    name: nginx
    state: started
    enabled: true
```

This ensures that:

* Nginx is currently running.
* Nginx is enabled to start automatically after a system reboot.

The playbook also contains:

```yaml
become: true
```

This allows Ansible to use privilege escalation (`sudo`) because installing packages and managing system services require administrative privileges.

---

## 13.6 Syntax Check the Playbook

Before running the playbook, validate its YAML and Ansible syntax.

You should currently be in:

```text
/home/ec2-user/playbooks
```

Run:

```bash
ansible-playbook --syntax-check nginx.yml
```

Expected output:

```text
playbook: nginx.yml
```

If this is displayed without an error, the playbook syntax is valid.

> **Note:** A syntax check does not execute the playbook. It only validates the playbook structure and syntax.

---

## 13.7 Run the Nginx Playbook

The `ansible.cfg` and `inventory.ini` files are located in:

```text
/home/ec2-user/
```

Therefore, run the playbook from `/home/ec2-user` so Ansible automatically picks up the configured inventory.

Go back to the home directory:

```bash
cd /home/ec2-user
```

Run:

```bash
ansible-playbook playbooks/nginx.yml
```

On the first execution, Ansible should install Nginx and start the service on all three Managed Nodes.

A successful execution should look similar to:

```text
PLAY [Install and start nginx] ***********************************************

TASK [Gathering Facts] *******************************************************
ok: [node2]
ok: [node3]
ok: [node4]

TASK [Install nginx package] *************************************************
changed: [node2]
changed: [node3]
changed: [node4]

TASK [Ensure nginx is running] ***********************************************
changed: [node2]
changed: [node3]
changed: [node4]

PLAY RECAP *******************************************************************
node2 : ok=3 changed=2 unreachable=0 failed=0
node3 : ok=3 changed=2 unreachable=0 failed=0
node4 : ok=3 changed=2 unreachable=0 failed=0
```

The exact output may vary.

---

## 13.8 Run the Playbook a Second Time

Run the same command again:

```bash
ansible-playbook playbooks/nginx.yml
```

The second execution should report `ok` instead of `changed` for the Nginx installation and service tasks:

```text
TASK [Install nginx package] *************************************************
ok: [node2]
ok: [node3]
ok: [node4]

TASK [Ensure nginx is running] ***********************************************
ok: [node2]
ok: [node3]
ok: [node4]
```

This demonstrates **Ansible idempotency**.

Ansible checks the current state of the Managed Nodes and only makes changes when the desired state has not already been achieved.

For example:

```text
First Run
---------
Nginx not installed
        ↓
Ansible installs Nginx
        ↓
changed


Second Run
----------
Nginx already installed
        ↓
Nginx already running
        ↓
No changes required
        ↓
ok
```

---

## 13.9 Verify Nginx Is Running

Verify the Nginx service on all Managed Nodes:

```bash
ansible webservers -b -m command -a "systemctl is-active nginx"
```

Expected output should contain:

```text
active
```

for `node2`, `node3`, and `node4`.

---

## 13.10 Verify Nginx Is Enabled

Verify that Nginx will automatically start after a reboot:

```bash
ansible webservers -b -m command -a "systemctl is-enabled nginx"
```

Expected output:

```text
enabled
```

for all three Managed Nodes.

---

## 13.11 Verify the Nginx Version

You can also verify that Nginx is installed by checking its version:

```bash
ansible webservers -m command -a "nginx -v"
```

Each Managed Node should return the installed Nginx version.

---

## 13.12 Final Directory Structure

After completing this exercise, the Control Node should have:

```text
/home/ec2-user/
├── ansible.cfg
├── inventory.ini
└── playbooks/
    └── nginx.yml
```

The overall workflow is:

```text
Control Node
    |
    | inventory.ini
    | webservers group
    |
    v
Ansible Playbook
nginx.yml
    |
    +------------------+------------------+
    |                  |                  |
    v                  v                  v
  node2              node3              node4
    |                  |                  |
    v                  v                  v
 Install Nginx      Install Nginx      Install Nginx
 Start Nginx        Start Nginx        Start Nginx
 Enable Nginx       Enable Nginx       Enable Nginx
```
---

# 14. Summary

The basic setup process is:

1. Update the VM packages.
2. Install Python on the Managed Nodes.
3. Install Python and `pip3` on the Control Node.
4. Install Ansible on the Control Node using `pip`.
5. Configure the Control Node `PATH` for the user-installed Ansible binaries.
6. Verify that the SSH service is running.
7. Enable password authentication temporarily if required.
8. Set the `ec2-user` password.
9. Configure the Ansible inventory and `ansible.cfg`.
10. Test Ansible connectivity using password-based ad-hoc commands.
11. Generate an SSH key pair on the Control Node.
12. Keep the private key on the Control Node.
13. Copy only the public key to the Managed Nodes using `ssh-copy-id`.
14. Test SSH connectivity from the Control Node to each Managed Node.
15. Verify Ansible connectivity using the `ping` module.
16. Start using Ansible ad-hoc commands and playbooks.

> **Security Recommendation:** Password authentication should ideally be disabled after key-based authentication has been successfully configured and verified. The private SSH key (`~/.ssh/id_ed25519`) should never be copied to the Managed Nodes.
