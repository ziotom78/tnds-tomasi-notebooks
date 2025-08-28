---
title: "Lezione 1: Analisi dei dati (arrays)"
author:
- "Leonardo Carminati"
- "Maurizio Tomasi"
date: "A.A. 2021−2022"
lang: it-IT
...

[La pagina con la spiegazione originale degli esercizi si trova qui: <https://labtnds.docs.cern.ch/Lezione1/Lezione1/>.]

In questa prima lezione proviamo a rinfrescare la memoria sulla programmazione lavorando direttamente su un caso concreto: abbiamo a disposizione un file in cui sono immagazzinati i valori ottenuti da una certa misura e vogliamo scrivere un codice per farci sopra una analisi statistica minimale.

1. Carichiamo in memoria dei dati che provengono da un file di misure;
2. Calcoliamo media, varianza e mediana del campione.

Il calcolo della mediana in particolare richiede che il set di dati sia ordinato e quindi ci obbliga a fare un po' di esercizio aggiuntivo.

# Che dati analizzeremo?

In questo caso guardiamo un file [1941.txt](1941.txt) che contiene le differenze tra la temperatura stimata ogni giorno dell'anno 1941 dal modello di re-analisi [ERA5](https://cds.climate.copernicus.eu/cdsapp#!/dataset/reanalysis-era5-single-levels?tab=overview) e la media delle temperature stimate dallo stesso modello dal 1941 a 2023 per quel giorno nell'area di Milano. Questi dati possono essere scaricati dal sito <https://open-meteo.com/>. Nelle prossime lezioni dovremo imparare ad aprire tutti i files, uno per ogni anno di misure.

In questa lezione lavoreremo con questi ingredienti:

- Il tipo di dato da leggere è constituito da numeri `double` immagazzinati in un file [1941.txt](1941.txt).
- Il tipo di contenitore di dati è un *array* (dinamico) del C.
- Le operazioni sui dati vengono svolte mediante funzioni.

Prima di incominciare a scrivere il codice è utile ripassare rapidamente alcuni elementi base del linguaggio.

# Passaggio di input da linea di comando

È possibile passare al programma degli input direttamente da riga di comando, ad esempio:

    ./programma <input1> <input2>

Per fare questo, nella dichiarazione del main bisogna aggiungere due argomenti:

```c++
int main(int argc, char *argv[])
```

-   `argc` è il numero di argomenti presenti sulla riga di comando. Il valore di `argc` è sempre maggiore di 0 poiché il primo argomento è il nome del programma.
-   `argv` è un array di `argc` elementi che contiene gli array di caratteri passati da riga di comando. Quindi `argv[0]` è il nome del programma, `argv[1]` il primo argomento, ecc…

Se da riga di comando passiamo un numero, esso verrà passato tramite `argv` come un array di caratteri; per convertire un array di caratteri in un numero **intero** (`int`) si usa la funzione `std::stoi(const std::string &)` (che è contenuta in `<string>`):

```c++
int N;
N = std::stoi(argv[1]);
```

Se avessimo avuto bisogno di convertire una stringa in un numero **floating-point** (`double`), la funzione da usare sarebbe invece stata `std::stod(const std::string &)` (notare la `d` alla fine anziché la `i`!), anch'essa disponibile in `<string>`:

```c++
double fl;
fl = std::stod(argv[1]);
```

<div class="warning-box">

## Le funzioni `atoi` e `atof`

Il C++ fornisce anche le funzioni `atoi` e `atof`, che sono state definite nello standard C del 1971, ma **sono da evitare**. In caso di errore infatti restituiscono il valore `0`, come mostra questo esempio:

```c++
#include <iostream>
#include <cstdlib>

using namespace std;

int main(int argc, char *argv[]) {
  if (argc != 2) {
	cerr << "Errore, devi specificare un numero intero da linea di comando.\n";
	return 1;
  }

  int i = atoi(argv[1]);
  cout << argv[1] << " convertito in un intero è " << i << "\n";
}
```

Come vedete, il programma restituisce lo stesso output sia che si passi il valore `0` (corretto) sia che si passi `pippo` (sbagliato):

```
$ ./test 5
5 convertito in un intero è 5
$ ./test 0
0 convertito in un intero è 0
$ ./test pippo
pippo convertito in un intero è 0
```

Se invece si usa `std::stoi` anziché `atoi` per inizializzare `i`:

```c++
int i = stoi(argv[1]);
```

il programma funziona come sopra con gli input corretti (`5` e `0`), ma stavolta segnala l'errore quando si inserisce `pippo`:

```
$ ./test 5
5 convertito in un intero è 5
$ ./test 0
0 convertito in un intero è 0
$ ./test pippo
terminate called after throwing an instance of 'std::invalid_argument'
  what():  stoi
Aborted (core dumped)
```
</div>

## Cin, cout e cerr

L'output su schermo e l'input da tastiera sono gestiti in C++ usando gli oggetti `cin`, `cout` e `cerr`, che sono definiti nella libreria `<iostream>`. Vediamo un esempio:

```c++
// Usato per messaggi
cout << "A = " << a << endl;

// Usato per segnalare condizioni di errore
cerr << "Errore nel parametro a: " << a << endl;
```

-   `<<` serve a passare le variabili allo stream di output;
-   `<< "A = "` stampa `A = ` (senza apici) a schermo;
-   `<< a` stampa il valore della variabile a a schermo, qualsiasi sia il tipo di `a`;
-   `<< endl` (end line) stampa la fine della riga e svuota il buffer. È necessario con `cout`, perché altrimenti nessuna scritta appare (subito) a video. Per `cerr` invece è equivalente all'uso di `\n` (ritorno a capo), perché l'output è sempre immediato:

    ```c++
    // Ok, uso `endl` con `cout`
    cout << "Errore, occorre specificare un nome di file!" << endl;
    // Potrebbe non essere stampato subito, ma solo quando il programma termina
    cout << "Errore, occorre specificare un nome di file!\n";

    // Questi due casi sono equivalenti, perché scriviamo su `cerr`
    cerr << "Errore, occorre specificare un nome di file!" << endl;
    cerr << "Errore, occorre specificare un nome di file!\n"
    ```

Si dovrebbe usare `cout` per i messaggi informativi (ad esempio, quando stampate il risultato di un calcolo) e `cerr` per i messaggi d'errore; vedremo nelle prossime lezioni quale sia la ragione di questa regola.

Uso di `cin`:

```c++
int a;
cin >> a;
```

-   `>>` serve a prendere le variabili dallo stream di input;
-   `>> a` legge da video un contenuto appropriato e lo salva nella variabile a.

**Attenzione**: se `a` è una variabile `int` e digitate da tastiera 2.34, il valore di `a` sarà convertito a 2. Se digitate `pippo`, non sarà possibile convertirlo in un numero, ed il valore di `a` rimarrà inalterato.

## Allocazione dinamica della memoria

L'allocazione dinamica della memoria consente di decidere *al momento dell'esecuzione* (*runtime*) quanta memoria il programma deve allocare. In C++ l'allocazione (e la de-allocazione) dinamica della memoria viene effettuata con gli operatori `new` e `delete`. Il comando

```c++
double *x = new double[N];
```

crea un puntatore `x` a una zona di memoria di `N` double (cioè a un array di `double` con `N` elementi). Il comando

```c++
delete[] x;
```

dealloca la memoria; ciò vuol dire che un tentativo di accedere agli elementi di `x` dopo il comando delete potrebbe portare ad un errore di *segmentation violation*.

È estremamente importante ricordarsi di deallocare la memoria. Infatti in programmi complessi che utilizzano molta memoria (o in cicli che continuano ad allocare memoria), l'assenza della deallocazione può portare a consumare progressivamente tutta la memoria RAM della macchina (*memory leak*), causando un blocco del sistema. Nel caso in cui si allochino array (come nel nostro caso), la presenza delle parantesi `[]` dopo `delete` indica che bisogna deallocare tutta la zona di memoria. Il comando

```c++
delete x;
```

crea un *memory leak*, perché dealloca solo il puntatore all'array ma non il suo contenuto. Questo programma quindi è in linea di principio **sbagliato**:

```c++
#include <cstdlib>

int main(int argc, char *argv[]) {
  double * array = new double[10];
  array[1] = 30.0;
  delete array;    // Errore, sarebbe dovuto essere "delete[] array;"
  return 0;
}
```

Il compilatore `g++` non segnala questo tipo di errore:

```
$ g++ -o test test.cpp
$
```

Potete però usare i flag `-Wall -Wextra -Werror --pedantic` (**consigliatissimi per tutti i vostri programmi!**), in modo che il compilatore vi avvisi:

```
$ g++ -std=c++23 -g3 -Wall -Wextra -Werror --pedantic -o test test.cpp
test.cpp: In function ‘int main(int, const char**)’:
test.cpp:6:10: error: ‘void operator delete(void*, long unsigned int)’ called on pointer returned from a mismatched allocation function [-Wmismatched-new-delete]
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
  cerr << "Error ....\n"; //stampa un messaggio
  return 1; // Ritorna un valore diverso da quello usuale
}
```

L'utilizzo degli stream per scrivere su un file di output o per caricare da un file di input è uguale all'uso di `cin`, `cout` e `cerr`:

```c++
inputFile >> a;
outputFile << "pippo " << a << "\n";
```

Siccome di solito il contenuto di un file viene ispezionato dopo il termine del programma, quando si scrive in file non è di solito rilevante la differenza tra `endl` e `"\n"`.

Un metodo estremamente utile di `ifstream` è

```c++
inputFile.eof();   // Restituisce un valore Booleano
```

che restituisce `true` se si è raggiunta la fine del file, `false` altrimenti. Dopo l'utilizzo del file è possibile chiuderlo con il metodo `close()`:

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
  inputFile.close();  // Non necessario
  return a;
}
```

è esattamente uguale a questa:

```c++
double readDoubleFromFile() {
  ifstream inputFile("data.dat");
  double a;
  inputFile >> a;
  // Non c'è bisogno di invocare inputFile.close(): ci pensa g++
  return a;
}
```

# Esercizio 1.0 - Primo codice per analisi {#esercizio-1.0}

Scriviamo un unico codice che legge i dati da file, li immagazzina in un array dinamico, e infine calcola la media, la varianza e la mediana dei dati raccolti. Scriviamo su un file di output i dati riordinati in ordine crescente. Il numero di elementi da caricare e il nome del file in cui trovare i dati sono passati da tastiera nel momento in cui il programma viene eseguito. Cerchiamo di costruire il codice passo passo.

## Struttura del programma

Per questo primo esercizio ripassiamo la struttura generale di un programma:

```c++
#include <fstream>
#include <iostream>
#include <string>

