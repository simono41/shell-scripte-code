### shell-scripte
Nützliche shell-scripte

ssh tunnel vom server oder zum server
einrichten mit:

~~~
ssh-keygen -t rsa -b 4096 

ssh-copy-id -i ~/.ssh/id_rsa.pub user@server 
~~~

oder

~~~
cat id_rsa.pub | ssh server 'cat>> ~/.ssh/authorized_keys'
~~~

### Zum schreiben eines Passworts mittels eines virtuellen Keyboards

https://man.archlinux.org/man/ydotool.1

### ydotool

run deamon with:

~~~
echo '## Give ydotoold access to the uinput device
## Solution by https://github.com/ReimuNotMoe/ydotool/issues/25#issuecomment-535842993
KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"
' > /etc/udev/rules.d/80-uinput.rules
sudo usermod -G wheel,uinput simono41
sudo ydotoold
setxkbmap -query
WAYLAND_DISPLAY=wayland-0 localectl set-x11-keymap de
~~~

and run youre command

~~~
sleep 5 && XKB_DEFAULT_LAYOUT=de sudo ydotool type 'Hello World!' -d 20 && notify-send finish
~~~

### mit dotool

~~~
sleep 5 && { echo typedelay 100; echo type ${PASSWORT}; } | DOTOOL_XKB_LAYOUT=de dotool && notify-send done
~~~

### Zum suchen der libinput Treiber mit
~~~
libwacom-list-local-devices
for wort in /usr/share/libwacom/*; do if cat $wort | grep CTL-4100WL; then echo $wort; fi; done
~~~

### Port forwarding using OpenVPN client

~~~
vps# iptables -t nat -A PREROUTING  -p tcp --dport 9987 -j DNAT --to-destination 192.168.1.3 (mein Homeserver wenn ich richtig verstanden habe)
vps# iptables -t nat -A POSTROUTING -p tcp --dport 9987 -j MASQUERADE

vps# iptables -t nat -A PREROUTING  -p tcp --dport 30033 -j DNAT --to-destination 192.168.1.3
vps# iptables -t nat -A POSTROUTING -p tcp --dport 30033 -j MASQUERADE

vps# iptables -t nat -A PREROUTING  -p tcp --dport 10011 -j DNAT --to-destination 192.168.1.3
vps# iptables -t nat -A POSTROUTING -p tcp --dport 10011 -j MASQUERADE

sysctl -w net.ipv4.ip_forward=1

iptables -t nat -A PREROUTING -d 50.xxx.xxx.xxx -p tcp --dport 8081 -j DNAT --to-dest 192.168.2.86:8081

iptables -t nat -A POSTROUTING -d 192.168.2.86 -p tcp --dport 8081 -j SNAT --to-source 10.0.2.42
~~~

### Find and Remove old Syncthing Files
~~~
find -name "*.tmp" -exec rm -vf {} \;
~~~

### Setzt das Repository auf dem aktuellen HEAD zurück und löscht neue Dateien die bis dahin erzeugt wurden
~~~
git reset --hard 8& git clean -dfx
~~~

### Qemu chroot Raspberry PI
~~~
pacman -S qemu-user-static qemu-user-static-binfmt
https://wiki.archlinux.org/title/QEMU#Chrooting_into_arm/arm64_environment_from_x86_64
~~~