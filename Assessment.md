# 🧪 Ansible Foundations — Final Assessment

> **Course:** Ansible Fundamentals (6-Day Training)
> **Format:** MCQs · Ad-hoc Command Tasks · YAML Fix Exercises · Short-Answer Questions
> **Total Marks:** 100 &nbsp;|&nbsp; **Duration:** 90 minutes &nbsp;|&nbsp; **Passing Score:** 70 / 100

---

## 📋 Table of Contents

1. [Instructions](#-instructions)
2. [Lab Environment Setup](#-lab-environment-setup)
3. [Section A — Multiple Choice Questions](#section-a--multiple-choice-questions-30-marks)
4. [Section B — Ad-hoc Command Tasks](#section-b--ad-hoc-command-tasks-25-marks)
5. [Section C — Fix the Broken YAML](#section-c--fix-the-broken-yaml-25-marks)
6. [Section D — Short Answer & Conceptual](#section-d--short-answer--conceptual-20-marks)
7. [Submission Instructions](#-submission-instructions)
8. [Answer Key (Instructor Only)](#-answer-key-instructor-only)

---

## 📌 Instructions

- Attempt **all** sections.
- For **MCQs**, write the letter of the correct answer in the space provided.
- For **Section B**, use the inventory and config files provided in the [Lab Environment Setup](#-lab-environment-setup) section below. Run each command and **paste the actual output** in the space given.
- For **Section C**, **rewrite the entire corrected block** — identifying the error alone is not sufficient.
- For **Section D**, keep responses concise and precise (3–5 sentences unless stated otherwise).
- No AI assistance is permitted. All ad-hoc command outputs must be from your own lab environment.

---

## 🖥️ Lab Environment Setup

> **Complete this setup before attempting Section B.** All ad-hoc tasks in Section B depend on the files created here. Everything you need is provided — there are no dependencies on any previously created files from the training sessions.

### Step 1 — Create the Assessment Working Directory

```bash
mkdir -p ~/ansible-assessment
cd ~/ansible-assessment
```

### Step 2 — Create `ansible.cfg`

Create the file `~/ansible-assessment/ansible.cfg` with the following content:

```ini
[defaults]
inventory       = ./inventory.ini
remote_user     = student
host_key_checking = False
become          = False

[privilege_escalation]
become_method   = sudo
```

### Step 3 — Create `inventory.ini`

Create the file `~/ansible-assessment/inventory.ini` with the following content. Replace the IP addresses with the actual IPs of your lab nodes:

```ini
[web]
node1 ansible_host=192.168.1.101
node2 ansible_host=192.168.1.102

[db]
node3 ansible_host=192.168.1.103

[all:vars]
ansible_user=student
ansible_python_interpreter=/usr/bin/python3
```

> **Note:** If your lab uses a different username or Python path, update `ansible_user` and `ansible_python_interpreter` accordingly.

### Step 4 — Verify SSH Access

Confirm that passwordless SSH from your control node to all managed nodes is working:

```bash
ssh student@192.168.1.101
ssh student@192.168.1.102
ssh student@192.168.1.103
```

If SSH prompts for a password, run the following on the control node to set up key-based auth:

```bash
ssh-keygen -t ed25519          # Press Enter for all prompts
ssh-copy-id student@192.168.1.101
ssh-copy-id student@192.168.1.102
ssh-copy-id student@192.168.1.103
```

### Step 5 — Confirm Ansible Sees the Inventory

```bash
cd ~/ansible-assessment
ansible-inventory --list
```

You should see all three nodes listed under `web` and `db` groups. If this command works correctly, your environment is ready for Section B.

---

## Section A — Multiple Choice Questions (30 marks)

> **30 questions × 1 mark each.** Write the letter of the single best answer.

---

**Q1.** Which of the following best describes Ansible's agentless architecture?

- A) Ansible installs a lightweight daemon on each managed host that runs continuously
- B) Ansible connects to hosts on demand over SSH or WinRM; nothing persists on the remote host after execution
- C) Ansible requires a central database to track the state of all managed hosts
- D) Managed nodes periodically pull configuration updates from the control node

**Your Answer:** ___

---

**Q2.** What is the only requirement on a **managed Linux host** for Ansible to connect and execute tasks?

- A) Ansible installed on the managed host
- B) A running HTTP/HTTPS service
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
- C) Tasks that skip execution when the managed host is already at the latest version
- D) The ability to roll back a failed playbook to a known-good state automatically

**Your Answer:** ___

---

**Q5.** On Ubuntu, which sequence of commands correctly installs Ansible?

- A) `sudo yum install epel-release -y` → `sudo yum install ansible -y`
- B) `sudo apt update` → `sudo apt install ansible -y`
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

