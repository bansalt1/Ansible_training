# 🧪 Ansible Foundations — Candidate Assessment

> **Training Coverage:** Day 1 – Day 6 | Ansible Fundamentals  
> **Format:** MCQs · Ad-hoc Command Tasks · YAML Fix Exercises · Short-Answer Questions  
> **Total Marks:** 100 | **Duration:** 90 minutes  
> **Passing Score:** 70 / 100

---

## 📋 Table of Contents

1. [Instructions](#-instructions)
2. [Section A – Multiple Choice Questions (30 marks)](#section-a--multiple-choice-questions-30-marks)
3. [Section B – Ad-hoc Command Tasks (25 marks)](#section-b--ad-hoc-command-tasks-25-marks)
4. [Section C – Fix the Broken YAML (25 marks)](#section-c--fix-the-broken-yaml-25-marks)
5. [Section D – Short Answer & Conceptual (20 marks)](#section-d--short-answer--conceptual-20-marks)
6. [Submission Instructions](#-submission-instructions)
7. [Answer Key (Instructor Only)](#-answer-key-instructor-only)

---

## 📌 Instructions

- Attempt **all** sections.
- For MCQs, **circle or write** the letter of the correct answer.
- For ad-hoc tasks, **write the exact command** and paste the **output** in the space provided.
- For YAML fix exercises, **rewrite the corrected block** — do not just describe what is wrong.
- For short answers, keep responses **concise and precise** (2–5 sentences unless otherwise stated).
- No external tools or AI assistance are allowed during the assessment.

---

## Section A — Multiple Choice Questions (30 marks)

> **30 questions × 1 mark each.** Choose the single best answer.

---

### Day 1 — Ansible Foundations

**Q1.** Which of the following best describes Ansible's agentless architecture?

- A) Ansible installs a lightweight daemon on each managed host at boot time
- B) Ansible uses SSH or WinRM to connect to hosts on demand; nothing persists on the remote after execution
- C) Ansible requires a centralized database to track host state
- D) Ansible uses a pull model where managed nodes fetch configuration from the control node

---

**Q2.** What is the minimum requirement on a **managed Linux host** for Ansible to function?

- A) Ansible installed on the managed host
- B) A running HTTP server
- C) Python and SSH access
- D) The `ansible-agent` service running

---

**Q3.** Which command verifies that Ansible is correctly installed on the control node?

- A) `ansible -v`
- B) `ansible --check`
- C) `ansible --version`
- D) `ansible status`

---

**Q4.** On an Ubuntu control node, which two commands are used in sequence to install Ansible?

- A) `yum install epel-release` → `yum install ansible`
- B) `apt update` → `apt install ansible -y`
- C) `pip install ansible` → `ansible --configure`
- D) `snap install ansible` → `ansible init`

---

**Q5.** What is **idempotency** in the context of Ansible?

- A) The ability to run a task on multiple hosts simultaneously
- B) Running the same task multiple times always produces the same result without unintended side effects
- C) Tasks that skip hosts when they are already running the latest configuration
- D) The ability to roll back a playbook automatically on failure

---

**Q6.** Which of the following is **NOT** a core component of Ansible's architecture?

- A) Control Node
- B) Inventory
- C) Agent Daemon
- D) Modules

---

### Day 2 — Core Building Blocks

**Q7.** In the recommended Ansible project layout, where are variables shared across an entire host group stored?

- A) `host_vars/`
- B) `roles/defaults/`
- C) `group_vars/`
- D) `inventory/`

---

**Q8.** Which file controls Ansible's default behavior at the project level?

- A) `inventory/hosts.ini`
- B) `playbooks/site.yml`
- C) `ansible.cfg`
- D) `group_vars/all.yml`

---

**Q9.** What is the correct order of `ansible.cfg` precedence from **highest to lowest**?

- A) `~/.ansible.cfg` → `./ansible.cfg` → `/etc/ansible/ansible.cfg`
- B) `ANSIBLE_CONFIG` env var → `./ansible.cfg` → `~/.ansible.cfg` → `/etc/ansible/ansible.cfg`
- C) `/etc/ansible/ansible.cfg` → `~/.ansible.cfg` → `./ansible.cfg`
- D) `./ansible.cfg` → `ANSIBLE_CONFIG` → `~/.ansible.cfg`

