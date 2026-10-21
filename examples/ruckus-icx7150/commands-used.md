# ICX7150 field commands: recovery, upgrade, and commissioning record

This file records commands observed or used successfully during this specific ICX7150-C12P upgrade and commissioning. It is a lab record, not a generic flashing script. Confirm hardware, image checksums, release notes, and the applicable RUCKUS procedure before reuse. Keep the serial console attached and never interrupt flash writes.

## Isolated boot-monitor network

PC TFTP server: 192.0.2.2/24 on Windows adapter 1gb Network  
Switch recovery address: 192.0.2.3/24

At the ICX7150 boot-monitor prompt:

~~~text
setenv ipaddr 192.0.2.3
setenv netmask 255.255.255.0
setenv serverip 192.0.2.2
printenv
ping 192.0.2.2
~~~

Observed connectivity result: host 192.0.2.2 is alive.

## Intermediate FastIron 08.0.80f stage

Files in the TFTP root:
- SPS08080f.bin
- mnz10114.bin

Commands used in boot monitor:

~~~text
setenv image_name SPS08080f.bin
saveenv
update_primary
setenv image_name SPS08080f.bin
update_secondary
setenv uboot mnz10114.bin
saveenv
update_uboot
reset
~~~

Observed result: both switch images were written to NAND and boot code mnz10114.bin was copied to flash. After reboot, show version reported 08.0.80fT211.

## Final FastIron 08.0.95s UFI stage

At the normal privileged CLI, with the tested TFTP connection:

~~~text
copy tftp flash 192.0.2.2 SPS08095sufi.bin primary
copy tftp flash 192.0.2.2 SPS08095sufi.bin secondary
reload
~~~

Observed result for both image writes: Bundle image processed successfully. After reboot, console output showed Uboot and image integrity checks passed; show version reported 08.0.95sT211.

## Boot partition synchronization and final Primary boot

The first UFI boot logged a cross-partition Uboot/FastIron warning. The flash inventory showed 08.0.95sT211 in both image partitions, but primary boot code 10.1.14T225 and secondary boot code 10.1.27T225.

The switch was booted from Secondary using:

~~~text
boot system flash secondary yes
~~~

After the Secondary boot completed and the CLI became available, the bundle was synchronized to Primary:

~~~text
copy flash flash primary
~~~

Observed result: application image and boot ROM image were flashed to Primary; Bundle image processed successfully; Copy Done. The subsequent show flash output showed both image entries at 08.0.95sT211 and both boot-code entries at 10.1.27T225.

Primary was then explicitly booted:

~~~text
boot system flash primary yes
~~~

The console reported Booted from partition 1, Uboot checksum verification PASS, and image checksum verification PASS. After login, show version identified the UFI image from Primary. A subsequent show flash confirmed both image and boot-code versions remained matched.

## Commissioning commands used for verification

Run these individually from the switch CLI after logging in:

~~~text
show version
show flash
show interfaces brief
show vlan
show ip address
show inline power
show running-config
write memory
~~~

Observed final results:
- show version: FastIron 08.0.95sT211 from Primary; primary boot code 10.1.27T225.
- show flash: both image entries 08.0.95sT211; both boot-code entries 10.1.27T225.
- show interfaces brief: ports 1/1/1, 1/1/2, 1/1/3 Up / Forward at Full 1G; mgmt1 Down in the final capture.
- show ip address initially showed 0.0.0.0 before setting the isolated recovery management address.
- show inline power: port 1/1/3 Admin On, Oper On, 6,100 mW consumed, 30,000 mW allocated, 2P-IEEE, Class 4; total PoE capacity 124,000 mW, remaining 94,000 mW.
- write memory completed with Write startup-config done and Copy Done before final Primary boot.

## Windows and end-to-end tests

Recovery-address test on Windows:

~~~powershell
ping.exe -n 4 192.0.2.3
~~~

Observed at that stage: 4 replies, 0% loss.

Client adapter received from OPNsense:
- 1gb Network: 198.51.100.124/24
- Gateway, DHCP server, DNS server: 198.51.100.1

End-to-end tests explicitly bound to the client source address:

~~~powershell
ping.exe -S 198.51.100.124 -n 4 198.51.100.1
ping.exe -S 198.51.100.124 -n 4 1.1.1.1
Resolve-DnsName example.com -Server 198.51.100.1
~~~

Observed:
- Gateway: 4/4 replies, 0% loss.
- 1.1.1.1: 4/4 replies, 0% loss, 40 ms average round-trip time.
- DNS: A and AAAA results returned by 198.51.100.1.

The connected PoE endpoint was on port 1/1/3. A PoE controller reset warning appeared during the Primary reboot, but initialization later completed and post-boot live PoE status showed the endpoint drawing 6.1 W. The root cause and recurrence of the controller reset message were not determined; monitor during normal use.

## Important caveats

- The target is Layer 2 switching with PoE. OPNsense remains DHCP/routing/firewall authority; user VLAN segmentation is not part of this commissioning pass.
- In the final status capture, mgmt1 was Down. A connected and usable out-of-band management link has not been verified after Primary boot.
- The PoE controller reset warning was followed by successful initialization and live power output, but controller logs were not captured after boot.
- No credential values are stored here. Do not put passwords, tokens, private keys, or other secrets in the repository.
- Firmware binaries are excluded; download them only from the official RUCKUS support page for the correct device and release path.
