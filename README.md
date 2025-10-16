

# S4005EF — OpenWrt  Guide

**Target device:** S4005EF
**SoC:** MediaTek MT7620 (mt7620)
**Purpose:** Recover access, flash a custom image, and network configuration via UART.

---

## Prerequisites

* A TTL to USB serial adapter (3.3 V). This is mandatory for console access.
* A computer running Linux (or macOS/Windows with equivalent tools).
* `screen`, `hexdump`, `dd`, `binwalk` (optional), `hashcat` (optional).
* The vendor factory firmware binary or a full flash dump (`backup.bin`).
---

###  Prepare serial connection

1. Connect the TTL adapter to the router UART pins (RX, TX, GND).
2. On your PC identify the serial device (commonly `/dev/ttyUSB0` or `/dev/ttyACM0`).

Start a serial console:

```bash
sudo screen /dev/ttyUSB0 57600
```

the credentials for the webui are:

* **Username:** `R3000admin`
* **Password:** `admin`

###  Flash the system image

1. Log into the router web UI (vendor/admin page).
2. Upload the correct system upgrade image (follow vendor web UI steps).
3. After the device flashes and reboots, it will boot into a state with no functional network config. At this point you will need the UART.

### 5. Restore network configuration via UART console

1. Open serial console (as above).
2. Wait until the system boots and you see a login prompt. Press Enter 20 seconds after boot.
3. Remove the broken `network` config and replace it with a minimal working configuration:

Commands:

```sh
# backup current config
cp /etc/config/network /tmp/network.bak

# remove the file
rm /etc/config/network

# create a new minimal network config
cat > /etc/config/network <<'EOF'
config switch
    option name 'switch0'
    option reset '1'
    option enable_vlan '1'

config switch_vlan
    option device 'switch0'
    option vlan '1'
    option ports '0 1 2 3 6t'

config switch_vlan
    option device 'switch0'
    option vlan '2'
    option ports '4 6t'

config device
    option name 'br-lan'
    option type 'bridge'
    list ports 'eth0.1'

config interface 'lan'
    option device 'br-lan'
    option proto 'static'
    option ipaddr '192.168.1.1'
    option netmask '255.255.255.0'

config interface 'wan'
    option device 'eth0.2'
    option proto 'dhcp'
EOF
```
---

