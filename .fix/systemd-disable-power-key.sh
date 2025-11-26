#!/usr/bin/env bash

# INFO: They put the fucking Power Key of my Lenovo 16APK10 on the right side of the chassis.
#       This leads to accidentally shutting down my system when the device sits in my lap.
#
# See https://www.freedesktop.org/software/systemd/man/latest/logind.conf.html

sudo mkdir -p /etc/systemd/logind.conf.d
sudo tee /etc/systemd/logind.conf.d/ignore-power-key.conf >/dev/null <<EOF
[Login]
HandleHibernateKey=ignore
HandlePowerKey=ignore
HandleRebootKey=ignore
HandleSuspendKey=ignore

HandleHibernateKeyLongPress=ignore
HandlePowerKeyLongPress=ignore
HandleRebootKeyLongPress=ignore
HandleSuspendKeyLongPress=ignore

EOF

echo "The system needs to be rebooted now."

