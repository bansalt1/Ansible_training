# Assessment — Ansible Foundations Final Assessment

This directory contains the final assessment for the **Ansible Fundamentals (6-Day Training)** course.

---

## Files

| File | Description |
|------|-------------|
| [`Assessment.md`](./Assessment.md) | The full assessment — complete this file and submit via Pull Request |

---

## Assessment Overview

| Section | Description | Marks |
|---------|-------------|-------|
| A | Multiple Choice Questions (30 × 1 mark) | 30 |
| B | Ad-hoc Command Tasks (8 × 5 marks) | 40 |
| C | Fix the Broken YAML (6 × 5 marks) | 30 |
| | **Total** | **100** |

- **Duration:** 90 minutes
- **Passing Score:** 70 / 100
- **Format:** Fill in answers directly in [`Assessment.md`](./Assessment.md)

---

## Topics Covered

The assessment tests the complete 6-day curriculum:

- Ansible architecture (agentless model, control node, managed nodes, modules)
- Installation on Ubuntu and RHEL/CentOS
- `ansible.cfg` configuration
- Inventory file structure and variables
- SSH key-based authentication
- Ad-hoc commands (`ping`, `command`, `shell`, `apt`, `service`)
- Privilege escalation (`--become`)
- Playbook structure and task execution order
- YAML syntax rules
- Idempotency

---

## Lab Environment

Section B requires a live Ansible lab with:

- A **control node** running Ubuntu
- Three **managed nodes** accessible over SSH
- The `student` user configured on all nodes

> Use the Terraform configuration in [`../infra/`](../infra/) to provision EC2 nodes.  
> Follow [`../Beginner/commands.md`](../Beginner/commands.md) to configure the control node and set up SSH authentication.  
> Section B uses `apt`-based managed nodes (Ubuntu). Complete the Lab Environment Setup section in `Assessment.md` before starting Section B.

---

## How to Submit

### Step 1 — Fork the Repository

1. Open [https://github.com/bansalt1/Ansible_training](https://github.com/bansalt1/Ansible_training) in your browser.
2. Click the **Fork** button (top-right corner).
3. GitHub will create a copy of this repo under your own account — you will be redirected to it automatically.

---

### Step 2 — Clone Your Fork

On your local machine (or lab control node), run:

```bash
git clone https://github.com/<your-github-username>/Ansible_training.git
cd Ansible_training
```

> Replace `<your-github-username>` with your actual GitHub username.

---

### Step 3 — Create a Branch

```bash
git checkout -b assessment/<your-name>
```

**Example:**

```bash
git checkout -b assessment/jane-doe
```

Verify you are on the new branch:

```bash
git branch
```

The branch with the `*` is the active one.

---

### Step 4 — Fill in Your Answers

Open `Assessment/Assessment.md` in any text editor and fill in your answers directly in the file:

- **Section A** — write the answer letter in the `Your Answer:` field after each question
- **Section B** — complete the Lab Environment Setup first, then paste the exact command you ran and the full terminal output for each task
- **Section C** — rewrite the **complete corrected YAML block** below each broken snippet (identifying the error alone without fixing it earns zero marks)

> For Section B Tasks 7 and 8, save the provided playbooks to `~/ansible-assessment/` before running them.

---

### Step 5 — Stage and Commit

```bash
git add Assessment/Assessment.md
git commit -m "feat: complete ansible assessment - <your-name>"
```

**Example:**

```bash
git commit -m "feat: complete ansible assessment - jane-doe"
```

Verify the commit was recorded:

```bash
git log --oneline -3
```

---

### Step 6 — Push Your Branch to GitHub

```bash
git push origin assessment/<your-name>
```

**Example:**

```bash
git push origin assessment/jane-doe
```

> **Authentication:** If prompted for a password, use a **Personal Access Token (PAT)** — GitHub no longer accepts plain account passwords over HTTPS.
> Generate one at: **GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)** → select the `repo` scope → copy the token and use it as your password.

---

### Step 7 — Open a Pull Request

1. Go to your forked repo on GitHub:
   `https://github.com/<your-github-username>/Ansible_training`
2. GitHub will show a yellow banner — click **"Compare & pull request"**.
3. Verify the settings at the top of the PR form:
   - **base repository:** `bansalt1/Ansible_training`
   - **base branch:** `main`
   - **head repository:** `<your-github-username>/Ansible_training`
   - **compare branch:** `assessment/<your-name>`
4. Set the PR **title** to:
   ```
   Assessment Submission — <Your Name> — <Date>
   ```
   **Example:**
   ```
   Assessment Submission — Jane Doe — 2025-07-15
   ```
5. In the PR **description**, include:
   - Your full name
   - Lab environment used (local VM / cloud instance / provided lab)
   - Output of `ansible --version`
   - Any questions for the instructor
6. Click **Create Pull Request**.

Your instructor will review your submission, leave inline comments on specific answers, and merge or close the PR with feedback.

---

## Rules

- Attempt **all** sections.
- For Section A, write the letter of the correct answer in the `Your Answer:` field.
- For Section B, paste the **actual terminal output** from your running lab environment. No AI assistance is permitted.
- For Section C, **rewrite the entire corrected block** — identifying the error without fixing it earns zero marks.