---

**Q10.** In an INI inventory file, how do you create a **parent group** called `prod` that contains both the `web` and `db` groups?

- A) `[prod] web db`
- B) `[prod:children] web db`
- C) `[prod:groups] web, db`
- D) `parent: prod; children: web, db`

---

**Q11.** Which `ansible.cfg` directive disables SSH host key verification (useful in lab environments)?

- A) `ssh_check = false`
- B) `disable_key_check = yes`
- C) `host_key_checking = False`
- D) `strict_host_check = no`

---

**Q12.** What command verifies your inventory structure and lists all hosts in JSON format?

- A) `ansible --list-hosts all`
- B) `ansible-inventory --list`
- C) `ansible all --inventory`
- D) `ansible-playbook --check inventory/`

---

### Day 3 — Inventory & SSH Foundations

**Q13.** What command copies your SSH public key to a managed host's `authorized_keys` file?

- A) `ssh-keygen --copy user@host`
- B) `ssh-copy-id user@hostname`
- C) `ansible all -m authorized_key`
- D) `scp ~/.ssh/id_rsa.pub user@host:~/.ssh/`

---

**Q14.** Where should host-specific variable overrides be placed so they take precedence over group variables?

- A) `group_vars/all.yml`
- B) `inventory/hosts.ini`
- C) `host_vars/<hostname>.yml`
- D) `roles/defaults/main.yml`

---

**Q15.** Which ad-hoc command tests connectivity to all hosts in the `managed` group using a specific user and password?

- A) `ansible managed -m ping --user=ec2-user --password=<PASS>`
- B) `ansible managed -m ping -e "ansible_user=ec2-user ansible_password=<PASS>"`
- C) `ansible managed --connect=ssh -u ec2-user`
- D) `ansible managed test -m connectivity`

---

**Q16.** In a YAML inventory, what key is used to specify the actual IP address of a host when the hostname is not DNS-resolvable?

- A) `ansible_ip`
- B) `ansible_address`
- C) `ansible_host`
- D) `remote_host`

---

### Day 4 — Control Node, Managed Nodes & Ad-hoc Commands

**Q17.** Which statement about the **control node** is correct?

- A) It must be a dedicated server; it cannot run any other workloads
- B) It is the machine where Ansible is installed and from which all automation is executed
- C) It must be the same OS as the managed nodes
- D) Ansible must be installed on both the control node and all managed nodes

---

**Q18.** Which module should you use when your ad-hoc command requires **pipes** or **shell redirection**?

- A) `command`
- B) `raw`
- C) `shell`
- D) `exec`

---

**Q19.** What is the key difference between the `command` and `shell` modules?

- A) `command` requires Python; `shell` does not
- B) `command` executes binaries directly with no shell interpretation; `shell` runs through `/bin/sh` enabling pipes and redirection
- C) `shell` is deprecated in favour of `command`
- D) `command` supports Windows; `shell` supports Linux only

---

**Q20.** How do you run an ad-hoc command with **sudo privilege escalation**?

- A) Add `-s` flag
- B) Add `--sudo` flag
- C) Add `--become` flag
- D) Set `become=true` in the command

---

**Q21.** An ad-hoc command returns `UNREACHABLE` for a host. What should you check **first**?

- A) Whether the playbook YAML syntax is correct
- B) Whether SSH connectivity and firewall rules allow access from the control node
- C) Whether `ansible.cfg` has the correct `remote_user`
- D) Whether Python is installed on the managed node

---

**Q22.** Which flag increases the SSH connection timeout for slow networks in an ad-hoc command?

- A) `--delay`
- B) `--wait`
- C) `--timeout`
- D) `--retry`

---

### Day 5 — YAML Basics

**Q23.** Which of the following is a **valid** YAML key-value pair?

- A) `port = 8080`
- B) `port: 8080`
- C) `port -> 8080`
- D) `port : 8080` *(extra space before colon)*

---

**Q24.** In YAML, list items are denoted by:

- A) `*` followed by a space
- B) `>` followed by a space
- C) `-` followed by a space
- D) `+` followed by a space

---

**Q25.** What will the YAML parser do if you use **tabs** instead of spaces for indentation?

