"""
Created on Mon Feb 10 01:52:18 2025

@author: iBlameMattheww
"""

from config import RPM_LOW, RPM_HIGH, THROTTLE_THRESHOLD

class BrightnessCalculator:

    lastBrightness = 0

    @staticmethod
    def calculate_brightness(rpm, throttle):
        """Determines brightness level based on RPM & Throttle Position"""
        if rpm == 0:
            BrightnessCalculator.lastBrightness = 0
            return 0 
             # Engine is off
        
        if rpm < RPM_LOW or throttle < THROTTLE_THRESHOLD:
            BrightnessCalculator.lastBrightness = max(0, BrightnessCalculator.lastBrightness - 15)
            return BrightnessCalculator.lastBrightness
        
        if RPM_LOW <= rpm <= RPM_HIGH:
            x = rpm / RPM_HIGH
            y = throttle / 100
            BrightnessCalculator.lastBrightness = int(255 * ((0.6 * x) + (0.4 * y)))
            return BrightnessCalculator.lastBrightness
        
        BrightnessCalculator.lastBrightness = 255
        return BrightnessCalculator.lastBrightness
