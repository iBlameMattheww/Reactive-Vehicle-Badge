#!/usr/bin/env bash
set -euo pipefail

echo "=== Reactive Badge Installer ==="

sudo apt-get update
sudo apt-get install -y git

echo ">> (Optional) Installing Bluetooth and BLE tools"
sudo apt-get install -y bluetooth bluez bluez-tools rfkill

echo ">> Scanning for Android-Vlink Bluetooth adapter..."
timeout 30s bluetoothctl scan on
sleep 5
Device_MAC=$(bluetoothctl devices | grep -i "Android-Vlink" | awk '{print $2}' | head -n1)

set +e
if [ -n "${Device_MAC}" ]; then
  echo ">> Android-Vlink Bluetooth adapter found."
  echo ">> Pairing with $Device_MAC..."
  if bluetoothctl pair "$Device_MAC"; then
    sleep 2
    echo ">> Trusting $Device_MAC..."
    if bluetoothctl trust "$Device_MAC"; then
      sleep 2
      echo ">> Connecting to $Device_MAC..."
      if bluetoothctl connect "$Device_MAC"; then
        echo ">> Successfully paired, trusted, and connected to $Device_MAC."
        BLE_Configured=true
      else
        echo "!! Failed to connect to $Device_MAC."
        BLE_Configured=false
      fi
    else
      echo "!! Failed to trust $Device_MAC."
      BLE_Configured=false
    fi
  else
    echo "!! Failed to pair with $Device_MAC."
    BLE_Configured=false
  fi
else
  echo ">> Bluetooth adapter not found. BLE setup will be skipped."
  BLE_Configured=false
fi
set -e

echo ">> Unblocking Bluetooth if needed..."
sudo rfkill unblock bluetooth

echo ">> Removing old Aegis directory..."
rm -rf "${HOME}/Aegis"

echo ">> Cloning Aegis repository..."
git clone --depth 1 https://github.com/iBlameMattheww/Reactive-Vehicle-Badge.git "${HOME}/Aegis"

echo ">> Installing system packages..."
sudo apt-get update
sudo apt-get install -y \
  python3 \
  python3-venv \
  python3-pip \
  python3-dev \
  python3-rpi.gpio \
  git \
  build-essential

echo ">> Removing old virtual environment..."
rm -rf "${HOME}/Aegis/project_aegis/venv"

echo ">> Creating Python virtual environment..."
python3 -m venv "${HOME}/Aegis/project_aegis/venv"

echo ">> Activating virtual environment..."
# shellcheck disable=SC1090
source "${HOME}/Aegis/project_aegis/venv/bin/activate"
pip install --upgrade pip

echo ">> Uninstalling any pip-installed Jetson.GPIO & RPi.GPIO..."
pip uninstall -y Jetson.GPIO RPi.GPIO || true

echo ">> Installing project requirements..."
pip install -r "${HOME}/Aegis/project_aegis/requirements.txt"

echo ">> Symlinking system RPi.GPIO into venv..."
VENV_SITE="$HOME/Aegis/project_aegis/venv/lib/python3.11/site-packages"
rm -rf "${VENV_SITE}/RPi" "${VENV_SITE}/RPi.GPIO*"
ln -s /usr/lib/python3/dist-packages/RPi "${VENV_SITE}/RPi"

echo ">> Installing Blinka & NeoPixel via pip..."
pip install \
  adafruit-blinka \
  adafruit-circuitpython-neopixel

echo ">> Writing systemd service file..."
SERVICE_PATH="/etc/systemd/system/project_aegis.service"
sudo tee "${SERVICE_PATH}" > /dev/null <<EOF
[Unit]
Description=Reactive Badge Startup
After=network.target

[Service]
WorkingDirectory=${HOME}/Aegis/project_aegis
ExecStart=${HOME}/Aegis/project_aegis/venv/bin/python3 ${HOME}/Aegis/project_aegis/main.py
Restart=always
User=root
Environment=PYTHONUNBUFFERED=1

[Install]
WantedBy=multi-user.target
EOF

echo ">> Reloading systemd, enabling & starting service..."
sudo systemctl daemon-reload
sudo systemctl enable project_aegis.service
sudo systemctl restart project_aegis.service

echo "Reactive Badge installation complete!"
if [ "${BLE_Configured}" = false ]; then
  echo "Bluetooth setup was skipped. For more details on how to manually set up Bluetooth or serial, please refer to the documentation:" # add link when done
fi
