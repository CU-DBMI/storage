# 🧭 Data Migration Guide

This guide is for labs moving research data, analysis files, databases, source code, credentials, or shared project folders into a more stable storage location.

The short version:

1. Put shared lab files on Isilon when they need to be available to multiple people or systems.
1. Work with the DBMI software engineering team before moving live databases such as PostgreSQL or MySQL.
1. Use Google Cloud when you need cloud compute, managed storage, or project-specific infrastructure that can be paid for with SpeedTypes.
1. Use OneDrive for personal or small shared files, but avoid it for large migrations or high-throughput workflows.
1. Update GitHub organization ownership, teams, and access before people leave or projects change ownership; transfer repositories only when the current organization cannot support the project long term.
1. Use VPN for internal CU Anschutz resources and 1Password for shared password management.
1. Use the [Data Transfer Guide](data-transfer-guide.md) once access is ready and you need to initiate transfers.

## Data Classification

Classify data before choosing a storage or transfer path. CU uses Public, Confidential, and Highly Confidential classifications; see CU's [Data Classification guidance](https://www.cu.edu/data-governance/resources-support/data-classification).

For this guide:

- Confidential data is non-public data that needs controlled access but is less sensitive than Highly Confidential data.
- Highly Confidential data includes data protected by law, regulation, contract, legal agreement, or breach-notification requirements. Regulated data such as HIPAA/PHI may have additional requirements.
- The data owner or Data Trustee is responsible for classification. Do not downgrade data because it is inconvenient to store or transfer.
- Choose storage based on the most sensitive data in the folder.

Resource guidance:

- Isilon can be appropriate for Confidential data and may be appropriate for Highly Confidential data such as HIPAA/PHI only when the share is approved for that use and has the required access controls.
- PetaLibrary can be appropriate for research data and Confidential data when the allocation, permissions, and transfer method are approved for the data. For Highly Confidential data, confirm requirements with the data owner and campus IT/security before using PetaLibrary.
- Library-style shared reference folders should only contain non-sensitive or appropriately approved reference data. Do not put HIPAA/PHI or other Highly Confidential data in broadly shared library locations.
- OneDrive should not be used as a staging area for large datasets or restricted data migrations unless the data owner and policy allow it.
- Globus and Globus Connect Personal are transfer tools, not approval by themselves. The source, destination, endpoint, workstation, and users all need to be appropriate for the data classification.

## Common Storage Options

### Isilon storage

Isilon is a shared network storage system for files and folders. It is a good fit for lab data that needs centralized access, long-running projects, shared analysis outputs, sensitive data, and files that should not live on a single person's laptop.

Use Isilon when:

- Multiple lab members need access to the same folder.
- Data should remain available after staff or students leave.
- Files are too large or too important for personal cloud storage.
- A server, workstation, or analysis workflow needs to read and write files from a shared location.
- The data include HIPAA, PHI, or other sensitive research data and the share has the right access controls.
- Confidential or Highly Confidential data need an access-controlled storage location approved for that classification.

Before migrating to Isilon, confirm:

