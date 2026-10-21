# Starlink Integration into the Home-Lab Network

**Status:** Proposed topology; validate the actual Starlink kit and cabling before changing production connections.  
**Last updated:** 2026-10-19

## Objective

Integrate Starlink as the WAN source while keeping the Riverbed SteelHead CX-770 running OPNsense as the network's firewall/router and the RUCKUS ICX7150-C12P as the core PoE/access switch.

## Proposed logical topology

```text
Starlink dish / terminal
        |
        | Starlink-supplied cable and power equipment
        v
Starlink Ethernet handoff
(router Ethernet port, power supply Ethernet, or model-specific adapter)
        |
        | Ethernet WAN cable
        v
Riverbed SteelHead CX-770 running OPNsense
  - WAN: DHCP client from Starlink
  - LAN/trunk: private home-lab network
        |
        | LAN Ethernet / VLAN trunk as designed
        v
RUCKUS ICX7150-C12P core switch
        |
        +---- Dell PowerConnect X1018 ---- in-wall LAN drops
        |
        +---- TP-Link Omada SG2008 ---- dedicated CSI node NIC 2 network
        |
        +---- TP-Link Omada SG2008P ---- camera network
        |
        +---- Omada EAP650 access point
        |
        +---- TrueNAS / Framework Desktop / Red Queen PC / CSI NIC 1
```

This is a logical design, not a confirmation that every listed link or VLAN is currently commissioned. The WAN must connect to the physical port identified as WAN in the CX-770/OPNsense interface map. The LAN-side switch connection must use the intended OPNsense LAN interface or configured VLAN trunk.

## Important: identify the Starlink generation first

Starlink's Ethernet handoff depends on the kit:

- **Standard Actuated / commonly called Gen 2:** Usually requires the official Starlink Ethernet Adapter between the router and OPNsense. If OPNsense is to be the main router, Starlink says bypass mode is required for this kit.
- **Starlink Standard / commonly called Gen 3:** Built-in Ethernet is available on the router; connect a LAN Ethernet port to the OPNsense WAN. Use bypass mode if OPNsense should own routing and Starlink Wi-Fi is not needed.
- **Performance kits:** The external power supply generally provides native Ethernet; exact generation-specific guidance applies.
- **Starlink Mini:** Ethernet can be provided with the model-compatible USB-C Ethernet adapter/cable. Confirm the exact accessory and weatherproofing instructions.
- **Original Gen 1:** The original terminal/router setup differs; follow the instructions for that exact kit rather than assuming modern bypass-mode behavior.

References:
- [Starlink: Can I use my own router?](https://starlink.com/fm/support/article/0b372c01-c692-8920-8396-ffb7f429aab1)
- [Starlink: What is bypass mode?](https://starlink.com/tv/support/article/a0fe8d51-32f7-d2b9-d74a-801e31ad9f6a)

## OPNsense WAN configuration

1. Identify the actual physical NIC and port mapped to WAN. Do not infer it from chassis location alone.
2. Configure WAN IPv4 as DHCP unless the exact Starlink setup or an existing validated configuration requires otherwise.
3. Do not connect Starlink Ethernet to the RUCKUS LAN first if the intended design is Starlink -> OPNsense -> LAN. That could bypass the firewall or introduce an unintended second DHCP/routing path.
4. Connect the Starlink Ethernet handoff directly to the CX-770's designated OPNsense WAN interface.
5. After link is up, inspect OPNsense interface status and DHCP lease; test a public IP such as 1.1.1.1 and then DNS resolution. A ping failure alone is not conclusive if the target filters ICMP.
6. Keep the OPNsense LAN subnet separate from any management subnet used by Starlink's app or diagnostics.
7. Avoid enabling multiple DHCP servers on the same LAN broadcast domain.

## Bypass mode and double NAT

If Starlink's router remains in normal router mode while OPNsense also performs NAT, the network may use double NAT. It can still provide internet access, but may complicate inbound connections, VPNs, gaming, port forwarding, and troubleshooting. Bypass mode disables Starlink router Wi-Fi/routing features on supported kits and gives OPNsense the primary routing role. It may be reversed only through the model-specific process; Starlink says factory reset is required to exit bypass on some current router models. Confirm before enabling.

Starlink uses carrier-grade NAT in many service configurations, so bypass mode does not itself guarantee a publicly reachable IPv4 address or inbound port forwarding. Verify the service plan and WAN address if inbound access is a requirement.

## Core switch and uplink considerations

- The ICX7150-C12P's twelve access ports are 1GbE. The model has two SFP/SFP+ uplinks that may support 10GbE with the appropriate supported configuration/license and compatible optic or DAC. Verify actual interface status and SKU before assuming 10GbE.
- The RUCKUS is not the router in this design; OPNsense owns routing, DHCP, NAT, and firewall policy.
- Connect downstream switches to the RUCKUS on intended access ports or VLAN trunks, according to the final VLAN plan.
- A 10GbE RUCKUS uplink to a future multi-gig switch can support high-speed transfers between devices connected to that multi-gig switch. A TrueNAS client path still falls back to the slowest link in the path.
- Keep the dedicated CSI NIC 2 interconnect isolated on the Omada SG2008 as planned; do not accidentally bridge it into the general LAN.
- Keep the SG2008P camera network's intended segmentation clear. VLAN isolation requires consistent configuration on the camera switch, RUCKUS, and OPNsense.

## Validation checklist

Record date/time, physical port labels, link state, negotiated speed, IP address, gateway, and test result.

### Physical layer
- [ ] Record Starlink dish/terminal and router model or generation.
- [ ] Confirm whether an Ethernet adapter is required and installed.
- [ ] Verify cable path from Starlink handoff to the designated CX-770 WAN port.
- [ ] Confirm link lights and negotiated speed on both ends.
- [ ] Verify the exact CX-770 NIC-to-OPNsense interface mapping.

### WAN and firewall
- [ ] OPNsense WAN receives a DHCP address and gateway.
- [ ] OPNsense shows the WAN gateway as online.
- [ ] Test public IP connectivity.
- [ ] Test DNS resolution.
- [ ] Confirm a LAN client obtains an address from the intended OPNsense DHCP scope.
- [ ] Confirm the LAN client reaches the internet through OPNsense.
- [ ] Confirm no unintended Starlink DHCP server is reachable on the internal LAN.
- [ ] Save a fresh OPNsense configuration backup after a verified working state.

### Switches and segmentation
- [ ] Verify the CX-770-to-RUCKUS LAN link and intended speed.
- [ ] Verify RUCKUS-to-Dell X1018 uplink and in-wall LAN path.
- [ ] Verify RUCKUS-to-Omada AP connectivity and PoE requirements.
- [ ] Validate VLAN IDs, tagged/untagged membership, and trunk configuration end-to-end before enabling segmentation.
- [ ] Verify camera network and CSI NIC 2 network remain isolated as intended.
- [ ] Measure throughput separately from negotiated PHY link rate.

## Known unknowns to resolve

- Exact Starlink kit, router generation, and Ethernet handoff accessory.
- Exact CX-770 physical NIC and OPNsense interface mapping.
- Whether bypass mode is currently enabled.
- Current OPNsense WAN addressing and whether CGNAT is present.
- Final VLAN IDs, subnets, trunk ports, and DHCP scopes.
- Actual RUCKUS SFP+ license/configuration and uplink speed.

## Engineering note

Treat this page as a proposed design until the validation checklist is completed. Do not label Starlink-to-OPNsense connectivity or downstream VLAN behavior as verified based solely on the topology diagram.
