# CU DBMI storage utilities

These scripts are here to help you get started with data storage quickly.

Please use your best judgment when using these scripts, and treat them as use-at-your-own-risk since environments can vary.

## Connecting to Isilon Storage

These guides assume you already have an Isilon share and that your account has access (please verify or request both before using).

For additional setup and connection guidance on Windows or macOS, see the SOM knowledge base docs:
https://medschool.zendesk.com/hc/en-us/sections/360005463054-Map-to-SOM-Network-Drive

You can also use this script to connect to Isilon storage at CU Anschutz from the command line on macOS or Linux.

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
