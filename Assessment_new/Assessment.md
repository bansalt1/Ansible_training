# 🧪 Ansible Foundations — Final Assessment

> **Course:** Ansible Fundamentals (6-Day Training)
> **Format:** MCQs · Ad-hoc Command Tasks · Fix the Broken YAML
> **Total Marks:** 100 &nbsp;|&nbsp; **Duration:** 90 minutes &nbsp;|&nbsp; **Passing Score:** 70 / 100
>
> 📄 Answers are in [`ANSWER-KEY.md`](./ANSWER-KEY.md) — for instructor use only.

| Section | Description | Marks |
|---------|-------------|-------|
| A | Multiple Choice Questions (30 × 1) | 30 |
| B | Ad-hoc Command Tasks (8 × 5) | 40 |
| C | Fix the Broken YAML (6 × 5) | 30 |
| | **Total** | **100** |

---

## 📋 Table of Contents

1. [Instructions](#-instructions)
2. [Lab Environment Setup](#-lab-environment-setup)
3. [Section A — Multiple Choice Questions (30 marks)](#section-a--multiple-choice-questions-30-marks)
4. [Section B — Ad-hoc Command Tasks (40 marks)](#section-b--ad-hoc-command-tasks-40-marks)
5. [Section C — Fix the Broken YAML (30 marks)](#section-c--fix-the-broken-yaml-30-marks)
6. [Submission Instructions](#-submission-instructions)

---

## 📌 Instructions

- Attempt **all** sections.
- For **Section A**, write the letter of the correct answer in the `Your Answer:` field after each question.
- For **Section B**, all required files are provided in the [Lab Environment Setup](#-lab-environment-setup) section. Run every command from the `~/ansible-assessment/` directory and **paste the actual terminal output** in the space given.
- For **Section C**, **rewrite the entire corrected block** below each broken snippet — identifying the error alone without fixing it earns zero marks.
- No AI assistance is permitted. All Section B outputs must come from your own running lab environment.

---

## 🖥️ Lab Environment Setup

> **Complete this setup first — before attempting Section B.** Everything is provided here; there are no dependencies on any files created during training.

### Step 1 — Create the Assessment Working Directory

```bash
mkdir -p ~/ansible-assessment
cd ~/ansible-assessment
```

### Step 2 — Create `ansible.cfg`

Create `~/ansible-assessment/ansible.cfg` with exactly the following content:

```ini
[defaults]
inventory         = ./inventory.ini
remote_user       = student
host_key_checking = False

[privilege_escalation]
become_method = sudo
```

### Step 3 — Create `inventory.ini`

> ⚠️ **Replace the placeholder IPs below with the actual IP addresses of your lab nodes before saving the file.**
> Your instructor will provide the correct IPs for your environment. Do not run any Section B commands until the IPs are updated.

Create `~/ansible-assessment/inventory.ini`:

```ini
[web]
node1 ansible_host=<IP-OF-NODE1>
node2 ansible_host=<IP-OF-NODE2>

[db]
node3 ansible_host=<IP-OF-NODE3>

[all:vars]
ansible_user=student
ansible_python_interpreter=/usr/bin/python3
```

**Example** (your IPs will differ):
```ini
node1 ansible_host=10.0.0.11
node2 ansible_host=10.0.0.12
node3 ansible_host=10.0.0.13
```

### Step 4 — Set Up Passwordless SSH

> ⚠️ **Use the actual IPs of your nodes** in the `ssh-copy-id` commands below — not the placeholders.

If SSH prompts for a password when connecting to your nodes, run these once on the control node:

```bash
ssh-keygen -t ed25519        # Press Enter for all prompts
ssh-copy-id student@<IP-OF-NODE1>
ssh-copy-id student@<IP-OF-NODE2>
ssh-copy-id student@<IP-OF-NODE3>
```

### Step 5 — Verify the Environment is Ready

```bash
cd ~/ansible-assessment
ansible-inventory --list
```

You should see `node1`, `node2` under `web` and `node3` under `db`. Once this looks correct, your environment is ready for Section B.

---

## Section A — Multiple Choice Questions (30 marks)

> **30 questions × 1 mark each.** Write the letter of the single best answer.

---

**Q1.** Which of the following best describes Ansible's agentless architecture?

- A) Ansible installs a lightweight daemon on each managed host that runs continuously
- B) Ansible connects to hosts on demand over SSH or WinRM; nothing persists on the remote host after execution
- C) Ansible requires a central database to track the state of all managed hosts
- D) Managed nodes periodically pull configuration from the control node

**Your Answer:** ___

---

**Q2.** What is the only requirement on a **managed Linux host** for Ansible to connect and run tasks?

- A) Ansible installed on the managed host
- B) A running HTTP/HTTPS service on port 443
- C) Python and SSH access with a valid user account
- D) The `ansible-agent` service running and listening on port 8443