**Q8.** In the recommended Ansible project directory structure, what is the purpose of `group_vars/`?

- A) Stores variables specific to individual hosts that override group defaults
- B) Stores variables applied to every host in a named group
- C) Contains encrypted secrets managed by Ansible Vault
- D) Holds Jinja2 templates for generating configuration files

**Your Answer:** ___

---

**Q9.** Which file controls Ansible's default behaviour — including inventory path, remote user, and SSH settings — at the project level?

- A) `inventory/hosts.ini`
- B) `playbooks/site.yml`
- C) `ansible.cfg`
- D) `group_vars/all.yml`

**Your Answer:** ___

---

**Q10.** What is the correct order of `ansible.cfg` precedence, from **highest** to **lowest** priority?

- A) `~/.ansible.cfg` → `./ansible.cfg` → `/etc/ansible/ansible.cfg`
- B) `ANSIBLE_CONFIG` env var → `./ansible.cfg` → `~/.ansible.cfg` → `/etc/ansible/ansible.cfg`
- C) `/etc/ansible/ansible.cfg` → `~/.ansible.cfg` → `./ansible.cfg`
- D) `./ansible.cfg` → `ANSIBLE_CONFIG` → `/etc/ansible/ansible.cfg`

**Your Answer:** ___

---

**Q11.** Which `ansible.cfg` directive disables SSH host-key verification (useful in lab environments)?

- A) `ssh_check = false`
- B) `disable_key_check = yes`
- C) `host_key_checking = False`
- D) `strict_host_check = no`

**Your Answer:** ___

---

**Q12.** In an INI inventory file, how do you create a **parent group** called `prod` that contains both the `web` and `db` child groups?

- A) `[prod] web db`
- B) `[prod:children]` on one line, then `web` and `db` on subsequent lines
- C) `[prod:groups] web, db`
- D) `parent: prod; children: web, db`

**Your Answer:** ___

---

**Q13.** Which command inspects your full inventory structure and outputs all hosts and variables in JSON format?

- A) `ansible --list-hosts all`
- B) `ansible-inventory --list`
- C) `ansible all --inventory`
- D) `ansible-playbook --check inventory/`

**Your Answer:** ___

---

**Q14.** Where should variables specific to a single host be placed so they take precedence over group variables?

- A) `group_vars/all.yml`
- B) `inventory/hosts.ini` inline
- C) `host_vars/<hostname>.yml`
- D) `roles/defaults/main.yml`

**Your Answer:** ___

---

**Q15.** Which magic variable is used in the inventory to specify the actual **IP address** of a host when the hostname is not DNS-resolvable?

- A) `ansible_ip`
- B) `ansible_address`
- C) `ansible_host`
- D) `remote_host`

**Your Answer:** ___

---

**Q16.** What command generates an SSH key pair on the control node for use with Ansible?

- A) `ssh-keygen -t ed25519`
- B) `ansible-keygen --ssh`
- C) `openssl genrsa -out id_rsa 4096`
- D) `ssh-create-key --type rsa`

**Your Answer:** ___

---

**Q17.** Which command copies your control node's SSH public key to a managed host's `authorized_keys` file?

- A) `ssh-keygen --copy user@host`
- B) `ssh-copy-id user@hostname`
- C) `scp ~/.ssh/id_rsa.pub user@host:~/.ssh/`
- D) `ansible all -m authorized_key`

