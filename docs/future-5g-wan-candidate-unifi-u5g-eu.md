# Future 5G WAN Candidate: UniFi 5G Backup (UK/EU U5G)

**Status:** Strong low-cost fleet candidate; not purchased or tested in this lab.  
**Proposed allocation:** Three fixed placements plus one movable/field-deployable unit, subject to OPNsense and carrier qualification.  
**Current UK store listing observed:** £79 per unit; four units = £316 hardware subtotal before data plans, taxes, shipping, power accessories, or other costs.

## Why it is a strong contender

The U5G is a compact cellular device with a 1 GbE RJ45 interface, nano-SIM plus eSIM, and PoE input. Ubiquiti's UK store lists the EU-store product at £79. At that list price, four units cost £316 before operating costs. This makes a four-location/three-fixed-plus-one-movable concept worth evaluating against a single GL.iNet MUDI 7, which GL.iNet currently lists at US$419.99. Prices are in different currencies and may include different taxes or shipping; compare actual checkout totals before purchase.

- [Ubiquiti UK store product page](https://uk.store.ui.com/uk/en/products/u5g)
- [Ubiquiti technical specifications](https://techspecs.ui.com/unifi/integrations/u5g-us)
- [Ubiquiti 5G/LTE backup deployment guide](https://help.ui.com/hc/en-us/articles/29887153953559-UniFi-5G-and-LTE-Backup-Best-Practices)
- [GL.iNet MUDI 7 official product page](https://www.gl-inet.com/en-us/products/gl-e5800/)
- [Compare candidates in the 5G WAN shortlist](future-5g-wan-shortlist.md)

## Proposed deployment concept

- **Unit 1: movable/field-deployable.** Can be relocated between sites or test locations, but it is not battery-powered. It requires PoE and Ethernet cabling, so portable use needs an appropriate PoE source/power arrangement.
- **Units 2–4: fixed placements.** Three PoE-powered units at selected fixed locations or as WAN/backup links where the network architecture supports them.
- Each unit needs a compatible SIM/eSIM profile, an eligible cellular plan, coverage, and data budgeting. Do not assume one data subscription can serve all four devices.
- Four devices do not automatically create four independent WAN paths on a single OPNsense installation. The WAN design, routing, controller/adoption model and actual placement must be planned.

## Critical technology distinction: 5G RedCap

U5G is a **5G RedCap** device, not a conventional high-end 5G NR hotspot. Ubiquiti's product page says 5G use requires carrier-specific 5G Standalone (SA) and RedCap subscription support; otherwise it uses LTE fallback. Its North American technical sheet lists peak 5G SA speeds of 220 Mbps down / 120 Mbps up. These are vendor peak specifications, not a throughput promise for the EU device or any specific carrier.

This limitation may be acceptable for a low-cost backup or fixed telemetry/management connection. It may not be suitable when a high-throughput primary link is required.

## Philippine band and carrier checks

The EU/EMEA U5G variant is reported in Ubiquiti Community discussion as supporting 5G bands **n1, n3, n5, n7, n8, n20, n26, n28, n40, n41, n77 and n78**. This includes Philippine-relevant n28/n41/n78. The public Ubiquiti tech-spec page defaults to the North American SKU, whose published band list differs; do not use the North American model spec to approve the EU purchase.

- [Ubiquiti Community discussion citing the EU/EMEA band list](https://community.ui.com/releases/b8c2c086-2bfd-4ff7-b7ac-960f4134739c?replyId=55a4addd-e5a1-4a86-8244-bfbcc88e8822)
- [DITO announcement of a 5G RedCap home Wi-Fi product](https://dito.ph/news/dito-launches-new-dito-home-wowfi-the-worlds-first-5g-redcap-wifi-for-home)

DITO announced a RedCap-based home Wi-Fi service in the Philippines in 2024, which is an encouraging indicator that RedCap exists in-market. It does **not** prove that a U5G device is approved for DITO, that the same plan is available to customer-provided hardware, or that a particular SIM/eSIM will provision successfully. Confirm operator approval, SA/RedCap plan eligibility, APN, IMEI policy, exact local coverage, and the specific EU model before buying. Also verify LTE fallback bands from the exact EU SKU's official datasheet; 5G band support alone is not enough to approve the device for Philippine service.

## Critical non-UniFi system compatibility finding

**For the current OPNsense-based lab, treat the UniFi 5G Backup as unsupported unless Ubiquiti explicitly confirms otherwise or a one-unit proof-of-concept succeeds.**

Ubiquiti's official [5G/LTE Backup Best Practices](https://help.ui.com/hc/en-us/articles/29887153953559-UniFi-5G-and-LTE-Backup-Best-Practices) documents two workflows:
- **LAN-connected cellular backup:** connect the U5G to a PoE LAN port/switch and adopt it in the UniFi Network application; the design uses a GRE tunnel over the LAN.
- **Primary WAN:** connect it to WAN1/WAN2 on a UniFi gateway, power it with PoE, and adopt it through UniFi Network.

Those instructions are built around a **UniFi gateway and UniFi Network management**, not a generic router such as OPNsense. Ubiquiti's official documentation does not provide a standalone web UI or a documented third-party gateway workflow for the U5G. An [independent review](https://dongknows.com/ubiquiti-u5g-unifi-5g-backup-review/) also lists lack of third-party router support as a limitation.

The device has an Ethernet port, but that does **not** prove it can be used like a generic standalone 5G modem. Do not assume that plugging its Ethernet port into the OPNsense WAN will produce a working DHCP/IP handoff. Provisioning, data access, WAN handoff, and ongoing management may depend on UniFi adoption/configuration.

Official references:
- [UniFi 5G and LTE Backup Best Practices](https://help.ui.com/hc/en-us/articles/29887153953559-UniFi-5G-and-LTE-Backup-Best-Practices)
- [U5G technical specifications and app requirement](https://techspecs.ui.com/unifi/integrations/u5g-us)
- [Independent review: UniFi 5G Backup](https://dongknows.com/ubiquiti-u5g-unifi-5g-backup-review/)

## What this means for the four-unit idea

The hardware-price comparison looks compelling, but **the four-unit fleet concept is not yet a viable OPNsense deployment plan**. Before committing money, one of these must be true:
1. Ubiquiti confirms in writing that the exact EU U5G can operate with a third-party gateway such as OPNsense, including the required adoption/provisioning workflow and supported Ethernet handoff; or
2. The network architecture includes a compatible UniFi gateway and controller setup, with the added cost and management trade-off explicitly accepted.

If neither is viable, keep the U5G as a good-value *UniFi* cellular accessory, but not a direct OPNsense WAN modem. The four-device price should not outweigh a platform restriction that prevents deployment.

## Requirements before purchase

1. Confirm the exact **EU/EMEA SKU**, and verify the exact 5G and LTE band list from the seller/manufacturer documentation.
2. Get written confirmation of carrier/SIM/plan compatibility for the intended country and provider, including RedCap + 5G SA eligibility or expected LTE fallback.
3. **Resolve OPNsense/third-party gateway support first.** Obtain written Ubiquiti confirmation or test one borrowed/returnable unit before buying more.
4. Budget for PoE power at each site; the movable unit also needs a practical powered field setup. The U5G has no built-in battery.
5. Compare the same-day, same-currency checkout costs including four SIM plans, data, power accessories, shipping, taxes, and duties.
6. Test one unit at a real intended location before purchasing the remaining three.

## Decision status

Keep as a **strong cost-per-unit contender in UniFi environments**, but place it on **compatibility hold for OPNsense**. Not a confirmed replacement for the MUDI 7. The MUDI 7 is the better fit for battery-powered travel, multi-carrier SIM/eSIM flexibility, 2.5 GbE, and a generic travel-router role. U5G offers a much lower listed per-device hardware price and neat PoE deployment, but RedCap throughput, carrier provisioning, and UniFi-oriented management are important trade-offs.