using namespace std;

int main(int argc, char *argv[]) {
  if (argc < 3) {
      cerr << "Uso del programma: " << argv[0] << " <n_data> <filename>\n";
      return 1;
  }

  int ndata = stoi(argv[1]);
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
            cerr << "Raggiunta la fine del file prima di aver letto " << ndata << " dati, esco\n";
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


Esistono vari tipi di algoritmi di riordinamento con prestazioni molto diverse. Qui implementiamo uno dei più semplici (ma anche dei più lenti), che viene chiamato *simple sort* o [*selection sort*](https://it.wikipedia.org/wiki/Selection_sort). Sentitevi liberi di implementare algoritmi più raffinati.

```c++
// Prima riordino gli elementi del vettore dal minore al maggiore.
// Devo farne una copia, in modo che il vettore originale resti
// inalterato.

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
    g++ esercizio1.0.cpp -std=c++23 -g -Wall -Wextra -Werror --pedantic -o main
    ```

-   Eseguiamo il programma:

    ```
    ./main 365 1941.txt
    ```

**Domanda**: Quanti elementi contiene il file [1941.txt](1941.txt)? Cosa succede se tento di leggere un milione di elementi ?


# Esercizio 1.1 - Codice di analisi con funzioni {#esercizio-1.1}

Vogliamo ora riorganizzare il codice precedente per renderlo più modulare e facilmente riutilizzabile. Per capirci meglio: il calcolo della media è una operazione generale che può essere immaginata come un blocco di codice che accetta in input un array di dati e una dimensione e restituisce un valore (la media, appunto). Se in uno stesso codice principale dobbiamo calcolare più volte la media di array di dati diversi, non vogliamo ripetere più volte il frammento di codice relativo; lo stesso vale per la lettura di un set di dati da un file o per il calcolo della mediana. Il codice dovrebbe avere quindi una struttura del tipo:

-   Dichiarazione di tutte le funzioni che verranno utilizzate.
-   Programma vero e proprio `int main() {...}` in cui le funzioni vengono utilizzate.
-   Al termine del programma principale l'implementazione di tutte le funzioni dichiarate.

Dal momento che abbiamo deciso di spezzare il codice in funzioni proviamo a fare uso di una funzione dedicata che scambi tra loro due elementi di un array. In questo caso ripassiamo prima rapidamente come funziona il passaggio di dati in una funzione.

## Funzioni con argomenti *by reference*, *by value* e *by pointer*

Il passaggio di valori a una funzione può avvenire *by value*, *by reference* o *by pointer*.

Consideriamo l'esempio di una funzione che scambi il valore di due variabili. Abbiamo tre possibilità:

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
void scambiaByValue(
    double a,
    double b
) {
  double c = a;
  a = b;
  b = c;
}
```

</td>
<td>

```c++
void scambiaByRef(
    double & a,
    double & b
) {
  double c = a;
  a = b;
  b = c;
}
```

</td>
<td>

```c++
void scambiaByPtr(
    double * a,
    double * b
) {
  double c = *a;
  *a = *b;
  *b = c;
}
```

</td>
</tr>
<tr>
<td>Chiamata</td>
<td>

```c++
double a = 5;
double b = 4;
scambia(a, b);
```

</td>
<td>

```c++
double a = 5;
double b = 4;
scambiaByRef(a, b);
```

</td>
<td>

```c++
double a = 5;
double b = 4;
scambiaByPtr(&a, &b);
```

</td>
</tr>
<tr>
<td>Effetto</td>
<td>`a` e `b` restano gli stessi! **Errore!**</td>
<td>`a = 4`, `b = 5`: ok!</td>
<td>`a = 4`, `b = 5`: ok!</td>
</tr>
</tbody>
</table>

Il passaggio dei parametri *by value* non funziona poiché alla funzione vengono passate copie dei parametri, e la funzione chiamata opera su queste copie dei parametri. Qualunque cambiamento apportato alle copie non ha alcun effetto sui valori originali dei parametri `a` e `b` presenti nella funzione chiamante.

Le chiamate *by pointer* e *by reference* passano alla funzione l'indirizzo di memoria in cui il programma ha memorizzato la variabile `a`, per cui la funzione agisce direttamente sulla variabile `a` e non su una copia.

Vediamo ora passo passo come fare.

## Struttura del programma

Ecco come potrebbe diventare il vostro codice dopo la cura:

```c++
#include <fstream>
#include <iostream>
#include <string>

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

  int ndata = stoi(argv[1]);
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

    g++ esercizio1.1.cpp -std=c++23 -g3 -Wall -Wextra -Werror --pedantic -o esercizio1.1

Eseguiamo il programma :

    ./esercizio1.1 365 1941.txt


# Esercizio 1.2 - Codice di analisi con funzioni e Makefile {#esercizio-1.2}

In questo esercizio terminiamo il processo di riorganizzazione dell'esercizio 1.0. Procederemo in questo modo:

-   Spostiamo tutte le dichiarazioni di variabili che abbiamo messo in testa al programma in un file separato `funzioni.h`.
-   Spostiamo tutte le implementazioni delle funzioni in coda al programma in un file separato `funzioni.cpp`.
-   Ricordiamoci di includere il file `funzioni.h` sia in `esercizio1.0.cpp` sia in `funzioni.cpp` tramite il solito `#include "funzioni.h"`
-   Compiliamo separatamente `esercizio1.2.cpp` e `funzioni.cpp` utilizzando un `Makefile`

Prima di incominciare, rivediamo rapidamente come si scrive un `Makefile`.

## Il Makefile

Vogliamo creare un `Makefile` che ci permetta di compilare il nostro programma quando questo è composto/spezzato in diversi file sorgenti. Supponiamo di avere un codice spezzato in tre file:

#.  `esercizio1.2.cpp`
#.  `funzioni.cpp`
#.  `funzioni.h`

Ovviamente possiamo compilare il tutto con

    g++ esercizio1.2.cpp funzioni.cpp -std=c++23 -g3 -Wall -Wextra -Werror --pedantic -o main

ma possiamo farlo in maniera più efficace. La struttura/sintassi del `Makefile` è la seguente:

```
target: dipendenze
↹system command
```

dove `↹` indica che dovete proprio premere il tasto TAB della tastiera (a sinistra del tasto Q). Se usate il tasto TAB, il `Makefile` apparirà così sullo schermo:

```
target: dipendenze
    system command
```

Il tasto TAB è come una serie di spazi, ma attenzione! Usare gli spazi in questo contesto è un errore!

Nel nostro caso, con il `Makefile` contenente le righe

```makefile
main: funzioni.cpp esercizio1.2.cpp
↹g++ funzioni.cpp esercizio1.2.cpp -std=c++23 -g3 -Wall -Wextra -Werror --pedantic -o main
```

è possibile compilare tutto lanciando il comando `make`.

Possiamo scrivere il `Makefile` anche esplicitando le dipendenze, in modo che anche quando cambiamo il file `.h` il tutto venga propriamente ricompilato. In questo caso il `Makefile` diventa:

```makefile
main: main.o funzioni.o
    g++ -g3 -Wall -Wextra -Werror --pedantic -std=c++23 main.o funzioni.o -o main
main.o: esercizio1.2.cpp funzioni.h
    g++ -g3 -Wall -Wextra -Werror --pedantic -std=c++23 -c esercizio1.2.cpp -o main.o
funzioni.o: funzioni.cpp funzioni.h
    g++ -g3 -Wall -Wextra -Werror --pedantic -std=c++23 -c funzioni.cpp -o funzioni.o
```

Notate però quanto il `Makefile` sia ripetitivo. È possibile definire delle *variabili* nel Makefile per semplificarlo:

```makefile
CXXFLAGS = -g3 -Wall -Wextra -Werror --pedantic -std=c++23

main: main.o funzioni.o
    g++ main.o funzioni.o -o main $(CXXFLAGS)

main.o: esercizio1.2.cpp funzioni.h
    g++ -c esercizio1.2.cpp -o main.o $(CXXFLAGS)

funzioni.o: funzioni.cpp funzioni.h
    g++ -c funzioni.cpp -o funzioni.o $(CXXFLAGS)
```

La variabile `$@` è una cosiddetta *variabile implicita*, e viene sostituita di volta in volta col nome del *target* corrente (che nell'esempio sopra è `main`, `main.o` e infine `funzioni.o`). I flag `-g3 -Wall -Wextra -Werror --pedantic -std=c++23` servono per rendere la compilazione e l'esecuzione del codice più sicura, perché abilitano dei controlli addizionali, spiegati nelle [slide](tomasi-lezione-01.html#flag-del-compilatore).


# Esercizio 1.3 - Overloading di funzione (da consegnare) {#esercizio-1.3}

Aggiungete alla vostra libreria di funzioni una funzione `void Print(const double *, int)` che permetta di scrivere gli elementi di un array a video. Questo è possibile grazie all'*overloading* (funzioni con stesso nome, ma con argomenti differenti).

## Overloading di funzioni

L'overloading delle funzioni è una funzionalità specifica del C++ che non è presente in C. Questa funzionalità permette di poter utilizzare lo stesso nome per funzioni diverse (cioè che compiono operazioni diverse) all'interno dello stesso programma, a patto però che gli argomenti forniti alla funzione siano differenti. In maniera automatica, il compilatore sceglierà la funzione appropriata a seconda del tipo di argomenti passati. In pratica:

```c++
void Print(const double *  data, int ndata) {...}

void Print(const char * filename, const double * data, int ndata) {...}
```

Le due funzioni hanno lo stesso nome, ma ovviamente ci si aspetta che facciano cose diverse. Si noti che per poter fare l'overloading di una funzione non basta che soltanto il tipo restituito dalla funzione sia differente, ma occorre che siano diversi i tipi e/o il numero dei parametri passati alla funzione.

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

Questi comandi sono stati introdotti nel C++ tra gli anni '80 e '90, ed oggi non sono più usati. Vedremo nelle prossime lezioni che le versioni più recenti del C++ forniscono un metodo più semplice, versatile e intuitivo per stampare il valore di variabili.

## Implementazione migliorata

In generale l'implementazione di algoritmi in una funzione può avvenira in diversi modi. Proviamo a vedere alcune possibili varianti per le funzioni relative al calcolo della media e della varianza:

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
      accumulo = static_cast<double>(k) / static_cast<double>(k + 1) * accumulo +
          1.0 / static_cast<double>(k + 1) * data[k];
  }

  return accumulo;
}
```

La prima funzione implementa il calcolo in modo intuitivo. La seconda è meno ovvia, perché ad ogni passo incrementa `accumulo` con il valore
$$
\frac{k}{k + 1}\times \texttt{accumulo} + \frac{\texttt{data[k]}}{k + 1}.
$$
Non è difficile dimostrare che il risultato finale è lo stesso; questa versione però ha il vantaggio di non conservare la somma di tutti i valori che potrebbe diventare troppo grande.

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


# Errori comuni

Elenco qui gli errori più comuni che ho riscontrato negli ultimi anni correggendo gli esercizi della lezione 1 consegnati prima dell'esame scritto:

-   Assicuratevi di leggere da file proprio il numero `N` di elementi specificato da linea di comando: in certi codici che abbiamo corretto negli anni passati venivano letti `N - 1` elementi. Chiedete al vostro programma di caricarne un numero molto limitato (es., `N = 3`) e verificate ad occhio che abbia effettivamente caricato tre numeri.

-   Molti studenti in passato hanno consegnato dei programmi che richiedevano moltissimo per calcolare la varianza di file di dati grandi (molto più grandi di [1941.txt](1941.txt)). Una implementazione come questa ricalcola ogni volta la media, ed è da evitare:

    ```c++
    double accum = 0.0;
    for(int i = 0; i < N; ++i) {
	  // Ogni volta CalcolaMedia deve sommare gli N elementi
	  accum += pow(x[i] - CalcolaMedia(x, N), 2);
    }
    ```

    Siccome la media è sempre la stessa, conviene calcolarla **una volta sola** prima del ciclo `for`:

    ```c++
    double accum = 0.0;
    // Calcola la media una volta per tutte
	const double media = CalcolaMedia(x, N);
    for(int i = 0; i < N; ++i) {
      // Riutilizza il valore della media calcolato sopra: è molto più veloce!
	  accum += pow(x[i] - media, 2);
    }
    ```

-   Spesso il codice per il calcolo della mediana funziona solo se N è pari, oppure se N è dispari, ma non viceversa. Assicuratevi che funzioni con `N=3` e con `N=4`, che sono casi facili da controllare!

-   Alcuni studenti richiedono di specificare il numero N da linea di comando, ma poi ignorano quanto specificato dall'utente e leggono sempre `N=365`.

-   Alcuni studenti si affidano all'ordine di inclusione degli header per evitare qualche `#include` in più. Se in `vectors.h` avete definito funzioni che lavorano su vettori, e in `newton.h` avete ulteriori funzioni che risolvono problemi di fisica Newtoniana, dovete assicurarvi che all'inizio di `newton.h` ci sia un `#include "vectors.h"`:

    ```c++
    // newton.h
    #pragma once
    #include "vectors.h"

    // Qui segue il resto del file
    ...
    ```

    Alcuni studenti omettono la riga `#include "vectors.h"` nel file qui sopra, e la mettono nel `main` prima di `#include "newton.h"`:

    ```c++
    // main.cpp
    #include "vectors.h"
    #include "newton.h"

    // ...
    ```

    Anche se il codice compila lo stesso, è concettualmente sbagliato: il file `newton.h` richiede `vectors.h`, e dovrebbe quindi includerlo al suo interno. In altre parole, senza `#include "vectors.h"` il file `newton.h` è inconsistente!

    Questo è importante perché poi tutte le volte che userete `newton.h` in altri programmi (ad esempio nell'esame scritto!), dovrete sempre ricordarvi di anteporre `#include "vectors.h"`, e questa è una cosa facile da dimenticare se sono passati alcuni mesi da quando avete scritto quel file.
