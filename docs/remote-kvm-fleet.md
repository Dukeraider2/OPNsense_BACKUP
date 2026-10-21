# Remote KVM Fleet

**Status:** Planned / commissioning details pending  
**Quantity:** Four GL.iNet Comet GL-RM1 remote KVM units  
**Model reference:** [Official GL-RM1 user guide](https://docs.gl-inet.com/kvm/en/user_guide/gl-rm1/) · [Official product page](https://store.gl-inet.com/products/comet-gl-rm1-remote-keyboard-video-mouse)  
**Purpose:** Out-of-band console access to lab systems for remote troubleshooting, BIOS/UEFI configuration, OS recovery, and remote installation.

## Confirmed GL-RM1 capabilities

The GL-RM1 Comet has:
- One 10/100/1000 Mbps Ethernet port for network access.
- One HDMI input for capturing the target computer's video.
- USB 2.0 connections for keyboard/mouse emulation and extension/accessory use.
- USB-C power input, rated 5 V / 2 A.
- Up to 4K at 30 frames per second video capture.
- Remote keyboard/video/mouse control, clipboard, and file-transfer features.
- **No built-in Wi-Fi.** The GL-RM1 must connect to the network over Ethernet; it is not a wireless KVM.
- Remote power options such as Wake-on-LAN, or separately purchased compatible accessories (ATX board/Fingerbot). The KVM alone does not guarantee electrical power cycling for every target.

See the [official datasheet](https://static.gl-inet.com/www/images/products/datasheet/rm1_datasheet_20250320.pdf) and [official FAQ](https://docs.gl-inet.com/kvm/en/faq/power_on_off_control/). Confirm hardware revision and current documentation for each unit.

## Intended role in the lab

Four GL-RM1 devices are intended to provide remote console access to selected lab computers or appliances. Exact targets, management IPs, switch ports, USB/video cabling, and power arrangements must be recorded before marking the fleet commissioned.

### Proposed placement

| Unit | Model | Intended target | Network connection | Power | Status |
|---|---|---|---|---|---|
| Remote KVM 1 | GL-RM1 | TBD | 1 GbE Ethernet; switch/port TBD | USB-C, 5 V / 2 A | Planned |
| Remote KVM 2 | GL-RM1 | TBD | 1 GbE Ethernet; switch/port TBD | USB-C, 5 V / 2 A | Planned |
| Remote KVM 3 | GL-RM1 | TBD | 1 GbE Ethernet; switch/port TBD | USB-C, 5 V / 2 A | Planned |
| Remote KVM 4 | GL-RM1 | TBD | 1 GbE Ethernet; switch/port TBD | USB-C, 5 V / 2 A | Planned |

## Physical connections

For each target system, document:
- HDMI from target video output to the GL-RM1 HDMI-IN.
- USB device/control connection between GL-RM1 and target, according to the GL.iNet guide.
- GL-RM1 Ethernet port to a switch port on the chosen management network.
- USB-C power supply to the KVM.
- Optional Wake-on-LAN configuration or a separately purchased compatible power-control accessory if actual power-on/off is required.

The GL-RM1 does not support Wi-Fi. Use the wired Ethernet interface for network access. Its 1 GbE interface fits the lab's Gigabit access layer; it does not need a 10 GbE uplink.

## Network and security recommendations

- Put KVM management interfaces on a dedicated management VLAN when the VLAN design is ready. Until then, limit access to trusted admin devices and do not expose KVM web interfaces directly to the public internet.
- Reserve management IP addresses in OPNsense DHCP after the management subnet/VLAN is selected. Record device labels and MAC addresses in the private port map, not in public-facing documentation.
- Use unique administrator credentials, current supported firmware, and encrypted remote access. Disable unused services and avoid port forwarding directly to KVM management pages.
- Remote access options documented by GL.iNet include LAN browser access and supported remote methods such as Tailscale, ZeroTier, NetBird, or GLKVM cloud service. Choose and document the lab's preferred method; no method is assumed configured.
- Test console access with the target at BIOS/UEFI, during OS boot, and after normal login. Confirm target video output and USB control are stable.
- Treat remote console access and physical power control as separate capabilities.

## Commissioning checklist

- [ ] Record the unit label and hardware revision for each GL-RM1.
- [ ] Identify the target host each unit controls.
- [ ] Record HDMI, USB, Ethernet, and USB-C power connections.
- [ ] Record each management MAC/IP, switch and port, and VLAN.
- [ ] Update firmware using the official model-specific instructions.
- [ ] Verify access from the admin workstation and confirm untrusted networks cannot reach the management interface.
- [ ] Test BIOS/UEFI access, boot recovery, keyboard/mouse input, file transfer, and console stability.
- [ ] Verify power-loss recovery and whether Wake-on-LAN or a separate power-control accessory is supported by the target.
- [ ] Add confirmed port/interface details to the physical network port map.

## Inventory fields to complete

For each unit, record: unit label, GL-RM1 hardware revision, serial/asset identifier (keep private if repository becomes public), firmware, target host, host HDMI/USB ports, management MAC/IP, switch and port, VLAN, power source, remote-access method, and test result.
