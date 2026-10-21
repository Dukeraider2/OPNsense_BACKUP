# EAP650 V1 Wi-Fi Channel Tuning and Throughput Test

**Date:** 2026-10-18  
**Status:** Radio settings applied; throughput validation pending  
**Device:** TP-Link Omada EAP650 V1 in standalone management mode  
**Client adapter:** Intel Wi-Fi 6E AX210 160 MHz, driver 23.170.0.1  
**Purpose:** Use a Windows Wi-Fi scan to choose less congested channels, apply a baseline configuration, and later measure actual LAN throughput.

## Current configuration

### 5 GHz radio
- Wireless mode: 802.11a/n/ac/ax mixed
- Channel range: Band 3 (DFS)
- Channel: 100 / 5500 MHz (DFS)
- Channel width: 80 MHz
- Transmit power: 20 dBm
- SSID: `globaltrustnetwork_wifi_5.0`
- SSID VLAN ID shown by standalone UI: 0 (untagged/default network)

### 2.4 GHz radio
- Wireless mode: 802.11b/g/n/ax mixed
- Channel: 1 / 2412 MHz
- Channel width: 20 MHz
- Transmit power: 20 dBm
- SSID: `globaltrustnetwork-wifi_2.4`
- SSID VLAN ID shown by standalone UI: 0 (untagged/default network)

## Windows scan observations

Collected with `netsh wlan show networks mode=bssid` from the Intel AX210. The PC was at the test location; results are a snapshot and do not measure all RF interference or total airtime utilization.

- 2.4 GHz channel 11 was heavily represented, including a network at 91% signal and reported channel utilization as high as 78%.
- Channel 6 included strong networks at 80% signal; some BSS Load reports showed 61–62% channel utilization.
- Channel 1 also had multiple networks and one channel 3 network that overlaps it, but was selected as the initial test channel.
- On 5 GHz, several nearby networks appeared on channels 44, 149, 157, and 161. No networks were reported on channels 100–112 in this scan.
- DFS channel 100 was selected as an initial test channel; DFS radar detection can force a channel change or interrupt service.

## Observed client link

Captured after connecting the Windows PC to `globaltrustnetwork_wifi_5.0`:

- State: Connected
- Band/channel: 5 GHz, channel 100
- Radio type: 802.11ax
- Signal: 86%; RSSI: -54 dBm
- One capture showed receive 1201 Mbps / transmit 245 Mbps.
- A subsequent capture showed receive 1081 Mbps / transmit 1081 Mbps.

These are negotiated PHY link rates, not measured application throughput. Variation between captures is normal and should not be interpreted as proof of interference reduction. No before/after throughput benchmark has been completed.

## Pinned follow-up test / resume here

**Do this later:** Measure real LAN throughput over Wi-Fi using `iperf3`. Do not mark Wi-Fi performance validation complete until both directions have been tested against a wired LAN host.

1. Choose a wired computer connected to the lab LAN and install/run the same `iperf3` version on it.
2. On the wired computer, run `iperf3 -s` and leave it running.
3. Determine its actual LAN IP address. Do not assume the example address below is correct.
4. On the wireless Windows PC, run:
   ```powershell
   iperf3 -c <WIRED_HOST_IP> -P 4 -t 30
   iperf3 -c <WIRED_HOST_IP> -P 4 -t 30 -R
   ```
5. Record the sender/receiver throughput, retransmits where reported, PC location, signal/RSSI, channel, channel width, and test time.
6. Repeat a scan and throughput test at the same physical location at another time. Compare results before making more radio changes.

The Windows client has `iperf3 3.22` installed and `iperf3 --version` was verified. A wired server host has not yet been selected or tested.

## Current assessment

- The 5 GHz radio is confirmed connected on DFS channel 100 with strong reported signal.
- The 2.4 GHz radio has been set to channel 1 / 20 MHz / 20 dBm.
- The current configuration is a reasonable test baseline, not a proven optimum.
- The scan lists nearby Wi-Fi networks only. It cannot fully characterize non-Wi-Fi interference, hidden clients, or actual airtime contention.
- SSIDs currently display VLAN ID 0. VLAN segmentation is not part of this test and should only be introduced after the corresponding switch trunk and OPNsense VLAN interfaces/firewall policies are confirmed.
- Do not claim reduced interference or validated throughput until measurements are collected.

## Commands used

Scan visible networks:
```powershell
netsh wlan show networks mode=bssid
```

Check client link:
```powershell
netsh wlan show interfaces
```

Check iperf3 installation:
```powershell
iperf3 --version
```

## Next acceptance criteria

- [ ] Identify a wired LAN host for iperf3 server.
- [ ] Record 30-second iperf3 throughput in both directions.
- [ ] Confirm tests stay within the LAN and are not internet speed tests.
- [ ] Repeat measurements at the same PC location.
- [ ] Decide whether channel 100 / 80 MHz performs better than a non-DFS comparison channel.
- [ ] Keep the final configuration and test results in this blog.
