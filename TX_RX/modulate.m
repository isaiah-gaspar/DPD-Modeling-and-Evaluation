function symbols = modulate(bits, modType)
% Map bits to BPSK, QPSK, or 16 QAM signals.
% Uses same bit-to-symbol mapping as 3GPP (cellular) standards.
% Symbols are scaled to have unit energy on average.

switch modType
    case 'bpsk'
        symbols = (-1).^bits;
    case 'qpsk'
        symbols = sqrt(1/2)*((-1).^bits(1:2:end) + 1i*(-1).^bits(2:2:end));
    case '16qam'
        si = (-1).^bits(1:4:end).*3.^bits(3:4:end);
        sq = (-1).^bits(2:4:end).*3.^bits(4:4:end);
        symbols = sqrt(1/10)*(si + 1i*sq);
end

end
