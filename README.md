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

There are **two ways to submit** — see [`Assessment/README.md`](./Assessment/README.md) for full instructions on both.

---

## Submitting Your Assessment

There are two submission options. Your instructor will tell you which one to use.

---

### Option 1 — HTML Form *(no Git required)*

1. Download [`Assessment/assessment-form.html`](./Assessment/assessment-form.html) to your local machine.
2. Open it in any browser (Chrome, Firefox, Edge, Safari).
3. Fill in your name and all three sections directly in the form.
4. When finished, click **Print / Save PDF** to export your completed form.
5. Email the PDF to your instructor with the subject line:
   ```
   Assessment Submission — <Your Name> — <Date>
   ```

---

### Option 2 — GitHub Pull Request *(recommended for Git practice)*

#### Step 1 — Fork the Repository

1. Open [https://github.com/bansalt1/Ansible_training](https://github.com/bansalt1/Ansible_training) in your browser.
2. Click the **Fork** button (top-right corner).
3. GitHub will create a copy of this repo under your own account.

#### Step 2 — Clone Your Fork

```bash
git clone https://github.com/<your-github-username>/Ansible_training.git
cd Ansible_training
```

> Replace `<your-github-username>` with your actual GitHub username.

#### Step 3 — Create a Branch

```bash
git checkout -b assessment/<your-name>
```

**Example:**

```bash
git checkout -b assessment/jane-doe
```

#### Step 4 — Fill in Your Answers

Open `Assessment/Assessment.md` and fill in your answers directly in the file:

- **Section A** — write the answer letter in the `Your Answer:` field after each question
- **Section B** — paste the exact command you ran and the full terminal output
- **Section C** — rewrite the complete corrected YAML block below each broken snippet

#### Step 5 — Stage and Commit

```bash
git add Assessment/Assessment.md
git commit -m "feat: complete ansible assessment - <your-name>"
```

**Example:**

```bash
git commit -m "feat: complete ansible assessment - jane-doe"
```

#### Step 6 — Push Your Branch

```bash
git push origin assessment/<your-name>
```

**Example:**

```bash
git push origin assessment/jane-doe
```

> If prompted for credentials, enter your GitHub username and a **Personal Access Token (PAT)** as the password. GitHub no longer accepts plain passwords over HTTPS.
> Generate a PAT at: **GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)** — select the `repo` scope.

#### Step 7 — Open a Pull Request

1. Go to your forked repo on GitHub: `https://github.com/<your-github-username>/Ansible_training`
2. Click the **"Compare & pull request"** button that appears after your push.
3. Set the **base repository** to `bansalt1/Ansible_training` and **base branch** to `main`.
4. Set the PR title to:
   ```
   Assessment Submission — <Your Name> — <Date>
   ```
5. In the PR description, include:
   - Your full name
   - Lab environment used (local VM / cloud instance / provided lab)
   - Output of `ansible --version`
   - Any questions for the instructor
6. Click **Create Pull Request**.

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