**Your Answer:** ___

---

**Q3.** Which of the following is **NOT** a core component of Ansible's architecture?

- A) Control Node
- B) Inventory
- C) Agent Daemon
- D) Modules

**Your Answer:** ___

---

**Q4.** What does **idempotency** mean in the context of Ansible?

- A) Running a task in parallel across multiple hosts simultaneously
- B) Running the same task multiple times always produces the same result, without unintended side effects
- C) Tasks that skip execution when the managed host is already at the latest OS version
- D) The ability to roll back a failed playbook to a previous known-good state

**Your Answer:** ___

---

**Q5.** On Ubuntu, which sequence of commands correctly installs Ansible?

- A) `sudo yum install epel-release -y` → `sudo yum install ansible -y`
- B) `sudo yum update` → `sudo yum install ansible -y`
- C) `pip install ansible` → `ansible --configure`
- D) `snap install ansible` → `ansible init`

**Your Answer:** ___

---

**Q6.** On RHEL/CentOS, which repository must be enabled **before** installing Ansible via DNF?

- A) REMI
- B) EPEL (Extra Packages for Enterprise Linux)
- C) AppStream Base
- D) SCL (Software Collections)

**Your Answer:** ___

---

**Q7.** Which command confirms that Ansible is correctly installed and shows the Python version it uses?

- A) `ansible -v`
- B) `ansible --check`
- C) `ansible --version`
- D) `ansible status`

**Your Answer:** ___

---

**Q9.** Which file controls Ansible's default behaviour — inventory path, remote user, and SSH settings — at the project level?

- A) `inventory/hosts.ini`
- B) `playbooks/site.yml`
- C) `ansible.cfg`
- D) `group_vars/all.yml`

**Your Answer:** ___

---

**Q11.** Which `ansible.cfg` directive disables SSH host-key verification?

- A) `ssh_check = false`
- B) `disable_key_check = yes`
- C) `host_key_checking = False`
- D) `strict_host_check = no`

**Your Answer:** ___

---

**Q13.** Which command outputs your full inventory structure as JSON — useful for verifying hosts and groups before running a playbook?

- A) `ansible --list-hosts all`
- B) `ansible-inventory --list`
- C) `ansible all --inventory`
- D) `ansible-playbook --check inventory/`

**Your Answer:** ___

---

**Q15.** Which inventory variable sets the actual **IP address** Ansible connects to when the hostname is not DNS-resolvable?

- A) `ansible_ip`
- B) `ansible_address`
- C) `ansible_host`
- D) `remote_host`

**Your Answer:** ___

---

**Q16.** Which command generates a new SSH key pair on the control node?

- A) `ssh-keygen -t ed25519`
- B) `ansible-keygen --ssh`
- C) `openssl genrsa -out id_rsa 4096`
- D) `ssh-create-key --type rsa`

**Your Answer:** ___

---

**Q17.** Which command copies the control node's SSH public key to a managed host's `authorized_keys`?

- A) `ssh-keygen --copy user@host`
- B) `ssh-copy-id user@hostname`
- C) `scp ~/.ssh/id_rsa.pub user@host:~/.ssh/`
- D) `ansible all -m authorized_key`

**Your Answer:** ___

---

**Q18.** The control node is best described as:

- A) A dedicated server that must not run any other workload
- B) The machine where Ansible is installed and from which all automation is executed
- C) Any managed node that also runs `ansible-playbook`
- D) A cloud-hosted service that manages inventory and scheduling

**Your Answer:** ___

---

**Q19.** Which module runs a command through `/bin/sh`, enabling pipes and output redirection?

- A) `command`
- B) `raw`
- C) `shell`
- D) `exec`

**Your Answer:** ___

---

**Q20.** What is the key difference between the `command` and `shell` modules?

- A) `command` requires Python; `shell` does not
- B) `command` executes binaries directly without shell interpretation; `shell` runs through `/bin/sh`, enabling pipes, redirection, and environment variables
- C) `shell` is deprecated in favour of `command`
- D) `command` supports Windows targets; `shell` supports Linux only

**Your Answer:** ___

---

**Q21.** An ad-hoc command returns `UNREACHABLE` for a host. What should you check **first**?

