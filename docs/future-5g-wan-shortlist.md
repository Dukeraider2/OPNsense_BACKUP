# Future 5G WAN Shortlist

**Status:** Research and compatibility stage; no device selected or purchased.  
**Architecture context:** The home lab uses OPNsense for routing/firewalling, a RUCKUS ICX7150-C12P core switch, and an Omada EAP650. Do not count any candidate as OPNsense-compatible until its Ethernet handoff and required management workflow have been tested.

## Summary

The current idea is to compare one flexible, battery-powered travel router with a low-cost multi-unit cellular strategy:

- **Fleet concept:** one movable/field-deployable unit plus three fixed units.
- **Important wording:** the U5G is *movable* but not battery-powered; it requires PoE. Portable deployment needs a suitable PoE source.
- **Financial hypothesis:** the current UK list price for U5G is £79 each, so four are £316 hardware-only; GL.iNet currently lists the MUDI 7 at US$419.99. The figures are different currencies and exclude different potential fees; regard them as broadly comparable sticker-price tiers, not an exact checkout comparison.

## Candidate comparison

| Attribute | UniFi 5G Backup U5G-EU | GL.iNet MUDI 7 GL-E5800EU |
|---|---|---|
| Current observed hardware price | £79 each in Ubiquiti UK store; four = £316 | US$419.99 listed by GL.iNet |
| Multi-unit strategy | Strong value if a four-node deployment works with the final gateway/carrier design | One premium travel device at roughly the same broad sticker-price tier as four U5G units |
| Ethernet | 1 GbE RJ45 | 2.5 GbE WAN/LAN |
| Power / mobility | PoE input; no built-in battery. Movable only with PoE power available | Built-in battery; designed for travel |
| Cellular category | 5G RedCap + LTE | 5G NR NSA/SA, Sub-6 GHz |
| 5G bands relevant to PH | EU/EMEA band list reported to include n28/n41/n78; verify exact SKU against manufacturer docs | Official EU list includes n28/n41/n78 |
| LTE fallback | Verify the exact EU/EMEA SKU's LTE bands before purchase | Official EU list includes LTE B1/B3/B8/B28, among others |
| SIM | Nano-SIM + eSIM | Dual nano-SIM + eSIM support |
| Vendor setup model | UniFi Network adoption; primary-WAN use is documented with a UniFi gateway | Travel-router interface; verify the selected WAN mode and upstream behavior |
| OPNsense confidence | **Unverified / key purchase gate** | More natural candidate for a generic Ethernet uplink, but still test before deployment |
| Best role | Economical fixed cellular backup / fleet of endpoints if carrier and controller constraints are solved | Portable 5G internet, travel, or cellular WAN where battery and broad regional bands matter |

## Candidate 1: UniFi 5G Backup U5G-EU

[Open the full candidate evaluation](future-5g-wan-candidate-unifi-u5g-eu.md)

**Why it is compelling:** Low list price per endpoint, 1 GbE, small size, flexible mounting, PoE power, nano-SIM + eSIM, and a proposed three-fixed-plus-one-movable deployment.

**Hard caveats:**
- U5G is 5G RedCap, not a conventional full-performance 5G router. Ubiquiti says 5G service requires carrier-specific 5G SA and RedCap subscription support; otherwise it falls back to LTE.
- It has no battery. A field-deployable unit still requires PoE power and an Ethernet cable.
- Ubiquiti's official workflows require UniFi Network adoption and document connection to a UniFi gateway. Third-party gateway support is not documented; an independent review also lists lack of third-party router support. Treat U5G as **on compatibility hold for OPNsense** unless Ubiquiti confirms otherwise or one unit passes a proof-of-concept.
- Four units may mean four SIM/data plans and four PoE drops. The four-device hardware price is not the whole operating cost.
- Philippine RedCap availability must be checked with the exact operator and plan. DITO announced a RedCap home Wi-Fi service, but that does not guarantee that a third-party U5G can be provisioned.

