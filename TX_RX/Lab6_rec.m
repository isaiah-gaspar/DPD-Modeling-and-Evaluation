clc;
clear;
% Use this to generate the same bits every time to avoid overwrite the file bits.mat
% Specified variables
nTrSyms = 64;         % number of training symbols
sps = 4;              % samples per symbol
filterSpan = 10;      % span of filter in symbol durations
rolloffFactor = 0.3;  % root-raised cosine filter roll-off factor
fSym = 25e3;         % symbol rate
nDataBits = 1024;     % number of bits in our sequence
modType = 'bpsk'; 
% modulation type can be 'bqsk', 'qpsk', or '16qam'
rng(255);
n=7;
k=4;

% Derived variables
rrcosFilter = rcosdesign(rolloffFactor, 10, sps); % filter coefficients
fSample = fSym*sps; % sample rate
filterLen = length(rrcosFilter); % number of taps in our FIR filter

% Modulation type
switch modType
    case 'bpsk'
        bitsPerSymbol = 1;
        constSize = 2;
    case 'qpsk'
        bitsPerSymbol = 2;
        constSize = 4;
    case '16qam'
        bitsPerSymbol = 4;
end
nDataSyms = nDataBits/bitsPerSymbol/k*n
%nDataSyms = nDataBits/bitsPerSymbol; % number of data symbols
nTrBits = nTrSyms*bitsPerSymbol;     % number of training bits
nTotalSyms = nDataSyms + nTrSyms;    % Total number of symbols

load('file_bits');
load('file_training');

RecSig = 'receiveData64.wav';
[RecSig,fSample] = audioread(RecSig);
RxSig = (RecSig(:,1)+1i*RecSig(:,2)).';
realpart = real(RxSig);
imagpart = imag(RxSig);
[rxPhaseCorrected, timingOffsetEstimate,  phaseOffsetEstimate] = timeAlign( RxSig, rrcosFilter, Trainingsyms, sps, nTotalSyms )

downsampled_sig = downsample(rxPhaseCorrected, sps);

realpart2 = real(downsampled_sig);
imagpart2 = imag(downsampled_sig);

Rx_TrSyms = downsampled_sig(1:nTrSyms);
h_hat = Trainingsyms*Rx_TrSyms'/(Trainingsyms*Trainingsyms');
RxSyms_corrected = downsampled_sig/h_hat;

demod_sig = demodulate(RxSyms_corrected, modType);


rx_coded_bits=demod_sig(nTrBits+1:end);
rxbits = decode(rx_coded_bits);
err=nnz(rxbits-bits);

BER = err/nDataBits
