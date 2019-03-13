function decoed_data = decode(data)

    n=7; % Number of coded bits
    k=4; % Number of data bits
    % Make the data into a 7 by length/7
    data_reshaped=reshape(data,n,length(data)/n);
    % Parity Matrix
    H = [1,0,1,0,1,0,1; 0,1,1,0,0,1,1; 0,0,0,1,1,1,1];
    % Receive Matrix
    R = [0,0,1,0,0,0,0; 0,0,0,0,1,0,0; 0,0,0,0,0,1,0; 0,0,0,0,0,0,1];
    % Matrix containing all single bit error corrections
    en = [ 0 0 0 0 0 0 0; eye(n)];   
    syndrom = mod(H*reshape(data_reshaped, [n, length(data)/n]), 2);
    % Compute the locations of errors 1 to 7, 0 means no error
    err_loc = 2.^(0:(n-k-1))*syndrom+1;
    % Gets the needed correction vectors for each 7 bit block
    bitcorrector = en(err_loc,:).';
    % Corrects the Bits by XOR
    corrected_data = mod((bitcorrector+data_reshaped), 2);
    % Maps the original data and flattens it
    decoed_data = reshape((mod((R*corrected_data),2)), [1, length(data)*k/n]);
end
