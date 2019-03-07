% *************************************************************************
% aucor_0.m
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
%         
% Input Parameters:
% 
%     filename
%     sheet number
%     column name, for instance 'A:A' will import all of column A.
%
% *************************************************************************

%% Data Import from excel files

filename = 'throughdata_02_7_19.xls';
sheet = 1;
ra0 = 'A:A';

%First column of measured data
mes0 = xlsread(filename, sheet, ra0);


%% Autocorrelation of measured data
    
y = mes0;
leng = length(y)- 1;


%Compute the normalized and unnormalized sample ACF
[normalizedACF, lags] = autocorr(y, 'NumLags', leng);
unnormalizedACF = normalizedACF*var(y,1);

figure(1)
plot( lags, normalizedACF)

str = sprintf('Normalized ACF: %s in %s', filename, ra0);
title(str, 'Interpreter', 'none')
xlabel('Lag')
ylabel('Autocorrelation')
grid

figure(2)
plot( lags, unnormalizedACF)

str = sprintf('Unnormalized ACF: %s in %s', filename, ra0);
title(str, 'Interpreter', 'none')
xlabel('Lag')
ylabel('Autocorrelation')
grid


