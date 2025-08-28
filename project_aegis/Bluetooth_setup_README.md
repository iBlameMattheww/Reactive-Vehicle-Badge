# Manual Bluetooth Setup for Reactive Mustang Badge

After running `install.sh`, follow these steps to manually connect your Android-Vlink OBD adapter via Bluetooth.

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

```bash
sudo rfcomm bind 0 13:E0:2F:8D:5E:DB
ls /dev/rfcomm*
```

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

## Troubleshooting

- Make sure your BLE ELM327 adapter is powered and in pairing mode.
- If you don’t see `/dev/rfcomm0`, repeat the binding step.
