% MASSIVE MIMO PROJECT (MRT vs ZF Precoding)
% Spectral Efficiency vs SNR Simulation (Monte Carlo averaged)
%
% Downlink model: K single-antenna users, M base-station antennas,
% Rayleigh fading channel, perfect CSI at the base station.
% SNR is per user: each user's beam is normalised to unit power.

clc;
clear;
rng(1);                     % fixed seed so results are repeatable

% Step-1: Basic parameters
K = 10;                     % number of users
M_values = [32 64 128];     % number of BS antennas
SNRdB = 0:5:30;             % SNR range in dB
SNR = 10.^(SNRdB/10);       % converting dB to linear scale
N = 200;                    % number of random channel realisations per point

% To store results
SE_MRT = zeros(length(M_values), length(SNRdB));
SE_ZF  = zeros(length(M_values), length(SNRdB));

% Step-2: Loop over antenna configurations and SNR values
for m = 1:length(M_values)

    M = M_values(m);

    for s = 1:length(SNR)

        rho = SNR(s);
        se_mrt = 0;
        se_zf  = 0;

        for n = 1:N

            % Step-3: Rayleigh fading channel matrix (K x M)
            H = (randn(K,M) + 1i * randn(K,M)) / sqrt(2);

            % ===================== MRT Precoding =====================
            Wmrt = H';                       % conjugate transpose
            Wmrt = Wmrt ./ vecnorm(Wmrt);    % power normalisation

            HWmrt = H * Wmrt;
            signal_mrt = abs(diag(HWmrt)).^2;
            interference_mrt = sum(abs(HWmrt).^2, 2) - signal_mrt;
            se_mrt = se_mrt + sum(log2(1 + (rho .* signal_mrt) ./ (1 + rho .* interference_mrt)));

            % ===================== ZF Precoding ======================
            Wzf = H' / (H * H');             % H^H (H H^H)^(-1)
            Wzf = Wzf ./ vecnorm(Wzf);       % power normalisation

            HWzf = H * Wzf;
            signal_zf = abs(diag(HWzf)).^2;
            interference_zf = sum(abs(HWzf).^2, 2) - signal_zf;
            se_zf = se_zf + sum(log2(1 + (rho .* signal_zf) ./ (1 + rho .* interference_zf)));

        end

        % Average over all channel realisations
        SE_MRT(m, s) = se_mrt / N;
        SE_ZF(m, s)  = se_zf  / N;

    end
end

% Step-4: Plot results
figure;
hold on;

% ZF curves (solid lines)
plot(SNRdB, SE_ZF(1,:), '-o', 'LineWidth', 1.5);
plot(SNRdB, SE_ZF(2,:), '-s', 'LineWidth', 1.5);
plot(SNRdB, SE_ZF(3,:), '-^', 'LineWidth', 1.5);

% MRT curves (dashed lines)
plot(SNRdB, SE_MRT(1,:), '--o', 'LineWidth', 1.5);
plot(SNRdB, SE_MRT(2,:), '--s', 'LineWidth', 1.5);
plot(SNRdB, SE_MRT(3,:), '--^', 'LineWidth', 1.5);

xlabel('SNR (dB)');
ylabel('Sum Spectral Efficiency (bits/s/Hz)');
title('Massive MIMO Spectral Efficiency (MRT vs ZF), K = 10 users');
legend('ZF-32','ZF-64','ZF-128','MRT-32','MRT-64','MRT-128','Location','northwest');
grid on;
