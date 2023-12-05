function y = pvoc(x, r,n)
if nargin < 3
  n = 1024;
end
hop = n/4;

%scf = 1.0;
scf = r/n;
% Calculate the basic STFT, magnitude scaled
X = scf * stft(x', n, n, hop,44100);

% Calculate the new timebase samples
[rows, cols] = size(X);
t = 0:r:(cols-2);
% Generate the new spectrogram
X2 = pvsample(X, t, hop);

% Invert to a waveform
y = istft(X2, n, n, hop)';
