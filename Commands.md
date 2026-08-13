# Ansible SSH Configuration

This document explains how to enable password authentication and configure passwordless SSH authentication between the **Ansible Control Node** and the **Managed Nodes**.

### Environment

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

---

## 1. Enable Password Authentication

Password authentication is required initially to copy the Control Node's SSH public key to the Managed Nodes.

Run the following commands on the nodes where password authentication needs to be enabled:

```bash
sudo sed -i -E 's/^#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
sudo sed -i -E 's/^PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config.d/50-cloud-init.conf && \
sudo sshd -t && \
sudo systemctl reload sshd

sudo systemctl restart sshd
```

Set the password for `ec2-user`:

```bash
sudo passwd ec2-user
```

### Verify Password Authentication

```bash
sudo sshd -T | grep -i passwordauthentication
```

Expected output:

```text
passwordauthentication yes
```

> **Note:** `sudo sshd -t` validates the SSH configuration before the SSH service is reloaded.

---

# 2. Configure Passwordless SSH Authentication

Passwordless SSH authentication uses an SSH key pair instead of the user's password.

The **Control Node** generates the SSH key pair, and only the **public key** is copied to the Managed Nodes.

```text
Control Node (Node1)
        |
        | ~/.ssh/id_ed25519
        | ~/.ssh/id_ed25519.pub
        |
        +--------------------+
        |                    |
        v                    v
     Node2                Node3                Node4
     Managed              Managed              Managed
     Node                 Node                 Node
```

> **Important:** The private key must remain on the Control Node. Only the public key should be copied to the Managed Nodes.

---

## 2.1 Generate SSH Key Pair on the Control Node

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

## 2.2 Copy the Public Key to the Managed Nodes

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

Replace:

```text
<MANAGED_NODE_1_IP>
<MANAGED_NODE_2_IP>
<MANAGED_NODE_3_IP>
```

with the respective private IP addresses of the Managed Nodes.

The first time `ssh-copy-id` is executed for each node, you will be prompted for the `ec2-user` password.

The public key will be added to:

```text
/home/ec2-user/.ssh/authorized_keys
```

on each Managed Node.

---

## 2.3 Verify Passwordless SSH

From the **Control Node**, connect to each Managed Node.

### Node2

```bash
ssh ec2-user@<MANAGED_NODE_1_IPP>
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

## 2.4 Verify Using a Single Command

You can also verify all three Managed Nodes by running:

```bash
ssh ec2-user@<MANAGED_NODE_1_IP> hostname
ssh ec2-user@<MANAGED_NODE_2_IP> hostname
ssh ec2-user@<MANAGED_NODE_3_IP> hostname
```

Each command should return the hostname of the corresponding Managed Node without requesting a password.

---

# 3. SSH Authentication Flow

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
             |           |           |
             +-----------+-----------+
                         |
                  authorized_keys
```

The authentication works as follows:

```text
Node1
 |
 | Private Key
 | ~/.ssh/id_ed25519
 |
 +------ SSH ------> Node2
                     |
                     | Public Key
                     | ~/.ssh/authorized_keys
                     |
                     +--> Authentication successful
```

---

# 4. Important SSH Files and Permissions

### Control Node

```text
~/.ssh/
├── id_ed25519          # Private key
└── id_ed25519.pub      # Public key
```

Recommended permissions:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
```

### Managed Nodes

```text
~/.ssh/
└── authorized_keys
```

Recommended permissions:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

---

# 5. Ansible Connectivity Test

Once passwordless SSH is working, configure the Ansible inventory on the Control Node.

Example:

```ini
[managed]
node2 ansible_host=<MANAGED_NODE_1_IP>
node3 ansible_host=<MANAGED_NODE_2_IP>
node4 ansible_host=<MANAGED_NODE_2_IP>

[managed:vars]
ansible_user=ec2-user
```

Test Ansible connectivity:

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

# 6. Summary

The setup requires the following steps:

1. Enable password authentication temporarily if required.
2. Set the `ec2-user` password.
3. Generate an SSH key pair on the Control Node.
4. Keep the private key on the Control Node.
5. Copy only the public key to the Managed Nodes using `ssh-copy-id`.
6. Test SSH connectivity from the Control Node to each Managed Node.
7. Configure the Ansible inventory.
8. Verify connectivity using the Ansible `ping` module.

> **Security Recommendation:** The private key (`~/.ssh/id_ed25519`) should never be copied to the Managed Nodes. Only `~/.ssh/id_ed25519.pub` should be added to the Managed Nodes' `~/.ssh/authorized_keys`.
