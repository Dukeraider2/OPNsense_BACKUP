# TrueNAS USB 2.5GbE Adapter Candidates

**Status:** Research shortlist — not purchased or tested on this TrueNAS system.  
**TrueNAS host:** Lenovo ThinkCentre M75q Gen 2 Tiny, machine type/model **11JJ007TUS**. This is the unit currently running TrueNAS, not the planned two-bay backup appliance.  
**Goal:** Add a 2.5GbE interface over USB as a low-cost experiment, while keeping the onboard 1GbE interface available.

## Host-specific hardware facts and manuals

- **Rear LAN:** one onboard RJ-45 Gigabit Ethernet port (1GbE).
- **Front USB-A:** USB 3.2 Gen 2, up to 10 Gbps theoretical USB link; preferred port for a USB 2.5GbE adapter.
- **Front USB-C:** USB 3.2 Gen 1, up to 5 Gbps theoretical USB link; it is not listed as Thunderbolt.
- **Expansion:** Tiny 1L chassis; no practical standard PCIe NIC expansion path for this build.
- **Official Lenovo PSREF specifications:** https://psref.lenovo.com/syspool/Sys/PDF/ThinkCentre/ThinkCentre_M75q_Gen_2/ThinkCentre_M75q_Gen_2_Spec.pdf
- **Official Lenovo Type 11JJ guides and manuals:** https://pcsupport.lenovo.com/us/en/products/desktops-and-all-in-ones/thinkcentre-m-series-desktops/thinkcentre-m75q-gen-2/11jj/document-userguide/doc_userguide
- **Official TrueNAS documentation:** https://www.truenas.com/docs/ (select the installed edition and release).

These specifications are platform-level references; confirm the physical port configuration on the actual unit. The installed TrueNAS edition and version remain unknown and must be recorded before purchase.

## Important TrueNAS caveat

USB Ethernet adapters are not the preferred design for a storage appliance. TrueNAS community guidance notes that USB NICs can be awkward because interface names may change or persist unexpectedly, and adapter support depends on the exact TrueNAS edition and release. Before purchasing, identify the installed release (SCALE or CORE) and confirm the chipset/driver is supported. Treat every candidate below as **unverified on this NAS**.

A 2.5GbE adapter only helps if the NAS's peer device and every switch/uplink on the transfer path also support 2.5GbE. Otherwise, the connection negotiates down to the highest shared rate. USB 3.x bandwidth is sufficient for a 2.5GbE link in principle.

## Candidates to review

| Priority | Candidate | Chipset / host connection | Current price indication | Why consider it | Caveats |
|---|---|---|---:|---|---|
| 1 | [Plugable USBC-E2500](https://plugable.com/products/usbc-e2500/) | Realtek RTL8156B; USB-A and USB-C compatible | **$24.95 USD** on Plugable's site when researched (Oct. 19, 2026) | Established vendor support; vendor lists Linux compatibility and USB-A support, so it can connect to the ThinkCentre's front USB-A port | Linux compatibility listed by the vendor does not guarantee compatibility with this specific TrueNAS release. Confirm adapter chipset and interface behavior after boot. |
| 2 | [StarTech US2GA30](https://www.startech.com/en-fi/networking-io/us2ga30) | Realtek RTL8156; USB-A | Price varies by seller; a US listing was found around **$46.99** | USB-A plug, documented Linux LTS kernel support, established enterprise-oriented vendor | Confirm current US pricing and the exact chipset revision before ordering; still a USB NIC with the same TrueNAS caveat. |
| 3 | [Sabrent NT-UA25](https://sabrent.com/) | USB-A 2.5GbE; listing indicates RTL8156BG | Roughly **$29–$48** depending on retailer/listing | USB-A form factor and a budget alternative | Retail listings vary; verify exact model, chipset, return policy, and TrueNAS compatibility before buying. |

Prices are snapshots from public vendor/retailer listings and can change. They are not endorsements of verified TrueNAS compatibility.

## Recommendation

Start by reviewing **Plugable USBC-E2500** because its vendor page clearly identifies the RTL8156B chipset, lists Linux compatibility, supports USB-A, and publishes a direct price. Do not treat it as plug-and-play on TrueNAS until the exact TrueNAS release is known.

If the NAS is a critical storage service and reliability is more important than experimenting, keep the onboard 1GbE connection rather than making USB networking a required production path.

## Validation checklist before buying / commissioning

- [ ] Record the exact TrueNAS edition and version.
- [ ] Confirm the adapter's exact chipset/revision from the vendor.
- [ ] Confirm support for that chipset in the installed TrueNAS kernel/driver set; avoid assuming generic Linux support equals TrueNAS support.
- [ ] Buy from a seller with a straightforward return policy.
- [ ] Keep onboard 1GbE connected during initial testing.
- [ ] After connection and reboot, verify the new interface is detected and its name remains stable.
- [ ] Verify link negotiation at 2.5Gbps on both ends.
- [ ] Test throughput in both directions with `iperf3` and perform a representative SMB/NFS transfer.
- [ ] Check logs for disconnects, driver errors, or interface renaming after reboot.
- [ ] Do not make the USB interface the only management path until reliability has been demonstrated.

## Research sources

- Lenovo ThinkCentre M75q Gen 2 PSREF: https://psref.lenovo.com/syspool/Sys/PDF/ThinkCentre/ThinkCentre_M75q_Gen_2/ThinkCentre_M75q_Gen_2_Spec.pdf
- Lenovo Type 11JJ Guides & Manuals: https://pcsupport.lenovo.com/us/en/products/desktops-and-all-in-ones/thinkcentre-m-series-desktops/thinkcentre-m75q-gen-2/11jj/document-userguide/doc_userguide
- TrueNAS documentation: https://www.truenas.com/docs/
- Plugable product specifications and price: https://plugable.com/products/usbc-e2500/
- StarTech US2GA30 specifications: https://www.startech.com/en-fi/networking-io/us2ga30
- TrueNAS Community discussion of USB 2.5GbE adapter support and interface-name concerns (Feb. 2026): https://forums.truenas.com/t/are-usb-to-2-5gbaset-ethernet-adapters-supported/63580
- Historical TrueNAS discussion of USB 2.5GbE / RTL8156 behavior: https://www.truenas.com/community/threads/usb-3-1-gen2-2-5gbps-ethernet-adapter.107273/
