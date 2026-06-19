# CU DBMI Data Storage Utilities and Guidance

These scripts and guides are here to help CU DBMI labs get started with data storage, migration planning, and shared research infrastructure.

Please use your best judgment when using these scripts, and treat them as use-at-your-own-risk since environments can vary.

## Guidance

- 🧭 [Data Migration Guide](docs/data-migration-guide.md): choose the right storage resource, plan lab migrations, handle HIPAA/PHI, coordinate live databases, move source code ownership, use VPN, and manage shared credentials with 1Password.
- 🚚 [Data Transfer Guide](docs/data-transfer-guide.md): connect to Isilon, use the mount script, transfer data to PetaLibrary with Globus Connect Personal, and troubleshoot common mount issues.

## Support Contacts

| Support area      | Contact                                                                   | Use for                                                                                                                                        |
| ----------------- | ------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| SOM IT help       | [dbmi@medschool.zendesk.com](mailto:dbmi@medschool.zendesk.com)           | Most School of Medicine IT support requests, including DBMI storage/access questions; SOM Information Services can escalate to OIT when needed |
| Anschutz OIT      | [ucd-oit-helpdesk@cuanschutz.edu](mailto:ucd-oit-helpdesk@cuanschutz.edu) | Campus platform support, infrastructure, networking, STAR/SFTP, and services beyond the direct SOM support path                                |
| Anschutz HPC help | [hpcsupport@cuanschutz.edu](mailto:hpcsupport@cuanschutz.edu)             | HPC-specific requests for Alpine, PetaLibrary, Globus, and related research computing workflows                                                |

## Data Classification

Before storing or transferring data, classify it as Public, Confidential, or Highly Confidential using CU's [Data Classification guidance](https://www.cu.edu/data-governance/resources-support/data-classification).

- Confidential data may be appropriate for approved shared storage such as Isilon or PetaLibrary when access controls, ownership, and retention are clear.
- Highly Confidential data, including regulated data such as HIPAA/PHI, requires additional review and approved controls before using Isilon, PetaLibrary, Globus, or any other transfer path.
- When in doubt, ask the data owner, campus IT/security, or DBMI before moving the data.

## Connecting to Isilon Storage

For Isilon connection and transfer instructions, including the command-line mount script, see the [Data Transfer Guide](docs/data-transfer-guide.md).

To request Isilon storage for DBMI work, contact [dbmi@medschool.zendesk.com](mailto:dbmi@medschool.zendesk.com). A university SpeedType is used to help determine billing and cost allocation. Current Anschutz Isilon rate details are listed under "Isilon Central File Server" on the CU Anschutz OIT [Billing and Rates](https://www.cuanschutz.edu/offices/office-of-information-technology/get-help/billing-and-rates#ac-backup-and-storage-0) page.

For additional setup and connection guidance on Windows or macOS, see the SOM knowledge base docs:
https://medschool.zendesk.com/hc/en-us/sections/360005463054-Map-to-SOM-Network-Drive
