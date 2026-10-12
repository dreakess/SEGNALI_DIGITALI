% Analisi ECG
close all
clear all

% Lettura del dataset
filename = 'test01_00s.dat';
fid = fopen(filename, 'r');
ecg = fread(fid, Inf, 'int16');
fclose(fid);

% Frequenza di campionamento e frequenza di Nyquist
fs = 500;
fn = fs/2;

% Progettazione del filtro ellittico per eliminare la componente a 50 Hz
Wp = [46 54]/fn; % Bande vicino a 50 Hz che voglio attenuare
Ws = [48 52]/fn; % Banda di stop
Rp = 1; % Attenuazione delle bande vicino a 50 Hz 
Rs = 50; % Attenuazione della banda di stop 

% Calcolo dell'ordine ottimale del filtro
[n, Wp] = ellipord(Wp, Ws, Rp, Rs);
[z, p, k] = ellip(n, Rp, Rs, Wp, 'stop');
[b, a] = zp2tf(z, p, k);

% Uso ellipord per determinare il grado ottimale per il filtro ellittico
% Successivamente derivo i parametri del filtro passando quelli desiderati
% Con zp2tf effettuo la conversione degli zeri e dei poli del filtro
% nella funzione di trasferimento
% L'uso del filtro ellittico risulta più appropriato rispetto a un filtro
% semplice per l'eliminazione efficace della componente a 50 Hz

% Preparazione del segnale e normalizzazione
n_samples = length(ecg) - 1;
t = (0:n_samples)/fs;

% Prelevo i primi 5 secondi
t = t(t <= 5);
ecg_1 = ecg(1:length(t));

% Normalizzazione e rimozione del valore medio
ecg_1 = (ecg_1 - min(ecg_1)) / (max(ecg_1) - min(ecg_1));
ecg_1 = ecg_1 - mean(ecg_1);

% Visualizzazione del segnale originale
figure(1)
plot(t, ecg_1);
title('Segnale da analizzare');
xlabel('Tempo [s]')
ylabel('Tensione [mV]')
grid on

% Risposta in frequenza del filtro ellittico
figure(2)
freqz(b, a)
title('Risposta in frequenza del filtro ellittico')

% Applicazione del filtro ellittico
figure(3)
y = filter(b, a, ecg_1);
plot(t, y)
title('Segnale filtrato con il filtro ellittico');
xlabel('Tempo [s]')
ylabel('Tensione [mV]')
grid on

% Applicazione del filtro mediano per la baseline wander
figure(4)
y2 = medfilt1(y);
plot(t, y2);
title('Segnale filtrato con il filtro mediano');
xlabel('Tempo [s]')
ylabel('Tensione [mV]')
grid on

% Filtro Butterworth passa-alto di secondo ordine per frequenza di taglio 0.5 Hz
[b1, a1] = butter(2, (0.5/fn), 'high');

figure(5)
y3 = filter(b1, a1, y2);
plot(t, y3);
title('Segnale filtrato con il filtro Butterworth');
xlabel('Tempo [s]')
ylabel('Tensione [mV]')
grid on

% Codice commentato per filtri aggiuntivi (opzionale)
% figure(6)
% [b1, a1] = butter(2, (0.5)/(250), 'high');
% freqz(b1, a1)
% 
% figure(7)
% y2 = filter(b1, a1, y);
% plot(t, y2);
% 
% figure(8)
% [b2, a2] = butter(4, 15/250, 'high');
% freqz(b2, a2);
% y4 = filter(b2, a2, y3);
% plot(t, y4);
% 
% figure(9)
% [b3, a3] = butter(4, 20/250, 'low');
% freqz(b3, a3);
% y5 = filter(b3, a3, y4);
% plot(t, y5);
% xlabel('Tempo [s]')