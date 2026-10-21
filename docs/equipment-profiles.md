# Home-Lab Equipment Profiles

**Status:** Planning reference  
**Last updated:** 2026-10-14

This document gives each item in the proposed home-lab topology its own equipment subsection: role, relevant capabilities, planned use, and items to verify. It distinguishes confirmed planning facts from assumptions. Do not treat estimated power or unverified link speeds as deployment approval.

## 1. Starlink Internet

**Role:** Internet service and WAN handoff.

**Planned use:** Provide the upstream internet connection to OPNsense. OPNsense remains the intended firewall/router for the home lab.

**Key considerations**
- Starlink hardware generations differ in Ethernet handoff and bypass/bridge-mode behavior.
- Confirm the installed dish/router generation and how Ethernet is provided.
- Avoid unintentionally running two independent router/NAT layers unless that is deliberate.

**Verify before deployment:** Router model, Ethernet adapter or handoff, bypass mode, WAN addressing, and OPNsense WAN connectivity.

**Official support:** https://www.starlink.com/support

## 2. OPNsense Firewall/Router

**Hardware:** Riverbed SteelHead CX-770 repurposed as the OPNsense appliance.

**Role:** Primary firewall, router, DHCP/NAT service, and inter-VLAN policy point.

**Planned use:** Route the WAN connection from Starlink to the LAN and enforce access between network segments. Keep administrative access restricted to trusted clients.

