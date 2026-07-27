# 🚚 Data Transfer Guide

This guide is for initiating data transfers after the lab has confirmed where the data should live and who should have access.

Use this when:

- You need to connect to an Isilon share.
- You need to move files between Isilon, a local workstation, and PetaLibrary.
- You need a practical transfer path for large datasets.
- You need to troubleshoot the Isilon mount script.

For migration planning and choosing the right destination first, see the [Data Migration Guide](data-migration-guide.md).

## Before You Transfer

Confirm:

- The source location and destination location.
- The data owner.
- The PI as the default accountable owner unless a different technical owner is required for implementation.
- The SpeedType or funding source for billable Isilon or PetaLibrary storage.
- Whether the data are Public, Confidential, or Highly Confidential under CU's [Data Classification guidance](https://www.cu.edu/data-governance/resources-support/data-classification).
- Whether the data include HIPAA, PHI, identifiable participant data, or other restricted data with additional requirements.
- The people or service accounts that need access.
- VPN access for internal CU Anschutz resources.
- The expected data size and file count.
- Whether the transfer needs to be resumable and verified.
- Whether the old copy must be retained temporarily for rollback.

For large transfers, move a small test folder first and validate it before starting the full transfer.

Do not initiate transfers of Highly Confidential data until the data owner and campus IT/security have confirmed that the source, destination, workstation, transfer tool, and access controls are approved for that data. This applies to Isilon, PetaLibrary, Globus, Globus Connect Personal, and any intermediate system.

## Connect to Isilon

These guides assume you already have an Isilon share and that your account has access. Verify or request both before using the mount script.

To request Isilon storage for DBMI work, contact [dbmi@medschool.zendesk.com](mailto:dbmi@medschool.zendesk.com). A university SpeedType is used to help determine billing and cost allocation. Current Anschutz Isilon rate details are listed under "Isilon Central File Server" on the CU Anschutz OIT [Billing and Rates](https://www.cuanschutz.edu/offices/office-of-information-technology/get-help/billing-and-rates#ac-backup-and-storage-0) page.

For Confidential or Highly Confidential data, also confirm the Isilon share is approved for that classification and that permissions are limited to authorized users.

For additional setup and connection guidance on Windows or macOS, see the SOM knowledge base docs:
https://medschool.zendesk.com/hc/en-us/sections/360005463054-Map-to-SOM-Network-Drive

You can use the mount script in this repository to connect to Isilon storage at CU Anschutz from the command line on macOS or Linux.

When prompted, enter either a DBMI share name, a path below the DBMI base, or a full SMB path. For example, all of these input styles are supported:

```text
LabName
dbmi/Way_McKinsey_Cardiac_Fibrosis
smb://data.ucdenver.pvt/dept/som/dbmi/dbmi/Way_McKinsey_Cardiac_Fibrosis
```

Run the script directly from the GitHub raw URL:

```sh
curl https://raw.githubusercontent.com/CU-DBMI/data-storage/main/src/mount_isilon.sh | sh
```

Safer option, which lets you inspect the script before running it:

```sh
curl -fsSL https://raw.githubusercontent.com/CU-DBMI/data-storage/main/src/mount_isilon.sh -o /tmp/mount_isilon.sh
less /tmp/mount_isilon.sh
sh /tmp/mount_isilon.sh
```

For Isilon, connect to VPN first when you are off network, then mount the share or open the mapped network drive.

## Transfer to PetaLibrary with Globus

PetaLibrary can be useful for large research storage allocations and high-volume data movement connected to CU Research Computing workflows. For official transfer guidance, see the CURC [Data Transfer documentation](https://curc.readthedocs.io/en/latest/compute/data-transfer.html).

For PetaLibrary storage tiers and current rate details, see the CURC [PetaLibrary Allocation Tiers](https://curc.readthedocs.io/en/latest/petalibrary/allocation_types.html#) documentation.

Use Globus for large, resumable, verified data transfers. Globus is a better fit than manual desktop copy operations when moving large datasets between storage systems.

Use Globus Connect Personal when the source or destination is a local workstation or a mounted filesystem. A common Isilon-to-PetaLibrary workflow is:

1. Connect to VPN if required.
1. Mount the Isilon share on a workstation using the Isilon mount script or the mapped network drive instructions.
1. Install and configure Globus Connect Personal on that workstation.
1. Expose the mounted Isilon folder through the local Globus endpoint.
1. In the Globus web interface, connect the local endpoint to the PetaLibrary endpoint.
1. Start with a small test transfer.
1. Run the full transfer after the test succeeds.
1. Validate files at the destination before removing or archiving the source copy.

Before transferring from Isilon to PetaLibrary, confirm:

- The data classification is known.
- The PI is the default accountable owner for the transfer unless a delegated technical owner is required.
- The user has access to the Isilon share.
- The user has access to the PetaLibrary allocation.
- The Isilon share and PetaLibrary allocation are approved for the data classification.
- The SpeedType or funding source is confirmed for billable storage.
- The workstation can see the mounted Isilon folder.
- The workstation is appropriate for the data classification and is not a shared or unmanaged device.
- Globus Connect Personal is running on the workstation.
- The destination folder in PetaLibrary is correct.
- The transfer does not route through OneDrive or another constrained intermediate location.

For Highly Confidential data, confirm requirements before using PetaLibrary or Globus. CU Boulder OIT guidance says to contact the Office of Information Security before choosing a tool for research data that falls under the Highly Confidential data standard.

## Validate the Transfer

After the transfer:

- Review the Globus transfer status.
- Compare expected file counts and sizes.
- Open or checksum a sample of important files.
- Confirm users can access the destination.
- Confirm permissions at the destination still match the data classification.
- Update scripts, notebooks, documentation, or applications that reference the old path.
- Keep the source copy until the data owner confirms the destination is valid.

Snapshots and disaster recovery replication are not a substitute for transfer validation. Even when Isilon snapshots and replication are in place, confirm the destination copy is complete and usable before archiving or removing source data.

## FAQ

### What does `mount_smbfs: mount error: ... File exists` mean on macOS?

This usually means macOS found a conflict at the local mount point. The network and VPN may be working, but the share cannot be mounted cleanly.

Common causes:

- The share is already mounted.
- A previous failed mount left a stale mount entry.
- The local mount directory already exists in a state macOS does not want to mount over.
- A Finder window, terminal, or process is still using the mount directory.

First, check whether the share is already mounted:

```sh
mount | grep SoragniLab
```

If it is mounted, unmount it:

```sh
umount /Users/buntend/mnt/SoragniLab
```

If that reports the mount is busy, close Finder windows, terminal sessions, editors, or scripts using that folder, then retry. On macOS, this can also help:

```sh
diskutil unmount /Users/buntend/mnt/SoragniLab
```

If the directory is not mounted, check whether it is just an empty local folder:

```sh
ls -la /Users/buntend/mnt/SoragniLab
```

If it is empty and not mounted, remove the local directory and rerun the mount script:

```sh
rmdir /Users/buntend/mnt/SoragniLab
```

Then rerun the script. If network reachability succeeded and the failure happened at `mount_smbfs`, the issue is more likely the local mount point or an already-mounted share than VPN or DNS.
