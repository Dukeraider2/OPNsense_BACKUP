# Dell Networking X1018 firmware upgrade evidence

**Session:** 2026-10-18  
**Model:** Dell Networking X1018  
**Firmware before:** 3.0.0.64  
**Boot code before:** 1.0.0.14  
**Firmware after:** 3.0.1.9  
**Boot code after:** 1.0.0.25  
**Hardware version:** 00.00.02

## Console and transfer evidence

Windows detected the rear USB console as USB Serial Port COM5. Login reached the Dell console# prompt.

Dell management interface before and after update:
- VLAN: 1
- IP address: 203.0.113.1/24
- Interface status: UP/UP

PC isolated transfer adapter:
- Adapter: 2.5gb Network
- IP address: 203.0.113.2/24
- Adapter link rate reported by Windows: 1 Gbps

Windows command ping.exe -n 4 203.0.113.1 after upgrade returned 4 replies, 0% loss, average 2 ms.

Files transferred via TFTP:
- x10xx-3019.ros: 11,506,394 bytes copied in 00:03:18.
- x10xx_boot-10025.rfb: 524,304 bytes copied in 00:00:09.

Before reload, show bootvar showed:
- image-1: 3.0.0.64, Active.
- image-2: 3.0.1.9, Not active*, selected for next boot.

After reload, show version reported:
- SW version 3.0.1.9.
- Boot version 1.0.0.25.
- HW version 00.00.02.

After reload, show bootvar showed:
- image-1: 3.0.0.64, Not active.
- image-2: 3.0.1.9, Active*.

## Boot/CPLD checks

The console reported:
- Boot1 Checksum Test: PASS.
- Boot2 Checksum Test: PASS.
- Flash Image Validation Test: PASS.
- Updating CPLD firmware version: PASS.
- CPLD Code match. No need to upgrade. CPLD Version 2.09.
- Startup initialization completed and the console# prompt returned.

## Link-state evidence

show interfaces status after update showed:
- gi1/0/16: Full duplex, speed 1000 Mbps, negotiation enabled, link Up.
- gi1/0/1 through gi1/0/15: Down in the captured output.
- gi1/0/17 and gi1/0/18 (fiber/SFP): Down in the captured output.

## Limitations / next validation

- No separate configuration backup was taken before the upgrade, by operator choice.
- The Dell-to-RUCKUS uplink was not connected or tested in the captured session.
- No VLAN trunking or end-to-end client test through both switches has been claimed.
- Current management IP 203.0.113.1/24 should be checked for address conflict before connecting the Dell into the production LAN.
- Dell documents a 10–15 minute CPLD-update window for applicable upgrades; this session's console showed CPLD update PASS and then indicated no CPLD update was needed at version 2.09.

## Vendor docs

- Dell X1000/X4012 release notes, firmware 3.0.1.9.
- Dell X10xx/X4012 CLI software upgrade instructions.
- Dell X1000/X4000 Series User Guide.
