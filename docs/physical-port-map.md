# Physical Network Port Map

## Purpose

Record the real cabling and interface assignments for the home-lab network. This is a working document: entries must be updated from direct observation, not inferred from the logical topology.

## Status key

- **Verified:** The physical connection and relevant link details were observed.
- **In progress:** Part of the connection has been checked, but the full path is not validated.
- **Planned:** Intended connection that has not been commissioned.
- **TBD:** Record the value after checking the equipment.

## Remote KVM fleet

Four GL.iNet remote KVM units are planned for remote console access to selected lab systems. Target hosts and physical connections are not yet confirmed. Complete the unit-by-unit inventory in [Remote KVM Fleet](remote-kvm-fleet.md) before recording connections as verified.

| ID | From device / interface | To device / interface | Media | Expected speed | Observed speed / state | VLAN or role | Status / evidence |
|---|---|---|---|---|---|---|---|
| PHY-009 | GL.iNet Remote KVM 1 interface TBD | Switch/AP and target host TBD | TBD | TBD | TBD | Management / remote console | Planned |
| PHY-010 | GL.iNet Remote KVM 2 interface TBD | Switch/AP and target host TBD | TBD | TBD | TBD | Management / remote console | Planned |
| PHY-011 | GL.iNet Remote KVM 3 interface TBD | Switch/AP and target host TBD | TBD | TBD | TBD | Management / remote console | Planned |
| PHY-012 | GL.iNet Remote KVM 4 interface TBD | Switch/AP and target host TBD | TBD | TBD | TBD | Management / remote console | Planned |

## Connection register

| ID | From device / interface | To device / interface | Media | Expected speed | Observed speed / state | VLAN or role | Status / evidence |
|---|---|---|---|---|---|---|---|
| PHY-001 | Starlink Ethernet handoff — exact port TBD | OPNsense WAN interface — mapping TBD | Ethernet; handoff to confirm | TBD | TBD | WAN | In progress |
| PHY-002 | OPNsense LAN interface — mapping TBD | RUCKUS ICX7150-C12P port TBD | Ethernet | Up to interface capability | TBD | LAN / trunk role TBD | In progress |
| PHY-003 | RUCKUS ICX7150-C12P port TBD | Dell PowerConnect X1018 port TBD | Copper or SFP; confirm actual media | Confirm both endpoints | TBD | Uplink role TBD | Planned / not end-to-end validated |
| PHY-004 | Dell PowerConnect X1018 Gi1/0/16 | Test PC or endpoint used during prior check | Copper Ethernet | 1 GbE | 1 GbE observed in prior notes | Test endpoint | Previously verified; recheck if changed |
| PHY-005 | RUCKUS access port TBD | CSI node 1 NIC 1 via compatible PoE splitter | Ethernet + splitter power path | Confirm endpoint and switch limits | TBD | General LAN | Planned |
| PHY-006 | RUCKUS access port TBD | CSI node 2–6 NIC 1 via compatible PoE splitters | Ethernet + splitter power path | Confirm each endpoint and switch limits | TBD | General LAN | Planned |
| PHY-007 | CSI node NIC 2 | TP-Link Omada SG2008 port TBD | Ethernet | Confirm node NIC capability | TBD | Dedicated cluster interconnect | Planned |
| PHY-008 | TP-Link Omada SG2008P port TBD | Camera endpoint(s) | Ethernet / PoE as applicable | Confirm endpoint capability | TBD | Camera network | Dedicated camera-switch role documented |
| PHY-009 | TP-Link Omada EAP650 uplink | Access-switch port TBD | Ethernet with PoE power path to confirm | Confirm both endpoints | TBD | Wireless AP management / client VLANs TBD | In progress |
| PHY-010 | TrueNAS host Ethernet | Switch port TBD | Ethernet | Host onboard interface is 1 GbE | TBD | Storage / LAN role TBD | In progress |

> These rows are a working inventory, not proof that all listed cables are currently connected. Replace TBD values only after inspecting the actual devices and cabling. Split multi-endpoint rows into individual rows when commissioning.

## Device interface inventory

For each switch, firewall, server, or node, record:

- Device name and exact model / hardware revision.
- Interface name as reported by the device.
- Physical port label.
- Connected peer and peer interface.
- Media type and transceiver model, if applicable.
- Negotiated speed and duplex.
- VLAN mode and allowed VLANs, once configured.
- PoE state and power draw, where applicable.
- Interface errors, drops, and counters before and after testing.
- Date checked and a link to sanitized evidence.

## Commissioning checklist

- [ ] Identify the exact physical WAN and LAN interfaces on the Riverbed SteelHead CX-770 running OPNsense.
- [ ] Record Starlink Ethernet handoff details and whether bypass mode is enabled.
- [ ] Verify OPNsense WAN address, gateway state, DNS, and outbound connectivity.
- [ ] Verify the OPNsense LAN-to-RUCKUS link, negotiated speed, and client connectivity.
- [ ] Connect and validate the Dell-to-RUCKUS uplink; verify both ends and end-to-end traffic.
- [ ] Record every CSI node's NIC and splitter model before applying PoE.
- [ ] Confirm RUCKUS PoE budget, splitter losses, and endpoint demand before powering all planned nodes.
- [ ] Verify the EAP650 power requirements and wired uplink.
- [ ] Record VLAN IDs, access/trunk mode, DHCP scopes, and firewall policy after implementation.
- [ ] Measure endpoint link rates and throughput; save test evidence.

## Update discipline

Update this document after a physical cabling or port-assignment change. If a test fails, record the observed state and a follow-up action rather than silently changing the status to verified.