- A) Whether the playbook YAML syntax is correct
- B) Whether SSH is reachable on port 22 and no firewall is blocking the connection
- C) Whether the correct `remote_user` is set in `ansible.cfg`
- D) Whether Python is installed on the managed node

**Your Answer:** ___

---

**Q22.** How do you add **sudo privilege escalation** to a single ad-hoc command without editing `ansible.cfg`?

- A) Add `-s` to the command
- B) Add `--sudo` to the command
- C) Add `--become` to the command
- D) Prefix the module argument with `sudo:`

**Your Answer:** ___

---

**Q23.** Which ad-hoc command installs the `vim` package on the `web` group using the `yum` module with privilege escalation?

- A) `ansible web -m yum -a 'name=vim state=present'`
- B) `ansible web -m yum -a 'name=vim state=present' --become`
- C) `ansible web -m install -a 'package=vim' --become`
- D) `ansible web --sudo -m yum -a 'name=vim'`

**Your Answer:** ___

---

**Q24.** Which of the following is a **valid** YAML key-value pair?

- A) `port = 8080`
- B) `port: 8080`
- C) `port -> 8080`
- D) `port:8080` *(no space after colon)*

**Your Answer:** ___

---

**Q25.** In YAML, list items are denoted by:

- A) `*` followed by a space
- B) `>` followed by a space
- C) `-` followed by a space
- D) `+` followed by a space

**Your Answer:** ___

---

**Q27.** Which command validates a playbook's YAML syntax **without** executing any tasks on hosts?

- A) `ansible-playbook --dry-run site.yml`
- B) `ansible-playbook --syntax-check site.yml`
- C) `ansible --check-yaml site.yml`
- D) `yamllint --ansible site.yml`

**Your Answer:** ___

---

**Q28.** In an Ansible play, what does `become: true` do?

- A) Forces the play to run in check mode without making changes
- B) Elevates privileges (sudo) so tasks run as root or another privileged user
- C) Enables dry-run mode
- D) Detaches the play and runs it in the background

**Your Answer:** ___

---

**Q29.** In what order are tasks in a play executed?

- A) Alphabetically by task name
- B) Randomly — Ansible optimises order automatically
- C) Top-to-bottom, in the order they are listed in the playbook
- D) By host group priority as defined in the inventory

**Your Answer:** ___

---

**Q30.** A playbook is run twice. First run: `changed=1, failed=0`. Second run: `changed=0, failed=0`. What does the second run confirm?

- A) The second run silently suppressed an error
- B) The task was skipped due to a `when` condition
- C) Idempotency is working — the desired state was already present; no changes were needed
- D) The module did not execute because the host was unreachable

**Your Answer:** ___

---

## Section B — Ad-hoc Command Tasks (40 marks)

