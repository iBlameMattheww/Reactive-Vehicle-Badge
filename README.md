# Reactive-Vehicle-Badge

The Reactive Mustang Badge is a custom smart 5.0L coyote emblem designed for Mustang vehicles (tested on the 5.0/GT platform). It dynamically lights up in response to live OBD-II data such as RPM and throttle position, making your rear badge come alive with your driving style.

This project was built specifically around the Coyote pony badge dimensions, and the included CAD and STL files match that fitment. However, the electronics and code are fully adaptable — if you want to customize the mechanical design for a different badge or vehicle, the files provide a starting point.

This project combines electronics, embedded systems, and mechanical design to deliver a reactive, customizable badge that you can tune to your own preferences.


<p align="center">
    <img src="picsNvids/vid.gif" alt="Mustang GT 5.0 Revving Reactive Badge Live GIF" width="300"/>

</p>

Full video with sound here: 
## Features

* LED pony badge that reacts to RPM and throttle input.
* OBD-II integration (Bluetooth or Serial via ELM327 OBD-II adapter).
* Configurable brightness scaling and animations.
* Fully open-source mechanical + electrical design.
* Easy customization via code snippets.

## Hardware

| Component          | Part Used (Our Build)                                             | Notes                                                |
| ------------------ | ----------------------------------------------------------------- | ---------------------------------------------------- |
| **MCU**            | Raspberry Pi Zero 2W                                              | Runs the Python control code and BLE pairing         |
| **OBD-II Adapter** | iCar Pro Vgate BLE (ELM327-based)                                 | Provides live RPM/throttle data via Bluetooth        |
| **LEDs**           | WS2812B (Neopixels)                                               | Individually addressable RGB LEDs for badge lighting |
| **Diode**          | SR560 Schottky                                                    | For Vin on our Neopixels                             |
| **Cigarette Lighter to USB Adapter**   | Kewig Car Charger, 36W Fast Dual USB w/ Voltmeter & On/Off Switch | Powered via cigarette lighter to USB                 |
| **Buzzer + LED**   | Generic 5V buzzer + LED                                           | Used for startup/alert feedback (UI)                 |
| **Resistor**       | 100 Ω                                                             | Current limiting; shared by buzzer and LED           |


Schematic


(Replace this with actual KiCad schematic export)
