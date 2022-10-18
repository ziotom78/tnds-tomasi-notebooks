---
title: "Lezione 1: Analisi dei dati (arrays)"
author:
- "Leonardo Carminati"
- "Maurizio Tomasi"
date: "A.A. 2021−2022"
lang: it-IT
...

[La pagina con la spiegazione originale degli esercizi si trova qui: [labmaster.mi.infn.it/Laboratorio2/labTNDS/lectures_1819/lezione1_1819.html](http://labmaster.mi.infn.it/Laboratorio2/labTNDS/lectures_1819/lezione1_1819.html).]

In questa prima lezione proviamo a rinfrescare la memoria sulla programmazione lavorando direttamente su un caso concreto: abbiamo a disposizione un file in cui sono immagazzinati i valori ottenuti da una certa misura e vogliamo scrivere un codice per farci sopra una analisi statistica minimale. Calcoliamo la media, la varianza e la mediana della distribuzione: il calcolo della mediana in particolare richiede che il set di dati sia ordinato e quindi ci obbliga a fare un pò di esercizio aggiuntivo. In questa lezione lavoreremo con:

- Tipo di dato da leggere è constituito da numeri `double`.
- Tipo di contenitore di dati è un array (dinamico) del C.
- Operazioni sui dati vengono svolte mediante funzioni.

Prima di incominciare a scrivere il codice è utile ripassare rapidamente alcuni elementi base del linguaggio.

# Passaggio di input da linea di comando

È possibile passare al programma degli input direttamente da riga di comando, ad esempio:

    ./programma <input1> <input2>

per fare questo nella dichiarazione del main bisogna aggiungere due argomenti:

```c++
main(int argc, char *argv[])
```

-   `argc` è il numero di argomenti presenti sulla riga di comando. Il valore di `argc` è sempre maggiore di 0 poiché il primo argomento
        è il nome del programma.
-   `argv` è un array di `argc` elementi che contiene le stringhe di caratteri passate da riga di comando. Quindi `argv[0]` è il nome del programma, `argv[1]` il primo argomento, ecc…

Se da riga di comando passiamo un numero, esso verrà passato tramite `argv` come una stringa di caratteri; per convertire una stringa di caratteri in un numero intero si usa la funzione `atoi(const char*)` (che è contenuta in `<cstdlib>`):

```c++
int N;
N = atoi(argv[1]);
```

Per completezza di informazione, la funzione corrispondente per convertire una stringa di caratteri in un numero reale è `atof(const char*)`, anch'essa disponibile in `<cstdlib>`.

## Cin, cout e cerr

L'output su schermo e l'input da tastiera sono gestiti in C++ usando gli oggetti `cin`, `cout` e `cerr`, che sono definiti nella libreria `<iostream>`.

Il principale vantaggio di questi oggetti rispetto a `scanf` e `printf` (usati nel C) è che non è necessario specificare il tipo (`double`, `string`, etc) che si sta passando all'oggetto.

Uso di `cout` e di `cerr`:

```c++
// Usato per messaggi
cout << "A = " << a << endl;

// Usato per segnalare condizioni di errore
cerr << "Errore nel parametro a: " << a << endl;
```

-   `<<` serve a passare le variabili allo stream di output;
-   `<< "A = "` stampa `A = ` (senza apici) a schermo;
-   `<< a` stampa il valore della variabile a a schermo, qualsiasi sia il tipo di `a`;
-   `<< endl` (end line) stampa la fine della riga e svuota il buffer. È necessario con `cout`, perché altrimenti nessuna scritta appare (subito) a video. Per `cerr` invece basta usare `\n` (ritorno a capo), perché l'output è sempre immediato:

    ```c++
    // Ok, uso `endl` con `cout`
    cout << "Errore, occorre specificare un nome di file!" << endl;
    // Potrebbe non essere stampato subito, ma solo quando il programma termina
    cout << "Errore, occorre specificare un nome di file!\n"
    
    // Questi due casi sono equivalenti, perché scriviamo su `cerr`
    cerr << "Errore, occorre specificare un nome di file!" << endl;
    cerr << "Errore, occorre specificare un nome di file!\n"
    ```

Uso di `cin`:

```c++
cin >> a;
```

-   `>>` serve a prendere le variabili dallo stream di input;
-   `>> a` legge da video un contenuto appropriato e lo salva nella variabile a.

**Attenzione**: se `a` è una variabile `int` e voi a schermo digitate 2.34, il valore di `a` sarà convertito a 2. Se digitate a schermo "pippo", non sarà possibile convertirlo in un numero, ed il valore di `a` rimarrà inalterato.

## Allocazione dinamica della memoria

L'allocazione dinamica della memoria consente di decidere al momento dell'esecuzione, ossia a *runtime* e non al momento della compilazione, quanta memoria il programma deve allocare.

In C++ l'allocazione e la deallocazione dinamica della memoria viene effettuata rispettivamente con gli operatori `new` e `delete`. Il comando

```c++
double *x = new double[N];
```

crea un puntatore `x` a una zona di memoria di `N` double (cioè a un array di `double` con `N` elementi). Il comando

```c++
delete[] x;
```

dealloca la memoria; ciò vuol dire che un tentativo di accedere agli elementi di `x` dopo il comando delete risulterà in un errore di *segmentation violation*.

È estremamente importante ricordarsi di deallocare la memoria. Infatti in programmi complessi che utilizzano molta memoria (o in cicli che continuano ad allocare memoria), l'assenza della deallocazione può portare a consumare progressivamente tutta la memoria RAM della macchina (*memory leak*), causando un blocco del sistema.

Nel caso si allochino vettori (come nel nostro caso), la presenza delle parantesi `[]` dopo `delete` indica che bisogna deallocare tutta la zona di memoria. Il comando

```c++
delete x;
```

crea un *memory leak*, perché dealloca solo lo spazio della prima componente del vettore, non di tutto il vettore. Questo programma quindi è **sbagliato**:

```c++
#include <cstdlib>

int main(int argc, char *argv[]) {
  double * array = new double[10];
  array[1] = 30.0;
  delete array;    // Error, it should have been delete[] array;
  return 0;
}
```

Il compilatore `g++` non segnala questo tipo di errore:

```
$ g++ -o test test.cpp
$ 
```

Potete però usare il flag `-Wall` (**consigliatissimo per tutti i vostri programmi!**), in modo che il compilatore vi avvisi:

```
$ g++ -Wall -o test test.cpp
test.cpp: In function ‘int main(int, const char**)’:
test.cpp:6:10: warning: ‘void operator delete(void*, long unsigned int)’ called on pointer returned from a mismatched allocation function [-Wmismatched-new-delete]
    6 |   delete array;
      |          ^~~~~
test.cpp:4:33: note: returned from ‘void* operator new [](long unsigned int)’
    4 |   double * array = new double[10];
      |                                 ^
$ 
```

## Fstream

L'input e l'output da files è gestito in C++ dalla libreria `fstream`. I principali oggetti sono `ifstream` (*input file stream*) e `ofstream` (*output file stream*). Gli stream vengono dichiarati e inizializati come:

```c++
#include <fstream>

using namespace std;

ifstream inputFile("nomeInput.txt");
ofstream outputFile("nomeOutput.txt");
```

Per controllare che il file sia stato aperto con successo si può usare il seguente codice

```c++
if(! inputFile) {
  cerr << "Error ....\n"l; //stampa un messaggio
  return 1; // Ritorna un valore diverso da quello usuale
}
```

L'utilizzo degli stream per scrivere su un file di output o per caricare da un file di input è uguale all'uso di `cin`, `cout` e `cerr`:

```c++
inputFile >> a;
outputFile << "pippo " << a << "\n";
```

A differenza di `cout`, quando si scrive in file non è di solito rilevante la differenza tra `endl` e `"\n"`.

Un metodo estremamente utile di `ifstream` è

```c++
inputFile.eof();   # Return a boolean
```

che restituisce vero se si è raggiunta la fine del file e falso altrimenti. Dopo l'utilizzo del file è possibile chiuderlo con il metodo `close()`:

```c++
inputFile.close();
outputFile.close();
```

Questo metodo viene però invocato automaticamente dal compilatore C++, quindi questa funzione:

```c++
double readDoubleFromFile(const string & file_name) {
  ifstream inputFile(file_name);
  double a
  inputFile >> a;
  inputFile.close();
  return a;
}
```

è esattamente uguale a questa:

```c++
double readDoubleFromFile(const string & file_name) {
  ifstream inputFile(file_name);
  double a
  inputFile >> a;
  // Non c'è bisogno di chiamare inputFile.close(), ci pensa il compilatore
  return a;
}
```

# Esercizio 1.0 - Primo codice per analisi {#esercizio-1.0}

Proviamo a scrivere un unico codice che legga dati da file, li immagazzini in un array dinamico, calcoli la media, la varianza e la mediana dei dati raccolti. Scriviamo su un file di output i dati riordinati in ordine crescente. Il numero di elementi da caricare e il nome del file in cui trovare i dati sono passati da tastiera nel momento in cui il programma viene eseguito. Cerchiamo di costruire il codice passo passo.

## Struttura del programma

Per questo primo esercizio ripassiamo la struttura generale di un programma:

```c++
#include <cstdlib>
#include <fstream>
#include <iostream>

using namespace std;

int main(int argc, char *argv[]) {
  if (argc < 3) {
      cerr << "Uso del programma: " << argv[0] << " <n_data> <filename>\n";
      return 1;
  }

  int ndata = atoi(argv[1]);
  double * data = new double[ndata];
  const char * filename = argv[2];

  // 1) leggi i dati da file e caricali nel c-array data
  // ...

  // dopo averli caricati, visualizzali a video
  for(int k = 0; k < ndata; ++k) {
      cout << data[k] << endl;
  }

  // 2) calcola la media e la varianza degli elementi caricati
  // ...

  // Stampa il risultato
  cout << "Media = " << media << endl;
  cout << "Varianza = " << varianza << endl;

  // calcola la mediana: prima crea una copia del vettore di partenza
  double * vcopy = new double[ndata];
  for(int k = 0; k < ndata; ++k) {
      vcopy[k] = data[k];
  }

  // 3) riordina gli elementi del vettore `vcopy` dal minore al maggiore
  // ...

  // dopo averli riordinati, stampali a video
  cout << "Valori riordinati:" << endl;
  for(int k = 0; k < ndata; ++k) {
      cout << vcopy[k] << endl;
  }

  // 4) prendi il valore centrale (se `ndata` è dispari) o la media
  // tra i due centrali (se `ndata` è pari) dell'array ordinato `vcopy`
  // ...

  cout << "Mediana = " << mediana << endl;

  // visualizza l'array originale per verificare che non è stato
  // riordinato

  for(int k = 0; k < ndata; ++k) {
      cout << data[k] << endl;
  }

  // 5) scrivi i dati riordinati su un file
  // ...

  delete[] vcopy;
  delete[] data;
}
```

Provate ad implementare le parti mancanti. Se non ci riuscite sbirciate pure sotto.

## Caricamento elementi da file (1)

In questo frammento di codice apriamo un file utilizzando un `ifstream` e carichiamo `ndata` elementi:

```c++
// leggi dati da file e caricali nel c-array data

ifstream fin(filename);

if (!fin) {
    cerr << "Non riesco ad aprire il file " << filename << endl;
    exit(1);
} else {
    for(int k = 0; k < ndata; ++k) {
        fin >> data[k];
        if (fin.eof()) {
            cerr << "Raggiunta la fine del file prima di aver letto " << ndata << "dati, esco\n";
            exit(1);
    }
}
```

## Calcolo della media e della varianza (2)

In questo frammento di codice calcoliamo la media degli elementi immagazzinati nell'array data. Costruite voi usando lo stesso schema il frammento di codice per il calcolo della varianza.

```c++
// calcolo la media degli elementi caricati

double media = 0;
for(int k = 0; k < ndata; ++k) {
    media += data[k];
}

// un `double` (media) diviso per un intero è un double:
// tutto ok, nessun arrotondamento!
media /= ndata;
cout << "Valore medio del set di dati caricato: " << media << endl;
```

## Riordino elementi di un array (3)

In questo frammento di codice riordiniamo gli elementi dell'array data in ordine crescente. Utilizziamo un semplice algoritmo di riordinamento che dovreste già conoscere, il [*selection sort*](https://it.wikipedia.org/wiki/Selection_sort).

```c++
// prima riordino gli elementi del vettore dal minore al maggiore
// devo farne una copia in modo che il vettore originale resti
// inalterato

double * vcopy = new double[ndata];
for(int k = 0; k < ndata; ++k) {
    vcopy[k] = data[k];
}

int imin = 0;
double min = 0;
for(int j = 0; j < ndata - 1; ++j) {
    imin = j;
    min = vcopy[imin];
    for(int i = j + 1; i < ndata; ++i) {
        if(vcopy[i] < min) {
            min = vcopy[i];
            imin = i;
        }
    }

    // Scambia vcopy[j] con vcopy[imin]
    double c = vcopy[j];
    vcopy[j] = vcopy[imin];
    vcopy[imin] = c;
}
```

## Calcolo della mediana (4)

In questo frammento di codice calcoliamo la mediana lavorando sull'array ordinato `vcopy`:

```c++
// prendo il valore centrale (`ndata` dispari) o la media tra i due
// centrali (`ndata` pari) dell'array ordinato

double mediana = 0;

if (ndata % 2 == 0) {
    mediana = (vcopy[ndata / 2 - 1] + vcopy[ndata / 2]) / 2;
} else {
    mediana = vcopy[ndata / 2];
}

cout << "Mediana = " << mediana << endl;
```


## Scrittura elementi su file (5)

Infine scriviamo il vettore ordinato su un file `output_file.txt`:

```c++
ofstream fout("output_file.txt");
for(int k = 0; k < ndata; ++k) {
    fout << vcopy[k] << endl;
}

fout.close();
```

-   Compiliamo il programma invocando come al solito `g++`:

    ```
    g++ main.cpp -o main
    ```

-   Eseguiamo il programma:

    ```
    ./main 1000000 data.dat
    ```

# Esercizio 1.1 - Codice di analisi con funzioni {#esercizio-1.1}

Vogliamo ora riorganizzare il codice precedente per renderlo più modulare e facilmente riutilizzabile. Per capirci meglio: il calcolo della media è una operazione generale che può essere immaginata come un blocco di codice che accetta in input un array di dati e una dimensione e restituisce un valore (la media, appunto). Se in uno stesso codice principale dobbiamo calcolare più volte la media di array di dati diversi, non vogliamo ripetere più volte il frammento di codice relativo; lo stesso vale per la lettura di un set di dati da un file o per il calcolo della mediana. Il codice dovrebbe avere quindi una struttura del tipo:

-   Dichiarazione di tutte le funzioni che verranno utilizzate.
-   Programma vero e proprio `int main() {...}` in cui le funzioni vengono utilizzate.
-   Al termine del programma principale l'implementazione di tutte le funzioni dichiarate.

Dal momento che abbiamo deciso di spezzare il codice in funzioni proviamo a fare uso di una funzione dedicata che scambi tra loro due elementi di un array. In questo caso ripassiamo prima rapidamente come funziona il passaggio di dati in una funzione.

## Funzioni con argomenti *by reference*, *by value* e *by pointer*

Il passaggio di valori a una funzione può avvenire *by value*, *by reference* o *by pointer*.

Ad esempio, se vogliamo scrivere una funzione che incrementi di uno il valore di una variabile intera abbiamo tre possibilità:

<table>
<thead>
<tr>
<td>Tipo</td>
<td>*By value* (C e C++)</td>
<td>*By reference* (C++)</td>
<td>*By pointer* (C e C++)</td>
</tr>
</thead>
<tbody>
<tr>
<td>Implementazione</td>
<td>

```c++
void incrementa(int a) {
  a++;
}
```

</td>
<td>

```c++
void incrementa(int &a) {
  a++;
}
```

</td>
<td>

```c++
void incrementa(int *a) {
  (*a)++;
}
```

</td>
</tr>
<tr>
<td>Chiamata</td>
<td>

```c++
int a = 0;
incrementa(a);
```

</td>
<td>

```c++
int a = 0;
incrementa(a);
```

</td>
<td>

```c++
int a = 0;
incrementa(&a);
```

</td>
</tr>
<tr>
<td>Effetto</td>
<td>`a` **non** viene incrementato</td>
<td>`a` viene incrementato</td>
<td>`a` viene incrementato</td>
</tr>
</tbody>
</table>

Il passaggio dei parametri *by value* non funziona poiché alla funzione vengono passate copie dei parametri, e la funzione chiamata opera su queste copie dei parametri. Qualunque cambiamento apportato alle copie non ha alcun effetto sui valori originali dei parametri presenti nella funzione chiamante.

Le chiamate *by pointer* e *by reference* passano alla funzione l'indirizzo di memoria in cui il programma ha memorizzato la variabile `a`. Per cui la funzione agisce direttamente sulla variabile `a` e non su una copia.

Vediamo ora passo passo come fare.

## Struttura del programma

Ecco come potrebbe diventare il vostro codice dopo la cura:

```c++
#include <cstdlib>
#include <fstream>
#include <iostream>

using namespace std;

double CalcolaMedia(double*, int);
double CalcolaVarianza(double*, int);
double CalcolaMediana(double[], int);
double * ReadDataFromFile(const char *, int);
void Print(const char *, double *, int);
void scambiaByValue(double, double);
void scambiaByRef(double &, double &);
void scambiaByPointer(double *, double *);
void selection_sort(double *, int);

int main(int argc, char *argv[]) {
  if (argc < 3) {
      cerr << "Uso del programma: " << argv[0] << " <n_data> <filename>\n";
      return 1;
  }

  int ndata = atoi(argv[1]);
  const char * filename = argv[2];

  // uso la funzione per leggere gli elementi da un file
  double * data = ReadDataFromFile(filename, ndata);

  // dopo averli caricati, visualizzali a video
  for(int k = 0; k < ndata; ++k) {
      cout << data[k] << endl;
  }

  // calcola la media e la varianza degli elementi caricati
  cout << "Media = " << CalcolaMedia(data, ndata) << endl;
  cout << "Varianza = " << CalcolaVarianza(data, ndata) << endl;
  cout << "Mediana = " << CalcolaMediana(data, ndata) << endl;

  // scrivi i dati riordinati su un file
  Print("fileout.txt", data, ndata);

  delete[] data;
}
```

Queste le funzioni da definire a parte:

```c++
double * ReadDataFromFile(const char * filename, int size) {
  double * data = new double[size];

  // ...

  return data;
}

void Print(const char * filename, double * data, int size) {
  // ..
}

double CalcolaMedia(double * data, int size) {
  // ..

  return media;
}

double CalcolaVarianza(double * data, int size) {
  // ..

  return varianza;
}

void scambiaByValue(double a, double b) {
  double c = a;
  a = b;
  b = c;
}

void scambiaByRef(double &a, double &b) {
  double c = a;
  a = b;
  b = c;
}

void scambiaByPointer(double *a, double *b) {
  double c = *a;
  *a = *b;
  *b = c;
}

void selection_sort(double * vec, int size) {
  for(int j = 0; j < size - 1; ++j) {
      int imin = j;
      double min = vec[imin];
      for(int i = j + 1; i < size; ++i) {
          if(vec[i] < min) {
              min = vec[i];
              imin = i;
          }
      }

      scambiaByRef(vec[j], vec[imin]);
      // equivalente:
      // scambiaByPointer(vec + j, vec + imin);
  }
}

// Calcola la mediana di un array `vec` di dimensione `size`.
// Prima crea una copia dell'array, poi lo riordina e quindi
// calcola la mediana
double CalcolaMediana(double * data, int size) {
  double * vcopy = new double[size];
  for(int i = 0; i < size; ++i) {
      vcopy[i] = vec[i];
  }

  selection_sort(vcopy, size);

  double mediana = 0;

  if(size % 2 == 0) {
      mediana = (vcopy[size / 2 - 1] + vcopy[size / 2]) / 2;
  } else {
      mediana = vcopy[size / 2];
  }

  delete[] vcopy;

  return mediana;
}
```

Il `main` è ora decisamente più compatto e leggibile. Quasi tutte le principali funzionalità del codice sono state scorporate in un opportuno set di funzioni.

Come nel caso dell'esercizio precedente compiliamo il programma invocando come al solito `g++`:

    g++ main.cpp -o main


Eseguiamo il programma :

    ./main 1000000 data.dat

# Esercizio 1.2 - Codice di analisi con funzioni e Makefile {#esercizio-1.2}

In questo esercizio terminiamo il processo di riorganizzazione dell'esercizio 1.0. Procederemo in questo modo:

-   Tutte le dichiarazioni di variabili che abbiamo messo in testa al programma le spostiamo in un file separato `funzioni.h`.
-   Tutte le implementazioni delle funzioni in coda al programma le spostiamo in un file separato `funzioni.cpp`.
-   Ricordiamoci di includere il file `funzioni.h` sia in `main.cpp` sia in `funzioni.cpp` tramite il solito `#include "funzioni.h"`
-   Compiliamo separatamente `main.cpp` e `funzioni.cpp` utilizzando un `Makefile`

Prima di incominciare, rivediamo rapidamente come si scrive un `Makefile`:

## Il Makefile

Vogliamo creare un `Makefile` che ci permetta di compilare il nostro programma quando questo è composto/spezzato in diversi file sorgenti. Supponiamo di avere un codice spezzato in tre file:

#.  `main.cpp`
#.  `funzioni.cpp`
#.  `funzioni.h`

Ovviamente possiamo compilare il tutto con

    g++ main.cpp funzioni.cpp -o main

ma possiamo farlo in maniera molto più efficace. La struttura/sintassi del `Makefile` è la seguente:

```
target: dipendenze
[tab] system command
```

Nel nostro caso

```makefile
main: funzioni.cpp main.cpp
    g++ funzioni.cpp main.cpp -o main
```

lanciando il comando `make` tutto viene compilato.

Possiamo scriverlo anche esplicitando le dipendenze in modo che anche quando cambiamo il file `.h` il tutto venga propriamente ricompilato. In questo caso il `Makefile` diventa:

```makefile
main: main.o funzioni.o
    g++ -g -Wall --pedantic -std=c++11 main.o funzioni.o -o main
main.o: main.cpp funzioni.h
    g++ -g -Wall --pedantic -std=c++11 -c main.cpp -o main.o
funzioni.o: funzioni.cpp funzioni.h
    g++ -g -Wall --pedantic -std=c++11 -c funzioni.cpp -o funzioni.o
```

Notate però quanto il `Makefile` sia ripetitivo. È possibile definire delle *variabili* nel Makefile per semplificarlo:

```makefile
CXXFLAGS = -g -Wall --pedantic -std=c++11

main: main.o funzioni.o
    g++ main.o funzioni.o -o main $(CXXFLAGS)

main.o: main.cpp funzioni.h
    g++ -c main.cpp -o main.o $(CXXFLAGS)
    
funzioni.o: funzioni.cpp funzioni.h
    g++ -c funzioni.cpp -o funzioni.o $(CXXFLAGS)
```

La variabile `$@` è una cosiddetta *variabile implicita*, e viene sostituita di volta in volta col nome del *target* corrente (che nell'esempio sopra è `main`, `main.o` e infine `funzioni.o`). I flag `-g -Wall --pedantic -std=c++11` servono per rendere la compilazione e l'esecuzione del codice più sicura, perché abilitano dei controlli addizionali, spiegati nelle [slide](tomasi-lezione-01.html#flag-del-compilatore).


# Esercizio 1.3 - Overloading di funzione (da consegnare) {#esercizio-1.3}

Aggiungete alla vostra libreria di funzioni una funzione `void Print(const double *, int)` che permetta di scrivere gli elementi di un array a video. Questo è possibile grazie all'*overloading* (funzioni con stesso nome, ma con argomenti differenti).

## Overloading di funzioni

L'overloading delle funzioni è una funzionalità specifica del C++ che non è presente in C. Questa funzionalità permette di poter utilizzare lo stesso nome per funzioni diverse (cioè che compiono operazioni diverse) all'interno dello stesso programma, a patto però che gli argomenti forniti alla funzione siano differenti. In maniera automatica, il compilatore sceglierà la funzione appropriata a seconda del tipo di argomenti passati. In pratica:

```c++
void Print(const double *  data, int ndata) {...}

void Print(const char * filename, const double * data, int ndata) {...}
```

Le due funzioni hanno lo stesso nome, ma ovviamente il codice al loro interno dovrà essere differente! Si noti che per poter fare l'overloading di una funzione non basta che soltanto il tipo restituito dalla funzione sia differente, ma occorre che siano diversi i tipi e/o il numero dei parametri passati alla funzione.

Seguono ulteriori suggerimenti.

## Formattazione dell'output

La C++ Standard Library permette di manipolare la formattazione dell'output utilizzando i manipolatori, alcuni dei quali sono dichiarati nell'header `<iomanip>`.
In generale i manipolatori modificano lo stato di uno stream (`cout`, `cin`, `cerr`, `ofstream`, `ifstream`…).

I manipolatori che ci serviranno per modificare l'output di numeri floating-point sono:

-   `fixed`: stampa i numeri senza l'uso di esponenti, ove possibile
-   `scientific`: stampa i numeri utilizzando gli esponenti
-   `setprecision(int n)`: stampa `n` cifre dopo la virgola

Esempio:

```c++
cout << "double number: " << setprecision(4) << double_number;
```

Utili per stampare i dati in una tabella sono

-   `setw(int n)`: imposta la larghezza di un campo ad n
-   `setfill(char c)`: usa c come carattere di riempimento (quello di default è lo spazio)

Ad esempio:

```c++
cout << setw(5) << "0.132" << setw(5) << "234" << endl
     << setw(5) << "10" << setw(5) << "12" << endl
```

stampa i numeri in due colonne allineate.

## Questione di stile

Proviamo a vedere alcune possibili varianti per le funzioni relative al calcolo della media e della varianza:

```c++
// Versione 1
double CalcolaMedia(double * data, int size) {
  double accumulo = 0;

  if(size == 0) {
      return accumulo;
  }

  for(int k = 0; k < size; ++k) {
      accumulo += data[k];
  }

  return 1.0 / static_cast<double>(size) * accumulo;
}

// Versione 2
double CalcolaMedia(double * data, int size) {
  double accumulo = 0;

  if(size == 0) {
      return accumulo;
  }

  for(int k = 0; k < size; ++k) {
      accumulo = static_cast<double>(k) / static_cast<double(k + 1) * accumulo +
          1.0 / static_cast<double>(k + 1) * data[k];
  }

  return accumulo;
}
```

La prima funzione implementa il calcolo in modo intuitivo. La seconda è meno ovvia ma se ci pensate ha lo stesso effetto con il grosso vantaggio di non conservare la somma di tutti i valori che potrebbe diventare troppo grande.

```c++
// Versione 1
double CalcolaVarianza(double * data, int size) {
  double result = 0;
  if(size == 0) {
      return result;
  }

  double sumx = 0;
  double sumx2 = 0;

  for(int i = 0; i < size; ++i) {
      sumx += data[i];
      sumx2 += data[i] * data[i];
  }

  result = 1.0 / static_cast<double>(size) * (sumx2 - (sumx * sumx / static_cast<double>(size)));
  return result;
}

// Versione 2
double CalcolaVarianza(double * data, int size) {
  double result = 0;
  if(size == 0) {
      return result;
  }

  double old_average;
  double average = 0;

  for(int i = 0; i < size; ++i) {
      old_average = average;
      average = static_cast<double>(i) / static_cast<double>(i + 1) * average +
          1.0 / static_cast<double>(i + 1) * data[i];

      result = 1.0 / static_cast<double>(i + 1) *
          (static_cast<double>(i) * result +
           data[i] * data[i] +
           static_cast<double>(i) * old_average * old_average) -
          average * average;
  }

  return result;
}
```

Nel caso della varianza la prima implementazione richiede una chiamata alla funzione CalcolaMedia() mentre la seconda no. La terza infine implementa il calcolo nello stesso modo visto per la media, ovvero evitando di immagazzinare somme troppo elevate.