- A) Convert tabs to two spaces automatically
- B) Issue a warning but continue parsing
- C) Reject the file with a parse error
- D) Treat each tab as four spaces

---

**Q26.** Which command checks the syntax of a playbook without running it against any hosts?

- A) `ansible-playbook --dry-run site.yml`
- B) `ansible-playbook --syntax-check site.yml`
- C) `ansible --check-yaml site.yml`
- D) `yamllint --ansible site.yml`

---

### Day 6 — Playbook Structure

**Q27.** In an Ansible play, what is the purpose of the `become: true` key?

- A) Forces the play to run in check mode
- B) Elevates privileges (sudo) so tasks can run as root or another user
- C) Enables dry-run mode without making changes
- D) Makes the play run in the background

---

**Q28.** Tasks in an Ansible play are executed in which order?

- A) Alphabetically by task name
- B) Randomly — Ansible optimises execution order automatically
- C) Top-to-bottom, in the order they are listed in the playbook
- D) By host group priority defined in the inventory

---

**Q29.** Which module would you use to **transfer and render a Jinja2 template** to a remote host?

- A) `copy`
- B) `file`
- C) `template`
- D) `fetch`

---

**Q30.** What does a task returning `changed=0` indicate when running a playbook for the second time?

- A) The task failed silently
- B) The task was skipped due to a condition
- C) Idempotency is working — the desired state was already present; no changes were made
- D) The task ran but had no modules to execute

---

## Section B — Ad-hoc Command Tasks (25 marks)

> **Write the exact command** for each task. Where instructed, **run it and paste the output** below the command.  
> Each task is worth 5 marks: **3 for the correct command**, **2 for the output / explanation**.

---

### Task 1 — Connectivity Test *(5 marks)*

**Scenario:** You have a group called `webservers` in your inventory. Verify that Ansible can reach all hosts in that group.

**Write the command:**

```bash
# Your answer here
```

**Paste the expected output format or actual output:**

```
# Your output here
```

---

### Task 2 — Check Disk Usage *(5 marks)*

**Scenario:** Quickly check the disk usage on all managed hosts without writing a playbook. The output must show filesystem sizes in human-readable format.

**Write the command:**

```bash
# Your answer here
```

**Paste the expected output format or actual output:**

```
# Your output here
```

---

### Task 3 — Gather System Uptime *(5 marks)*

**Scenario:** You need to check the uptime of all hosts in the `db` group without shell features (pipes/redirects).

**Write the command:**

```bash
# Your answer here
```

**Paste the expected output format or actual output:**

```
# Your output here
```

---

### Task 4 — Restart a Service *(5 marks)*

**Scenario:** The `nginx` service on the `web` group needs to be restarted. Use the appropriate Ansible module — **not** a raw shell command.

**Write the command:**

```bash
# Your answer here
```

**Explain why you chose this module over `shell` or `command`:**

```
# Your explanation here
```

---

### Task 5 — List All Hosts & Verify Inventory *(5 marks)*

**Scenario:** Before running any playbook, you want to inspect your full inventory structure and confirm all host groups and variables are correctly parsed.

**Write the command:**

```bash
# Your answer here
```

**Paste a snippet of the expected output:**

```json
// Your output here
```

---

## Section C — Fix the Broken YAML (25 marks)

> Each exercise below contains **one or more errors** in a YAML playbook or inventory snippet.  
> **Rewrite the corrected version** below each block. Identifying the error alone is **not sufficient** — you must provide the fixed code.  
> Each exercise is worth 5 marks: **2 for identifying the error**, **3 for the corrected code**.

---

### Exercise 1 — Indentation Error *(5 marks)*

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

**What is wrong?**

```
# Your answer here
```

**Corrected playbook:**

```yaml
# Your corrected YAML here
```

---

### Exercise 2 — Tab Characters *(5 marks)*

**Broken playbook** *(tabs represented as `→`):*

```yaml
---
- name: Configure server
  hosts: all
  tasks:
→ - name: Check disk
→   shell: df -h
```

**What is wrong?**

```
# Your answer here
```

**Corrected playbook:**

```yaml
# Your corrected YAML here
```

---

### Exercise 3 — Missing `---` Document Start & Incorrect List Syntax *(5 marks)*

**Broken inventory variable file:**

