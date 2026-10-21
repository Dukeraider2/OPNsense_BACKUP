# Home-Lab Network Topology Plan

**Status:** Proposed design, not yet commissioned.  
**Version:** 1.1  
**Date:** October 13, 2026

Related detailed procedure: [Starlink WAN integration and validation plan](starlink-network-integration.md).

## Design goals

- Starlink provides the WAN connection to OPNsense.
- OPNsense remains the primary firewall and router.
- RUCKUS ICX7150-C12P is planned as the core managed switch and PoE source, subject to exact SKU and budget verification.
- Six CSI nodes use two NICs each: NIC 1 for general LAN access through one compatible PoE-to-12 V splitter per node; NIC 2 for dedicated node-to-node traffic through the non-PoE Omada SG2008.
- TP-Link Omada SG2008P is dedicated to the camera system.
- Dell PowerConnect X1018 is dedicated to in-wall LAN drops.
- TP-Link Omada EAP650 provides Wi-Fi.
- TrueNAS, Red Queen PC, and Framework Desktop connect to the general/core network. High-speed storage paths will be finalized after NIC speeds are verified.
- A 2.5 GbE access switch with a 10 GbE uplink is a future planned upgrade, not purchased.

## Logical topology

```text
Starlink
   |
OPNsense firewall/router
   |
RUCKUS ICX7150-C12P (core; PoE subject to validation)
   |-- CSI nodes 1-6 NIC 1 (one compatible PoE splitter per node)
   |-- Omada EAP650 (PoE, if budget allows)
   |-- TrueNAS
   |-- Red Queen PC
   |-- Framework Desktop
   |-- Omada SG2008P (dedicated camera switch)
   |-- Dell PowerConnect X1018 (in-wall LAN drops)
   |
   +-- future 2.5 GbE switch with 10 GbE uplink (planned)

CSI nodes 1-6 NIC 2
   |
Omada SG2008 (non-PoE; dedicated CSI interconnect)
```

## CSI dual-NIC configuration

- **NIC 1:** General LAN, management, updates, and permitted internet access. Ethernet data passes through the PoE splitter; the splitter powers the node through its DC input. Do not apply PoE directly to the NIC.
- **NIC 2:** Connect to the non-PoE SG2008 for node-to-node traffic. Use a dedicated static subnet that does not overlap existing networks. Normally do not configure a default gateway on this interface unless the cluster software requires it.
- The SG2008 is Gigabit Ethernet; each node link is limited to 1 GbE unless equipment is upgraded.

## PoE planning

Planning assumption: two higher-power CSI nodes at up to 20 W each, four lower-power nodes at up to 15 W each, plus approximately 15 W for the EAP650.

Estimated device-side demand:
- 2 × 20 W = 40 W
- 4 × 15 W = 60 W
- EAP650 ≈ 15 W
- Total ≈ 115 W

The RUCKUS has been discussed as having a nominal 124 W PoE budget, leaving only about 9 W before splitter losses, peak demand, and differences between DC-side and PoE-side consumption. **Do not treat this as approved.** Verify the exact RUCKUS SKU, PoE budget, splitter efficiency, node peak load, and EAP650 maximum draw. If margin is insufficient, use a separate compliant PoE source for the AP or one or more nodes.

Each splitter must support standards-based IEEE 802.3af/at input and the exact 12 V DC polarity, connector, and current required by the CSI node. The node label shows 12 V DC, 3 A (36 W rated maximum), not measured typical consumption.

## Network segmentation

| Network | Intended role |
|---|---|
| Management | Restrict switch/firewall administration to trusted clients. |
| General LAN | Trusted clients and normal services. |
| CSI management | NIC 1, optionally separated by VLAN from the general LAN. |
| CSI interconnect | Physically separate NIC 2 network on SG2008; no default gateway by default. |
| Storage | Optional dedicated network for TrueNAS and storage clients, depending on NIC capability. |
| Cameras | Camera devices behind SG2008P; restrict outbound and inter-VLAN access. |
| Wireless / IoT | Segment less-trusted clients where appropriate. |

Use OPNsense to enforce security rules for traffic that must cross routed VLANs. Final VLAN IDs, subnets, DHCP scopes, and port assignments must be chosen after checking the current configuration.

## Future 2.5 GbE / 10 GbE upgrade

Plan to add a 2.5 GbE switch with a 10 GbE uplink for compatible desktop and storage endpoints. Before purchase, verify the NICs in TrueNAS, Red Queen, and Framework Desktop, and verify the exact RUCKUS C12P uplink SKU and any required licensing. The Dell X1018 is treated as a Gigabit switch, not a 10 GbE uplink device.

## Open verification items

1. Verify exact RUCKUS ICX7150-C12P suffix, SFP/SFP+ capability, license state, and PoE budget.
2. Confirm peak power draw of all CSI nodes and EAP650, including splitter losses.
3. Select and verify six compatible PoE-to-12 V splitters.
4. Verify NIC speeds in all CSI nodes, TrueNAS, Red Queen, and Framework Desktop.
5. Record current OPNsense subnets, VLAN IDs, DHCP scopes, and switch uplinks.
6. Confirm CSI software uses NIC 2 for node-to-node traffic.
7. Confirm Starlink Ethernet handoff and router/bypass configuration.
8. Decide whether TrueNAS requires a dedicated high-speed storage path now or after the planned switch upgrade.

## Implementation sequence

1. Inventory model numbers, hardware revisions, NIC speeds, PoE specifications, current subnets, and VLANs.
2. Connect Starlink to OPNsense WAN and OPNsense LAN to RUCKUS; validate internet and management access.
3. Connect CSI NIC 2 ports to SG2008, assign unique static addresses, and test node-to-node communication.
4. Test one splitter/node first. Confirm output voltage, polarity, stability, and load. Do not deploy all six on the RUCKUS PoE budget until adequate headroom is verified.
5. Connect camera devices to SG2008P and fixed in-wall drops to X1018; validate intended VLANs and uplinks.
6. Connect TrueNAS, Red Queen, and Framework Desktop; confirm negotiated link speed and benchmark storage.
7. Add the planned 2.5 GbE switch with 10 GbE uplink only after endpoint and uplink compatibility are confirmed.

## Acceptance checklist

- [ ] Starlink internet access works through OPNsense.
- [ ] OPNsense is the intended firewall/router for routed networks.
- [ ] All six CSI nodes have general LAN access on NIC 1.
- [ ] All six CSI nodes communicate through NIC 2 on SG2008.
- [ ] CSI NIC 2 has no unintended gateway or internet path.
- [ ] Each PoE splitter provides correct 12 V DC and is stable under sustained load.
- [ ] Total PoE demand is within verified budget with operating headroom.
- [ ] EAP650 is powered and wireless access works.
- [ ] Cameras operate on the intended network.
- [ ] In-wall LAN drops work through X1018.
- [ ] TrueNAS is reachable from intended clients and storage performance is measured.
- [ ] Endpoint negotiated link speeds are verified.
- [ ] Configuration backups, port assignments, and recovery steps are documented.

## Official equipment manuals

See [docs/equipment-manuals.md](docs/equipment-manuals.md) for manufacturer documentation links, revision notes, and unresolved model-identification items.
