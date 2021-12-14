---
title: Lezioni del corso di TNDS
author: Maurizio Tomasi
date: A.A. 2021−2022
lang: it-IT
header-includes: <script src="./fmtinstall.js"></script>
...

# Esercizi e delle spiegazioni

<center>
| Data             | Esercizi                                              | Spiegazione                                                        |
|------------------|-------------------------------------------------------|--------------------------------------------------------------------|
| 5 Ottobre 2021   | [Arrays](carminati-esercizi-01.html)                  | [Lezione 1](tomasi-lezione-01.html)                                |
| 11 Ottobre 2021  | [Classe `Vettore`](carminati-esercizi-02.html)        | [Lezione 2](tomasi-lezione-02.html)                                |
| 19 Ottobre 2021  | [Template e `vector`](carminati-esercizi-03.html)     | [Lezione 3](tomasi-lezione-03.html)                                |
| 26 Ottobre 2021  | [Classi ed ereditarietà](carminati-esercizi-05.html)  | [Lezione 4](tomasi-lezione-04.html)                                |
| 2 Novembre 2021  | Idem                                                  | [Lezione 5](tomasi-lezione-05.html)                                |
| 9 Novembre 2021  | [Ricerca di zeri](carminati-esercizi-06.html)         | [Lezione 6](tomasi-lezione-06.html)                                |
| 16 Novembre 2021 | [Quadratura numerica](carminati-esercizi-07.html)     | [Notebook 7](https://ziotom78.github.io/tnds-notebooks/lezione07/) |
| 23 Novembre 2021 | [Equazioni differenziali](carminati-esercizi-08.html) | [Notebook 8](https://ziotom78.github.io/tnds-notebooks/lezione08/) |
| 30 Novembre 2021 | Idem                                                  | Idem                                                               |
| 14 Dicembre 2021 | [Numeri pseudo-casuali](carminati-esercizi-10.html)   | [Notebook 10](https://ziotom78.github.io/tnds-notebooks/lezione10/) |
</center>

Durante le sessioni di laboratorio useremo il sito [gather.town](https://gather.town/app/etYemzL2K4Nr4o2t/LabTNDS2022) per gestire le persone collegate online.

# Suggerimenti vari

## Uso della libreria `fmt` {#fmtinstall}

Siete invitati ad impratichirvi con la libreria `fmt`, che potete installare usando lo script [`install_fmt_library.sh`](./install_fmt_library.sh): scaricatelo nella directory dell'esercizio ed eseguitelo, oppure eseguite direttamente questo comando:

```
curl https://ziotom78.github.io/tnds-tomasi-notebooks/install_fmt_library.sh | sh
```

In alternativa, scaricate questo [file zip](./fmtlib.zip) nella directory dell'esercizio e decomprimetelo, poi aggiungete il file `format.cc` nella riga in cui compilate l'eseguibile. La libreria occupa molto poco spazio, quindi potete copiarla in ogni cartella in cui implementate un esercizio.

## Gplot++ {#gplotinstall}

Se avete difficoltà ad usare ROOT, potete interfacciare il vostro codice a [Gnuplot](http://www.gnuplot.info/) mediante la libreria [gplot++](https://github.com/ziotom78/gplotpp): è sufficiente scaricare il file [`gplot++.h`](https://raw.githubusercontent.com/ziotom78/gplotpp/master/gplot%2B%2B.h), oppure eseguire questo comando:

```
curl 'https://raw.githubusercontent.com/ziotom78/gplotpp/master/gplot%2B%2B.h' > gplot++.h
```
