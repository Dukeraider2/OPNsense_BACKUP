# Home-Lab Network Plan
**Version:** 1.5 | **Status:** Proposed design | **Updated:** 2026-10-20

[![Home-lab network topology — open the interactive Archify diagram](../images/home-lab-network-topology.svg)](https://dukeraider2.github.io/OPNsense_BACKUP/)

> The diagram is a conceptual overview. Confirm exact port assignments, negotiated link speeds, VLAN IDs, and PoE capacity against installed hardware before deployment.

## 1. Executive summary
Starlink provides WAN service to OPNsense, the primary firewall/router. The RUCKUS ICX7150-C12P is planned as the core managed switch. Six CSI nodes use dual Ethernet interfaces: NIC 1 connects to the general LAN through one compatible PoE-to-12 V splitter per node; NIC 2 connects to a dedicated non-PoE TP-Link Omada SG2008 for node-to-node traffic. The TP-Link Omada SG2008P is dedicated to cameras, and the Dell PowerConnect X1018 is dedicated to in-wall LAN drops.

TrueNAS, Red Queen PC, Framework Desktop, and the Omada EAP650 connect to the core network. A 2.5 GbE access switch with a 10 GbE uplink is a future planned upgrade, not current equipment.

## 2. Equipment and assigned roles

| Equipment | Intended role | Verification required |
|---|---|---|
| Starlink | Internet WAN | Confirm Ethernet handoff and router/bypass mode for installed generation. |
| OPNsense | Firewall, routing, DHCP, NAT, inter-VLAN policies | Confirm interfaces and current configuration. |
| RUCKUS ICX7150-C12P | Core switch and planned PoE source | Verify exact SKU, PoE budget, uplinks, firmware support, and any 10 GbE licensing/configuration. |
| Six CSI nodes | Cluster compute | Two higher-power and four lower-power nodes; two RJ45 NICs each. Exact model and NIC speeds unverified. |
| Six PoE splitters | PoE-to-12 V DC power for nodes | One per node; verify 802.3af/at input, 12 V output, polarity, connector, current, and efficiency. |
| TP-Link Omada SG2008 (non-PoE) | Dedicated CSI interconnect | NIC 2 from all six nodes; Gigabit links. |
| TP-Link Omada SG2008P | Camera switch | Confirm hardware revision and PoE budget for cameras. |
| Dell PowerConnect X1018 | In-wall LAN drops | Treat as Gigabit; not a 10 GbE distribution switch. |
| TP-Link Omada EAP650 | Wireless access point | Planned PoE from RUCKUS only if power budget allows. |
| TrueNAS | Shared storage / file services / iSCSI as configured | Confirm NIC speed and storage requirements. |
| Four GL.iNet remote KVM units | Remote console access for selected lab systems | Exact models, target hosts, network interfaces, power, and connectivity are not yet inventoried; see [Remote KVM Fleet](remote-kvm-fleet.md). |
| Red Queen PC | Desktop and storage client | Confirm installed NIC capability. |
| Framework Desktop | Compute / AI workloads | Confirm installed NIC capability and storage needs. |
| Future 2.5 GbE switch + 10 GbE uplink | Faster desktop/storage access | Planned future purchase; model not selected. |
| Future two-bay TrueNAS backup appliance | Dedicated mirrored backup target | Case is 3D-printed; configure two data drives as a mirror. |

## 3. Topology

```text
Starlink
   |
OPNsense firewall/router
   |
RUCKUS ICX7150-C12P (core)
   |-- CSI nodes 1-6 NIC 1 through one PoE-to-12 V splitter per node
   |-- Omada EAP650 (if PoE budget allows)
   |-- TrueNAS
   |-- Red Queen PC
   |-- Framework Desktop
   |-- Omada SG2008P --> cameras
   |-- Dell PowerConnect X1018 --> in-wall LAN drops
   |-- Future 2.5 GbE switch with 10 GbE uplink (planned)

CSI nodes 1-6 NIC 2
   |
Omada SG2008 (non-PoE, dedicated CSI interconnect)
```

The diagram and text describe logical roles, not a final port map. Record switch port numbers and negotiated link speeds during commissioning.

## 4. CSI dual-NIC design
**NIC 1: General LAN and management.** Connect each node's first Ethernet interface to RUCKUS through its own compatible PoE splitter. Ethernet carries data; the splitter powers the node through its DC input. The photographed CSI label indicates 12 V DC, 3 A (36 W rated maximum input), not typical measured consumption.

**NIC 2: Dedicated cluster interconnect.** Connect each node's second Ethernet interface to the non-PoE SG2008. Use a dedicated static subnet that does not overlap existing networks. Example only: `192.0.2.0/24`. Assign a unique address to each node and normally leave the default gateway unset on this interface unless cluster software requires routing. Configure cluster software to use NIC 2 and test interface selection.

The SG2008 provides Gigabit Ethernet per port. Physical separation keeps inter-node traffic off the general LAN, but does not increase link speed beyond negotiated 1 GbE.

## 5. PoE capacity and electrical validation
Planning assumptions:
- Two higher-power nodes at up to 20 W each: 40 W.
- Four lower-power nodes at up to 15 W each: 60 W.
- EAP650 planning estimate: approximately 15 W.
- Estimated device-side total: approximately 115 W.

The RUCKUS has been discussed as having a nominal 124 W PoE budget. This leaves only about 9 W before splitter losses, peak/startup load, and differences between node DC-side draw and PoE-side draw. **This estimate is not an approved load calculation.**

Before deployment:
1. Verify the exact RUCKUS SKU and official PoE budget.
2. Confirm peak demand for each node and the EAP650.
3. Verify each splitter's IEEE 802.3af/at input and 12 V DC output, polarity, connector, and current rating.
4. Include conversion losses and peak demand in the budget.
5. Test one splitter and node under sustained load before expanding.
6. If headroom is insufficient, power the EAP650 or one or more nodes from a separate compliant PoE source.

Do not inject PoE directly into a CSI node Ethernet port unless the exact unit explicitly supports PoE input.

## 6. Segmentation and security

Finalize VLAN IDs and subnets only after reviewing the current OPNsense configuration.

| Network | Intended purpose | Baseline policy |
|---|---|---|
| Management | Firewall and switch administration | Allow trusted administration clients only. |
| General LAN | Trusted clients and ordinary services | Normal outbound access. |
| CSI management | NIC 1, optionally separated by VLAN | Permit required management, update, and control services. |
| CSI interconnect | NIC 2 via SG2008 | Physically separate; no default gateway by default. |
| Storage | TrueNAS and authorized storage clients, if separate | Permit only required SMB/NFS/iSCSI and administration flows. |
| Cameras | Cameras behind SG2008P | Restrict outbound and inter-VLAN access. |
| Wireless/IoT | EAP650 clients as appropriate | Separate untrusted/IoT devices where needed. |

Use OPNsense for routed inter-VLAN policy. A VLAN alone does not guarantee isolation if another device routes between networks. Avoid overlapping subnets and duplicate DHCP servers.

## 7. Storage and future high-speed expansion
Initially connect TrueNAS, Red Queen, and Framework Desktop using verified available NIC speeds. Measure negotiated link rates and storage throughput.

Planned upgrade: a 2.5 GbE access switch with a 10 GbE uplink. Before purchase, verify endpoint NIC speeds, upstream 10 GbE capability, exact RUCKUS SFP/SFP+ capability and any licensing/configuration requirements, and whether TrueNAS should use a dedicated storage segment. The Dell X1018 remains a Gigabit switch for ordinary in-wall drops.

A separate two-bay TrueNAS appliance is planned as a dedicated backup target. Its required layout is a two-drive mirror; see the [backup TrueNAS proposal](future-improvements/backup-truenas-system.md).

### Future cellular WAN options

Starlink remains the WAN shown in the current topology. Cellular options are under evaluation, not commissioned:
- [5G WAN shortlist](future-5g-wan-shortlist.md) compares a four-device UniFi U5G-EU concept (three fixed, one movable/field-deployable) against a single battery-powered GL.iNet MUDI 7 EU.
- The U5G hardware subtotal at the observed UK store price is £316 for four units, before data plans, PoE supplies/accessories, taxes, shipping, or duties. It is 5G RedCap, requires PoE power, and has not been validated as a generic Ethernet WAN for OPNsense.
- The MUDI 7 is battery-powered and has 2.5 GbE, but one unit is roughly in the same broad sticker-price tier as four U5G units. Prices are in different currencies and need a same-day all-in comparison.

Do not change the current Starlink-to-OPNsense deployment based on this shortlist. Before selecting cellular hardware, test one exact regional SKU with a real SIM and confirm the carrier's bands/plan plus OPNsense WAN handoff. The U5G specifically requires checking 5G SA/RedCap plan support; otherwise it may fall back to LTE.

## 8. Implementation phases
1. **Inventory:** Record model numbers, hardware revisions, NIC speeds, PoE specifications, current subnets, VLANs, DHCP scopes, and uplinks.
2. **Core/WAN:** Connect Starlink to OPNsense WAN and OPNsense LAN to RUCKUS; verify connectivity and management.
3. **CSI interconnect:** Connect all NIC 2 ports to SG2008; assign static addresses and verify traffic uses NIC 2.
4. **PoE pilot:** Test one splitter/node for correct voltage, polarity, stability, and negotiated PoE. Do not connect all loads until the full budget is verified.
5. **Dedicated switches:** Connect cameras to SG2008P and in-wall drops to X1018; validate uplinks and policies.
6. **Storage/compute:** Connect TrueNAS, Red Queen, and Framework Desktop; record link speed and benchmark storage.
7. **Future expansion:** Add the 2.5 GbE switch with 10 GbE uplink after compatibility checks.

## 9. Acceptance checklist
- [ ] Starlink internet works through OPNsense.
- [ ] OPNsense remains the intended firewall/router.
- [ ] All six CSI nodes have general LAN access through NIC 1.
- [ ] All six nodes communicate over NIC 2 through SG2008.
- [ ] NIC 2 has no unintended gateway or internet path.
- [ ] Splitters provide correct 12 V DC and remain stable under load.
- [ ] Total PoE load is below the verified budget with operating headroom.
- [ ] EAP650 wireless access works and reaches intended networks only.
- [ ] Camera network operates with intended isolation.
- [ ] In-wall drops work through X1018.
- [ ] TrueNAS is reachable from authorized clients and throughput is measured.
- [ ] Red Queen and Framework Desktop negotiated link speeds are recorded.
- [ ] Port assignments, VLANs, backups, and recovery steps are documented.

## 10. Equipment documentation
- [Equipment Profiles: detailed role, capabilities, deployment checks, and official support links for each device](equipment-profiles.md)
- [Equipment Manuals and Official Documentation](equipment-manuals.md) for manufacturer resources and revision guidance.