**Your Answer:** ___

---

**Q18.** The control node is best described as:

- A) A dedicated server that must not run any other workloads
- B) The machine where Ansible is installed and from which all automation is executed
- C) Any managed node that also runs `ansible-playbook`
- D) A cloud-hosted service that manages inventory and scheduling

**Your Answer:** ___

---

**Q19.** Which ad-hoc command module runs commands through `/bin/sh`, enabling pipes and redirection?

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
- B) Whether SSH connectivity and firewall rules allow port 22 from the control node
- C) Whether the correct `remote_user` is set in `ansible.cfg`
- D) Whether Python is installed on the managed node

**Your Answer:** ___

---

**Q22.** How do you run an ad-hoc command with **sudo privilege escalation** without modifying `ansible.cfg`?

- A) Add `-s` to the command
- B) Add `--sudo` to the command
- C) Add `--become` to the command
- D) Prefix the module argument with `sudo:`

**Your Answer:** ___

---

**Q23.** Which ad-hoc command uses the `setup` module to collect **all facts** about every host?

- A) `ansible all -m facts`
- B) `ansible all -m gather_facts`
- C) `ansible all -m setup`
- D) `ansible all -m info`

**Your Answer:** ___

---

**Q24.** Which of the following is a **valid** YAML key-value pair?

- A) `port = 8080`
- B) `port: 8080`
- C) `port -> 8080`
- D) `port:8080` *(no space after colon)*

**Your Answer:** ___

---

**Q25.** In YAML, list items are denoted by which character sequence?

- A) `*` followed by a space
- B) `>` followed by a space
- C) `-` followed by a space
- D) `+` followed by a space

**Your Answer:** ___

---

**Q26.** What will a YAML parser do if **tabs** are used instead of spaces for indentation?

- A) Automatically convert each tab to two spaces
- B) Issue a warning but continue parsing
- C) Reject the file with a parse error
- D) Treat each tab as four spaces

**Your Answer:** ___

---

**Q27.** Which command validates a playbook's YAML syntax without executing any tasks on managed hosts?

- A) `ansible-playbook --dry-run site.yml`
- B) `ansible-playbook --syntax-check site.yml`
- C) `ansible --check-yaml site.yml`
- D) `yamllint --ansible site.yml`

**Your Answer:** ___

---

**Q28.** In an Ansible play, what is the purpose of `become: true`?

- A) Forces the play to run in check mode only
- B) Elevates privileges (sudo) so tasks run as root or another privileged user
- C) Enables dry-run mode without making any changes on hosts
- D) Makes the play execute in the background and detach from the terminal

**Your Answer:** ___

---

**Q29.** Tasks inside an Ansible play are executed in which order?

- A) Alphabetically by task name
- B) Randomly — Ansible automatically optimises execution order
- C) Top-to-bottom, in the order they are listed in the playbook
- D) By host group priority as defined in the inventory

**Your Answer:** ___

---

**Q30.** A playbook is run twice on the same host. The first run shows `changed=1`; the second run shows `changed=0`. What does this tell you?

- A) The second run encountered an error that was silently suppressed
- B) The task was skipped on the second run due to a `when` condition
- C) Idempotency is working — the desired state was already present on the second run, so no changes were made
- D) The module did not execute because the host was unreachable

**Your Answer:** ___

---

## Section B — Ad-hoc Command Tasks (25 marks)

