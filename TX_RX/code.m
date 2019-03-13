function coded_data = code(data)
    n=7; % Number of coded bits
    k=4; % Number of data bits
    % Generator Matrix
    G = [1 1 0 1;1 0 1 1;1 0 0 0;0 1 1 1; 0 1 0 0; 0 0 1 0; 0 0 0 1];
    % Reshapes the data into a 4 by length/4 matrix
    reshaped_data = reshape(data, [k, length(data)/k]);
    % Maps each 4 bit block of data onto a 7 bit coded block
    coded_data_tmp = mod((G*reshaped_data),2);
    % Flattens the matrix into a array
    coded_data=reshape(coded_data_tmp,1,length(data)/k*n);
end
