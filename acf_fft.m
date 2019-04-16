% *************************************************************************
% acf_fft.m
% *************************************************************************
% 
% This MATLAB program evaluates the autocorrelation of sampled data
% saved within a excel workbook.
% 
%
% Program computes:
% 
%     normalizedACF
%     unnormalizedACF
%     
% Program plots:
%
%     NormalizedACF vs Lag
%     Magnitude vs Spectrum
%     
%         
% Input Parameters:
% 
%     filename
%     fSpec
%
% *************************************************************************

function acf_fft(filename, fs, r)
%function acf(filename, sheet, ra)
%0.1 and 10 ms for wave form

%d1 = fscanf(filename, fSpec);   %Text file import
                                % fSpec examples:
                                % Floating-point %f, e, g
                                % Integer Signed %d, i
                                
%d1 = xlsread(filename,r); %msec, min, ecg

m = (1:1000);

d1 = sin(m);

                                
%fs = ;         %Sampling Frequency
T = 1/fs;       %Sampling period
L = length(d1); %Length of the signal
t = (0:L-1)*T;  %Time Vector

S = d1;           %Stream of data


Y = fft(S);       %Fourier transform of Data

%Compute two-sided spectrum P2, then single-sided spectrum P1
%based on P2 and the even-valued signal length L

P2 = abs(Y/L);
P1 = P2(1:L/2+1)
P1(2:end-1) = 2*P1(2:end - 1)

%Frequency domain f, plotted wrt to P1
f = fs*(0:(L/2))/L;

figure(1)

plot(f,P1)
title('Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)')
grid

[normalizedACF, lags] = autocorr(d1, 'NumLags',L-1);

figure(2)
plot( lags, normalizedACF)

str = sprintf('Normalized ACF: %s', filename);
title(str, 'Interpreter', 'none')
xlabel('Lag')
ylabel('Autocorrelation')
grid

end
