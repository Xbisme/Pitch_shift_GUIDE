function output_audio = formantShift(input_audio, fs, formant_center_frequencies, formant_bandwidths)
    % T?o m?t b? l?c bandpass cho t?ng formant
    num_formants = length(formant_center_frequencies);
    formant_filtered_audio = zeros(size(input_audio));

    for i = 1:num_formants
        center_frequency = formant_center_frequencies(i);
        bandwidth = formant_bandwidths(i);

        % T?o b? l?c bandpass
        [b, a] = butter(4, [(center_frequency - bandwidth/2) (center_frequency + bandwidth/2)] / (fs/2), 'bandpass');

        % �p d?ng b? l?c bandpass l�n t�n hi?u �m thanh
        formant_filtered_audio(:, i) = filter(b, a, input_audio);
    end

    % T�ch h?p l?i c�c formants �? ��?c �i?u ch?nh
    output_audio = sum(formant_filtered_audio, 2);
end
