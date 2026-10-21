# Future 5G WAN Candidate: GL.iNet MUDI 7 (GL-E5800EU)

**Status:** Future contender only; not purchased or validated in this lab.

## Why it is on the shortlist

The EU/international GL-E5800EU variant is a candidate for a portable 5G uplink that can be carried between locations and connected to the lab over wired Ethernet. Its 2.5GbE WAN/LAN port is backward-compatible with the lab's 1GbE Ethernet requirement. The device is battery-powered and supports physical SIM/eSIM options, subject to regional SKU and carrier compatibility.

## Requirements to verify before purchase

- Confirm the exact model is **GL-E5800EU**, not the North American GL-E5800NA variant.
- Confirm supported 5G NR and LTE bands against the intended Philippine carrier and the specific location where it will be used. Band support alone does not guarantee carrier certification, coverage, or service availability.
- Confirm SIM/eSIM activation, carrier APN settings, and any carrier restrictions.
- Verify Ethernet WAN/LAN mode and whether the selected operating mode exposes the cellular connection to OPNsense as an upstream WAN.
- Check current price, warranty, regional firmware, and local availability before buying.

## Planned role in the lab

Potential topology: **5G cellular network → MUDI 7 (GL-E5800EU) → Ethernet → OPNsense WAN/secondary WAN → RUCKUS ICX7150-C12P → lab networks**.

The intended use is portable cellular internet for a backup WAN, travel connectivity, or a future alternative upstream. OPNsense should remain responsible for lab routing, firewall policy, DHCP, and VLAN gateways. Avoid placing the device into the production topology until the exact SKU, carrier compatibility, Ethernet behavior, and failover design are tested.

## Comparison with the low-cost UniFi U5G fleet concept

The [5G WAN shortlist](future-5g-wan-shortlist.md) also evaluates four UniFi 5G Backup U5G-EU units (three fixed plus one movable/field-deployable) against a single MUDI 7. The U5G fleet has a much lower per-unit list price, but needs PoE power, individual cellular eligibility/data plans, RedCap/5G SA support, and a successful OPNsense Ethernet-handoff proof of concept. The MUDI 7 remains the closer match for battery-powered mobility, 2.5GbE, and broad-band travel use.

## Decision status

Keep on the future-candidate list; do not treat as selected, purchased, or tested hardware. Use the [5G WAN shortlist](future-5g-wan-shortlist.md) to compare it against the UniFi U5G fleet. Confirm exact SKU, carrier compatibility, Ethernet behavior, and total cost before buying.

## Manufacturer reference

- [GL.iNet MUDI 7 official product page](https://www.gl-inet.com/en-us/products/gl-e5800/)
