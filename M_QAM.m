clc;
close all;

FRM=2048;

MaxNumErrs=100;
MaxNumBits=1e5;

EbNo_vector = 0:1:10;
BER_vector=zeros(size(EbNo_vector));

EbNolin = 10.^(EbNo_vector/10);
colors = {'k-*', 'g-o', 'r-h', 'c-d'};
index = 1;

%% Initializations

Modulator = comm.GeneralQAMModulator;
AWGN = comm.AWGNChannel;
DeModulator = comm.GeneralQAMDemodulator;
BitError = comm.ErrorRate;

%% Outer Loop computing Bit-error rate as a function of EbNo

for EbNo = EbNo_vector
    snr = EbNo + 10*log10(2);
    AWGN.EbNo=snr;
    numErrs = 0; 
    numBits = 0;
    results=zeros(3,1);


%% Inner loop modeling transmitter, channel model and receiver for each EbNo

    while ((numErrs < MaxNumErrs) && (numBits < MaxNumBits))

    % Transmitter
        u = randi([0 1], FRM,1); % Generate random bits
        mod_sig = step(Modulator, u); % QPSK Modulator
    % Channel
        rx_sig = step(AWGN, mod_sig); % AWGN channel
    % Receiver
        y = step(DeModulator, rx_sig); % QPSK Demodulator
        results = step(BitError, u, y); % Update BER
        numErrs = results(2);
        numBits = results(3);
    end
    
    % Compute BER

    ber = results(1); 
    bits= results(3);
    
    
%% Clean up & collect results
    reset(BitError);
    BER_vector(EbNo+1)=ber;
    
end

plotHandle = plot(EbNo_vector, BER_vector,char(colors(index)));
set(plotHandle, 'LineWidth', 1.5);
hold on;
index = index + 1


%% M-QAM 

m = 2:2:6; %% when m = 2 , M = 4 , mod = QAM, when m = 4 , M = 16 , mod = 16 QAM,, when m = 6 , M = 64 , mod = 64-QAM  
M = 2.^m;
for i = M
    k = log2(i);
    berErr = 1/k*(1-1/sqrt(i))*erfc(sqrt(3*EbNolin*k/(2*(i-1))));
    plotHandle = plot(EbNo_vector, log10(berErr), char(colors(index)));
    set(plotHandle, 'LineWidth', 1.5);
    index = index + 1;
    hold on;
end

legend('QAM', '4-QAM', '16-QAM', '64-QAM');
set(gca, 'XTick', 0:10);
title('BER vs. EbNo - QAM modulation');
ylabel('Probability of BER Error - log10(Pb)');
xlabel('Ev/No')
grid on;



