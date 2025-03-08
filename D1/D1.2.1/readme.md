# BCH Error Correction Coding System

## Overview
This project implements a BCH (Bose-Chaudhuri-Hocquenghem) error correction coding system in MATLAB. The system simulates the encoding, transmission through noisy channels, and decoding of digital data, demonstrating the error correction capabilities of BCH codes.

## BCH Codes
BCH codes are a class of cyclic error-correcting codes that can detect and correct multiple random error patterns. This implementation provides:
- BCH(n=31, k=26, t=1): Can correct up to 1 error in a 31-bit codeword
- BCH(n=31, k=21, t=2): Can correct up to 2 errors in a 31-bit codeword

## Features
- Random message generation
- BCH encoding with configurable error correction capability (t=1 or t=2)
- BPSK modulation for symbol transmission
- Gaussian noise channel simulation with variable SNR
- Maximum Likelihood (ML) decoding
- Performance analysis using Bit Error Rate (BER) measurements
- Graphical comparison of coded vs uncoded transmission

## Files Description

### Core Functions
- `BCH.m`: Implements the BCH encoding process
- `moduloG.m`: Performs polynomial division for BCH coding
- `ML.m`: Maximum Likelihood decoder for error correction
- `ML2.m`: Optimized ML decoder using pre-computed syndromes

### Modulation/Demodulation
- `bits2symbols.m`: Converts bit sequences to symbols (PAM, PSK, QAM)
- `symbols2bits.m`: Converts symbols back to bit sequences (not provided in files but referenced)
- `modulation.m`: Creates and modulates random message sequences
- `demodulation.m`: Demodulates received signals

### Channel Simulation
- `canal.m`: Simulates Gaussian noise channel with configurable noise levels

### Performance Evaluation
- `BER.m`: Calculates Bit Error Rate between transmitted and received data
- `initialisation_synd.m`: Pre-computes error syndromes for faster decoding

### Simulation Scripts
- `plot_programme_BCH.m`: Main simulation script (execution time ~1:36)
- `plot_programme_BCH_2.m`: Optimized simulation script using pre-computed syndromes (execution time ~27s)
- `test.m`: Simple test script for BCH coding and decoding

## How to Use

1. **Basic Test**:
   Run `test.m` to verify basic BCH encoding and decoding functionality.

2. **Performance Simulation**:
   - `plot_programme_BCH.m`: Standard simulation
   - `plot_programme_BCH_2.m`: Faster simulation using pre-computed syndromes

3. **Configure Parameters**:
   - `N`: Number of message sequences (default: 100)
   - `Nc`: Number of channel noise levels to test (default: 100)

## Results Interpretation

The simulation generates plots showing Bit Error Rate (BER) vs Signal-to-Noise Ratio (SNR) for:
- Uncoded transmission
- BCH t=1 (can correct 1 error)
- BCH t=2 (can correct 2 errors)

The plots demonstrate that BCH coding provides significant error correction capability, especially at higher SNR levels.

## Implementation Details

### Encoding Process
The BCH encoder adds parity bits to the message according to the BCH(31,k) polynomial. The implementation supports:
- 5 parity bits for t=1, resulting in 26 data bits
- 10 parity bits for t=2, resulting in 21 data bits

### Decoding Process
The decoder calculates the syndrome of the received codeword and compares it with known error patterns:
- For t=1: Tests all possible 1-bit error patterns
- For t=2: Tests all possible 1-bit and 2-bit error patterns
- If the syndrome matches a known error pattern, the errors are corrected

### Optimizations
`plot_programme_BCH_2.m` pre-computes all possible syndromes using `initialisation_synd.m`, reducing execution time significantly (from 1:36 to 27 seconds).

## Performance Analysis
The system performance can be evaluated by analyzing the BER vs SNR curves:
- Lower BER values indicate better performance
- The steeper the curve falls with increasing SNR, the more effective the coding scheme
- BCH(t=2) generally outperforms BCH(t=1), which outperforms uncoded transmission

## Dependencies
- MATLAB (tested on MATLAB R2024b or later)
