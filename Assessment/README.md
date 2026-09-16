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

1. **Fork** this repository to your own GitHub account.
2. Create a branch: `assessment/<your-name>` (e.g. `assessment/jane-doe`).
3. Fill in all answers in [`Assessment.md`](./Assessment.md) directly below each question.
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
   - Lab environment used (local VM / cloud instance / provided lab)
   - Output of `ansible --version`
   - Any questions for the instructor

---

## Rules

- Attempt **all** sections.
- For Section A, write the letter of the correct answer in the `Your Answer:` field.
- For Section B, paste the **actual terminal output** from your running lab environment. No AI assistance is permitted.
- For Section C, **rewrite the entire corrected block** — identifying the error without fixing it earns zero marks.
