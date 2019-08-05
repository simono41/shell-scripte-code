#!/bin/bash

set -ex

version="${1}"
[[ -z "${version}" ]] && version="${hostname#*-}"

# while-schleife
while (( "$#" ))
do
    echo ${1}
    export ${1}="y"
    shift
done

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 1>&2
    sudo "$0" "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9"
    exit 0
else
    echo "Als ROOT angemeldet!!!"
fi

function makesshsecure() {

    #sshd -T |grep permitrootlogin

    sed -e 's|PermitRootLogin=.*$|PermitRootLogin=\ no|' -i /etc/ssh/sshd_config
    sed -e 's|Port=.*$|Port=\ 2020|' -i /etc/ssh/sshd_config

    systemctl restart sshd.service

    cat /etc/services
}

function makesshsecure() {
    apt install tcpd -y

    nano -w /etc/hosts.allow

    nano -w /etc/hosts.deny
}

function makeiptables() {

    apt install iptables-persistent -y

    iptables-save > /etc/iptables/rules.v4
    ip6tables-save > /etc/iptables/rules.v6
}

function makefail2ban() {
    apt install fail2ban -y

    cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

    nano -w /etc/fail2ban/jail.local

    systemctl restart fail2ban.service
}

function makeuser() {
    apt install sudo
    if ! cat /etc/group | grep wheel; then
        groupadd wheel
    fi
    echo "root ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers
    echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
    adduser user1
    adduser user1 wheel
}

function userloginalert() {

    apt install finger -y
    echo "#!/bin/bash

echo "Login auf $(hostname) am $(date +%Y-%m-%d) um $(date +%H:%M)"
echo "Benutzer: $USER"
echo
    finger" >> /opt/shell-login.sh

    echo "/opt/shell-login.sh | mailx -s "SSH-Log-in auf ihrem Server $(cat /etc/hostname)" bahn01@online.de" > /etc/profile
    chmod 755 /opt/shell-login.sh

}

function dailyupdates() {

    echo "#!/bin/bash" > /etc/cron.daily/update-packages
    echo "apt update && apt upgrade -y" >> /etc/cron.daily/update-packages
    echo "ROOT" >> /etc/cron.daily/update-packages
    echo "EXITVALUE=\$?" >> /etc/cron.daily/update-packages
    echo "if [ \$EXITVALUE != 0 ]; then" >> /etc/cron.daily/update-packages
    echo "    /usr/bin/logger -t update-packages \"ALERT exited abnormally with [\$EXITVALUE]\"" >> /etc/cron.daily/update-packages
    echo "fi" >> /etc/cron.daily/update-packages
    echo "exit \$EXITVALUE" >> /etc/cron.daily/update-packages
    chmod +x /etc/cron.daily/update-packages

}

if [ "${makesshsecure}" == "y" ] || [ "${all}" == "y" ]; then
    makesshsecure
fi
if [ "${makeiptables}" == "y" ] || [ "${all}" == "y" ]; then
    makeiptables
fi
if [ "${makefail2ban}" == "y" ] || [ "${all}" == "y" ]; then
    makefail2ban
fi
if [ "${makeuser}" == "y" ] || [ "${all}" == "y" ]; then
    makeuser
fi
if [ "${userloginalert}" == "y" ] || [ "${all}" == "y" ]; then
    userloginalert
fi
if [ "${dailyupdates}" == "y" ] || [ "${all}" == "y" ]; then
    dailyupdates
fi
