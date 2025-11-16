#!/usr/bin/env bash
# INFO: This fixes an issue on sleep which I have on my Lenovo 16APK10

sudo tee /etc/modprobe.d/usb-xhci-quirk.conf >/dev/null <<'EOF'
# Prevent AMD xHCI controller from entering a broken D3cold low-power state.
# Without this quirk, the USB host controller dies on resume ("HC died"),
# causing Bluetooth and Wi-Fi (Realtek combo chip) to reinitialize slowly.
#
# This fixes slow WLAN reconnect after suspend which leaves the system unresponsive for a few second.

options xhci_hcd quirks=0x40

EOF

sudo mkinitcpio -P

echo "The system needs to be rebooted now."

