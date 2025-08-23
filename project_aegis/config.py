"""
Created on Mon Feb 10 01:52:18 2025

@author: iBlameMattheww
"""


#UPDATE_INTERVAL = 0.2  # Time between queries (seconds)

# OBD Connection Settings
OBD_USB_PORT = "/dev/rfcomm0"  # Updated
OBD_BAUD_RATE = 38400  # Standard baud rate
OBD_TIMEOUT = 5  # Timeout in seconds

OBD_POLL_INCREMENT = 0.05  # Increment for poll time on reconnect
OBD_POLL_DECAY_INTERVAL = 90  # Time after which poll time decreases
OBD_MIN_POLL = 0.2  # Minimum poll time in seconds

# LED Configuration
NUM_LEDS = 8  # Number of LEDs in the strip
LED_PIN = 18  # GPIO pin for the LED strip

# Brightness Thresholds
RPM_LOW = 1500
RPM_HIGH = 6000
THROTTLE_THRESHOLD = 40

# GPIO Pins
BUZZER_PIN = 24
LED_INDICATOR_PIN = 23
