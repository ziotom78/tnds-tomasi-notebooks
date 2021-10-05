% Laboratorio di TNDS -- Lezione 1
% Maurizio Tomasi
% Martedì 5 Ottobre 2021

# Introduzione al corso

# Queste slides

-   All'inizio di ogni sessione di laboratorio mosterò alcune slides che
riprendono alcuni concetti già visti a lezione.

-   Queste slides sono disponibili all'indirizzo
[ziotom78.github.io/tnds-tomasi-notebooks](https://ziotom78.github.io/tnds-tomasi-notebooks),
e sono navigabili.

-   Se vi è più comodo, potete ottenere una versione PDF producendola da
soli: basta aggiungere `?print-pdf` alla fine della URL e stampare la
pagina da browser in un file PDF (vedi le [istruzioni
dettagliate](https://revealjs.com/pdf-export/)).


# Avvertenza generale

-   *Non* fare copia-e-incolla da slide come queste! Trascrivere a mano il
codice è più utile, perché vi consente di notare alcune sottigliezze
sintattiche (es., dove vengono usati i punti e virgola).

-   In generale, trascrivere codice è un ottimo allenamento per imparare a
scrivere programmi.


# Esercizi per oggi

-   La spiegazione dettagliata è sul sito del corso
[labmaster.mi.infn.it/Laboratorio2/labTNDS/lectures_1819/lezione1_1819.html](http://labmaster.mi.infn.it/Laboratorio2/labTNDS/lectures_1819/lezione1_1819.html).

-   Gli esercizi sono i seguenti:

    -   1.0: Calcolo di media, varianza e mediana dei dati letti da un file
    -   1.1: Codice di analisi con funzioni (variante del precedente)
    -   1.2: Codice di analisi con `Makefile` (variante del precedente)
    -   1.3: Codice di analisi con overloading (variante del precedente)


# Esercizi per oggi

```text
$ head -n 4 data.dat
8.50763
11.6275
20.9615
9.55072
$ ./esercizio01.1 4 data.dat
Media = 12.6618
Varianza = 32.2969
Mediana = 10.5891
8.50763
11.6275
20.9615
9.55072
```

**Nota**: la *varianza* è il quadrato della *deviazione standard*;
quest'ultima si indica anche con RMS (*Root Mean Square*).

# Soluzioni attese

-   È molto importante che verifichiate la corretta esecuzione dei vostri programmi!

-   State attenti al calcolo della mediana: il 30% degli studenti alla fine del corso consegna esercizi di questa prima lezione in cui la mediana è errata.

-   Le soluzioni che dovete aspettarvi sono mostrate nel video seguente. Assicuratevi di ottenere gli stessi valori!

---

<asciinema-player src="asciinema/julia-exercise-1.0-68×16.asciinema" cols="68" rows="16" font-size="medium"></asciinema-player>

# Come svolgere gli esercizi

Potete svolgere gli esercizi in uno dei modi seguenti:

1.   Usando il computer di laboratorio davanti a voi (per chi è in presenza);
2.   Chi segue la lezione online può connettersi ai computer del laboratorio.
3.   Se avete un portatile con un compilatore C++ installato (ragionevolmente recente), potete svolgere l'esercizio su di esso.
4.   Potete usare [Repl.it](https://replit.com/~): in questo caso non c'è bisogno di installare nulla, e potete usare anche un tablet (ma sarebbe meglio collegare una tastiera!).


# Computer di laboratorio

-   **Non** premete quello che sembra essere il pulsante on/off del monitor, perché in realtà **spegne il computer** (e manda una segnalazione al centro di calcolo).

-   Vi consiglio di usare come editor [Visual Studio Code](https://code.visualstudio.com/), che è installato sui computer del laboratorio.

-   Potete scaricare ed installare Visual Studio Code anche sul vostro portatile: è gratuito e disponibile per Windows, Linux e Mac OS X.

-   Di seguito c'è un breve filmato che vi mostra come scrivere ed eseguire un programma di esempio. Visual Studio Code presenta numerosi *plugin* per semplificare lo sviluppo; li vedremo meglio durante il corso.

---

<div style="padding:54.53% 0 0 0;position:relative;"><iframe src="https://player.vimeo.com/video/623206212?h=71f53f0f8b&amp;badge=0&amp;autopause=0&amp;player_id=0&amp;app_id=58479" frameborder="0" allow="autoplay; fullscreen; picture-in-picture" allowfullscreen style="position:absolute;top:0;left:0;width:100%;height:100%;" title="Visual Studio Code &amp;ndash; First steps with C++"></iframe></div><script src="https://player.vimeo.com/api/player.js"></script>


# Computer del laboratorio (1/2)

Se usate un sistema Linux o Mac OS X, potete usare il comando `ssh`
dal terminale:

<asciinema-player src="asciinema/connect-to-tolab-75×20.asciinema" cols="75" rows="20" font-size="medium"></asciinema-player>

# Computer del laboratorio (2/2)

-   Se usate Windows, installate la versione *free* di [MobaXTerm](https://mobaxterm.mobatek.net/).

-   Dovete configurare una connessione di tipo «SSH» a `tolab.fisica.unimi.it`, specificando il vostro nome utente (solitamente `nome.cognome`).


# Come usare Repl.it

-   Una soluzione che non richiede di installare nulla è [Repl.it](https://replit.com/~), un ambiente di sviluppo usabile da browser.

-   Durante l'anno scorso abbiamo svolto tutto il laboratorio usando Repl.it, quindi è fattibile impiegarlo per tutte le lezioni, anche se siete in presenza…

-   …ma il sito non si è sempre dimostrato affidabile: a volte resta offline, altre volte è estremamente lento.

-   Se potete usare il vostro computer o quello del laboratorio, vi suggerirei di preferire questa opzione.

---

<iframe src="https://player.vimeo.com/video/623224728?h=87f213239a&amp;badge=0&amp;autopause=0&amp;player_id=0&amp;app_id=58479" width="1280" height="698" frameborder="0" allow="autoplay; fullscreen; picture-in-picture" allowfullscreen title="Repl.it &amp;ndash; How to write C++ code"></iframe>

# Accorgimenti per Repl.it

-   Nel video si mostra come creare un *nuovo* progetto, ma nel vostro caso dovreste invece fare il *fork* del template fornito dal docente. (Vi arriverà la mail non appena termina questa spiegazione).

-   Alla fine di ogni lezione scaricare sul proprio computer un file `.zip` che contenga ogni esercizio.

-   Prima dell'esame scritto dovrete «consegnare» gli esercizi. Non è necessario farlo alla fine della lezione, perché potreste volerci tornare sopra più volte nel corso del semestre.

-   Si possono consegnare gli esercizi facendo «Submit» in Repl.it, ma **dovete** anche copiare gli esercizi nella vostra *home* sui
    computer di laboratorio.


# Lavoro online

-   Durante la lezione useremo il sito [gather.town]() per gestire le persone collegate online.

-   Se siete online, per collegarvi a Gather fate click su [questo link ](https://gather.town/invite?token=53aE7z9bj9hXWI2nOu6RlBXbHO-qVewq) (che scadrà al termine della lezione): verrete connessi alla stanza [LaboratorioTNDS](https://gather.town/app/ZrvLmfvx9QMCKHFO/LaboratorioTNDS).

-   Registratevi col vostro nome completo e posizionatevi in uno dei «banchi» virtuali disponibili.

# Suggerimenti vari

# Uso di argc e argv

# Linea di comando

-   I parametri `argc` e `argv` passati come argomenti al `main` servono per leggere parametri passati dalla linea di comando, come nel caso seguente:

    ```sh
    $ ./main 10 data.dat
    ```

-   Si possono dichiarare in più modi, tutti equivalenti:

    ```c++
    int main(int argc, char ** argv);
    int main(int argc, char *argv[]);
    int main(int argc, const char **argv);
    // La mia preferita, che ho usato nei video di oggi
    int main(int argc, const char *argv[]);
    // Potete usare altri nomi
    int main(int num_of_arguments, const char *args[]);
    ```

---

# Significato di argc e argv (1/2)

-   Il primo parametro (`argc`) contiene il numero di
parametri, **incluso il nome dell'eseguibile**, mentre `argv` è una lista di puntatori a caratteri (ossia stringhe) che contengono il nome dell'eseguibile seguito dal resto.

-   Esempio:

    <asciinema-player src="asciinema/argc-argv-60×13.asciinema" cols="60" rows="13" font-size="medium"></asciinema-player>

---

# Significato di argc e argv (1/2)

Se eseguiamo più volte il programma, ecco il suo output:

```text
$ ./args-example
argc = 1
argv[0] = ./args-example
$ ./args-example 10
argc = 2
argv[0] = ./args-example
argv[1] = 10
$ ./args-example 10 ../data.dat
argc = 3
argv[0] = ./args-example
argv[1] = 10
argv[2] = ../data.dat
```


# Uso di Makefile


# Compilare un programma (1/3)

Prendiamo questo semplice esempio:

```c++
#include <iostream>

int calc(int a, int b) { return a + b; }

int main() {
    std::cout << "Insert two numbers: ";

    int a, b;
    std::cin >> a >> b;

    std::cout << "The result is "
              << calc(a, b) << "\n";
    return 0;
}
```

---

# Compilare un programma (2/3)

-   Sinora abbiamo mostrato esempi in cui tutto il codice sorgente è in un unico file. Questo non è però utile, perché in futuro dovrete riciclare spesso parti di codice!

-   Anziché usare le funzioni di copia-e-incolla, è meglio suddividere il codice in più file con estensione `.cpp`, che dovranno però poi essere compilati uno a uno e «combinati» insieme (il termine esatto è *linking*).

-   In questo corso vi obblighiamo ad usare uno strumento piuttosto vetusto ma presente su qualsiasi sistema Unix: GNU Make.


# Compilare un programma (3/3)

-   Partiamo da un caso molto semplice (l'esercizio 1.2 sarà più complicato). Create un file con nome `Makefile` (attenzione alla maiuscola iniziale!), e scrivete queste righe al suo interno:

    ```makefile
    CXXFLAGS = -g -Wall --pedantic

    main: main.cpp
    ```

-   Infine, da linea di comando eseguite il comando `make` (`$` indica il
prompt):

    ```text
    $ make
    g++ -g -Wall --pedantic    main.cpp   -o main
    $ ls
    main   main.cpp   Makefile
    ```


# Flag del compilatore


-   È utile specificare dei flag aggiuntivi per la compilazione, tramite la riga

    ```makefile
    CXXFLAGS = -std=c++11 -g -Wall --pedantic
    ```

-   `-std=c++11` abilita alcune caratteristiche «recenti» del C++ (nelle versioni più aggiornate del compilatore GCC è inutile).

-   `-g`: se il codice va in *crash*, stampa la riga di codice che ha causato l'errore.

-   `-Wall`: rende il compilatore C++ più brontolone del solito.

-   `--pedantic`: lo rende ancora più brontolone.

---

# Spiegazione del comando make

-   Il comando `make` serve per «creare» (appunto, *to make*) dei file partendo da altri. Con la scritta

    ```makefile
    main: main.cpp
    ```

    si dice a Make che si vuole creare il file `main` (eseguibile) partendo dal file `main.cpp`.

-   Make sa che i file con estensione `.cpp` sono programmi C++, e quindi correttamente invoca l'eseguibile `g++`, passandogli i parametri nella variabile `CXXFLAGS`.

# Comandi personalizzati

-   Se si vuole fornire manualmente la lista dei comandi da inviare, bisogna scriverli nella riga successiva, che va indentata inserendo un carattere **TAB** (attenzione: **non** una sequenza di spazi!):

    ```makefile
    CXXFLAGS = -std=c++11 -g -Wall --pedantic
    
    main: main.cpp
        # You MUST use a Tab character to indent here!
        g++ $(CXXFLAGS) main.cpp
    ```

-   Per inserire un Tab da Repl.it, impostate *Indent type* uguale a *Tab* e *Indent size* uguale a 8 in «Settings». **Attenzione**: su alcuni computer, Repl.it non permette di inserire un carattere Tab.

---

# Esecuzione di un Makefile

-   Se eseguiamo immediatamente `make` una seconda volta, avviene una cosa interessante:

    ```text
    $ make
    $
    ```

-   In questo caso, Make non fa nulla: ha controllato le date dei file `main` e `main.cpp`, e ha visto che il primo è stato creato *dopo* il secondo: quindi non c'è bisogno di compilare nuovamente il programma.

-   Se voleste obbligare `make` a saltare il controllo delle date e ricreare tutto da capo, basta invocarlo così: `make -B`.

---

# Usare più file sorgente

-   Nell'esercizio 1.2 si richiede di dividere il programma tra più file,
e di compilarli separatamente. In questo caso la struttura del
`Makefile` si complica:

    ```makefile
    esercizio1.2: esercizio1.2.cpp funzioni.cpp
        # Con \ si può andare a capo
        g++ esercizio1.2.cpp funzioni.cpp \
            -o esercizio1.2 $(CXXFLAGS)
    ```

    Questo esempio crea di nuovo l'eseguibile a partire da file `.cpp`.

-   Quanto scritto qui sopra funziona, ma **non è quanto richiesto dall'esercizio**: bisogna esplicitare anche il passaggio intermedio, ossia la creazione di file `.o`.

---

# Creare i file oggetto (`.o`)

-   GNU Make permette di richiedere dipendenze «intermedie», ossia
dipendenze da file che devono essere creati dallo stesso GNU Make.

-   Questo è ciò che serve per i file `.o`:

    ```makefile
    esercizio1.2: esercizio1.2.o funzioni.o
        g++ esercizio1.2.o funzioni.o -o esercizio1.2
    
    esercizio1.2.o: esercizio1.2.cpp funzioni.h
        g++ -c sercizio1.2.cpp -o esercizio1.2.o $(CXXFLAGS)
    
    funzioni.o: funzioni.cpp funzioni.h
        g++ -c funzioni.cpp -o funzioni.o $(CXXFLAGS)
    ```

    (`CXXFLAGS` non serve quando si mettono insieme più file `.o`: la compilazione del codice C++ è già avvenuta).

---

# Un trucco

-   GNU Make definisce alcune variabili speciali che semplificano la scrittura del `Makefile`. Una di queste è `$@`, che rappresenta il nome del file da creare.

-   L'esempio nella slide precedente si può riscrivere così:

    ```makefile
    esercizio1.2: esercizio1.2.o funzioni.o
        g++ esercizio1.2.o funzioni.o -o $@
    
    esercizio1.2.o: esercizio1.2.cpp funzioni.h
        g++ -c esercizio1.2.cpp -o $@ $(CXXFLAGS)
    
    funzioni.o: funzioni.cpp funzioni.h
        g++ -c funzioni.cpp -o $@ $(CXXFLAGS)
    ```

-   È più facile riciclare il `Makefile` nei nuovi esercizi!

---

# Avvertenza su GNU Make

-   Quando avrete svolto gli esercizi di questa lezione, vi sarà chiaro che la scrittura del `Makefile` è un processo molto lungo e verboso. Il comando `make` è stato inventato nel 1976, e all'epoca il mondo della programmazione era così!

-   Oggi più nessuno (neppure io!) usa GNU Make direttamente per compilare codice C++. Per i vostri progetti futuri (oltre questo corso) vi converrà usare sistemi più evoluti ed agili; tra questi, il più usato in assoluto è [CMake](https://cmake.org/).

-   Noi insegnamo il funzionamento di GNU Make perché pedagogicamente ci sembra utile: sistemi come CMake sono costruiti usando GNU Make come fondamento. Vediamone un esempio.

# Uso di CMake

-   CMake è lo standard *de facto* per compilare progetti in C/C++, e si basa su GNU Make. Il modo in cui si usa è il seguente:

    #.   Si scrive un file chiamato `CMakeLists.txt` (occhio alle maiuscole!)
    #.   Si esegue `cmake` da linea di comando: esso legge `CMakeLists.txt` e produce un `Makefile`
    #.   A questo punto si usa `make` per compilare il programma come al solito.

-   La compilazione avviene quindi ancora attraverso GNU Make, ma il `Makefile` prodotto da CMake è ottimizzato (e mostra una bella barra
percentuale se compilate un progetto che usa tanti file `.cpp`!).

-   Ecco perché studiare GNU Make è ancora utile.


# Esempio di CMake

Per darvi un'idea di come funzioni CMake, ecco il contenuto di `CMakeLists.txt` per l'esercizio 1.2:

```cmake
cmake_minimum_required (VERSION 2.8.11)
project (ESERCIZIO01.2)

add_executable (esercizio01.2
    esercizio01.2.cpp funzioni.cpp)
```

# Esempio di CMake (2/2)

**Attenzione**: se volete provare come funziona CMake, non eseguite `cmake` nella directory, altrimenti sovrascriverà il vostro `Makefile`! Fate così:

```bash
$ mkdir build && cd build
$ cmake .. # Legge il file CMakeLists.txt da ..
$ make # Esegue il `Makefile` in "./build"
$ ./esercizio01.2 # L'eseguibile è in "./build"
```

# Vantaggi di CMake

-   Molte meno righe da scrivere!

-   Tracciamento automatico dei file `.h`: non è necessario dire quali
    file `.h` includa un file `.cpp`, perché pensa automaticamente
    CMake a recuperare l'informazione cercando gli `#include` nel file
    `.cpp`. Non è più necessario quindi indicarli manualmente come nel
    caso di un `Makefile`:

    ```makefile
    # Non necessario se si usa CMake
    funzioni.o: funzioni.cpp funzioni.h
    ```

-   È ormai il metodo standard per includere librerie nei propri
    progetti:
    [ROOT](https://cliutils.gitlab.io/modern-cmake/chapters/packages/ROOT.html),
    [BOOST](https://cliutils.gitlab.io/modern-cmake/chapters/packages/Boost.html),
    [OpenMP](https://cliutils.gitlab.io/modern-cmake/chapters/packages/OpenMP.html),
    [CUDA](https://cliutils.gitlab.io/modern-cmake/chapters/packages/CUDA.html),
    [MPI](https://cliutils.gitlab.io/modern-cmake/chapters/packages/MPI.html),
    [Qt](https://doc.qt.io/qt-5/cmake-manual.html), etc.
