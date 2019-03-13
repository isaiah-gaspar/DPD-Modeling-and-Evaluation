function [rxPhaseCorrected, timingOffsetEstimate,  phaseOffsetEstimate] = timeAlign( rxSig, rrcosFilter, trSyms, sps, nTotalSyms )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


%% Time and phase synchronization
% Pass signal through matched filter
rxSigFiltered = filter(rrcosFilter, 1, rxSig);

% Timing synchronization: the received signal is correlated against the known training sequence.
% The peak should correspond the delay caused by propagation and filtering. 
trSymsUS = upsample(trSyms, sps); % makes things simpler
[xc, lag] = xcorr(rxSigFiltered, trSymsUS);
[~, maxIdx] = max(abs(xc));
timingOffsetEstimate = lag(maxIdx);

if (timingOffsetEstimate > 0)
    rxTimeCorrected = rxSigFiltered(timingOffsetEstimate + (1:nTotalSyms*sps))
else
    rxTimeCorrected = rxSigFiltered(1:nTotalSyms*sps);
end

    
% figure(32);
% plot(lag, abs(xc));
% grid on
% xlim([-180, 180]);
% xlabel('Lag (samples)')
% ylabel('Cross-correlation magnitude')
% title('Timing Syncronization')

% Phase offset correction: the angle of the previously computed correlation peak is an estimate of 
% the phase offset.
phaseOffsetEstimate = angle(xc(maxIdx));
rxPhaseCorrected = exp(-1i*phaseOffsetEstimate)*rxTimeCorrected;
%rxPhaseCorrected =rxTimeCorrected;

end

