# Wireless Communication System Simulation

This repository contains MATLAB code for simulating a complete wireless communication chain, including transmission, channel effects, and reception. The system implements various signal processing techniques such as modulation, filtering, amplification, and error correction.

## Project Overview

The simulation models a complete end-to-end wireless communication system with the following components:

- **Signal Generation**: Creates different test signals including one-tone, two-tone, modulated QAM, and image transmission
- **Digital Signal Processing**: RRC filtering, upsampling, and baseband signal processing
- **Digital-to-Analog Conversion**: Models DAC with configurable bit resolution
- **RF Transmission**: Implements mixing to RF frequencies and power amplification
- **Channel Modeling**: Simulates wireless channel effects including path loss and noise
- **Receiver Chain**: LNA, downmixing, filtering, amplification, and ADC
- **Signal Recovery**: Demodulation and error correction
- **Performance Analysis**: Calculates SNR, ACPR, and BER metrics

## Main Features

- **Configurable Parameters**: Adjustable sampling rates, modulation orders, filter characteristics, etc.
- **Multiple PA Models**: Five different power amplifier models with varying characteristics
- **BCH Error Correction**: Implements error detection and correction with configurable correction capability
- **Image Transmission**: Can transmit and receive image data using QAM modulation
- **Performance Metrics**: Calculates and displays SNR, ACPR, BER, etc.

## File Descriptions

- **completeTxRx_proj.m**: Main script that runs the full communication chain simulation
- **ACPRvsNbits.m**: Analyzes the relationship between DAC bit resolution and ACPR
- **BCH.m**: Implements BCH encoding functionality
- **BER.m**: Calculates Bit Error Rate between original and received bits
- **calculate_snr.m**: Function to calculate signal-to-noise ratio
- **initialisation_synd.m**: Initializes syndrome tables for BCH decoding
- **ML2.m**: Maximum likelihood decoder for BCH codes
- **moduloG.m**: Implements modulo G operation for BCH encoding/decoding
- **subblocks/**: Directory containing all component blocks required by `completeTxRx_proj.m`, in addition to those already listed  

## Usage

1. Set desired parameters in the `completeTxRx_proj.m` script:
   - Test type ('onetone', 'twotone', 'mod', or 'image')
   - Error correction mode (CODAGE parameter: 0, 1, or 2)
   - Sampling rates, bit resolutions, etc.

2. Run the main script:
   ```matlab
   completeTxRx_proj
   ```

3. The script will generate plots showing:
   - Signal spectra at different points in the chain
   - Constellation diagrams (for modulated signals)
   - Received image (for image transmission)

## Key Parameters

- **nBitDAC**: Number of bits for Digital-to-Analog Conversion (default: 9)
- **nBitADC**: Number of bits for Analog-to-Digital Conversion (default: 13)
- **CODAGE**: Error correction capability (0: none, 1: single error, 2: double error)
- **PA_model**: Power amplifier model selection (1-5)
- **rollOff**: Roll-off factor for RRC filter
- **symbolRate**: Raw symbol rate (default: 15MHz)

## Performance Metrics

The simulation calculates several key performance metrics:
- Signal power
- Signal-to-Noise Ratio (SNR)
- Signal-to-Noise-and-Distortion Ratio (SNDR)
- Adjacent Channel Power Ratio (ACPR)
- Bit Error Rate (BER) for image transmission

## Requirements

- MATLAB (script has been tested for compatibility with both MATLAB and Octave)
- MATLAB Signal Processing Toolbox
- Image Processing Toolbox (for image transmission functionality)

## Note

This code is designed for educational purposes to demonstrate wireless communication principles and system-level design considerations. Parameters may need adjustment for specific application scenarios.