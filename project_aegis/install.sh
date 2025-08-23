#!/usr/bin/env bash
set -euo pipefail

<<<<<<< HEAD
echo "[Reactive Badge Installer] Starting clean install..."

# 1. Remove existing Aegis software
echo "[1/5] Removing old Aegis directory if it exists..."
rm -rf "$HOME/Aegis"

# 2. Clone the GitHub repo
echo "[2/5] Cloning Aegis repo from GitHub..."
git clone https://github.com/iBlameMattheww/Aegis.git "$HOME/Aegis"
=======
echo "=== Reactive Badge Installer ==="

echo ">> Removing old Aegis directory..."
rm -rf "${HOME}/Aegis"
>>>>>>> 931f0ebd28402e21858e4b67656e32ec0fcc671b

echo ">> Cloning Aegis repository..."
git clone --depth 1 https://github.com/iBlameMattheww/Aegis.git "${HOME}/Aegis"

<<<<<<< HEAD
# 3. Install required system packages
echo "[3/5] Installing system packages..."
sudo apt update
sudo apt install -y python3-pip python3-venv git

# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install Python packages
=======
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
>>>>>>> 931f0ebd28402e21858e4b67656e32ec0fcc671b
pip install --upgrade pip

<<<<<<< HEAD
# 4. Remove Jetson references from Blinka
echo "[4/5] Removing Jetson references..."
find venv/lib/python3.11/site-packages/adafruit_blinka -type f -name "*.py" -exec sed -i '/Jetson/d' {} +
find venv/lib/python3.11/site-packages -type d -name "Jetson" -exec rm -rf {} +

# 5. Set up systemd service
echo "[5/5] Setting up systemd service..."

SERVICE_FILE="/etc/systemd/system/project_aegis.service"
sudo tee "$SERVICE_FILE" > /dev/null <<EOF
=======
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
>>>>>>> 931f0ebd28402e21858e4b67656e32ec0fcc671b
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

<<<<<<< HEAD
echo "Reactive Badge installation complete."
echo "Use 'sudo systemctl status project_aegis.service' to check the service status."
=======
echo "Reactive Badge installation complete!"
>>>>>>> 931f0ebd28402e21858e4b67656e32ec0fcc671b

