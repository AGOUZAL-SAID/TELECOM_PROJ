# BCH Error Correction Coding System

## Overview
This project implements a BCH (Bose-Chaudhuri-Hocquenghem) error correction coding system in MATLAB. The system simulates the encoding, transmission through noisy channels, and decoding of digital data, demonstrating the error correction capabilities of BCH codes with additional ARQ (Automatic Repeat Request) functionality and advanced equalization techniques.

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
- ARQ (Automatic Repeat Request) mechanism for error handling
- Advanced equalization techniques (Zero Forcing and Decision Feedback)

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
- `selective_canal.m`: Simulates Gaussian noise channel (0) & selective channels (1,2 & 3)
- `canal_ARQ.m`: Implements a channel with ARQ functionality, adding Gaussian noise to symbols and returning the noisy signal

### Equalization Techniques
- `ZFE_perso.m`: Implements Zero Forcing Equalization, computing the pseudo-inverse of the channel matrix and applying threshold detection
- `DFE_pers.m`: Implements Decision Feedback Equalization using QR decomposition for more robust signal recovery in noisy conditions
- `threshold_detector.m`: Applies decision thresholds based on modulation scheme (referenced but not provided in files)

### Performance Evaluation
- `BER.m`: Calculates Bit Error Rate between transmitted and received data
- `initialisation_synd.m`: Pre-computes error syndromes for faster decoding

### Simulation Scripts
- `plot_programme_BCH.m`: Main simulation script (execution time ~1:36)
- `plot_programme_BCH_2.m`: Optimized simulation script using pre-computed syndromes (execution time ~27s)
- `plot_programme_BCH_ARQ.m`: Extended simulation incorporating ARQ functionality with automatic retransmission on error detection (execution time ~27s)
- `test.m`: Simple test script for BCH coding and decoding

## How to Use

1. **Basic Test**:
   Run `test.m` to verify basic BCH encoding and decoding functionality.

2. **Performance Simulation**:
   - `plot_programme_BCH.m`: Standard simulation
   - `plot_programme_BCH_2.m`: Faster simulation using pre-computed syndromes
   - `plot_programme_BCH_ARQ.m`: Simulation with ARQ functionality

3. **Configure Parameters**:
   - `N`: Number of message sequences (default: 1000)
   - `Nc`: Number of channel noise levels to test (default: 100)
   - `min_N0`: Minimum noise level (default: 0.1)
   - `mod`: Modulation type (default: 'PSK')
   - `M`: Constellation size (default: 2 for BPSK)
   - `canal`: Channel type (default: 0 for AWGN)
   - `Equalizer`: Equalization method (0 for none, other values for different techniques)

## Advanced Features

### ARQ Implementation
The Automatic Repeat Request (ARQ) mechanism in `canal_ARQ.m` and `plot_programme_BCH_ARQ.m` allows for:
- Error detection on received sequences
- Automatic retransmission when errors are detected
- Performance improvement through retransmission of corrupted data

### Equalization Techniques
Two main equalization techniques are implemented:

1. **Zero Forcing Equalization (ZFE_perso.m)**:
   - Computes the pseudo-inverse of the channel matrix
   - Applies the inverse to the received signal to recover transmitted symbols
   - Performs threshold detection to obtain the final symbol decisions

2. **Decision Feedback Equalization (DFE_pers.m)**:
   - Uses QR decomposition for improved numerical stability
   - Implements a feedback loop to cancel known interference
   - Processes symbols in reverse order (from last to first)
   - Offers better performance than ZFE in channels with severe intersymbol interference

## Results Interpretation

The simulation generates plots showing:
- Bit Error Rate (BER) vs Signal-to-Noise Ratio (SNR) for uncoded and BCH-coded transmission
- Empirical coding gain compared to theoretical gain
- Performance improvements with ARQ implementation

The plots demonstrate that BCH coding with ARQ provides significant error correction capability, especially at higher SNR levels.

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

### ARQ Process
When a transmission error is detected:
1. The system requests a retransmission
2. The original data is resent through the channel
3. The new received data is processed again

### Optimizations
- `plot_programme_BCH_2.m` pre-computes all possible syndromes using `initialisation_synd.m`
- `plot_programme_BCH_ARQ.m` extends this optimization with ARQ functionality

## Performance Analysis
The system performance can be evaluated by analyzing the BER vs SNR curves:
- Lower BER values indicate better performance
- The steeper the curve falls with increasing SNR, the more effective the coding scheme
- BCH(t=2) generally outperforms BCH(t=1), which outperforms uncoded transmission
- ARQ implementation further improves performance by retransmitting corrupted data

## Dependencies
- MATLAB (tested on MATLAB R2024b or later)
- Curve Filtering Toolbox for the function "smooth()"