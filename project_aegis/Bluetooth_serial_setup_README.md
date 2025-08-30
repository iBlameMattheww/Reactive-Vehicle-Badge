# Manual Bluetooth Setup for Reactive Mustang Badge

After running `install.sh`, follow these steps to manually connect your OBD adapter via Bluetooth or serially.

---

## 1. Clean Bluetooth Reset

```bash
sudo systemctl restart bluetooth
```

---

## 2. Enter Bluetooth Control Shell

```bash
bluetoothctl
```

### In the shell, run:

```text
power on
agent on
default-agent
scan on
```

Wait until you see your adapter (e.g.):
```
13:E0:2F:8D:5E:DB Android-Vlink
```

---

## 3. Pair and Trust the Adapter

```text
pair 13:E0:2F:8D:5E:DB
trust 13:E0:2F:8D:5E:DB
info 13:E0:2F:8D:5E:DB
```

Look for this line in the info output:
```
UUID: Serial Port (00001101-0000-1000-8000-00805f9b34fb)
```
This means your adapter supports the classic SPP profile.

---

## 4. Bind the Serial Port

Make a custom unit:
```bash
sudo nano /etc/systemd/system/rfcomm-obd.service
```
Paste:
```bash
[Unit]
Description=Bind RFCOMM for OBD-II Adapter
After=bluetooth.target
Requires=bluetooth.service

[Service]
Type=oneshot
ExecStartPre=/bin/sh -c 'echo -e "connect 13:E0:2F:8D:5E:DB\nquit" | bluetoothctl'
ExecStart=/usr/bin/rfcomm bind 0 13:E0:2F:8D:5E:DB
ExecStop=/usr/bin/rfcomm release 0
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```
Enable + start:
```bash
sudo systemctl daemon-reexec
sudo systemctl enable rfcomm-obd.service
sudo systemctl start rfcomm-obd.service
```
Verify:
```bash
systemctl status rfcomm-obd.service
ls -l /dev/rfcomm*
```
If it worked, you should see /dev/rfcomm0 bound.

---

## 5. Reboot

```bash
sudo reboot
```

---

## 6. Check Service Logs

After reboot, check the status of your badge service:

```bash
sudo journalctl -u project_aegis.service -n 50
```

You should see lines like:
```
Status: CONNECTED, RPM: 0, Throttle: 0.0
```

---
## Serial Port Setup on Raspberry Pi

By default, the Reactive Badge daemon uses the Bluetooth RFCOMM device:

```python
OBD_USB_PORT = "/dev/rfcomm0"
```

When using a USB serial connection instead, the port will show up under `/dev/serial/by-id/`.  
This is more reliable than `/dev/ttyUSB0` because it persists across reboots and multiple USB devices.

---

### 1. Identify the Port

Run:

```bash
ls -l /dev/serial/by-id/
```

**Example output:**

```text
usb-1a86_USB_Serial-if00-port0 -> ../../ttyUSB0
```

In this case, set:

```python
OBD_USB_PORT = "/dev/serial/by-id/usb-1a86_USB_Serial-if00-port0"
```

---

### 2. Fallback Options

If `/dev/serial/by-id/` is not available, you can also check:

- `/dev/ttyGS0` &rarr; USB gadget serial (Zero 2W direct USB)
- `/dev/ttyUSB0` or `/dev/ttyACM0` &rarr; USB-UART adapters

---

## Troubleshooting

- Make sure your BLE ELM327 adapter is powered and in pairing mode.
- If you don’t see `/dev/rfcomm0`, repeat the binding step.