**Hardware visual references**
- [Official Riverbed SteelHead Installation Guide (PDF)](https://download.riverbed.com/var/imageshare/software-docs/sh-icg.pdf) — appendix “CX x70 Desktop Appliance Specifications,” figures E-1 and E-2 (front and back panel diagrams; around printed page 87 in the guide). The CX 770's Ethernet, console, USB, and power-port locations are shown in the guide.
- [Riverbed SteelHead CX support and documentation](https://support.riverbed.com/content/support/software/steelhead/cx-appliance.html?swVersion=9.16.0)
- [Illustrative CX-770 photo gallery](https://www.ebay.com/itm/284862930402) — third-party listing; photos may show a different revision or configuration, so use the official guide for port labels and confirm against the actual unit.

**Known hardware context:** The CX-770 has been identified as the appliance. Confirm its installed NIC layout, interface mapping, storage, firmware/BIOS configuration, and console access before finalizing deployment instructions. Do not assume all factory interfaces are available or correctly mapped for OPNsense without testing.

**Key considerations**
- Define VLAN IDs, subnets, DHCP scopes, and rules only after auditing the current configuration.
- Avoid overlapping networks and duplicate DHCP servers.
- Export configuration backups before major changes and retain recovery instructions.
- Record the interface-to-port mapping, including which physical port is WAN and which is LAN.

**Verify before deployment:** Physical interface mapping, WAN/LAN operation, VLAN support on the connected switch ports, DHCP scopes, firewall rules, and configuration backup/restore procedure.

**Official documentation:** https://docs.opnsense.org/

## 3. RUCKUS ICX7150-C12P Core Switch

**Role:** Central managed access/core switch and potential PoE+ source.

**Relevant platform capabilities:** 12 × 1GbE PoE+ access ports, 2 × 1GbE RJ45 uplink ports, and 2 × 1/10GbE SFP+ uplink ports are listed for this model family/configuration. A nominal 124 W PoE budget has been referenced in this plan. Confirm these against the exact unit and software configuration. 10GbE operation may depend on the specific SKU, software, licensing, and supported transceiver/DAC.

**Planned use**
- Connect OPNsense, TrueNAS, Red Queen PC, Framework Desktop, the EAP650, and downstream switches.
- Provide the general-LAN NIC 1 connections for the six CSI nodes through compatible PoE-to-12 V splitters, only if the verified PoE budget supports the loads.
- Use VLANs and trunks where configured on both ends.
- Potentially connect a future 2.5GbE switch over a verified 10GbE uplink.

**Important limitations**
- The twelve main access ports are Gigabit Ethernet, not 2.5GbE.
- The switch's USB port is not a NAS or general-purpose network storage interface.
- The switch should not replace OPNsense as the primary firewall in this design.
- Fanless operation is useful in a quiet lab, but maintain adequate ventilation.

**PoE planning warning:** Current estimate is about 100 W for the CSI nodes plus about 15 W for the EAP650, or roughly 115 W device-side against a nominal 124 W budget. Splitter losses, peak/startup draw, and actual consumption reduce the margin. This is an estimate, not approval to power every device from this switch.

**Verify before deployment:** Exact SKU/revision, firmware/support status, PoE budget, per-port PoE standard, actual power draw, SFP+ 10GbE availability/licensing, supported optics/DAC, VLAN/trunk configuration, and management access.

**Official resources**
- Product page: https://www.ruckusnetworks.com/products/ethernet-switches/itemicx7150-c12p/
- Datasheet: https://www.ruckusnetworks.com/globalassets/digizuite/61729-ds-icx-7150.pdf
- Support documents: https://support.ruckuswireless.com/documents?query=Icx7150

## 4. Six CSI Compute Nodes

**Role:** Cluster/compute nodes.

**Known planning details:** Six nodes, each with two RJ45 Ethernet interfaces. Two are classed as higher-power and four as lower-power. Photos of the node label indicate 12 V DC, 3 A (36 W rated maximum input); this is a rating, not a measured typical draw. Exact model and NIC speeds remain unverified.

**Planned network use**
- **NIC 1:** General LAN and management through the RUCKUS, with one compatible PoE-to-12 V splitter per node if electrical and PoE checks pass.
- **NIC 2:** Dedicated node-to-node traffic through the non-PoE TP-Link Omada SG2008.
- Give NIC 2 a dedicated static subnet that does not overlap existing networks. Normally leave its default gateway unset unless the cluster software requires routing.

**Verify before deployment:** Exact node model, NIC speeds, cluster software's interface selection, power draw under sustained/peak load, cooling, 12 V connector and polarity, and whether any vendor documentation specifies special NIC behavior.

## 5. Six PoE-to-12 V DC Splitters

**Role:** Extract standards-based PoE power from the Ethernet run and provide 12 V DC to a CSI node while passing Ethernet data.

**Planned use:** One splitter per CSI node on NIC 1's general-LAN connection.

**Requirements**
- IEEE 802.3af/at input compatible with the actual RUCKUS port and PoE negotiation.
- Regulated 12 V DC output, correct polarity and connector, and adequate continuous and peak current.
- Conversion efficiency and thermal performance suitable for sustained operation.

**Safety note:** Do not feed PoE directly into a CSI node unless its exact hardware documentation explicitly states that the Ethernet port accepts PoE.

**Verify before deployment:** Exact splitter model, input standard, maximum output current, connector dimensions, polarity, efficiency, and sustained-load temperature. Test one complete node before deploying all six.

## 6. TP-Link Omada SG2008 (Non-PoE)

**Role:** Dedicated CSI interconnect switch.

**Planned use:** Connect NIC 2 from all six CSI nodes to keep inter-node traffic physically separate from their general-LAN NIC 1 connections.

**Relevant limitation:** Gigabit Ethernet per port; the dedicated network does not exceed the negotiated port speed.

**Recommended configuration:** Use a non-overlapping static subnet, unique addresses, no default gateway by default, and configure cluster software to use NIC 2. Confirm that no unintended routing or bridge connects this network to the general LAN.

**Verify before deployment:** Hardware revision, firmware, VLAN/management configuration, link speeds, and cluster traffic actually using NIC 2.

**Official support:** https://support.omadanetworks.com/us/product/sg2008/

## 7. TP-Link Omada SG2008P Camera Switch

**Role:** Dedicated camera access switch.

**Planned use:** Connect cameras to this switch and uplink it to the RUCKUS. Apply camera VLAN and OPNsense policies as supported by the configured topology.

**Key considerations:** PoE capacity and port count depend on the exact hardware revision. Keep cameras from reaching management networks or the internet unless required.

**Verify before deployment:** Hardware revision, total and per-port PoE budgets, camera power requirements, uplink speed, VLAN settings, and required outbound services.

**Official support:** https://support.omadanetworks.com/us/product/sg2008p/

## 8. Dell PowerConnect X1018

**Role:** Dedicated switch for in-wall Ethernet drops.

**Planned use:** Connect fixed wall ports to the home-lab LAN through an uplink to the RUCKUS.

**Key limitation:** Treat it as Gigabit Ethernet; do not plan it as a 2.5GbE or 10GbE distribution switch.

**Verify before deployment:** Hardware condition, port mapping, management/VLAN capability as required, uplink speed, and which room/drop maps to each port.

**Official support:** https://www.dell.com/support/home/en-us (search for PowerConnect X1018).

## 9. TP-Link Omada EAP650 Access Point

**Role:** Wi-Fi access point.

**Planned use:** Provide wireless access, with SSIDs mapped to the intended LAN/VLANs where supported by the AP and switch configuration. The RUCKUS is the planned PoE source only if the final power budget permits.

**Key considerations:** Do not assume a particular PoE draw or feature set without checking the exact hardware revision. Keep untrusted/IoT wireless clients separated as appropriate.

**Verify before deployment:** Hardware revision, power method and maximum draw, uplink speed, controller/standalone mode, SSID-to-VLAN mapping, and roaming/security requirements.

**Official support:** https://support.omadanetworks.com/us/product/eap650/

## 10. Primary TrueNAS System

**Host hardware:** Lenovo ThinkCentre M75q Gen 2 Tiny, machine type/model **11JJ007TUS** (identified from the user's unit label/listing). This is the currently used TrueNAS host, not the separate planned two-bay backup appliance.

**Relevant networking/expansion details from Lenovo PSREF:** One onboard RJ-45 Ethernet port (Gigabit Ethernet); front USB-A port supporting USB 3.2 Gen 2 (10 Gbps theoretical USB link); front USB-C supporting USB 3.2 Gen 1 (5 Gbps theoretical USB link). Thunderbolt is not listed for this configuration. The Tiny 1L chassis does not provide a practical standard PCIe NIC upgrade path for this plan. Confirm port details against the exact machine configuration before purchasing accessories.

**Role:** Primary shared storage and file services.

**Planned use:** Serve authorized clients and store shared files, datasets, and other data according to the configured TrueNAS services. Potential protocols include SMB, NFS, or iSCSI when specifically configured and appropriate.

**Key considerations**
- Keep administration private and restrict service access to approved clients.
- Measure actual NIC link speed and storage throughput before planning faster workloads.
- The future two-bay TrueNAS unit is a separate dedicated backup appliance, not a replacement for this primary system.

**Verify before deployment:** TrueNAS edition/version, drive layout, NIC model/speed, SMB/NFS/iSCSI needs, datasets and permissions, snapshots, configuration backup, and restore procedures.

**Official hardware references:** [Lenovo ThinkCentre M75q Gen 2 PSREF/specifications (PDF)](https://psref.lenovo.com/syspool/Sys/PDF/ThinkCentre/ThinkCentre_M75q_Gen_2/ThinkCentre_M75q_Gen_2_Spec.pdf) · [Lenovo M75q Gen 2 Type 11JJ Guides & Manuals](https://pcsupport.lenovo.com/us/en/products/desktops-and-all-in-ones/thinkcentre-m-series-desktops/thinkcentre-m75q-gen-2/11jj/document-userguide/doc_userguide)

**Official software documentation:** https://www.truenas.com/docs/ (select the installed edition and release; exact TrueNAS version still needs to be recorded).

## 11. Red Queen PC

**Role:** Main workstation and home-lab client.

**Known system details:** ASUS TUF Gaming X570-Plus motherboard, AMD Ryzen 7 2700X CPU, and Radeon RX 5700 GPU. Installed Ethernet NIC model and link speed have not been confirmed.

**Planned use:** Access shared storage, development resources, and lab services. A faster connection depends on the installed NIC and the switch path.

**Verify before deployment:** NIC model, negotiated speed, driver, cabling, storage throughput, and whether a 2.5GbE NIC upgrade would be useful.

**Support:** ASUS https://www.asus.com/support/ ; AMD https://www.amd.com/en/support

## 12. Framework Desktop

**Role:** Compute and AI workloads.

**Planned use:** Run compute workloads and access authorized storage/datasets over the network.

**Key considerations:** Do not assume its Ethernet speed or expansion options without confirming the exact configuration. Workload performance depends on the network, storage, and compute hardware together.

**Verify before deployment:** Exact model/configuration, installed NIC speed, storage requirements, data access pattern, and expected throughput.

**Official support:** https://frame.work/support

## 13. Future 2.5GbE Access Switch with 10GbE Uplink

**Status:** Planned future purchase; model not selected.

**Role:** Higher-speed access for compatible workstation and storage endpoints.

**Planned use:** Connect compatible 2.5GbE endpoints and provide a 10GbE uplink to the core, if the RUCKUS unit's exact SFP+ configuration supports it.

**Selection requirements**
- Enough 2.5GbE ports for the intended endpoints.
- A compatible 10GbE uplink (SFP+ or RJ45, as appropriate).
- VLAN/trunk features if segmented networks will traverse the link.
- Compatible NICs, transceivers/DACs, cabling, and thermal/power characteristics.
- TrueNAS and workstation storage performance sufficient to benefit from the faster link.

**Do not purchase solely on the assumption that the RUCKUS uplink supports 10GbE.** Verify the exact switch configuration first.

## 14. Future Dedicated Two-Bay TrueNAS Backup Appliance

**Status:** Planned future improvement; the two-bay case has already been 3D-printed.

**Role:** Pure backup target for important data from the primary TrueNAS and selected home-lab systems.

**Required storage configuration:** Two data drives configured as a mirror. This is a fixed requirement for this two-bay design. Usable capacity is approximately one drive's capacity before overhead.

**Planned safeguards**
- Use dedicated backup credentials and restrict deletion permissions.
- Define backup schedules, retention, and notifications.
- Keep versioned backup generations where supported.
- Test restoring files and configurations.
- Consider an additional copy separate from this device for stronger disaster recovery.

**Verify before building:** Case fit, motherboard/compute hardware, drive compatibility, cooling, power supply, TrueNAS version, network interface, and backup software/workflow.

**Detailed proposal:** [Dedicated Backup TrueNAS System](future-improvements/backup-truenas-system.md)

## 15. Network and deployment dependencies

- Confirm exact models/revisions and link speeds before finalizing the port map.
- Decide VLAN IDs and subnets only after reviewing the current OPNsense configuration.
- Verify the full PoE load with actual device draw and splitter losses.
- Test inter-node traffic on CSI NIC 2 and confirm it does not use the default gateway.
- Confirm 10GbE capability and required configuration on the RUCKUS before buying a faster access switch.
- Record final switch ports, VLANs, addresses, firmware versions, and configuration backups after commissioning.
