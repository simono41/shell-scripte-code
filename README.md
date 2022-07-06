### shell-scripte
Nützliche shell-scripte

ssh tunnel vom server oder zum server
einrichten mit:

ssh-keygen -t rsa -b 4096 

ssh-copy-id -i ~/.ssh/id_rsa.pub user@server 

oder

cat id_rsa.pub | ssh server 'cat>> ~/.ssh/authorized_keys'

### Zum suchen der libinput Treiber mit
libwacom-list-local-devices
for wort in /usr/share/libwacom/*; do if cat $wort | grep CTL-4100WL; then echo $wort; fi; done

### Port forwarding using OpenVPN client

vps# iptables -t nat -A PREROUTING  -p tcp --dport 9987 -j DNAT --to-destination 192.168.1.3 (mein Homeserver wenn ich richtig verstanden habe)
vps# iptables -t nat -A POSTROUTING -p tcp --dport 9987 -j MASQUERADE

vps# iptables -t nat -A PREROUTING  -p tcp --dport 30033 -j DNAT --to-destination 192.168.1.3
vps# iptables -t nat -A POSTROUTING -p tcp --dport 30033 -j MASQUERADE

vps# iptables -t nat -A PREROUTING  -p tcp --dport 10011 -j DNAT --to-destination 192.168.1.3
vps# iptables -t nat -A POSTROUTING -p tcp --dport 10011 -j MASQUERADE

sysctl -w net.ipv4.ip_forward=1

iptables -t nat -A PREROUTING -d 50.xxx.xxx.xxx -p tcp --dport 8081 -j DNAT --to-dest 192.168.2.86:8081

iptables -t nat -A POSTROUTING -d 192.168.2.86 -p tcp --dport 8081 -j SNAT --to-source 10.0.2.42

### Find and Remove old Syncthing Files
find -name "*.tmp" -exec rm -vf {} \;
