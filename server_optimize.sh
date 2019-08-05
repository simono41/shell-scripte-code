#!/bin/bash

set -ex

version="${1}"
[[ -z "${version}" ]] && version="${hostname#*-}"

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 1>&2
    sudo "$0" "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9"
    exit 0
else
    echo "Als ROOT angemeldet!!!"
fi
echo "Als root Angemeldet"

if [ -z "${hostname}" ]; then
    if [ -f "/usr/bin/systemctl" ]; then
        if [ -f "/etc/hostname.example" ]; then
            hostname="$(cat /etc/hostname.example)"
        else
            cp /etc/hostname /etc/hostname.example
            hostname="$(cat /etc/hostname)"
        fi
    else
        if ! [ -f "/etc/conf.d/hostname.example" ]; then
            cp /etc/conf.d/hostname /etc/conf.d/hostname.example
        fi
        temphostname="$(cat /etc/conf.d/hostname.example)"
        #hostname="${temphostname%?}"
        hostname="${temphostname:10:$((${#temphostname})) - 11}"
    fi
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
    echo "%wheel ALL=(ALL)" >> /etc/sudoers
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

makesshsecure
sleep 1
makeiptables
sleep 1
makefail2ban
sleep 1
makeuser
sleep 1
