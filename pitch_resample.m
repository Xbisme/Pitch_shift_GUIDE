function output_signal = pitch_resample(input,sr ,p, q)
    speed_factor = 0.4;  % slow down
    fft_size = 1024;

    %% Change Speed
    y = pvoc(input, speed_factor); % pvoc(input, factor)
    len = max(length(y), length(input)); % longer signal
    % Plot
    figure
    subplot(2,1,1); plot(input, 'r'); xlim([0, len]); title('Original')
    subplot(2,1,2); plot(y, 'b'); xlim([0, len]); title('Stretched')

    %% Change Pitch
    speed = pvoc(input, p/q);
    output_signal = resample(speed, p, q); % resample(input, numerator, denominator), change pitch
    len = max(length(speed), length(pitch)); % longer signal

    % % Play
     soundsc( output_signal, sr) % overlap original with pitch shifted

    % Plot 
    figure
    subplot(3,1,1); plot(input, 'm'); xlim([0, len]); title('Original')
    subplot(3,1,2); plot(speed, 'b'); xlim([0, len]); title('Time Shift')
    subplot(3,1,3); plot(pitch, 'g'); xlim([0, len]); title('Pitch Shift (resampled)')
end
