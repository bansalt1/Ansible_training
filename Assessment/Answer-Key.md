# 🔐 Ansible Foundations — Answer Key

> ⚠️ **Instructor use only. Do not share with candidates before or during the assessment.**

---

## Section A — MCQ Answers

| Q | Answer | Rationale |
|---|--------|-----------|
| 1 | B | Agentless = SSH/WinRM on demand; nothing persists on the managed host after execution |
| 2 | C | Python + SSH access is the only requirement on managed Linux hosts |
| 3 | C | Agent Daemon is a Puppet/Chef concept; Ansible is agentless by design |
| 4 | B | Idempotency = same result regardless of how many times the operation runs |
| 5 | B | Ubuntu: `sudo apt update` → `sudo apt install ansible -y` |
| 6 | B | EPEL must be enabled on RHEL/CentOS before `ansible` is available via DNF |
| 7 | C | `ansible --version` is the standard installation verification command |
| 9 | C | `ansible.cfg` is the project-level configuration file |
| 11 | C | `host_key_checking = False` |
| 13 | B | `ansible-inventory --list` outputs full inventory as JSON |
| 15 | C | `ansible_host` sets the target IP/hostname Ansible connects to |
| 16 | A | `ssh-keygen -t ed25519` generates a modern SSH key pair |
| 17 | B | `ssh-copy-id user@hostname` copies the public key to `authorized_keys` |
| 18 | B | Control node = machine where Ansible is installed and from which all automation is run |
| 19 | C | `shell` module runs through `/bin/sh`, enabling pipes and redirection |
| 20 | B | `command` = direct binary exec; `shell` = through `/bin/sh` with full shell features |
| 21 | B | `UNREACHABLE` = SSH/network connectivity failure; check port 22 and keys first |
| 22 | C | `--become` flag adds privilege escalation to a single ad-hoc command |
| 23 | B | Package install requires `--become`; option A omits it |
| 24 | B | `port: 8080` — colon immediately after key, one space, then value |
| 25 | C | `- ` (hyphen + space) is the YAML list item prefix |
| 27 | B | `ansible-playbook --syntax-check` validates without executing any tasks |
| 28 | B | `become: true` elevates privileges (sudo) for the play or task |
| 29 | C | Tasks execute top-to-bottom in the order they are listed |
| 30 | C | `changed=0` on the second run confirms idempotency — desired state already present |

---

## Section B — Expected Commands & Scoring

| Task | Expected Command |
|------|-----------------|
| 1 — Connectivity Test | `ansible all -m ping` |
| 2 — Check Uptime | `ansible all -m command -a 'uptime'` |
| 3 — Disk Usage (web) | `ansible web -m shell -a 'df -h'` |
| 4 — Check Memory | `ansible all -m shell -a 'free -m'` |
| 5 — Check Hostname (db) | `ansible db -m command -a 'hostname'` |
| 6 — Install tree | `ansible web -m apt -a 'name=tree state=present' --become` |
| 7 — Run Playbook | `ansible-playbook install-curl.yml` (run twice) |
| 8 — Multi-task + Verify | `ansible-playbook setup-web.yml` then `ansible web -m shell -a 'systemctl status nginx'` |

### Scoring Notes

**Tasks 1–6** — Award 3 marks for the correct command, 2 marks for pasted output.

**Task 7 — Run a Playbook and Capture Output**
- First run output must show `changed=1` (curl was installed)
- Second run output must show `changed=0` (already present; no action taken)
- The one-sentence explanation must reference that the second run made no changes because the desired state was already present (idempotency). Accept any phrasing that captures this.
- Deduct 1 mark if output is missing; deduct 2 marks if both runs show `changed=1` (indicates same command not rerun)

**Task 8 — Multi-task Playbook + Verify**
- Playbook output must show 2 tasks: install nginx (`changed=1` on first run) and start/enable service
- Verification command: accept any of `systemctl status nginx`, `systemctl is-active nginx`, `service nginx status`
- Award 3 marks for the correct playbook run, 2 marks for a valid verification command with output

---

## Section C — Errors & Corrected YAML

---

### Exercise 1

**Errors:**
- `name: nginx` and `state: present` are at the same indentation level as `apt:` — they must be indented 2 spaces beneath `apt:` as its module arguments.

**Corrected playbook:**
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

---

### Exercise 2

**Errors:**
- Tab characters used for indentation — YAML parsers reject tabs entirely; only spaces are valid.

**Corrected playbook:**
```yaml
---
- name: Configure server
  hosts: all
  tasks:
    - name: Check disk
      shell: df -h
```

---

### Exercise 3

**Errors:**
1. List items are missing the `- ` (hyphen + space) prefix — bare indented strings are not valid YAML list items.
2. Missing `---` document start marker. *(minor — award marks if candidate identifies the list prefix error)*

**Corrected variable file:**
```yaml
---
packages:
  - nginx
  - python3
  - git
```

---

### Exercise 4

**Errors:**
1. `name Deploy web app` — missing `:` after `name`
2. `hosts webservers` — missing `:` after `hosts`
3. `become True` — missing `:` after `become`; boolean value must be lowercase `true`
4. `state started` — missing `:` between key and value

**Corrected fragment:**
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

---

### Exercise 5

**Errors:**
1. `Inventory` — `ansible.cfg` keys are case-sensitive; must be lowercase `inventory`
2. `remote user` — key must use an underscore: `remote_user` (space is invalid)

**Corrected `ansible.cfg`:**
```ini
[defaults]
inventory         = inventory/hosts.ini
remote_user       = student
become            = true
become_method     = sudo
host_key_checking = False
```

---

### Exercise 6

**Errors:**
1. First task `- name:` is indented only 2 spaces under `tasks:` while its `apt:` block is at 6 spaces — inconsistent indentation. All task list items must be at a consistent 4-space indent under `tasks:`.
2. `service` is missing `:` — must be `service:`.

**Corrected playbook:**
```yaml
---
- name: Setup database server
  hosts: db
  become: true

  tasks:
    - name: Install postgresql
      apt:
        name: postgresql
        state: present

    - name: Start postgresql
      service:
        name: postgresql
        state: started
        enabled: true
```

---

### Marking Guide — Section C

| Exercise | Full marks (5) | Partial (3) | Zero (0) |
|----------|---------------|-------------|----------|
| All errors identified + correct YAML | ✅ | — | — |
| Some errors identified + correct YAML | — | ✅ | — |
| Errors identified only, no fixed code | — | — | ✅ |
| Fixed code only, no error identification | — | ✅ (3 marks) | — |

---

*Answer Key — Ansible Training Team · Do not distribute to candidates*