**Recommended next step:** Before considering a four-unit purchase, obtain written confirmation from Ubiquiti about third-party gateway use with OPNsense. If unclear, test one borrowed/returnable unit. If it requires UniFi gateway adoption, include that gateway and its cost in the design.

Official links: [Ubiquiti UK store](https://uk.store.ui.com/uk/en/products/u5g) · [Ubiquiti tech specs](https://techspecs.ui.com/unifi/integrations/u5g-us) · [Ubiquiti WAN/backup guide](https://help.ui.com/hc/en-us/articles/29887153953559-UniFi-5G-and-LTE-Backup-Best-Practices).

## Candidate 2: GL.iNet MUDI 7 GL-E5800EU

[Open the full candidate evaluation](future-5g-wan-candidate-mudi-7-gl-e5800eu.md)

**Why it is compelling:** Built-in battery, 2.5 GbE, dual nano-SIM + eSIM, and a wider range of 5G/LTE bands on the EU model. It is closer to the original requirement for a single mobile device with Ethernet.

**Hard caveats:**
- Confirm the exact EU SKU; do not substitute the North American model.
- Confirm carrier/APN and SIM/eSIM support in each planned country.
- Check live price, shipping, tax/duties, and warranty at purchase time.

Official link: [GL.iNet MUDI 7 product page](https://www.gl-inet.com/en-us/products/gl-e5800/).

## Proposed deployment model

If the U5G proof-of-concept passes:

- **1 movable endpoint:** short-duration test, travel/site survey, or temporary backup placement. It still needs a PoE injector/supply or PoE-capable power arrangement.
- **3 fixed endpoints:** planned locations where wired Ethernet and PoE power are available.
- **Gateway integration:** decide whether the units connect to separate sites, a UniFi-managed network, or OPNsense. Multiple physical cellular units do not automatically create usable independent WANs in OPNsense.
- **Cost accounting:** hardware + per-unit SIM/eSIM plans + data allocations + PoE hardware/power + tax/shipping/duties + backup data usage.

## Go/no-go checklist

- [ ] Exact EU/EMEA model and LTE/5G bands verified from a manufacturer document.
- [ ] Carrier confirms device/SIM/plan provisioning; 5G SA + RedCap requirement understood.
- [ ] A real SIM connects successfully in the intended location; record band and speed.
- [ ] One U5G can provide usable upstream Ethernet connectivity to OPNsense, or the plan explicitly includes a UniFi gateway.
- [ ] PoE output, switch budget, and portable power plan are confirmed.
- [ ] Compare actual all-in cost for four U5G devices against one MUDI 7.
- [ ] Only then decide whether to buy one for a pilot or proceed with more units.

## Sources and price snapshot

- [Ubiquiti UK store: U5G, £79 listed](https://uk.store.ui.com/uk/en/products/u5g)
- [Ubiquiti U5G technical specifications (the page defaults to North America; verify the EU SKU separately)](https://techspecs.ui.com/unifi/integrations/u5g-us)
- [Ubiquiti 5G/LTE Backup Best Practices](https://help.ui.com/hc/en-us/articles/29887153953559-UniFi-5G-and-LTE-Backup-Best-Practices)
- [Ubiquiti Community discussion of the EU/EMEA U5G band's list](https://community.ui.com/releases/b8c2c086-2bfd-4ff7-b7ac-960f4134739c?replyId=55a4addd-e5a1-4a86-8244-bfbcc88e8822)
- [DITO's 2024 RedCap home Wi-Fi announcement](https://dito.ph/news/dito-launches-new-dito-home-wowfi-the-worlds-first-5g-redcap-wifi-for-home)
- [GL.iNet MUDI 7: US$419.99 list price and official EU/NA band comparison](https://www.gl-inet.com/en-us/products/gl-e5800/)

**Price note:** These prices were observed during planning on 2026-10-18. They may change. UK and US prices are in different currencies; do not infer a final saving without comparing same-day delivered totals in the same currency and including data-plan and power costs.
