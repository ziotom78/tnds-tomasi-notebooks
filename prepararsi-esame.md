Di seguito un piccolo vademecum per aiutarvi a svolgere nel migliore dei modi l'esame scritto.

#.  Potete mettere in pratica questo vademecum esercitandovi con i cinque temi pubblicati da Carminati a questo link: <https://labtnds.docs.cern.ch/ProveEsame/TemiEsame/>. Una spiegazione di come affrontarli è disponibile in una [pagina dedicata](temi-svolti.html).

#.  Dovete sapere **molto bene** la teoria per affrontare lo scritto, perché c'è sempre almeno una domanda la cui risposta è banalissima se si conoscono le equazioni che giustificano un metodo, quasi impossibile se non le si sanno. (Esempio: un problema potrebbe chiedere di determinare l'errore atteso da un integrale col metodo di Simpson, ma voi non sapete il valore vero. Nelle lezioni teoriche però si spiega qual è la relazione tra il passo $h$ del metodo di Simpson e l'errore atteso, e si fornisce pure una formula matematica per stimare l'errore senza sapere il valore esatto dell'integrale).

#.  Curate benissimo gli esercizi, ed arrivate il giorno dello scritto con un archivio ordinato di tutti i file che vi serviranno. Vi raccomando di mettere tutto il codice in file `.h` evitando i file `.cpp`. Se quindi avete implementato una classe in questo modo:

    ```c++
    // File RandomGen.h

    #pragma once

    class RandomGen {
      RandomGen::RandomGen(int seed);

      // Etc.
    };


    // File RandomGen.cpp

    #include "RandomGen.h"

    RandomGen::RandomGen(int seed) {
      // Implementation…
    }
    ```

    sarebbe meglio levare di mezzo il file `RandomGen.cpp` e avere tutto nel file `RandomGen.h`:

    ```c++
    // File RandomGen.h

    #pragma once

    class RandomGen {
      RandomGen::RandomGen(int seed) {
        // Here comes the implementation that was originally in RandomGen.cpp
      }

      // Etc.
    };
    ```

    Avere solo i file `.h` vi dà un grande vantaggio: non dovete complicare troppo il `Makefile` che scriverete durante il compito, perché basta includere i file `.h` che vi servono nel `main.cpp` e siete a posto. (Questo è esattamente quanto ho fatto nel file [`gplot++.hpp`](https://github.com/ziotom78/gplotpp/blob/master/gplot%2B%2B.h), che infatti potete usare con `#include` senza preoccuparvi di modificare il `Makefile`).

    Per essere ancora più efficienti il giorno dello scritto, potreste addirittura decidere di mettere *tutte le funzioni e classi* che avete scritto in un unico file `.h`, chiamandolo ad esempio `mylibrary.h`. In questo modo sarà sufficiente scrivere `#include "mylibrary.h"` nel vostro file `main.cpp` ed avrete automaticamente a disposizione tutto il vostro lavoro! (**Attenzione**: in tal caso ricordatevi che ogni funzione che metterete in `mylibrary.h` dovrà essere dichiarata `inline`, ad esempio `inline double CalcolaMedia(const std::vector<double> & v)`, altrimenti potreste avere errori strani nella creazione dell'eseguibile).

#.  Leggete con attenzione il testo, e annotate a margine (o su un foglio di brutta) le cose che sono esplicitamente richieste e quali no. Capita che gli studenti si incaponiscano a produrre un grafico fatto in un certo modo, quando il testo richiedeva semplicemente di “tabulare i risultati” (ossia, stamparli semplicemente a video!)

#.  Prima di iniziare a scrivere codice come forsennati, provate a stimare almeno l'ordine di grandezza delle risposte. Alcuni esempi pratici:

    -   Se si fornisce una funzione e si chiedono gli zeri, fate un grafico con Gnuplot o con Excel per stimarli grossolanamente;

    -   Se si deve fare una simulazione di un esperimento per stimare l'errore su un certo parametro, provate a fare una semplice propagazione degli errori. Può però capitare che i conti risultino troppo lunghi da svolgere a mano (la formula di propagazione include derivate, quadrati e radici quadrate, e può facilmente diventare complicata!). In tal caso limitatevi ad usare il buon senso: se un parametro di input ha una precisione intorno al percento, ci si aspetta che anche il risultato sia più o meno dello stesso ordine di grandezza, e quindi se il vostro codice stima un errore del 100% o dello 0.001% c'è sicuramente un errore!

    -   Se si devono generare numeri casuali con una specifica distribuzione, implementate come prima cosa nel `main` un codice per estrarre ~10 000 numeri e fatene un istogramma: la sua forma corrisponde alla distribuzione fornita?

    -   Etc.

    Non spendete però troppo tempo per arrivare a una stima con carta e penna: se dopo pochi minuti di lavoro siete ancora in alto mare, lasciate perdere!

#.  Leggete *tutto* il testo dell'esame prima di iniziare a scrivere il codice. Magari nel primo punto vi viene chiesto di assumere una certa quantità fisica (una massa, una velocità…) come costante, ma in uno dei punti successivi dovete cambiarne il valore oppure addirittura trasformarla in una quantità che dipende dal tempo o dallo spazio. Se leggete prima tutto il testo, potete già fare caso a queste cose e progettare la struttura del codice in maniera più efficace. Questo è l'approccio seguito negli svolgimenti dei temi d'esame riportati nella [pagina dedicata](temi-svolti.html).

#.  Mettete *sempre* all'inizio del `main()` le chiamate alle funzioni di test che avete scritto durante il semestre e che testano le funzioni prese dai vostri esercizi. Ad esempio, se usate le funzioni per gli zeri nello svolgimento, fate iniziare il `main()` con una chiamata a `test_zeroes()` (vedi lezione 6). Il motivo è che a volte gli studenti si rendono conto che il codice dei loro esercizi andrebbe esteso o parzialmente modificato **durante l’esame scritto**, ma nel toccarlo inseriscono inavvertitamente degli errori. Chiamare le funzioni di test vi mette al riparo da questa eventualità.

#.  I temi di esame sono solitamente espressi come una lista di punti, ciascuno dei quali è una domanda. **MAI** implementare tutto il codice, da cima a fondo, che risolve tutti i punti e solo alla fine eseguirlo! Implementate il codice che vi serve per risolvere il primo punto, stampatelo, verificate i risultati, e quando vi convince passate al secondo. In questo modo, se i numeri prodotti per il primo punto appaiono strani, potete correggere gli errori prima di passare al punto successivo. Altrimenti rischiate di dover buttare via tutto il lavoro: magari vi rendete conto che per risolvere bene il primo punto avevate bisogno di *due* variabili `std::vector` anziché una sola, e di conseguenza quanto avete implementato per i punti successivi non è più valido.

#.  Non succederà mai che viene richiesto l'uso di ROOT o di Gnuplot esplicitamente; fare però i grafici è utile per avere l'intuizione se i risultati che il vostro codice produce sono sensati oppure no.

#.  Prima di fare i grafici, preoccupatevi **sempre** di stampare con `println` i valori tabulati delle quantità che andate a mettere nei grafici. Noi docenti siamo sempre disposti a chiudere un occhio se un grafico risulta sbagliato o vuoto, nel caso in cui i valori che il programma stampa a video sono corretti: vuol dire che avete semplicemente sbagliato a creare il grafico, e questo è un errore perdonabile.

    Nel caso di simulazioni Monte Carlo, i numeri da stampare sono sempre moltissimi, quindi stampatene giusto qualcuno:

    ```c++
    const int num_of_simulations{10'000};
    std::vector<double> results{num_of_simulations};

    for(int i{}; i < num_of_simulations; ++i) {
      results[i] = run_simulation();

      // Stampo i primi 5 valori calcolati a video, giusto come controllo
      if(i < 5) {
        println("{}\t{}", i, results[i]);
      }
    }
    ```

    L'utilità di questo consiglio sta nel fatto che a volte ci sono errori banali nel codice che producono una sfilza di zeri o di numeri [NaN](https://en.wikipedia.org/wiki/NaN): se stampate i primi 5 numeri, ve ne accorgete subito.

#.  Capita spesso che venga richiesto di ripetere un'analisi più volte. Ad esempio, si deve calcolare un integrale col metodo di Simpson usando un numero di step via via crescente, o si deve risolvere un'equazione differenziale variando il numero di passi, etc.

    Alcuni studenti, presi dal “panico dell'esame”, lavorano di copia-e-incolla: risolvono il problema nel primo caso, poi copiano e incollano lo stesso codice nel `main` tante volte quante sono i casi da studiare, e aggiustano a mano quei parametri che vanno aggiornati. Ecco un esempio:

    ```c++
    int main() {
      // Il tema d'esame richiede di simulare un esperimento N volte
      // e stimare l'errore su un certo parametro A, e chiede di
      // vedere come l'errore su A cambia al variare di N. Il testo
      // chiede di far assumere a N i valori { 100, 500, 1000, 5000 }.

      double risultato{};

      // Codice per N = 100
      for(int i{}; i < 100; ++i) {
        // Qui aggiorno la variabile `risultato`
      }
      println("Risultato per N = 100: {}", risultato);

      // Codice per N = 500, copiato da sopra
      for(int i{}; i < 500; ++i) {
        // Qui aggiorno la variabile `risultato`
      }
      println("Risultato per N = 500: {}", risultato);

      // Codice per N = 1000, copiato da sopra
      for(int i{}; i < 1000; ++i) {
        // Qui aggiorno la variabile `risultato`
      }
      println("Risultato per N = 1000: {}", risultato);

      // Codice per N = 5000, copiato da sopra
      for(int i{}; i < 1000; ++i) {
        // Qui aggiorno la variabile `risultato`
      }
      println("Risultato per N = 5000: {}", risultato);
    }
    ```

    Questo porta ad alcuni problemi gravi:

    -   Se vi accorgete solo dopo aver fatto copia-e-incolla che c'era un errore nel caso con `N = 100`, lo dovrete correggere per tutti gli altri casi. Questo vi farà sprecare molto tempo, che in un esame è una risorsa preziosa;

    -   In ognuna delle copie del codice che avete incollato bisogna ovviamente cambiare qualcosa qua e là; è facile che ci sia almeno una di quelle copie in cui modificate la riga sbagliata, oppure non la modificate del tutto. (È il caso dell'esempio sopra: ve ne eravate accorti?)

    La cosa migliore da fare è quella di spostare il codice che va ripetuto all'interno di una funzione, e poi chiamarla più volte nel `main`:

    ```c++
    double calcola_risultato(int N) {
      // Qui va tutta l'implementazione del calcolo
      // ...
    }

    int main() {
      std::vector<int> list_of_N{100, 500, 1000, 5000};

      for(int i{}; i < ssize(list_of_N); ++i) {
        // Ricordate di usare list_of_N.at(i) anziché list_of_N[i],
        // perché così il compilatore controlla che il valore di `i`
        // non esca dai limiti del vettore
        int cur_N{list_of_N.at(i)};

        // Invoca la funzione `calcola_risultato` implementata sopra
        double risultato{calcola_risultato(cur_N)};
        println("Risultato per N = {}: {}", cur_N, risultato);
      }
    }
    ```

    Per fare un esempio un po' più complicato, immaginiamo che vi venga chiesto di fare la simulazione di un esperimento dati tre parametri $A$, $B$ e $C$, e che l'esercizio si articoli in tre punti:

    -   Prima dovete calcolare il risultato dell'esperimento supponendo che il parametro $A$ sia affetto da errore, mentre altre due quantità $B$ e $C$ usate nella simulazione non hanno errore;

    -   Poi dovete invece supporre che sia $B$ affetto da errore, ma non $A$ e $C$;

    -   Infine dovete supporre che solo $C$ sia affetto da un errore.

    Si possono inventare soluzioni sofisticate che impieghino un `std::vector` per seguire l'idea della variabile `list_of_N` nell'esempio precedente, ma nel caso di uno scritto (in cui il tempo è limitato) è meglio non stare a lambiccarsi troppo… Il codice seguente va più che bene:

    ```c++
    double calcola_risultato(double A, double err_A,
                             double B, double err_B,
                             double C, double err_C) {
      // Qui va tutta l'implementazione della logica, che può essere lunga!
      // ...
    }

    int main() {
      // Questi sono i parametri dell'esperimento, che immaginiamo siano
      // forniti nel testo dell'esercizio
      double A_rif{1.0};
      double B_rif{2.0};
      double C_rif{3.0};
      double err_A_rif{0.03};
      double err_B_rif{0.05};
      double err_C_rif{0.02};

      // Soluzione del primo punto: introduco solo un errore su A
      double risultato1{calcola_risultato(A_rif, err_A_rif, B_rif, 0.0, C_rif, 0.0)};

      // Soluzione del secondo punto: introduco solo un errore su B
      double risultato2{calcola_risultato(A_rif, 0.0, B_rif, err_B_rif, C_rif, 0.0)};

      // Soluzione del terzo punto: introduco solo un errore su C
      double risultato3{calcola_risultato(A_rif, 0.0, B_rif, 0.0, C_rif, err_C_rif)};

      // Stampo i risultati
      println("Punto 1 (errore solo su A): {}", risultato1);
      println("Punto 2 (errore solo su B): {}", risultato2);
      println("Punto 3 (errore solo su C): {}", risultato3);
    }
    ```

#.  Prima di consegnare lo scritto, rimettete a posto la formattazione. Dal terminale eseguite questo comando:

    ```
    clang-format -i *.cpp *.h
    ```

    per sistemare le indentazioni e i rientri di tutti i file `*.h` e `*.cpp` presenti nella cartella. Questo vi farà fare un figurone! (Sarebbe stata un'ottima cosa fare lo stesso anche per gli esercizi che avete consegnato. Ma se state leggendo queste righe per la prima volta solo il giorno dello scritto, ahimè è troppo tardi…)

---
title: Come prepararsi all'esame scritto
author: Maurizio Tomasi
date: A.A. 2024−2025
lang: it-IT
css:
- ./css/asciinema-player.css
...
