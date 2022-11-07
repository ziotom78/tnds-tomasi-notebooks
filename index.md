---
title: Lezioni del corso di TNDS
author: Maurizio Tomasi
date: A.A. 2022−2023
lang: it-IT
header-includes: <script src="./fmtinstall.js"></script>
...

# Esercizi e delle spiegazioni

<center>
| Data             | Esercizi                                              | Spiegazione                                                         |
|------------------|-------------------------------------------------------|---------------------------------------------------------------------|
| 4 Ottobre 2022   | [Arrays](carminati-esercizi-01.html)                  | [Lezione 1](tomasi-lezione-01.html)                                 |
| 11 Ottobre 2022  | [Classe `Vettore`](carminati-esercizi-02.html)        | [Lezione 2](tomasi-lezione-02.html)                                 |
| 18 Ottobre 2022  | [Template e `vector`](carminati-esercizi-03.html)     | [Lezione 3](tomasi-lezione-03.html)                                 |
| 25 Ottobre 2022  | [Classi ed ereditarietà](carminati-esercizi-05.html)  | [Lezione 4](tomasi-lezione-04.html)                                 |
| 8 Novembre 2022  | Idem                                                  | [Lezione 5](tomasi-lezione-05.html)                                 |
<!--
| 15 Novembre 2022  | [Ricerca di zeri](carminati-esercizi-06.html)         | [Lezione 6](tomasi-lezione-06.html)                                 |
| 22 Novembre 2022 | [Quadratura numerica](carminati-esercizi-07.html)     | [Notebook 7](https://ziotom78.github.io/tnds-notebooks/lezione07/)  |
| 29 Novembre 2022 | [Equazioni differenziali](carminati-esercizi-08.html) | [Notebook 8](https://ziotom78.github.io/tnds-notebooks/lezione08/)  |
| 13 Dicembre 2022 | Idem                                                  | Idem                                                                |
| 20 Dicembre 2022 | [Numeri pseudo-casuali](carminati-esercizi-10.html)   | [Notebook 10](https://ziotom78.github.io/tnds-notebooks/lezione10/) |
| 10 Gennaio 2022 | Idem                                                  | Idem                                                                |
| 17 Gennaio 2023  | [Metodi Monte Carlo](carminati-esercizi-11.html)      | [Lezione 11](tomasi-lezione-11.html)                                |
-->
</center>

# Suggerimenti vari

## Installazione di ROOT e Gnuplot

A partire dal Gennaio 2022, Repl.it non fornisce più una serie di programmi nelle proprie Repl, e purtroppo tra i programmi rimossi c'è anche Gnuplot. I docenti hanno provveduto ad installare sia ROOT che Gnuplot in ciascuno dei template usati per gli esercizi, ma questo non avviene se volete creare voi Repl aggiuntive.

Se avete creato una Repl per conto vostro e volete configurarla esattamente come quelle usate a lezione, eseguite questo comando dalla console della nuova Repl:

```sh
curl -s https://ziotom78.github.io/tnds-tomasi-notebooks/install_standard_packages | sh
```

Una volta eseguito, ROOT e Gnuplot, più altri utili programmi, saranno installati ed operativi.

## Uso della libreria `fmt` {#fmtinstall}

Siete invitati ad impratichirvi con la libreria `fmt`, che potete installare usando lo script [`install_fmt_library`](./install_fmt_library). È già fornito nei template degli esercizi forniti per il turno T2, ma potete installarlo anche in altre Repl con questo comando:

```
curl https://ziotom78.github.io/tnds-tomasi-notebooks/install_fmt_library | sh
```

In alternativa, scaricate questo [file zip](./fmtlib.zip) nella directory dell'esercizio e decomprimetelo, poi aggiungete il file `format.cc` nella riga in cui compilate l'eseguibile. La libreria occupa molto poco spazio, quindi potete copiarla in ogni cartella in cui implementate un esercizio.

## Gplot++ {#gplotinstall}

Se avete difficoltà ad usare ROOT, potete interfacciare il vostro codice a [Gnuplot](http://www.gnuplot.info/) mediante la libreria [gplot++](https://github.com/ziotom78/gplotpp): è sufficiente scaricare il file [`gplot++.h`](https://raw.githubusercontent.com/ziotom78/gplotpp/master/gplot%2B%2B.h), oppure eseguire questo comando:

```
curl 'https://raw.githubusercontent.com/ziotom78/gplotpp/master/gplot%2B%2B.h' > gplot++.h
```

Ricordate che la libreria funziona a patto che abbiate installato Gnuplot sul vostro computer.
