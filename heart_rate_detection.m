function [qrs_peaks, locs, r_times, heart_rate, hr_time] = heart_rate_detection(signal, fs)
    
    age = 25; % dato fornito dal dataset

    % 3. Rilevamento picchi sull’envelope
    max_HR_bpm = 220 - age;  % limite fisiologico massimo
    min_RR = 60 / max_HR_bpm;  % distanza minima in secondi tra due picchi
    min_samples = round(min_RR * fs)  % in campioni

    [qrs_peaks, locs] = findpeaks(signal, ...
        'MinPeakDistance', min_samples);

    t = (0:length(signal)-1)/fs;
    r_times = t(locs);  % tempo degli R-peaks

    % 4. Calcolo heart rate (BPM)   
    rr_intervals = diff(r_times);

    % la prima differenza di tempo non esiste in quanto non abbimao valori
    % minore di 0 e quindi non ho il valore per fare la differenza


    % questa è la fondamentale, perché gli intervalli tra diff di onde R
    % devono essere calcolati così da ottenere il bmp heart rate istantan
    heart_rate = 60 ./ rr_intervals;

   
    hr_time = r_times(2:end);  % tempo associato a ciascun valore di HR
end
