# Massive MIMO: MRT vs ZF Precoding

MATLAB simulation of a multi-user Massive MIMO downlink that compares the spectral efficiency of two linear precoding schemes: Maximum Ratio Transmission (MRT) and Zero Forcing (ZF).

## Simulation setup
- 10 single-antenna users served by a base station with 32, 64 and 128 antennas
- Rayleigh fading channel with perfect channel state information (CSI) at the base station
- Each user's beam is normalised to unit power, so SNR is defined per user
- SNR range of 0 to 30 dB in 5 dB steps
- Spectral efficiency calculated from the Shannon capacity formula
- Results averaged over 200 random channel realisations per point (fixed seed for repeatability)

## How to run
1. Open `massive_mimo_mrt_zf.m` in MATLAB (no extra toolboxes needed).
2. Press **Run**.
3. The script plots sum spectral efficiency (bits/s/Hz) against SNR for ZF and MRT with 32, 64 and 128 antennas.

## Findings
- ZF gives higher spectral efficiency than MRT across the simulated range, and the gap grows with SNR.
- MRT saturates at high SNR because inter-user interference is not removed.
- Adding antennas improves both schemes, and ZF benefits the most.
- MRT needs far less computation (no matrix inversion), which makes it attractive for low-complexity or low-power systems.

## Assumptions and limitations
- Perfect CSI and ideal hardware (no estimation error, antenna correlation or synchronisation errors)
- Downlink only, with an i.i.d. Rayleigh fading channel

## Background
Done as a Summer Industry Internship project at the Department of ECE, Sreenidhi Institute of Science and Technology (SNIST), as a team of three.

## Author
B. Harshit