```yaml
packages:
  nginx
  python3
  git
```

**What is wrong?**

```
# Your answer here
```

**Corrected file:**

```yaml
# Your corrected YAML here
```

---

### Exercise 4 — Missing Colon & Wrong Boolean *(5 marks)*

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

**What is wrong? (List all errors):**

```
# Your answer here
```

**Corrected fragment:**

```yaml
# Your corrected YAML here
```

---

### Exercise 5 — Incorrect `ansible.cfg` Causing Inventory Not Found *(5 marks)*

**Broken `ansible.cfg`:**

```ini
[defaults]
Inventory = inventory/hosts.ini
remote user = ansible
become = true
become_method = sudo
host_key_checking = False
```

**What is wrong? (List all errors):**

```
# Your answer here
```

**Corrected `ansible.cfg`:**

```ini
# Your corrected file here
```

---

## Section D — Short Answer & Conceptual (20 marks)

> Answer in **2–5 sentences** unless otherwise stated. Each question is worth 4 marks.

---

### Q1 — Why Scripts Aren't Enough *(4 marks)*

Explain **two specific limitations** of using shell scripts for infrastructure automation that Ansible overcomes. Use the term "idempotency" in your answer.

```
# Your answer here
```

---

### Q2 — Agentless Architecture *(4 marks)*

Describe how Ansible connects to and executes tasks on a managed Linux host. What happens on the managed host after execution completes?

```
# Your answer here
```

---

### Q3 — `command` vs `shell` Module *(4 marks)*

A colleague suggests using the `shell` module for all ad-hoc tasks because it supports pipes. Explain when you would **prefer `command` over `shell`** and why.

```
# Your answer here
```

---

### Q4 — Variable Precedence *(4 marks)*

You have the variable `http_port` defined in both `group_vars/webservers.yml` (value: `80`) and `host_vars/web01.yml` (value: `8080`). When Ansible runs a play against `web01`, which value takes effect and why?

```
# Your answer here
```

---

### Q5 — Playbook Idempotency Demonstration *(4 marks)*

You run the following playbook **twice** against a fresh server:

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

On the **first run**, the output shows `changed=1`. On the **second run**, it shows `changed=0`.  
Explain what happened in each run and what this tells you about Ansible's design.

```
# Your answer here
```

---

## 📤 Submission Instructions

1. **Fork** this repository to your own GitHub account.
2. Create a branch named `assessment/<your-name>` (e.g., `assessment/jane-doe`).
3. Complete all sections in this file (`README.md`) — write your answers directly below each question.
4. For Section B (ad-hoc commands), run the commands on your lab environment and paste the **actual output**.
5. Commit your completed file with the message: `feat: complete ansible assessment - <your-name>`.
6. Open a **Pull Request** to the `main` branch of the original repository with the title:  
   `Assessment Submission — <Your Name> — <Date>`
7. In the PR description, include:
   - Your name
   - The lab environment you used (local VM / cloud instance / provided lab)
   - Any questions or comments for the instructor

---

## 🔐 Answer Key (Instructor Only)

> ⚠️ **Do not share this section with candidates before or during the assessment.**

<details>
<summary>Click to expand — Instructor Answer Key</summary>

### Section A — MCQ Answers

