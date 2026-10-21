# Future Improvement: Dedicated Backup TrueNAS System

**Status:** Proposed future improvement  
**Priority:** Planned, not yet implemented  
**Required storage layout:** Two-drive mirror

## Idea

Use a second, dedicated TrueNAS system as a backup target for the home lab. A two-bay TrueNAS case has already been 3D-printed, providing a starting point for a compact backup appliance.

The two-bay unit is intended to operate as a **pure backup appliance**, with its two drives configured as a mirror. This is the chosen configuration for this build, not an open design choice.

## Intended role

- Hold independent backup copies of important data from the primary TrueNAS system and selected home-lab computers.
- Store critical configuration backups for OPNsense and network equipment, where export/backup is supported.
- Provide a recovery target if a primary disk, system, or dataset is lost.
- Retain versioned backup generations where supported by the selected backup workflow.

## Design requirements

1. **Two-drive mirror:** Configure the two data drives as a supported mirror. Usable capacity will be approximately the size of one drive before filesystem and operating overhead. A mirror can tolerate one drive failure, but does not protect against accidental deletion, malware, theft, or loss of the whole device.
2. **Backup-focused role:** Keep this system dedicated to receiving and retaining backups rather than serving as the primary general-purpose file store.
3. **Physical and administrative separation:** Use distinct backup credentials and restrict routine clients from deleting backup data. Consider powering the system down or disconnecting it when not in use if the desired recovery model allows it.
4. **Network placement:** Connect it to the managed home-lab network with access rules that allow approved backup traffic and limit unnecessary access. Final VLAN IDs, addresses, and switch ports remain undecided.
5. **Capacity and retention:** Confirm the primary data size and retention needs before selecting drive capacity. A mirror does not double usable capacity.
6. **Restore testing:** Document and periodically test restoring files and system configurations. A backup is not verified until recovery has been tested.
7. **Hardware and software verification:** Confirm the printed case's drive fit, cooling, power supply, motherboard/compute hardware, and intended TrueNAS version before building.

## Relationship to the current topology

The existing TrueNAS remains the planned primary shared-storage system. This second unit is a dedicated mirrored backup target, not a replacement for the primary NAS and not a function of the RUCKUS ICX7150-C12P switch's USB port.

For stronger disaster recovery, consider an additional copy kept separate from this mirrored device. That is a separate future safeguard, not a change to the two-bay unit's required mirror configuration.

## Acceptance checklist

- [ ] Confirm the two-bay case dimensions and hardware compatibility.
- [ ] Select two compatible drives and configure them as a mirror.
- [ ] Define backup sources, schedule, retention, and access controls.
- [ ] Add network/firewall rules and document final addressing.
- [ ] Configure backup jobs and notifications.
- [ ] Perform a test restore and document the result.
