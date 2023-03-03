---
title: Lezioni del corso di TNDS
author: Maurizio Tomasi
date: A.A. 2022−2023
lang: it-IT
header-includes: <script src="./fmtinstall.js"></script>
css:
- ./css/asciinema-player.css
...

# Esercizi e delle spiegazioni

<center>
| Data             | Esercizi                                              | Spiegazione                                                        |
|------------------|-------------------------------------------------------|--------------------------------------------------------------------|
| 4 Ottobre 2022   | [Arrays](carminati-esercizi-01.html)                  | [Lezione 1](tomasi-lezione-01.html)                                |
| 11 Ottobre 2022  | [Classe `Vettore`](carminati-esercizi-02.html)        | [Lezione 2](tomasi-lezione-02.html)                                |
| 18 Ottobre 2022  | [Template e `vector`](carminati-esercizi-03.html)     | [Lezione 3](tomasi-lezione-03.html)                                |
| 25 Ottobre 2022  | [Classi ed ereditarietà](carminati-esercizi-05.html)  | [Lezione 4](tomasi-lezione-04.html)                                |
| 8 Novembre 2022  | Idem                                                  | [Lezione 5](tomasi-lezione-05.html)                                |
| 15 Novembre 2022 | [Ricerca di zeri](carminati-esercizi-06.html)         | [Lezione 6](tomasi-lezione-06.html)                                |
| 22 Novembre 2022 | [Quadratura numerica](carminati-esercizi-07.html)     | [Notebook 7](https://ziotom78.github.io/tnds-notebooks/lezione07/) |
| 29 Novembre 2022 | [Equazioni differenziali](carminati-esercizi-08.html) | [Notebook 8](https://ziotom78.github.io/tnds-notebooks/lezione08/) |
| 6 Dicembre 2022  | Idem                                                  | [Slides addizionali per la lezione 8](tomasi-lezione-08.html)      |
| 13 Dicembre 2022 | [Numeri pseudo-casuali e integrali](carminati-esercizi-10.html)   | [Notebook 10](https://ziotom78.github.io/tnds-notebooks/lezione10/) |
| 20 Dicembre 2022 | Idem                                                  | Idem                                                                |
| 10 Gennaio 2023  | [Metodi Monte Carlo](carminati-esercizi-11.html)      | [Notebook 11](https://ziotom78.github.io/tnds-notebooks/lezione10/) |

</center>

Google form per il seminario finale su C++, Python e Julia: <https://forms.gle/99kR6ZADstXEJZZaA>. Slide del seminario: [link](./tomasi-c++-python-julia.html).

# Suggerimenti vari

## Installazione di ROOT e Gnuplot

A partire dal Gennaio 2022, Repl.it non fornisce più una serie di programmi nelle proprie Repl, e purtroppo tra i programmi rimossi c'è anche Gnuplot. I docenti hanno provveduto ad installare sia ROOT che Gnuplot in ciascuno dei template usati per gli esercizi, ma questo non avviene se volete creare voi Repl aggiuntive.

Se avete creato una Repl per conto vostro e volete configurarla esattamente come quelle usate a lezione, eseguite questo comando dalla console della nuova Repl:

<p><input type="text" value="curl -s https://ziotom78.github.io/tnds-tomasi-notebooks/install_standard_packages | sh" id="installStdPackages" readonly="1" size="60"><button onclick='copyFmtInstallationScript("installStdPackages")'>Copia</button></p>

Una volta eseguito, ROOT e Gnuplot, più altri utili programmi, saranno installati ed operativi.

## Uso della libreria `fmt` {#fmtinstall}

Siete invitati ad impratichirvi con la libreria `fmt`, che potete installare usando lo script [`install_fmt_library`](./install_fmt_library): si esegue con il comando `sh install_fmt_library`, e il comando **va eseguito nella directory in cui avete i vostri codici!**.

Lo script `install_fmt_library` è già fornito nei template degli esercizi forniti per il turno T2, ma potete installarlo anche in altre Repl con questo comando:

<p><input type="text" value="curl https://ziotom78.github.io/tnds-tomasi-notebooks/install_fmt_library | sh" id="installFmt" readonly="1" size="60"><button onclick='copyFmtInstallationScript("installFmt")'>Copia</button></p>

**Importante**: Il comando va dato all'interno della directory in cui codificate l'esercizio. Ciò significa che **ciascuna** delle directory che contiene un esercizio per cui è necessario usare `fmt` deve contenere una copia della libreria. Non preoccupatevi di sprecare spazio, perché la libreria `fmt` occupa pochi centinaia di KB.

Se non avete il comando `curl` o state usando Windows, scaricate questo [file zip](./fmtlib.zip) nella directory di ciascun esercizio in cui prevedete di usare `fmt` e decomprimetelo.

Questo è un esempio che mostra come installare ed usare la libreria:

<center>
  <script id="asciicast-FolwvNAVKQTqGXQs4grz4qjFk" src="https://asciinema.org/a/FolwvNAVKQTqGXQs4grz4qjFk.js" async></script>
</center>

## Gplot++ {#gplotinstall}

Se avete difficoltà ad usare ROOT, potete interfacciare il vostro codice a [Gnuplot](http://www.gnuplot.info/) mediante la libreria [gplot++](https://github.com/ziotom78/gplotpp): è sufficiente scaricare il file [`gplot++.h`](https://raw.githubusercontent.com/ziotom78/gplotpp/master/gplot%2B%2B.h), oppure eseguire questo comando:

<p><input type="text" value="curl 'https://raw.githubusercontent.com/ziotom78/gplotpp/master/gplot%2B%2B.h' > gplot++.h" id="installGplot" readonly="1" size="60"><button onclick='copyFmtInstallationScript("installGplot")'>Copia</button></p>

Ricordate che la libreria funziona a patto che abbiate installato Gnuplot sul vostro computer.
