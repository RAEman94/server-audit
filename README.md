# Server Audit Script

This project provides a simple Linux server auditing script that collects key security and system information for quick inspection.

It is designed for VPS / Linux servers (especially for setups with Docker, Xray, or general hosting environments).

---

## Quick Start

You can run the audit directly from the repository without downloading anything:

```bash
bash <(curl -fsSL https://git.raeman.ru/RAEman/server-audit/raw/branch/main/audit.sh) > audit.log
```
This will:

Download the script via curl

Execute it immediately

Save output to audit.log
## Recommended Usage (safer variant)

To also see output in real-time while saving it:
```bash
bash <(curl -fsSL https://git.raeman.ru/RAEman/server-audit/raw/branch/main/audit.sh) 2>&1 | tee audit.log
```
## Downloading the report via SSH

After the audit is finished, the file audit.log will be created on the server.

Option 1: SCP (recommended)

Run this on your local machine (not on the server):
```bash
scp root@YOUR_SERVER_IP:/root/audit.log .
```
Example:
```bash
scp root@123.123.123.123:/root/audit.log .
```
This will download the file into your current directory.

Option 2: rsync (alternative)
```bash
rsync -avz root@YOUR_SERVER_IP:/root/audit.log .
```
Option 3: manual copy (fallback)

On the server:
```bash
cat audit.log
```
Then copy the output manually.

## What the script checks

The audit includes:

- Open network ports (ss)
- Running services (systemctl)
- Active processes (ps)
- Firewall state (iptables, ufw, nft)
- SSH configuration
- Login history (last, lastb)
- Cron jobs
- Systemd timers
- Docker containers
- System users
- Recent file changes
- Journal errors
- System resources (CPU, RAM, disk)
## Notes
The script is read-only (it does not modify the system)
Some sections may require root privileges
Large output is expected on production servers
## Security tip

For best results, run the audit periodically and compare logs over time to detect changes in:

- open ports
- new services
- unexpected users or processes
## Example workflow

```bash
# run audit
bash <(curl -fsSL https://git.raeman.ru/RAEman/server-audit/raw/branch/main/audit.sh) 2>&1 | tee audit.log
```

```bash
# download result
scp root@server-ip:/root/audit.log .
```