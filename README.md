# CU DBMI storage utilities

These scripts are here to help you get started quickly, but please review and use them with care since environments can vary!

## Run `mount_isilon.sh` from GitHub

This script is used for interfacing with Isilon storage at CU Anschutz.
It requires you already have a share on Isilon and that your user has access to the share (please verify both before using).

You can run the script directly from a GitHub raw URL:

```sh
curl https://raw.githubusercontent.com/CU-DBMI/storage/main/src/mount_isilon.sh | sh
```

Safer option (inspect before running):

```sh
curl -fsSL https://raw.githubusercontent.com/CU-DBMI/storage/main/src/mount_isilon.sh -o /tmp/mount_isilon.sh
less /tmp/mount_isilon.sh
sh /tmp/mount_isilon.sh
```
