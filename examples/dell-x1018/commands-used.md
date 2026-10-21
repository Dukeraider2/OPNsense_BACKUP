# Dell Networking X1018: firmware-upgrade command record

This is a record of commands used on one Dell X1018 during the 3.0.1.9 upgrade. It is not a generic script. Verify model, file names, version path and the current Dell CLI upgrade instructions before reuse.

## Initial inspection

At the Dell console# prompt:

~~~text
show version
show bootvar
show ip interface
show interfaces status
~~~

Observed before update:
- SW version 3.0.0.64
- Boot version 1.0.0.14
- VLAN 1 IP 203.0.113.1/24, UP/UP
- image-1 3.0.0.64 active; image-2 3.0.0.64 not active

## Isolated transfer LAN

Windows PC Ethernet adapter 2.5gb Network: 203.0.113.2/24  
Dell VLAN 1 address: 203.0.113.1/24  
TFTP root directory:
%USERPROFILE%\Downloads\Dell-X1018-3019\x10xx-3019

Windows connectivity test:

~~~powershell
ping.exe -n 4 203.0.113.1
~~~

Before transfer, this test returned 4/4 replies and 0% loss.

## TFTP transfers

At the Dell console# prompt:

~~~text
copy tftp://203.0.113.2/x10xx-3019.ros image
~~~

Observed: 11,506,394 bytes copied in 00:03:18.

Then:

~~~text
copy tftp://203.0.113.2/x10xx_boot-10025.rfb boot
~~~

Observed: 524,304 bytes copied in 00:00:09.

Before reload:

~~~text
show bootvar
~~~

Observed: image-2, version 3.0.1.9, marked not active* (selected image for next boot).

## Reload and verify

At console#:

~~~text
reload
~~~

The operator confirmed the reload when prompted. The console then reported Boot1 checksum PASS, Boot2 checksum PASS, Flash Image Validation PASS, updating CPLD firmware PASS, “CPLD Code match. No need to upgrade. CPLD Version 2.09,” and Boot Software Version 1.0.0.25. It subsequently loaded the 3.0.1.9 image and completed initialization.

Post-reboot commands:

~~~text
show version
show bootvar
show ip interface
show interfaces status
~~~

Observed:
- SW version 3.0.1.9
- Boot version 1.0.0.25
- HW version 00.00.02
- image-2, version 3.0.1.9, Active*
- VLAN 1 at 203.0.113.1/24, UP/UP
- gi1/0/16 link Up, Full duplex, 1000 Mbps
- gi1/0/1-15 and gi1/0/17-18 Down in the captured status

## Important cautions

- No external configuration backup was taken before this upgrade.
- Keep power connected and never interrupt a vendor CPLD update. Dell's release notes say such updates may take at least 10-15 minutes and interruption can make the device inoperable.
- Do not claim Dell-to-RUCKUS integration is verified until a physical uplink and client traffic are tested.
- The address 203.0.113.1/24 may conflict if both switch-management interfaces are connected to the same Layer 2 network. Choose and configure a deliberate management-IP plan before production integration.
