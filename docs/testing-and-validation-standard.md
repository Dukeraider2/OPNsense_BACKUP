# Network Testing and Validation Standard

## Purpose

Use this standard to make network changes repeatable, reviewable, and safe. A configuration change is not considered validated until the expected behavior has been tested and the result recorded.

## Test record

For each meaningful test, record the following:

1. **Test ID and date** — use a stable identifier, for example `NET-TEST-001`.
2. **Objective** — the behavior or requirement being evaluated.
3. **Scope** — devices, interfaces, VLANs, clients, and services included.
4. **Preconditions** — known-good state, required links, configuration backups, and dependencies.
5. **Procedure** — commands and steps in the order performed, including the device or host where each command runs.
6. **Expected result** — a specific, observable outcome.
7. **Observed result** — exact output, measured values, and any relevant timestamps.
8. **Verdict** — **PASS**, **FAIL**, or **INCONCLUSIVE**. Explain the verdict.
9. **Evidence** — sanitized logs, screenshots, command output, or measurement files, with paths.
10. **Limitations and next action** — what the test does not prove and what should happen next.

## Verdict definitions

- **PASS:** The recorded evidence meets the stated acceptance criteria.
- **FAIL:** The evidence shows that one or more acceptance criteria were not met.
- **INCONCLUSIVE:** The test was blocked, incomplete, or did not collect enough evidence to decide.

Do not convert an inconclusive test into a pass because the configuration appears correct.

## Recommended commissioning sequence

Adapt this sequence to the actual topology and record the result of each stage.

1. **Physical layer:** Confirm cabling, link state, negotiated speed/duplex, and interface errors.
2. **Management plane:** Confirm switch and firewall management access through the intended path.
3. **Layer 2:** Validate the expected access or trunk behavior, VLAN membership, and absence of unintended loops.
4. **Layer 3:** Verify interface addressing, routes, gateway reachability, and DHCP behavior.
5. **DNS and internet:** Test name resolution and outbound connectivity from a client, not only from the firewall itself.
6. **Security policy:** Confirm permitted traffic works and intentionally blocked traffic remains blocked.
7. **Wireless:** Compare wireless client performance with a wired baseline under documented conditions.
8. **Storage and compute:** Measure endpoint link speed and representative transfer performance; distinguish link rate from application throughput.
9. **Resilience:** Where safe and appropriate, test recovery from a planned link or service interruption.
10. **Closeout:** Record configuration backups, final state, known limitations, and rollback steps.

## Performance test guidance

For throughput testing, use a known wired baseline and a tool such as `iperf3` where supported. Record:

- Client and server hardware and network interfaces.
- Interface negotiation speed.
- Test direction and duration.
- Number of runs and reported results.
- Whether the test uses TCP or UDP and any relevant parameters.
- Wireless band, channel, channel width, signal level, and client location for Wi-Fi tests.
- CPU utilization or other bottlenecks when available.

Do not equate a Wi-Fi PHY link rate with measured application throughput. Do not claim 10 GbE performance solely because an SFP+ port or cable is present.

## Safe change procedure

1. Capture the current configuration or state when possible.
2. Identify the intended change and acceptance criteria.
3. Note a rollback method before applying the change.
4. Apply one logically bounded change at a time.
5. Verify the immediate result and any dependent services.
6. Save sanitized evidence and update the project status.
7. Document when a backup was not available or a rollback was not tested.

## Evidence and privacy

- Redact passwords, API tokens, private keys, public IP addresses when unnecessary, and sensitive identifiers.
- Never commit credentials or unredacted configuration exports.
- Preserve useful command output while removing secrets.
- Keep original evidence where appropriate and describe any edits to screenshots or logs.
- Record firmware versions and source documentation for device-specific procedures.

## Status language

Use **Verified** only for directly observed results with evidence. Use **In progress** when part of the behavior is tested but the acceptance criteria are not fully met. Use **Planned** for future work. Use **Blocked** when a dependency prevents a test.

## Example test record

### NET-TEST-001 — Wired client internet connectivity

- **Objective:** Verify a wired client can obtain network settings and reach an external destination through the intended firewall path.
- **Scope:** Test client, access switch, core switch, OPNsense LAN/WAN, and WAN service.
- **Preconditions:** Correct cables and interfaces are identified; no maintenance is in progress.
- **Procedure:** Record the client's address, subnet, gateway, and DNS settings; verify local gateway reachability; test DNS resolution; test outbound connectivity; inspect relevant firewall and interface status if a step fails.
- **Expected result:** The client receives the intended network settings and can resolve names and reach the approved external test destination.
- **Observed result:** Fill in measured output and evidence links after performing the test.
- **Verdict:** Leave as **INCONCLUSIVE** until the test is run and recorded.
- **Limitations / next action:** This test alone does not validate VLAN isolation, Wi-Fi throughput, failover, or all downstream ports.