> **Use the inventory and `ansible.cfg` created in the [Lab Environment Setup](#-lab-environment-setup) section.**
> Run all commands from the `~/ansible-assessment/` directory.
> Each task is worth **5 marks**: 3 for the correct command, 2 for the pasted output.

---

### Task 1 — Connectivity Test *(5 marks)*

**Objective:** Verify that Ansible can reach all hosts in your inventory.

Run the ad-hoc connectivity test against **all** hosts. The response must confirm SSH is working and Python is available on each node.

**Write the command you ran:**

```bash
# Your command here
```

**Paste the actual output:**

```
# Your output here
```

---

### Task 2 — Gather System Facts *(5 marks)*

**Objective:** Collect the **hostname** fact from all hosts using a filtered fact query — not the full setup dump.

**Write the command you ran:**

```bash
# Your command here
```

**Paste the actual output:**

```
# Your output here
```

---

### Task 3 — Check Disk Usage on the `web` Group *(5 marks)*

**Objective:** Check disk usage across all hosts in the `web` group in human-readable format. The command must use the `shell` module (not `command`) because you want to be able to pipe the output if needed.

**Write the command you ran:**

```bash
# Your command here
```

**Paste the actual output:**

```
# Your output here
```

---

### Task 4 — Check Memory on All Hosts *(5 marks)*

**Objective:** Run `free -m` on **all** hosts. Explain in one sentence why you must use the `shell` module rather than the `command` module for this specific output.

**Write the command you ran:**

```bash
# Your command here
```

**Paste the actual output:**

```
# Your output here
```

**Why `shell` is required here (one sentence):**

```
# Your explanation here
```

---

### Task 5 — Install a Package with Privilege Escalation *(5 marks)*

**Objective:** Install the `tree` utility on the `web` group using the `apt` module with sudo privilege escalation — using only an ad-hoc command, no playbook.

**Write the command you ran:**

```bash
# Your command here
```

**Paste the actual output:**

```
# Your output here
```

---

## Section C — Fix the Broken YAML (25 marks)

> Each exercise contains **one or more deliberate errors**. Rewrite the fully corrected version below each block.
> Identifying the error alone is **not sufficient** — you must provide working, correctly indented YAML.
> Each exercise: **2 marks** for identifying all errors, **3 marks** for the corrected code.

---

### Exercise 1 — Module Arguments at Wrong Indentation Level *(5 marks)*

**Broken playbook:**

```yaml
---
- name: Install nginx
  hosts: webservers
  become: true
  tasks:
    - name: Install package
      apt:
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

### Exercise 2 — Tab Characters Used Instead of Spaces *(5 marks)*

> Tabs are represented below as `→` for visibility.

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

### Exercise 3 — Broken List Syntax in a Variable File *(5 marks)*

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

### Exercise 4 — Multiple Errors: Missing Colons, Wrong Boolean, Missing Separator *(5 marks)*

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

**What is/are the error(s)?** (list all)

```
# Your answer here
```

**Corrected fragment:**

```yaml
# Your corrected YAML here
```

---

### Exercise 5 — Broken `ansible.cfg` *(5 marks)*

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

## Section D — Short Answer & Conceptual (20 marks)

> Answer in **3–5 sentences** unless otherwise stated. Each question is worth **4 marks**.

---

### Q1 — Why Automation Tools Beat Scripts *(4 marks)*

Explain **two specific limitations** of shell scripts for infrastructure automation that Ansible directly solves. Use the term **idempotency** in your answer.

```
# Your answer here
```

---

### Q2 — Agentless Architecture Explained *(4 marks)*

Describe step-by-step what happens when Ansible runs a task on a managed Linux host — from the moment you execute the command on the control node to the moment the task is complete. What is left on the managed host after the run finishes?

```
# Your answer here
```

---

### Q3 — `command` vs `shell` Module *(4 marks)*

A colleague suggests always using the `shell` module because it is more powerful. Write a response explaining when you would **prefer `command` over `shell`** and what risk the `shell` module introduces.

```
# Your answer here
```

---

### Q4 — Variable Precedence *(4 marks)*

You have defined `http_port: 80` in `group_vars/webservers.yml` and `http_port: 8080` in `host_vars/web01.yml`. When Ansible runs a play targeting the `webservers` group and processes `web01`, which value is used and why?

```
# Your answer here
```

---

### Q5 — Reading Playbook Output *(4 marks)*

After running the playbook below **twice** on a fresh Ubuntu server, the first run shows `changed=1, failed=0` and the second run shows `changed=0, failed=0`.

```yaml
---
- name: Ensure nginx is installed
  hosts: webservers
  become: true
  tasks:
    - name: Install nginx
      apt:
        name: nginx
        state: present
```

Explain what happened during each run and what the difference in output tells you about how Ansible is designed. What would the output look like if you changed `state: present` to `state: absent` and ran it a third time?

```
# Your answer here
```

---

## 📤 Submission Instructions

1. **Fork** this repository to your own GitHub account.
2. Create a branch named `assessment/<your-name>` (e.g., `assessment/jane-doe`).
3. Complete all sections directly in this file — write your answers below each question.
4. For Section B, run every command from your lab environment and paste the **actual terminal output**.
5. Commit your completed file with the message:
   ```
   feat: complete ansible assessment - <your-name>
   ```
6. Open a **Pull Request** to the `main` branch of the original repository with the title:
   ```
   Assessment Submission — <Your Name> — <Date>
   ```
7. Include the following in your PR description:
   - Your full name
   - Lab environment used (local VM / cloud instance / provided lab)
   - Ansible version (`ansible --version` output)
   - Any questions or comments for the instructor

---

## 🔐 Answer Key (Instructor Only)

> ⚠️ **Do not share this section with candidates before or during the assessment.**

<details>
<summary>🔓 Click to expand — Instructor Answer Key</summary>

---

### Section A — MCQ Answers

| Q | Answer | Rationale |
|---|--------|-----------|
| 1 | B | Agentless = SSH/WinRM on demand; nothing persists on the managed host after execution |
| 2 | C | Python + SSH access is the only requirement on managed Linux hosts |
| 3 | C | Agent Daemon is a Puppet/Chef concept; Ansible is agentless by design |
| 4 | B | Idempotency = same result regardless of how many times the operation runs |
| 5 | B | Ubuntu uses `apt update` then `apt install ansible -y` |
| 6 | B | EPEL must be enabled on RHEL/CentOS before the `ansible` package is available |
| 7 | C | `ansible --version` is the standard installation verification command |
| 8 | B | `group_vars/` stores variables applied to all hosts in the named group |
| 9 | C | `ansible.cfg` is the project-level configuration file |
| 10 | B | `ANSIBLE_CONFIG` → `./ansible.cfg` → `~/.ansible.cfg` → `/etc/ansible/ansible.cfg` |
| 11 | C | `host_key_checking = False` disables SSH host-key verification |
| 12 | B | `[prod:children]` followed by child group names on subsequent lines |
| 13 | B | `ansible-inventory --list` outputs full inventory as JSON |
| 14 | C | `host_vars/<hostname>.yml` overrides group vars for that specific host |
| 15 | C | `ansible_host` is the magic variable for the target IP/hostname |
| 16 | A | `ssh-keygen -t ed25519` generates a modern key pair |
| 17 | B | `ssh-copy-id user@hostname` copies the public key to `authorized_keys` |
| 18 | B | Control node = machine where Ansible is installed and from which automation runs |
| 19 | C | `shell` module runs through `/bin/sh` enabling pipes and redirection |
| 20 | B | `command` = direct binary exec; `shell` = through `/bin/sh` |
| 21 | B | `UNREACHABLE` = SSH/network connectivity failure — check ports and keys first |
| 22 | C | `--become` flag enables privilege escalation in ad-hoc commands |
| 23 | C | `ansible all -m setup` collects all facts |
| 24 | B | `port: 8080` — colon immediately after key, single space, then value |
| 25 | C | `- ` (hyphen + single space) denotes list items in YAML |
| 26 | C | YAML parsers reject tab characters with a parse error — tabs are forbidden |
| 27 | B | `ansible-playbook --syntax-check` validates without executing any tasks |
| 28 | B | `become: true` elevates to sudo/root for the play or individual task |
| 29 | C | Tasks execute top-to-bottom in the order they are listed |
| 30 | C | `changed=0` on second run confirms idempotency: desired state already present |

---

### Section B — Expected Commands

| Task | Expected Command |
|------|-----------------|
| 1 — Connectivity Test | `ansible all -m ping` |
| 2 — Gather Hostname Fact | `ansible all -m setup -a "filter=ansible_hostname"` |
| 3 — Disk Usage on web | `ansible web -m shell -a 'df -h'` |
| 4 — Memory on all hosts | `ansible all -m shell -a 'free -m'` |
| 5 — Install tree on web | `ansible web -m apt -a 'name=tree state=present' --become` |

**Task 4 explanation:** `free -m` does not require pipes or redirects itself, but the `shell` module is still appropriate when the intent is to use shell-style formatting or chain commands; `command` would also work here — accept either module, penalise only if the student cannot explain the difference.

---

### Section C — Corrected YAML & Error Explanations

**Exercise 1:**
- **Error:** Module arguments `name` and `state` are at the same indentation level as `apt:` instead of being indented 2 spaces beneath it.
```yaml
---
- name: Install nginx
  hosts: webservers
  become: true
  tasks:
    - name: Install package
      apt:
        name: nginx
        state: present
```

**Exercise 2:**
- **Error:** Tab characters used for indentation instead of spaces. YAML parsers reject tabs entirely.
```yaml
---
- name: Configure server
  hosts: all
  tasks:
    - name: Check disk
      shell: df -h
```

**Exercise 3:**
- **Errors:** (1) Missing `---` document start marker. (2) List items missing `- ` (hyphen + space) prefix — bare indented strings are not valid YAML list items.
```yaml
---
packages:
  - nginx
  - python3
  - git
```

**Exercise 4:**
- **Errors:** (1) `name Deploy web app` — missing `:` after `name`. (2) `hosts webservers` — missing `:` after `hosts`. (3) `become True` — missing `:` after `become`; boolean should be lowercase `true`. (4) `state started` — missing `:` separator between key and value.
```yaml
- name: Deploy web app
  hosts: webservers
  become: true

  tasks:
    - name: Start nginx
      service:
        name: nginx
        state: started
```

**Exercise 5:**
- **Errors:** (1) `Inventory` — key must be lowercase `inventory`. (2) `remote user` — key must use an underscore: `remote_user`.
```ini
[defaults]
inventory       = inventory/hosts.ini
remote_user     = student
become          = true
become_method   = sudo
host_key_checking = False
```

---

### Section D — Model Answers

**Q1:** Shell scripts lack idempotency — a script that creates a user will error on the second run if the user already exists, requiring manual guard checks that are inconsistent across authors. Scripts also have no structured error handling; a failure partway through leaves the system in an unknown state. Ansible modules are idempotent by design — they check current state before acting — and halt with structured JSON output on failure.

**Q2:** When `ansible-playbook` is run, the control node opens an SSH connection to the managed host, transfers a small Python module to a temporary directory on the remote, executes it, collects the structured JSON output, and then deletes the temporary module. Nothing is left on the managed host after execution — the architecture is fully stateless and leaves no footprint.

**Q3:** The `command` module should be preferred when shell features (pipes, redirection, environment variable expansion, command chaining with `&&` or `;`) are not needed — it executes the binary directly without invoking `/bin/sh`, which eliminates the risk of shell injection and makes intent explicit. The `shell` module passes arguments to `/bin/sh`, which introduces the risk that user-controlled input could be interpreted as shell metacharacters.

**Q4:** `host_vars/web01.yml` takes precedence. In Ansible's variable precedence chain, host-level variables always win over group-level variables. For `web01`, `http_port` resolves to `8080` even though `group_vars/webservers.yml` sets it to `80`.

**Q5:** First run — nginx was not installed, so the `apt` module installed it and reported `changed=1`. Second run — Ansible checked the state and found nginx already present (`state: present` is already satisfied), so it made no changes and reported `changed=0`. This is idempotency in action: the module describes desired state, not steps. If `state: absent` were set on a third run, Ansible would remove nginx and report `changed=1` again.

</details>

---

*Assessment authored by the Ansible Training Team · Covers the complete 6-Day Ansible Fundamentals curriculum*
