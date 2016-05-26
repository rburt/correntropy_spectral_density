function xx = autocorrentropy_vector_new(input,kernelsize)
%This function computes the autocorrentropy of a signal.
%input is a vector (usually an audio signal in this case)
%kernelsize is the Gaussian kernel size used for correntropy

input_length = length(input);

input_window = [input;zeros(input_length,1)];

%Initialize output


xx= zeros(input_length,1);

for i = 1:input_length
    xx(i) = sum((1/(sqrt(2*pi)*kernelsize)).*exp(-abs(input-input_window(i:i-1+input_length))/(2*kernelsize^2)));
end

xx = xx/length(input);
xx = xx - min(xx);