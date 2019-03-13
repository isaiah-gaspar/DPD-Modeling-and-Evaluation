clc;
clear; % Use this to generate the same bits every time to avoid overwrite the file bits.mat
% Specified variables
nTrSyms = 64;         % number of training symbols
sps = 4;              % samples per symbol
filterSpan = 10;      % span of filter in symbol durations
rolloffFactor = 0.3;  % root-raised cosine filter roll-off factor
fSym = 25e3;         % symbol rate
nDataBits = 1024;     % number of bits in our sequence
modType = 'bpsk';     % modulation type can be 'bqsk', 'qpsk', or '16qam'
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
nDataSyms=nDataBits/bitsPerSymbol/k*n;
%nDataSyms = nDataBits/bitsPerSymbol; % number of data symbols
nTrBits = nTrSyms*bitsPerSymbol;     % number of training bits
nTotalSyms = nDataSyms + nTrSyms;    % Total number of symbols


bits = round(rand(1, nDataBits));
training = round(rand(1, nTrBits));
Coded_bits = code(bits);

block = [training, Coded_bits];
Modsignal_BPSK = modulate(block,modType);

L = 4;


upsampled_sym=upsample(Modsignal_BPSK,L); %%%
filtered_sym= filter(rrcosFilter, 1, [upsampled_sym,zeros(1,2*length(rrcosFilter))]); %%%

z = zeros (1, 10000);

zero_padded = [filtered_sym, z]

realpart = real(zero_padded);
imagpart = imag(zero_padded);

%power = realpart.*realpart + imagpart.*imagpart

sound = 'signalbpsk.wav';
audiowrite(sound,[realpart.',imagpart.'],fSample,'BitsPerSample', 16);

save('file_bits','bits');
Trainingsyms = Modsignal_BPSK(1:nTrSyms)
save('file_training','Trainingsyms');
