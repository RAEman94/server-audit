#!/usr/bin/env bash

echo "============================================================"
echo " Linux Security Audit"
echo "============================================================"
echo "Hostname : $(hostname)"
echo "Date     : $(date)"
echo "Kernel   : $(uname -r)"
echo "Uptime   : $(uptime -p)"
echo

export SYSTEMD_PAGER=cat
export PAGER=cat

##############################################################################
echo "==================== OS ===================="
cat /etc/os-release 2>/dev/null
echo

##############################################################################
echo "==================== NETWORK ===================="

echo "--- Listening ports ---"
ss -tulpen
echo

echo "--- Established connections ---"
ss -tpn state established
echo

##############################################################################
echo "==================== FIREWALL ===================="

echo "--- iptables ---"
iptables -S 2>/dev/null || true
echo

echo "--- nftables ---"
nft list ruleset 2>/dev/null || true
echo

echo "--- ufw ---"
ufw status verbose 2>/dev/null || true
echo

##############################################################################
echo "==================== SERVICES ===================="

systemctl --type=service --state=running --no-pager
echo

##############################################################################
echo "==================== ENABLED SERVICES ===================="

SYSTEMD_PAGER=cat systemctl list-unit-files --state=enabled
echo

##############################################################################
echo "==================== TOP PROCESSES ===================="

ps -eo user,pid,ppid,%cpu,%mem,lstart,cmd --sort=-%mem | head -50
echo

##############################################################################
echo "==================== USERS ===================="

awk -F: '$3>=1000 || $1=="root"{print}' /etc/passwd
echo

echo "--- /home ---"
ls -la /home
echo

##############################################################################
echo "==================== SSH ===================="

grep -vE '^(#|$)' /etc/ssh/sshd_config 2>/dev/null

echo
echo "--- authorized_keys (fingerprints) ---"

if [ -f /root/.ssh/authorized_keys ]; then
    ssh-keygen -lf /root/.ssh/authorized_keys
fi

echo

##############################################################################
echo "==================== LOGIN HISTORY ===================="

echo "--- last ---"
last -ai | head -30

echo
echo "--- failed logins ---"
lastb -ai | head -30

echo

##############################################################################
echo "==================== CRON ===================="

echo "--- root crontab ---"
crontab -l 2>/dev/null

echo
echo "--- /etc/crontab ---"
cat /etc/crontab 2>/dev/null

echo
echo "--- cron directories ---"
find /etc/cron* -maxdepth 2 -type f 2>/dev/null

echo

##############################################################################
echo "==================== TIMERS ===================="

systemctl list-timers --all
echo

##############################################################################
echo "==================== DOCKER ===================="

docker ps -a 2>/dev/null

echo
docker images 2>/dev/null

echo

##############################################################################
echo "==================== FAIL2BAN ===================="

fail2ban-client status 2>/dev/null || echo "Fail2ban client not available"

echo

##############################################################################
echo "==================== RECENT FILES ===================="

find /root -type f -mtime -30 2>/dev/null | head -100

echo

##############################################################################
echo "==================== SYSTEMD UNITS ===================="

find /etc/systemd -name "*.service" 2>/dev/null

echo

##############################################################################
echo "==================== JOURNAL ERRORS ===================="

journalctl -p err -b --no-pager | tail -100

echo

##############################################################################
echo "==================== SUSPICIOUS LOCATIONS ===================="

find /tmp /var/tmp /dev/shm \
-type f \
-executable \
2>/dev/null

echo

##############################################################################
echo "==================== LOADED MODULES ===================="

lsmod

echo

##############################################################################
echo "==================== DISK ===================="

df -h

echo

##############################################################################
echo "==================== MEMORY ===================="

free -h

echo

##############################################################################
echo "==================== DONE ===================="