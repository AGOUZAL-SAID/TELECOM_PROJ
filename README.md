# TELECOM_PROJ

This repository contains a set of projects and simulations related to telecommunications, primarily implemented in MATLAB. It covers various aspects of channel modeling, optical communication system performance, and signal analysis.

## Repository Structure

The repository is organized into several directories, each corresponding to a specific part of the project.

### `D1`

This directory contains MATLAB scripts for basic signal processing and communication functions, such as:

*   `ask_mod.m`, `fsk_mod.m`, `psk_mod.m`: ASK, FSK, and PSK modulation functions.
*   `demod.m`: Generic demodulation function.
*   `gen_signal.m`: Signal generation.
*   `matched_filter.m`: Matched filter implementation.
*   `QAM_mod.m`, `QAM_demod.m`: QAM modulation and demodulation functions.
*   `signal_gen.m`: Various signal generation.
*   `D1.pdf`: A PDF document that contain explanations or results related to this module.

### `D2`

This directory is dedicated to channel modeling and performance analysis of RF communication. It includes:

    *   `quadriga_src`: The QuaDRiGa source code, with channel configurations (`config/*.conf`) and tutorial scripts (`tutorials/*.m`).
*   **`subblocks/signal_analysis_and_performance_function`**: Scripts for spectral analysis and performance estimation.
    *   `perf_estim.m`, `plot_spectrum.m`, `simple_plot_spectrum.m`, `simple_raw_spectrum.m`.
    *   `D2.pdf`: A PDF document that contain explanations or results related to this module.

### `D3`

This module focuses on optical communication systems, with simulations of optical fiber and optoelectronic components. It contains:

*   `BER_Wf.m`, `BER_with_fiber.m`, `BER_with_fiber_direct.m`: Bit Error Rate (BER) calculation with and without optical fiber.
*   `egalizateur.m`: Equalizer implementation.
*   `fiber.m`, `fiber_PMDCF.m`, `fiber_o.m`: Optical fiber models.
*   `make_emlaser.m`, `make_laser_simple.m`, `make_photodetector.m`: Functions to model lasers and photodetectors.
*   `model.m`, `model_band_O.m`, `model_equalizer.m`: Optical system models.
*   `RX_photodetector.m`, `TX_optical_dml.m`, `TX_optical_eml.m`: Optical receiver and transmitter models.
*   `D3.pdf`: A PDF document that contain explanations or results related to this module.

### `D4`

This directory contains scripts for performance of emmission using different bit rate and different modulation, including:

*   `d4_perfs_students.m`, `rejection_per_debits.m`: Scripts to evaluate performance based on data rates.
*   `D4.pdf`: A PDF document that contain explanations or results related to this module.

### `ref`

This directory contains references or examples, such as the `git-homework` subdirectory with MATLAB scripts for calculating and displaying the Mandelbrot set (`mandelbrot_calc.m`, `mandelbrot_display.m`).

## Usage

To use the scripts, navigate to the desired module directory and run the corresponding `.m` files in a MATLAB environment. PDF files (`D3.pdf`, `D4.pdf`) may provide additional information on the objectives and results of the simulations.
