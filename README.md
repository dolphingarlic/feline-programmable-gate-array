# Feline Programmable Gate Array

It is well-known that cats are four-stage finite state machines wrapped in fur: they can recognize their owner’s voice, move toward that voice, get distracted by red laser dots, and meow. As such, this project aims to build a robotic cat that can identify and move toward its owner's voice.

To achieve this goal, we use a Xilinx Spartan-7 FPGA on a RealDigital Urbana board. FPGAs are ideal for this project because they support a wide range of sensors and outputs (e.g., microphones and Bluetooth) and can process sensor inputs in real-time. Thanks to this real-time signal processing capability, we can implement features like sound localization that would otherwise be difficult on the traditional von Neumann architecture.

## Features

- [x] I2S-driven audio capture
- [x] Finite impulse response audio anti-aliasing
- [x] Bluetooth wireless communications
- [x] Real-time mel-frequency cepstrum coefficient feature extraction
- [x] Asynchronous (software-based) linear SVM training
- [x] Real-time linear SVM-based inference
- [ ] Real-time audio localization
- [ ] Autonomous servomotor controls
- [ ] Real-time image recognition
- [x] Audio playback
