# ICX7150-C12P firmware upgrade and commissioning evidence

**Session date:** 2026-10-17 local lab notes  
**Hardware:** RUCKUS ICX7150-C12-POE / ICX7150-C12P  
**Initial running version:** FastIron 08.0.60T211  
**Final verified running version:** FastIron 08.0.95sT211 (UFI), booted from Primary  
**Final verified boot code:** 10.1.27T225 (mnz10127) in both partitions

## Final status

The switch is operational for the tested home-lab LAN use. Firmware image and boot-code versions are synchronized, Primary boot was verified, three data ports are forwarding at 1 Gbps, OPNsense gateway/internet/DNS tests passed, and the PoE endpoint on port 1/1/3 is drawing power.

One PoE controller reset warning appeared during the final Primary boot. PoE initialization later completed and live readings confirmed the endpoint was powered. The warning has not been diagnosed from post-boot logs in this session, so monitor for recurrence.

## Evidence observed on console

### Intermediate image stage

- show version after the intermediate upgrade showed 08.0.80fT211.
- Boot monitor was 10.1.14T225 (mnz10114).
- Primary and secondary transfers for SPS08080f.bin both completed with TFTP to Flash Done and 26,214,400 bytes written: OK.
- The mnz10114.bin transfer completed with TFTP to Flash Done.

### UFI stage

The switch CLI successfully copied SPS08095sufi.bin to Primary and Secondary. Both attempts printed Bundle image processed successfully.

On the first UFI boot, console output included:
- Firmware Integrity Test: Uboot Checksum Verification: PASS
- Firmware Integrity Test: Image Checksum Verification: PASS
- Kernel identified as Ruckus Linux MN VER=08.0.95s.
- Initial boot warning: Uboot and FastIron came from different partitions, and the other Uboot did not have the recommended version for the active FastIron image.

### Partition synchronization and Primary boot

After booting successfully from Secondary, this command was run:

~~~text
copy flash flash primary
~~~

Observed result:
- Flashing application image to Primary completed.
- Flashing boot ROM image to Primary completed.
- Bundle image processed successfully.
- Copy Done.

Subsequent show flash output reported:
- Compressed Primary Code: 08.0.95sT211 (SPS08095s.bin)
- Compressed Secondary Code: 08.0.95sT211 (SPS08095s.bin)
- Compressed Primary Boot Code: 10.1.27T225 (mnz10127)
- Compressed Secondary Boot Code: 10.1.27T225 (mnz10127)

Then Primary was explicitly booted:

~~~text
boot system flash primary yes
~~~

Captured boot output reported Booted from partition 1, Uboot checksum verification PASS, and image checksum verification PASS. Subsequent show version showed SPS08095s.bin (UFI) from Primary, version 08.0.95sT211, and primary boot code 10.1.27T225. Subsequent show flash continued to show the matched values.

### Data-plane links and OPNsense

Post-Primary show interfaces brief displayed:
- 1/1/1: Up, Forward, Full duplex, 1G
- 1/1/2: Up, Forward, Full duplex, 1G
- 1/1/3: Up, Forward, Full duplex, 1G
- mgmt1: Down in that final status capture

The Windows adapter 1gb Network received:
- IPv4: 198.51.100.124
- Mask: 255.255.255.0
- Gateway: 198.51.100.1
- DHCP server: 198.51.100.1
- DNS server: 198.51.100.1

Tests explicitly sourced from 198.51.100.124:
- Ping 198.51.100.1: 4/4 replies, 0% loss.
- Ping 1.1.1.1: 4/4 replies, 0% loss; 27-57 ms RTT, average 40 ms.
- Resolve-DnsName example.com -Server 198.51.100.1 returned A and AAAA records.

Earlier, 1/1/1 was connected to the OPNsense LAN uplink and 1/1/2 to the Windows test client. 1/1/3 had the PoE endpoint attached.

### Management reachability

During isolated recovery, Windows used 192.0.2.2/24. The switch management address was set using interface management 1 and IP 192.0.2.3/24. show interfaces management 1 reported the GigEthernet management interface up and line protocol up at that point. Windows ping to 192.0.2.3 returned 4/4 replies with 0% packet loss. The final post-Primary show interfaces brief later showed mgmt1 Down, so do not infer that the dedicated out-of-band link is currently connected.

### PoE endpoint test

The post-Primary show inline power output reported:
- Total PoE capacity: 124,000 mW (124 W)
- Port 1/1/3 Admin State: On
- Port 1/1/3 Oper State: On
- Power consumed: 6,100 mW (6.1 W)
- Power allocated: 30,000 mW (30 W)
- PD Type: 2P-IEEE
- PD Class: Class 4
- Total free capacity: 94,000 mW (94 W)

The endpoint was powered after Primary boot. This verifies current PoE delivery, but does not by itself establish long-term controller health.

### PoE controller warning

During the Primary reboot, the console printed: PoE Severe Error: Unexpected controller reset encountered on PoE module. Later boot output reported PoE module initialization complete and power enabled on port 1/1/3. The live PoE status then showed Oper State On and 6.1 W consumption. A post-boot show logging capture was not saved, so the warning persistence and root cause remain unverified. Monitor for recurrence; capture show logging and show inline power detail if it returns or the endpoint loses power.

## Configuration and credential notes

- Target architecture remains Layer 2 switching with PoE. OPNsense remains responsible for routing, firewall, DHCP, DNS and future VLAN gateways.
- User VLAN segmentation was not implemented.
- Credentials and passwords are deliberately omitted.
- Firmware binaries are deliberately not stored in this repository.

## Vendor references

- https://support.ruckuswireless.com/products/108-ruckus-icx-7150-campus-switches
- https://support.ruckuswireless.com/articles/000015158
- https://support.ruckuswireless.com/documents/1402-fastiron-08-0-60-software-upgrade-guide
- https://support.ruckuswireless.com/documents/1417-fastiron-08-0-60-command-reference-guide
