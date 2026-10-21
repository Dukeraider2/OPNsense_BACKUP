# Troubleshooting Case Study: [Short, Specific Title]

> **Status:** Draft / In progress / Verified  
> **Date:** YYYY-MM-DD  
> **Environment:** Device models, firmware/software versions, and relevant topology

## Summary

In two or three sentences, describe the fault or engineering problem, the method used to isolate it, and the verified outcome. Do not state an outcome that has not been tested.

## Problem statement

- **Expected behavior:**
- **Observed behavior:**
- **Impact / scope:**
- **How the issue was detected:**

## Topology and prerequisites

Describe only the relevant path. Include a small diagram or link to the project topology if it helps.

- **Devices and interfaces:**
- **IP addressing / VLAN context:** Sanitize sensitive details.
- **Versions and configuration state:**
- **Known-good baseline:**

## Investigation

| Step | Hypothesis or question | Diagnostic action | Observation / evidence | Conclusion |
|---|---|---|---|---|
| 1 | | | | |
| 2 | | | | |
| 3 | | | | |

Separate observed facts from assumptions. Record the commands and where they were run.

## Root cause

State the confirmed root cause if established. If it is not established, write **Root cause not yet confirmed** and explain the leading possibilities.

## Corrective action

1. Describe the change made.
2. Explain why it addresses the evidence.
3. Link the relevant command log, configuration excerpt, or manufacturer documentation.
4. Record any backup or rollback limitation.

## Verification

- **Acceptance criteria:**
- **Test procedure:**
- **Observed result:**
- **Verdict:** PASS / FAIL / INCONCLUSIVE
- **Evidence links:**
- **Test limitations:**

## Outcome and lessons learned

- What was restored, improved, or ruled out?
- What would you do differently next time?
- What follow-up monitoring or regression test is appropriate?

## Change safety and privacy

- [ ] Credentials, tokens, private keys, and unnecessary personal identifiers are removed.
- [ ] Firmware and commands are appropriate for the exact hardware and software version.
- [ ] Risk and rollback steps are documented.
- [ ] The result is not described as production-ready beyond the scope actually tested.
