# Equipment Manuals and Official Documentation

This index links to manufacturer-maintained documentation for the equipment in the home-lab network plan. Select the exact hardware revision where the manufacturer provides revision-specific documents. Prefer these live official pages over copied PDFs because firmware, safety notices, and manuals can change.

## Internet and firewall

| Equipment | Official documentation | Notes |
|---|---|---|
| Starlink | https://www.starlink.com/support | Select the actual dish/router generation. Bypass-mode instructions vary by router model. |
| OPNsense | https://docs.opnsense.org/ | Official OPNsense documentation. Use the matching release documentation for firewall, VLAN, DHCP, routing, and interface setup. |
| Riverbed SteelHead CX-770 (OPNsense host) | [SteelHead Installation Guide PDF](https://download.riverbed.com/var/imageshare/software-docs/sh-icg.pdf) · [Riverbed SteelHead CX support](https://support.riverbed.com/content/support/software/steelhead/cx-appliance.html?swVersion=9.16.0) | The guide's CX x70 Desktop Appliance Specifications appendix includes front/back panel diagrams for CX 570/CX 770 (figures E-1 and E-2, around printed page 87). Use the official guide to identify port labels; verify actual interface mapping and OPNsense drivers on the appliance. [Third-party illustrative photo gallery](https://www.ebay.com/itm/284862930402) may show a different revision/configuration and is not authoritative. |

## Switching and wireless

| Equipment | Official documentation | Notes |
|---|---|---|
| RUCKUS ICX7150-C12P | https://support.ruckuswireless.com/documents?query=Icx7150 | Includes the ICX 7150 Hardware Installation Guide and technical specifications. Verify exact C12P suffix, uplink configuration, PoE budget, software/firmware support, and licensing before deployment. RUCKUS announced end of sale for ICX7150-C12P effective January 15, 2026. |
| RUCKUS ICX7150 Hardware Installation Guide | https://support.ruckuswireless.com/documents/1397-ruckus-icx-7150-switch-hardware-installation-guide | Official installation guide for the ICX7150 family. |
| TP-Link Omada SG2008 (non-PoE) | https://support.omadanetworks.com/us/product/sg2008/ | Select the exact hardware version for installation guide, datasheet, reference guide, and firmware. Planned CSI NIC 2 interconnect switch. |
| TP-Link Omada SG2008P | https://support.omadanetworks.com/us/product/sg2008p/ | Select the exact hardware version. Planned dedicated camera switch. Some revisions specify 4 PoE+ ports and a 62 W budget; confirm the revision owned. |
| TP-Link Omada EAP650 | https://support.omadanetworks.com/us/product/eap650/ | Select the exact hardware version for installation guide, datasheet, and firmware. Confirm PoE requirements for the owned revision. |
| Dell Networking X1018 | [Dell Support](https://www.dell.com/support/home/en-us) | Firmware 3.0.1.9 and boot code 1.0.0.25 verified in the lab on 2026-10-18. Used the Dell X10xx/X4012 CLI upgrade instructions and 3.0.1.9 release notes. Console reported boot and image checks PASS and “CPLD Code match. No need to upgrade. CPLD Version 2.09.” Management IP is currently 203.0.113.1/24; check for conflict before joining the production LAN. See [X1018 upgrade field note](blog/2026-10-18-dell-x1018-firmware-upgrade.md) and [evidence](../attachments/dell-x1018-upgrade-evidence.md). |

## Storage and compute

| Equipment | Official documentation | Notes |
|---|---|---|
| Primary TrueNAS host: Lenovo ThinkCentre M75q Gen 2 Tiny (11JJ007TUS) | [Lenovo PSREF/specifications PDF](https://psref.lenovo.com/syspool/Sys/PDF/ThinkCentre/ThinkCentre_M75q_Gen_2/ThinkCentre_M75q_Gen_2_Spec.pdf) · [Lenovo Guides & Manuals for Type 11JJ](https://pcsupport.lenovo.com/us/en/products/desktops-and-all-in-ones/thinkcentre-m-series-desktops/thinkcentre-m75q-gen-2/11jj/document-userguide/doc_userguide) · [TrueNAS documentation](https://www.truenas.com/docs/) | This is the currently used TrueNAS host. PSREF identifies front USB-A as USB 3.2 Gen 2 (10 Gbps theoretical), front USB-C as USB 3.2 Gen 1 (5 Gbps theoretical), and one rear RJ-45 Gigabit Ethernet port; Thunderbolt is not listed. Confirm the exact installed port configuration. Record the TrueNAS edition/version before choosing a USB NIC; USB Ethernet is not guaranteed to work on every TrueNAS release. |
| Framework Desktop | https://frame.work/support | Search for Framework Desktop documentation and hardware support. Confirm exact model, NICs, and expansion options. |
| Red Queen PC | No single vendor manual identified for the complete custom-built system. | System: ASUS TUF Gaming X570-Plus motherboard, AMD Ryzen 7 2700X, Radeon RX 5700. Motherboard support/manuals: https://www.asus.com/support/ . GPU reference: https://www.amd.com/en/support . Check installed NIC model separately. |

## CSI nodes and PoE splitters

| Equipment | Documentation status | Required verification |
|---|---|---|
| Six CSI nodes | Exact manufacturer/model has not been conclusively identified from the available photos. | The shown power label indicates 12 V DC, 3 A input (36 W rated maximum). Each node has two RJ45 NICs. Obtain exact model/board identifier before using model-specific BIOS documentation. |
| Six PoE-to-DC splitters | Exact splitter models not selected yet. | Must accept IEEE 802.3af/at negotiated PoE input and provide the node's required 12 V DC output, polarity, connector, and sufficient current. Verify splitter efficiency and peak output before deployment. |

## Future planned equipment

| Equipment | Status | Selection requirements |
|---|---|---|
| 2.5 GbE switch with 10 GbE uplink | Planned future purchase; not yet selected. | Confirm 2.5 GbE endpoint NICs, 10 GbE uplink compatibility, management/VLAN requirements, and the RUCKUS SFP+ configuration before buying. |
| Two-bay TrueNAS backup appliance | Planned future improvement; two-bay case has been 3D-printed. | Dedicated backup target with a required two-drive mirror. See [backup TrueNAS proposal](future-improvements/backup-truenas-system.md). |

## Network integration plan

- [Starlink WAN integration and validation plan](starlink-network-integration.md) — proposed Starlink-to-OPNsense-to-RUCKUS path, model-specific handoff checks, and commissioning checklist.

## Deployment reminders

- Record each device's exact model and hardware revision before applying firmware or model-specific settings.
- Download firmware only from the manufacturer's official support page and confirm the hardware revision.
- Keep a local copy of critical manuals and the current configuration backups where licensing and terms permit.
- Do not assume that a splitter, switch port, or endpoint supports a particular PoE standard or link speed without checking the exact specifications.
- The RUCKUS PoE budget and the six CSI nodes plus EAP650 load must be verified. Current planning estimate is about 115 W device-side against a nominal 124 W switch budget, before splitter losses and peak load; this is not yet approved for deployment.
