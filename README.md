# Analisi ECG
 
Script MATLAB che legge un segnale ECG (`test01_00s.dat`, `int16`, 500 Hz), ne prende i primi 5 secondi, lo normalizza e lo filtra per rimuovere i disturbi più comuni.
 
## Pipeline di filtraggio
 
1. **Filtro ellittico elimina-banda** a 50 Hz (rimozione dell'interferenza di rete, ordine scelto con `ellipord`)
2. **Filtro mediano** (`medfilt1`)
3. **Butterworth passa-alto** del 2° ordine a 0.5 Hz (rimozione della baseline wander)
## Requisiti
 
- MATLAB con Signal Processing Toolbox
- `test01_00s.dat` nella stessa cartella dello script
## Output
 
5 figure: segnale originale, risposta in frequenza del filtro ellittico e segnale dopo ciascuno dei tre filtri.
 
## Note
 
- L'asse verticale è in unità arbitrarie (il segnale è normalizzato).
- Per cambiare file o frequenza di campionamento modifica `filename` e `fs`.
 