- Your lab has an Isilon share.
- If you need a new DBMI Isilon share, request it through [dbmi@medschool.zendesk.com](mailto:dbmi@medschool.zendesk.com).
- A university SpeedType is available to help determine billing and cost allocation.
- Current Isilon cost details are listed under "Isilon Central File Server" on the CU Anschutz OIT [Billing and Rates](https://www.cuanschutz.edu/offices/office-of-information-technology/get-help/billing-and-rates#ac-backup-and-storage-0) page.
- The right people and service accounts have access.
- The folder structure is clear enough for long-term use.
- Someone in the lab owns access requests and cleanup decisions.
- The PI is the default owner or accountable sponsor unless that blocks implementation; if a technical owner is required, document the PI and delegated owner.
- At least two appropriate people have owner/admin-level access when possible, so access does not depend on one person.
- Users know how to connect to VPN before accessing the share from off network.

### Backup, recovery, and the 3-2-1 rule

The 3-2-1 backup rule is a common way to think about resilience: keep three copies of important data, on two different types or systems of storage, with one copy offsite or otherwise separated from the primary copy.

Based on current Isilon administrator guidance, CU Anschutz Isilon aligns with this strategy through layered protection:

- Primary Isilon data are split across three nodes, providing on-premise redundancy.
- Hourly immutable point-in-time snapshots protect against accidental deletion or modification and are the first line of recovery.
- Data are replicated to a read-only disaster recovery system in Boulder.
- The DR replica has its own snapshots.
- Additional snapshots may be triggered when ransomware monitoring detects suspicious activity.

For practical planning, think of this as primary Isilon data plus local snapshots plus a read-only DR replica with snapshots. This protects shared file storage differently from a simple single-folder copy.

Do not confuse Isilon protection with "External Department Backups." External Department Backups are Commvault backups for individual servers and do not run on Isilon shares.

If a lab or section needs an additional independent offsite copy beyond Isilon's managed protection, discuss the requirement before copying data. Temporary external-drive workflows should be approved for the data classification, encrypted when required, tracked, and removed from service when no longer needed.

### Library or shared reference data

Some labs keep shared reference files, curated datasets, or reusable resources that many projects depend on. Treat these like a library, not a working scratch folder.

Library storage is for reusable non-sensitive reference material. HIPAA data, PHI, restricted clinical data, identifiable participant data, and data with project-specific access restrictions should not go in a broadly shared library location. Put those data in an access-controlled Isilon share or another approved restricted environment.

For library-style data:

- Keep the source or authoritative copy clear.
- Avoid editing files in place unless the lab has a defined process.
- Use read-only access where possible.
- Track versions, dates, or release names for important datasets.
- Keep a short README in the folder explaining what the data is and who maintains it.

### Live databases

Do not migrate a live database by copying raw database files while the database is running.

For PostgreSQL, MySQL, REDCap-adjacent systems, application databases, or anything that supports active software, work with the DBMI software engineering team. They can help plan the safest migration path, including:

- Database dumps and restores.
- Downtime windows.
- Application connection string changes.
- Backups and rollback plans.
- Validation after the move.
- Security and access controls.

If the database supports a production workflow, assume it needs a migration plan.

### DBMI software engineering support

Labs can work with the DBMI software engineering team when a migration involves databases, production software, cloud infrastructure, automation, dashboards, APIs, or research systems that need ongoing technical ownership.

These arrangements are commonly handled through shared FTE support and a memorandum of understanding, or MOU. The goal is to make responsibilities explicit before the work starts.

A typical arrangement should clarify:

- The PI, lab, project, or grant funding the work.
- The SpeedType or funding source, when applicable.
- The expected engineering FTE or level of effort.
- The initial scope of work and priorities.
- Who owns product decisions, data decisions, and technical decisions.
- Which two or more people, when possible, should retain owner/admin-level access for continuity.
- Expected response times for urgent and non-urgent requests.
- Whether the work is one-time migration support, ongoing maintenance, or both.
- How source code, cloud resources, credentials, and documentation will be handed off.

Use an MOU when the work needs sustained engineering time, production support, or shared responsibility across teams. For small questions or early planning, start with a lightweight consultation before committing to a larger support arrangement.

### VPN access

Many CU Anschutz storage and internal research resources require VPN access when you are not on the campus network. If a user cannot reach Isilon, internal servers, database hosts, or private dashboards, confirm VPN access before troubleshooting the application or storage path.

Basic VPN guidance:

- Install and configure the CU Anschutz VPN client before the migration window.
- Test access to the target storage or server before moving data.
- Confirm that every person who needs access can connect from their normal work location.
- Document which resources require VPN and which do not.
- Do not treat VPN as a substitute for permissions. Users still need explicit access to the share, server, database, or application.

For Isilon, users should connect to VPN first when they are off network, then mount the share or open the mapped network drive.

### 1Password and shared credentials

Use 1Password for shared password management during and after migrations. Passwords, API tokens, database credentials, cloud keys, service account secrets, and recovery codes should not live in personal notes, spreadsheets, source code, chat messages, or email threads.

Good 1Password practices:

- Store shared credentials in a lab, project, or team vault instead of an individual's private vault.
- Limit vault access to people who need it.
- Use named records for service accounts, databases, cloud projects, GitHub organizations, and deployment systems.
- Include enough context to know what each credential controls and who owns it.
- Rotate credentials when staff leave, when ownership changes, or after a migration.
- Move credentials into managed secrets systems when software needs automated access.
- Do not commit `.env` files, private keys, passwords, or tokens to GitHub.

During handoff, confirm that at least two appropriate people can access the necessary 1Password vaults and that old personal copies of credentials are removed or rotated.

### Google Cloud

Google Cloud can be used for lab projects that need cloud storage, managed databases, compute, automation, or scalable analysis environments. It can also be useful when a project needs infrastructure that is tied to a grant, project, or SpeedType.

Use Google Cloud when:

- You need cloud compute near the data.
- You need managed services such as object storage or managed databases.
- A workflow is too large or too automated for desktop storage.
- The project has a SpeedType or funding source for cloud costs.

Before using Google Cloud, confirm:

- Who owns the project and billing. The PI should be the default accountable owner unless that blocks implementation.
- Which SpeedType should pay for it.
- Whether the data is regulated, sensitive, or subject to specific access rules.
- How costs will be monitored.
- Who will shut down or archive resources when the project ends.

### PetaLibrary and Globus transfers

PetaLibrary can be useful for large research storage allocations and high-volume data movement connected to CU Research Computing workflows.

From a migration perspective, decide whether PetaLibrary is the right destination, confirm allocation access, and verify that the source data can be accessed by the person or workstation performing the transfer.

For PetaLibrary storage tiers and current rate details, see the CURC [PetaLibrary Allocation Tiers](https://curc.readthedocs.io/en/latest/petalibrary/allocation_types.html#) documentation.

For transfer steps after access is ready, including Isilon-to-PetaLibrary transfers with Globus Connect Personal, see the [Data Transfer Guide](data-transfer-guide.md).

Before choosing PetaLibrary for Highly Confidential data, confirm the allocation and workflow are approved for that classification. CU Boulder OIT guidance says to contact the Office of Information Security before choosing a tool for research data that falls under the Highly Confidential data standard.

Before transferring data from Isilon to PetaLibrary:

- Confirm whether the data are Public, Confidential, or Highly Confidential.
- Confirm the PI is the default accountable owner for the allocation or migration unless a delegated owner is required for implementation.
- Confirm the user has access to the Isilon share.
- Confirm the user has access to the PetaLibrary allocation.
- Confirm the SpeedType or funding source for any billable Isilon or PetaLibrary storage.
- Connect to VPN if the Isilon share or internal transfer path requires it.
- Transfer a small test folder first.
- Validate file counts, sizes, and important files after transfer.
- Avoid using OneDrive as an intermediate transfer location for large datasets.

### OneDrive

OneDrive is useful for personal files, small shared documents, and collaboration on office documents. It is not a good primary target for large lab data migrations.

OneDrive constraints:

- Throughput can become a bottleneck for large files or many small files.
- Sync behavior can make automated workflows unreliable.
- Local disk space may be consumed by synced files.
- Permissions and ownership can become unclear when people leave.
- It is not designed as a high-performance shared filesystem.

Use OneDrive for documents and small collaboration needs. Use Isilon or Google Cloud for larger research data, shared lab storage, databases, or compute-heavy workflows.

## Which Data Belongs Where

| Data type                                                              | Best fit                                                                | Avoid                                                           |
| ---------------------------------------------------------------------- | ----------------------------------------------------------------------- | --------------------------------------------------------------- |
| Confidential research data                                             | Approved Isilon share or PetaLibrary allocation with access controls    | Personal accounts, unmanaged shares, unclear ownership          |
| HIPAA, PHI, identifiable participant data, or restricted clinical data | Access-controlled Isilon share or other approved restricted environment | Library storage, personal OneDrive folders, public repositories |
| Highly Confidential research data                                      | Approved restricted environment after data owner and IT/security review | Moving before classification, approval, and controls are clear  |
| Shared lab working files                                               | Isilon                                                                  | Personal laptops or personal OneDrive folders                   |
| Reusable non-sensitive reference datasets                              | Library-style Isilon folder with clear ownership and versioning         | Ad hoc working folders                                          |
| Raw instrument output or large analysis files                          | Isilon or Google Cloud, depending on workflow                           | OneDrive for large or frequent transfers                        |
| Large transfers from Isilon to PetaLibrary                             | Globus with Globus Connect Personal when Isilon is mounted locally      | Manual desktop copy or OneDrive as an intermediate location     |
| Live PostgreSQL, MySQL, or application database data                   | Managed migration with DBMI software engineering                        | Manual file copy while the database is running                  |
| Code, scripts, notebooks, and software projects                        | Existing lab/project GitHub organization with updated owners and teams  | Personal GitHub accounts as the only authoritative copy         |
| Passwords, API keys, tokens, and recovery codes                        | 1Password shared vault with appropriate access                          | Source code, spreadsheets, chat, email, personal notes          |
| Small documents, drafts, and office collaboration files                | OneDrive                                                                | High-throughput pipelines or large datasets                     |

When in doubt, choose the resource based on the most sensitive data in the folder, not the average file. A folder with any HIPAA or restricted data should be treated as restricted.

## Source Code and GitHub Organizations

Source code should be migrated like a durable research asset. Repositories often support papers, pipelines, databases, dashboards, and long-running lab workflows, so they should not depend on one person's personal account.

Best practices:

- Treat the PI as the default accountable owner for lab or project source code unless GitHub or institutional implementation details require a delegated owner.
- Prefer updating ownership, teams, and access in the existing GitHub organization when that organization can continue to support the lab or project.
- Make at least two long-term maintainers organization owners.
- Use teams for access instead of granting permissions one person at a time.
- Keep repository visibility intentional: private for restricted work, public only when the lab is ready to share.
- Move deployment secrets, tokens, and service credentials into organization or repository secrets before handing off.
- Document which repositories support active systems, papers, grants, or datasets.
- Archive repositories that are no longer maintained instead of deleting them.
- Transfer repositories to a different organization only when the existing organization cannot provide durable ownership, appropriate access control, or long-term stewardship.

When transitioning an existing GitHub organization:

- Rename the organization if the existing organization has citations, paper links, users, stars, forks, or package history that should be preserved.
- GitHub redirects web links to repositories after an organization rename, so links from papers and other references usually continue to reach the repositories.
- Local `git clone`, `git fetch`, and `git push` operations can continue to work through the old remote URL, but maintainers should update remotes to the new organization URL.
- Update links to the organization profile page, API calls, GitHub Actions references, package references, documentation, and websites because not every reference redirects.
- Do not reuse the old organization name casually. If someone creates a new organization or repository under the old namespace, some redirects can stop working.

## Migration Checklist

Before moving data:

- Identify the current location, target location, and data owner.
- Identify the PI as the default accountable owner unless a different owner is required for implementation.
- Estimate size, file count, and expected growth.
- Identify sensitive or regulated data and classify it as Public, Confidential, or Highly Confidential.
- Confirm whether the target storage has the backup, snapshot, retention, and disaster recovery posture the lab needs.
- Decide who needs read, write, and admin access.
- Assign at least two owner/admin-level users when possible for backup and redundancy of access.
- Decide whether the data is active, archival, or reference/library data.
- Confirm whether any software, scripts, notebooks, or databases depend on the current path.
- Identify source code repositories, GitHub organizations, service accounts, deployment keys, and automation that need to move with the data.
- Confirm VPN access for users who need internal storage, servers, databases, or dashboards.
- Identify credentials and secrets that need to move into a shared 1Password vault or managed secrets system.
- Identify SpeedTypes or funding sources for billable storage and cloud resources.
- For PetaLibrary moves, confirm Globus access, Globus Connect Personal setup, and allocation access before the transfer window.

During migration:

- Prefer tested copy tools that can resume and verify transfers.
- Preserve timestamps and permissions when they matter.
- Move a small test folder first.
- Keep the original data unchanged until validation is complete.
- Record what moved, when it moved, and who approved the change.

After migration:

- Validate file counts, sizes, and a sample of important files.
- Update scripts, notebooks, applications, and documentation.
- Confirm users can access the new location.
- Confirm users can connect through VPN where required.
- Confirm credentials are stored in the right 1Password vault and old copies are removed or rotated.
- For Globus transfers, review transfer status and validate files at the destination before removing the source copy.
- Keep the old copy temporarily if rollback is needed.
- Set a date to archive or remove the old copy.

## Quick Decision Guide

| Need                                                                              | Recommended option                                                                 |
| --------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------- |
| Shared lab files                                                                  | Isilon                                                                             |
| Shared reference or curated datasets                                              | Isilon with library-style organization                                             |
| Confidential research data                                                        | Approved Isilon share or PetaLibrary allocation with controls                      |
| HIPAA, PHI, or restricted participant data                                        | Access-controlled Isilon share, not library storage                                |
| Highly Confidential data                                                          | Approved restricted environment after data owner/security review                   |
| Live PostgreSQL, MySQL, or application database                                   | Work with DBMI software engineering                                                |
| Production software, dashboards, APIs, or automation                              | DBMI software engineering support through shared FTE/MOU planning                  |
| Internal storage, servers, private dashboards, or database hosts from off network | VPN plus explicit permissions                                                      |
| Shared passwords, tokens, API keys, or recovery codes                             | 1Password shared vault                                                             |
| Large Isilon-to-PetaLibrary transfer                                              | Globus with Globus Connect Personal                                                |
| Cloud compute, managed services, or funded project infrastructure                 | Google Cloud with SpeedType planning                                               |
| Lab or project source code                                                        | Existing GitHub org with updated ownership/access, or transfer only when necessary |
| Personal documents or small collaboration files                                   | OneDrive                                                                           |
| Large file migration or high-throughput workflow                                  | Isilon or Google Cloud, not OneDrive                                               |
