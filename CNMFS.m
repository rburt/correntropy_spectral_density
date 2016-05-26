function [W1,W2,H1,H2] = CNMFS(input,L,mu,alpha,fs)
%Inputs:
% Input is the music vector that we're working with (a 1D column vector)
% L is the overcompleteness parameter
% mu is the learning rate (coefficient given to delta)
% alpha is the momentum rate (coefficient given to previous value)
% fs is sampling frequency
% Outputs:
% W1 is the frequency dictionary
% W2 is the noise dictionary
% H1 are the frequency coefficients
% H2 are the noise coefficients

%% THIS VERSION DOES NOT ADAPT THE KERNEL SIZE


input = (input-mean(input))/std(input);     %Normalize the input

[length_input,width_input] = size(input);

%Silverman's Rule
kernelsize(1:L*length_input/2) = 1.06*iqr(input)/1.34*power(length(input),-1/5)

%Compute autocorrentropy function of the input
R = autocorrentropy_vector_new(input,kernelsize(1));


%Initialize Dictionary matrices
W1 = zeros(length_input,L*length_input/2);  %W1 is the frequency dictionary matrix
freq = (0:L*length_input/2)/(L*length_input/fs);    %Make frequency vector
for i = 1:length_input
    for j = 1:L*length_input/2
        W1(i,j) = exp(-2*sin(pi*freq(j)/fs*i)^2/(kernelsize(j)^2));
    end
end


W2 = eye(length_input);  %W2 is the noise dictionary matrix


%Initialize coefficient matrices
W = [W1,W2];    %Combine dictionary matrices
H = W'*R;   %Initialize total coefficient matrix
H1 = H(1:L*length_input/2,:);
H2 = H(L*length_input/2+1:end,:);


%Now optimize!!!

%Current stopper
index = 0;

while(1==1)
    

    H = H.*((W'*R)./(W'*W*H));   %Update the coefficient matrix
    H1 = H(1:L*length_input/2,:);
    H2 = H(L*length_input/2+1:end,:);
    
    %Missing kernelsize update in this slot
%     
%     frob_norm(index+1) = sqrt(sum((R-W*H).^2));

    %Put some stopping conditions here
    index = index+1;
    if(index > 49)
        break
    end
end