> **Use the `ansible.cfg` and `inventory.ini` created in [Lab Environment Setup](#-lab-environment-setup).**
> Run all commands from `~/ansible-assessment/`.
> Each task is worth **5 marks**: 3 for the correct command, 2 for the pasted output.
> Write the exact command you ran and paste the complete terminal output below it.

---

### Task 1 — Connectivity Test (5 marks)

Verify that Ansible can reach all managed nodes.

**Command:**

```bash
# Your command here
```

**Output:**

```
# Paste your terminal output here
```

---

### Task 2 — Check Uptime on All Hosts (5 marks)

Retrieve the uptime of all managed nodes.

**Command:**

```bash
# Your command here
```

**Output:**

```
# Paste your terminal output here
```

---

### Task 3 — Check Disk Usage on the `web` Group (5 marks)

Check disk usage (`df -h`) on all hosts in the `web` group.

**Command:**

```bash
# Your command here
```

**Output:**

```
# Paste your terminal output here
```

---

### Task 4 — Check Memory on All Hosts (5 marks)

Display memory usage in megabytes across all nodes.

**Command:**

```bash
# Your command here
```

**Output:**

```
# Paste your terminal output here
```

---

### Task 5 — Check Hostname on the `db` Group (5 marks)

Print the hostname of every node in the `db` group.

**Command:**

```bash
# Your command here
```

**Output:**

```
# Paste your terminal output here
```

---

### Task 6 — Install a Package with Privilege Escalation (5 marks)

Install the `tree` package on the `web` group using an ad-hoc command with sudo.

**Command:**

```bash
# Your command here
```

**Output:**

```
# Paste your terminal output here
```

---

### Task 7 — Run a Playbook and Capture Output (5 marks)

Save the playbook below as `~/ansible-assessment/install-curl.yml`, run it **twice**, and paste both outputs.

```yaml
---
- name: Ensure curl is installed on web servers
  hosts: web
  become: true

  tasks:
    - name: Install curl
      yum:
        name: curl
        state: present
```

**Save the playbook:**

```bash
# Save the above content to ~/ansible-assessment/install-curl.yml
```

**First run command:**

```bash
# Your command here
```

**First run output:**

```
# Paste your first run output here
```

**Second run command:**

```bash
# Your command here (same command)
```

**Second run output:**

```
# Paste your second run output here
```

**What is different between the two outputs, and what does that tell you?**

```
# Your one-sentence answer here
```

---

### Task 8 — Run a Multi-Task Playbook and Verify the Result (5 marks)

Save the playbook below as `~/ansible-assessment/setup-web.yml`, run it, then verify the nginx service is running with an ad-hoc command.

```yaml
---
- name: Install and start nginx on web servers
  hosts: web
  become: true

  tasks:
    - name: Install nginx
      yum:
        name: nginx
        state: present

    - name: Ensure nginx service is started and enabled
      service:
        name: nginx
        state: started
        enabled: true
```

**Save and run the playbook:**

```bash
# Your ansible-playbook command here
```

**Playbook output:**

```
# Paste your playbook output here
```

**Now verify nginx is running using an ad-hoc `shell` command on the `web` group:**

```bash
# Your ad-hoc verification command here
```

**Verification output:**

```
# Paste your verification output here
```

---

## Section C — Fix the Broken YAML (30 marks)

> Each exercise below contains **one or more deliberate errors**.
> **Rewrite the fully corrected version** below each broken block.
> Each exercise: **2 marks** for correctly identifying all errors · **3 marks** for the corrected working code.

---

### Exercise 1 (5 marks)

**Broken playbook:**

```yaml
---
- name: Install nginx
  hosts: webservers
  become: true
  tasks:
    - name: Install package
      yum:
      name: nginx
      state: present
```

**What is/are the error(s)?**

```
# Your answer here
```

**Corrected playbook:**

```yaml
# Your corrected YAML here
```

---

### Exercise 2 (5 marks)

> `→` represents a tab character.

**Broken playbook:**

```
---
- name: Configure server
  hosts: all
  tasks:
→ - name: Check disk
→   shell: df -h
```

**What is/are the error(s)?**

```
# Your answer here
```

**Corrected playbook:**

```yaml
# Your corrected YAML here
```

---

### Exercise 3 (5 marks)

**Broken variable file:**

```yaml
packages:
  nginx
  python3
  git
```

**What is/are the error(s)?**

```
# Your answer here
```

**Corrected variable file:**

```yaml
# Your corrected YAML here
```

---

### Exercise 4 (5 marks)

**Broken playbook fragment:**

```yaml
- name Deploy web app
  hosts webservers
  become True

  tasks:
    - name: Start nginx
      service:
        name: nginx
        state started
```

**What is/are the error(s)?** (list every one)

```
# Your answer here
```

**Corrected fragment:**

```yaml
# Your corrected YAML here
```

---

### Exercise 5 (5 marks)

**Broken `ansible.cfg`:**

```ini
[defaults]
Inventory = inventory/hosts.ini
remote user = student
become = true
become_method = sudo
host_key_checking = False
```

**What is/are the error(s)?**

```
# Your answer here
```

**Corrected `ansible.cfg`:**

```ini
# Your corrected file here
```

---

### Exercise 6 (5 marks)

**Broken playbook:**

```yaml
---
- name: Setup database server
  hosts: db
  become: true

  tasks:
  - name: Install postgresql
      yum:
        name: postgresql
        state: present

    - name: Start postgresql
      service
        name: postgresql
        state: started
        enabled: true
```

**What is/are the error(s)?** (list every one)

```
# Your answer here
```

**Corrected playbook:**

```yaml
# Your corrected YAML here
```

---

## 📤 Submission Instructions

1. **Fork** this repository to your own GitHub account.
2. Create a branch named `assessment/<your-name>` — e.g., `assessment/jane-doe`.
3. Fill in all answers directly in this file below each question.
4. For Section B Tasks 7 and 8, save the provided playbooks to `~/ansible-assessment/` before running them.
5. Commit your completed file:
   ```
   feat: complete ansible assessment - <your-name>
   ```
6. Open a **Pull Request** to `main` with the title:
   ```
   Assessment Submission — <Your Name> — <Date>
   ```
7. Include in the PR description:
   - Your full name
   - Lab environment (local VM / cloud instance / provided lab)
   - Output of `ansible --version`
   - Any questions for the instructor

---

*Assessment authored by the Ansible Training Team · Covers the complete 6-Day Ansible Fundamentals curriculum*