| Q | Answer | Rationale |
|---|--------|-----------|
| 1 | B | Agentless = SSH/WinRM on demand; nothing persists on remote |
| 2 | C | Python + SSH access is the only requirement on managed Linux hosts |
| 3 | C | `ansible --version` is the standard installation verification command |
| 4 | B | Ubuntu uses `apt update` then `apt install ansible -y` |
| 5 | B | Idempotency = same result regardless of how many times you run it |
| 6 | C | Agent Daemon is a Puppet/Chef concept; Ansible is agentless |
| 7 | C | `group_vars/` holds variables applied to all hosts in a group |
| 8 | C | `ansible.cfg` is the project-level configuration file |
| 9 | B | `ANSIBLE_CONFIG` → `./ansible.cfg` → `~/.ansible.cfg` → `/etc/ansible/ansible.cfg` |
| 10 | B | `[prod:children]` is the INI syntax for a parent group |
| 11 | C | `host_key_checking = False` disables SSH host key verification |
| 12 | B | `ansible-inventory --list` outputs full inventory as JSON |
| 13 | B | `ssh-copy-id user@hostname` copies public key to authorized_keys |
| 14 | C | `host_vars/<hostname>.yml` overrides group_vars for that specific host |
| 15 | B | `-e "ansible_user=... ansible_password=..."` passes connection vars inline |
| 16 | C | `ansible_host` is the magic variable for the target IP/hostname |
| 17 | B | Control node = machine where Ansible is installed and executed |
| 18 | C | `shell` module enables pipes, redirection, env vars |
| 19 | B | `command` = direct binary exec; `shell` = through `/bin/sh` |
| 20 | C | `--become` flag enables privilege escalation in ad-hoc commands |
| 21 | B | `UNREACHABLE` = SSH/network connectivity failure — check first |
| 22 | C | `--timeout` sets the SSH connection timeout |
| 23 | B | `port: 8080` — colon immediately after key, space then value |
| 24 | C | `- ` (hyphen + space) denotes list items in YAML |
| 25 | C | YAML parsers reject tab characters with a parse error |
| 26 | B | `ansible-playbook --syntax-check` validates without executing |
| 27 | B | `become: true` elevates to sudo/root for the play |
| 28 | C | Tasks execute top-to-bottom in the order listed |
| 29 | C | `template` module renders Jinja2 templates; `copy` transfers static files |
| 30 | C | `changed=0` on second run confirms idempotency is working |

---

### Section B — Expected Ad-hoc Commands

| Task | Expected Command |
|------|-----------------|
| 1 | `ansible webservers -m ping` |
| 2 | `ansible all -m shell -a 'df -h'` |
| 3 | `ansible db -m command -a 'uptime'` |
| 4 | `ansible web -m service -a 'name=nginx state=restarted' --become` |
| 5 | `ansible-inventory --list` |

---

### Section C — Corrected YAML

**Exercise 1 — Correct:**
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
*Error: `apt:` module args (`name`, `state`) must be indented 2 spaces beneath `apt:`, not at the same level.*

**Exercise 2 — Correct:**
```yaml
---
- name: Configure server
  hosts: all
  tasks:
    - name: Check disk
      shell: df -h
```
*Error: Tab characters used instead of spaces — YAML rejects tabs.*

**Exercise 3 — Correct:**
```yaml
---
packages:
  - nginx
  - python3
  - git
```
*Errors: Missing `---` document start marker; list items missing `- ` (hyphen + space) prefix.*

**Exercise 4 — Correct:**
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
*Errors: Missing `:` after `name` and `hosts` keys; `True` should be lowercase `true`; `state started` missing `: ` separator.*

**Exercise 5 — Correct:**
```ini
[defaults]
inventory = inventory/hosts.ini
remote_user = ansible
become = true
become_method = sudo
host_key_checking = False
```
*Errors: `Inventory` should be lowercase `inventory`; `remote user` should be `remote_user` (underscore, not space).*

---

### Section D — Model Answers

**Q1:** Scripts lack idempotency — running a script that creates a user fails if the user already exists, requiring manual guard checks. They also have no structured error handling; Ansible modules are idempotent by design and halt on failure with structured JSON output.

**Q2:** Ansible's control node establishes an SSH connection to the managed host, pushes a small Python module, executes it, collects structured JSON output, then removes the module. Nothing persists on the managed host after execution — the architecture is fully stateless.

**Q3:** Prefer `command` when shell features (pipes, redirection, env vars) are not needed, because it executes binaries directly without shell interpretation — reducing the risk of shell injection and making the intent explicit. `shell` should only be used when shell features are genuinely required.

**Q4:** `host_vars/web01.yml` takes precedence over `group_vars/webservers.yml` — host-level variables always override group-level variables in Ansible's variable precedence chain. For `web01`, `http_port` will be `8080`.

**Q5:** First run: Ansible found nginx was not installed, so it installed it — `changed=1` means the system state was modified. Second run: Ansible checked and found nginx was already installed in the desired state (`present`), so it made no changes — `changed=0`. This demonstrates idempotency: the module checks current state before acting.

</details>

---

*Assessment prepared by the Ansible Training Team · Based on Day 1–6 training curriculum*  
*Repository maintained at `ansible-training/assessment`*
