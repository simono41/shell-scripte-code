# shell-scripte
Nützliche shell-scripte

ssh tunnel vom server oder zum server
einrichten mit:

ssh-keygen -t rsa -b 4096 

ssh-copy-id -i ~/.ssh/id_rsa.pub user@server 

oder

cat id_rsa.pub | ssh server 'cat>> ~/.ssh/authorized_keys'

# Zum suchen der libinput Treiber mit
libwacom-list-local-devices
for wort in /usr/share/libwacom/*; do if cat $wort | grep CTL-4100WL; then echo $wort; fi; done
