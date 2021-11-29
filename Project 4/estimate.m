function [output] = estimate(n, STFT) 

    %Creates the modified STFT by using the Matlab flip function, which reverses the 
    %order of the elements of the STFT matrix.
    modifiedSTFT = [STFT; flip(STFT)]; 
    
    IFFT = ifft(modifiedSTFT, n); %Takes the IFFT of the modified STFT values for a given n value.
    IFFT = real(IFFT(1:256, :)); %Modifies the estimated values so that the IFFT vector will only contain real values.
    
    %Declaring the two columns of the IFFT that contains
    %overlapping estimated values that resulted from constructing Xn(w).
    firstSegment = IFFT(1:128, 2:end); 
    secondSegment = IFFT(129:end, 1:end - 1);
    
    %Correcting the overlap by computing the average of the estimated
    %values for each segment since there are 2 estimates of the time signal per point.
    correctOverlap = (firstSegment + secondSegment)./2;
    
    %Outputting the estimated signal after applying the overlap fix and
    %then reshaping the vector.
    output = [IFFT(1:128, 1), correctOverlap, IFFT(129:256, end)];
    output = reshape(output, numel(output), 1);
    
end