---
title: "Lezione 3: Analisi dei dati (template e vector)"
author:
- "Leonardo Carminati"
- "Maurizio Tomasi"
date: "A.A. 2021−2022"
lang: it-IT
...

[La pagina con la spiegazione originale degli esercizi si trova qui: <https://labtnds.docs.cern.ch/Lezione3/Lezione3/>.]

In questa terza lezione affronteremo di nuovo gli stessi problemi della prima e seconda lezione (lettura di dati da un file, calcolo di media e mediana) utilizzando una evoluzione del contenitore di dati `Vettore`: possiamo rendere questa classe più flessibile in modo che sia capace di immagazzinare qualsiasi tipo di dato (e non necessariamente dei numeri `double`)? Nella seconda parte spingeremo ancora oltre la generalizzazione imparando ad usare il contenitore vector della [STL](http://www.cplusplus.com/reference/stl/). Quindi, in sintesi:

-   Tipo di dato da leggere è constituito da numeri `double`.
-   Tipo di contenitore di dati è una generalizzazione della classe `Vettore` della lezione 2 o il contenitore vector della STL.
-   Operazioni sui dati vengono svolte mediante funzioni che agiscono su oggetti di tipo `Vettore` o `vector`.

Per incominciare, ripassiamo brevemente cosa sono le funzioni e le classi template.

## Funzioni e classi template

Le funzioni o le classi `template` sono costruite in modo tale che possano operare con tipi generici. Cosa significa? Consideriamo la nostra classe `Vettore`: essa è disegnata per immagazzinare un set di numeri `double`. Ma cosa ci vieta di renderla più generale e fare in modo che sia in grado di contenere oggetti di tipo generico `T`? Allo stesso modo possiamo pensare di generalizzare le funzioni che abbiamo scritto in modo che possano lavorare su oggetti generici. Considerate la funzione `selection_sort`: l'algoritmo di riordinamento è valido per qualunque tipo di oggetto per cui sia definita una relazione d'ordine tra due elementi.

Vediamo un paio di esempi.

Supponiamo di voler dichiarare una classe `Vettore` che al suo interno possa immagazzinare oggetti generici di tipo `T`. Nell'*header file* dovrò modificare la dichiarazione della classe in questo modo:

```c++
template <typename T> class Vettore { ... };
```

mentre quando dovrò creare nel main un oggetto di tipo `Vettore` per immagazzinare dei `double` farò:

```c++
Vettore <double> v;
```

L'istruzione indicata qui sopra crea effettivamente una istanza della classe `Vettore` specializzata per lavorare con dei `double`. Analogamente se pensiamo per esempio alla funzione `CalcolaMedia()` possiamo scrivere

```c++
template <typename T> double CalcolaMedia (const Vettore<T> &v, size_t ndata) {...}
```

e possiamo quindi utilizzare la funzione `CalcolaMedia` nel `main` nel modo seguente:

```c++
cout << "media    = " << CalcolaMedia<double>(v) << endl;

// È valido anche omettere `<double>`, perché il compilatore può
// capire da solo cosa mettere in `<…>` basandosi sul tipo di `v`
// cout << "media    = " << CalcolaMedia(v) << endl;
```

Si possono trovare più dettagli a [questo link](http://www.cplusplus.com/doc/oldtutorial/templates/).


# Esercizio 3.0 - Evoluzione della classe Vettore in una classe template (da consegnare) {#esercizio-3.0}

Proviamo a rendere la classe `Vettore` della lezione scorsa una classe `template`, in modo che possa in linea di principio immagazzinare oggetti di un tipo generico `T`. Notate che quando usiamo classi o funzioni template non applichiamo la separazione tra header file (`.h`) e file di implementazione (`.cpp`), ma codifichiamo tutto dentro l'*header file*. Questo perché non sarebbe possibile per il compilatore compilare separatamente un set di funzioni o una classe senza sapere i tipi esatti con cui verranno utilizzati.

Vediamo come fare passo passo.

## Generalizzazione della classe Vettore

Provate a lavorare sulla generalizzazione della classe `Vettore` in modo che diventi un contenitore di oggetti generici di tipo `T`. Provate a completare voi le parti mancanti. Ricordatevi che in questo caso particolare tutto va fatto nell'*header file* della classe.

```c++
#pragma once

#include <iostream>
#include <cassert>

using namespace std;

template <typename T> class Vettore {
public:
  Vettore() { // costruttore senza argomenti
      // ...
  }

  Vettore(size_t N) { // costruttore
      // ..
  }

  Vettore(const Vettore& V) { // copy constructor
      // ...
  }

  Vettore& operator=(const Vettore& V) { // operatore di assegnazione
      // ...
  }

  ~Vettore() { delete [] m_v;  }

  size_t GetN() const { return m_N; }

  void SetComponent(size_t i, T a) { // modifica una componente
      // ...
  }

  T GetComponent(size_t i) const { // accedi ad una componente
      // ...
  }

  void Scambia(size_t primo, size_t secondo) { // scambia due elementi
      // ...
  }

  T& operator[](size_t i) { // accede all'elemento i-esimo
      // ...
  }

private:
  size_t m_N;
  T * m_v;
};
```

## Adeguamento funzioni

Analogamente a quanto fatto sopra, adattiamo il file di funzioni in modo tale che possano lavorare con contenitori `Vettore` di tipo `template`. Come già ricordato, tutto deve essere codificato nell'*header file* della classe e non nel file `.cpp`.

```c++
#include <iostream>
#include <fstream>
#include "vettore.h"

using namespace std;

template <typename T> Vettore<T> Read (size_t N , const char * filename) {
  ifstream in{filename};   // Parentesi graffe: uniform initialization
  Vettore<T> v{N};
  if(! in) {
      cerr << "Il file di input non esiste\n";
      exit(1);
  }

  for (size_t i{}; i < N; i++) {
      T val{};
      in >> val ;
      v.SetComponent(i, val);
      if(in.eof()) {
        cerr << "Fine del file inattesa\n";
        exit(1);
      }

  }
  return v;
}

template <typename T> void Print(const Vettore<T> & v) {
  for (size_t k{}; k < v.GetN(); k++) {
      cout << v.GetComponent(k) << endl;
  }
}

template <typename T> void Print(const Vettore<T> & v, const char * filename) {
  ofstream out(filename);
  if(! out) {
    cerr << "Non posso creare il file " << filename << "\n";
    return;
  }

  for (size_t i{}; i < v.GetN(); i++) {
      out << v.GetComponent(i) << endl;
  }
}
```

Provate voi ad modificare le funzioni che mancano.


## Struttura del programma

Ecco l'aspetto che potrebbe avere il `main`: come vedete, usiamo il contenitore `Vettore` per immagazzinare un set di `double`.

```c++
#include <fstream>
#include <iostream>
#include <string>

#include "vettore.h"
#include "funzioni.h"

using namespace str;

int main (int argc, char * argv[]) {
  // Esegui i test sull'implementazione di `Vettore` (v. slide di Tomasi)
  test_vettore();
  
  if(argc < 3) {
      cerr << "Uso del programma: " << argv[0] << " <n_data> <filename>\n";
      return 1;
  }

  int ndata{stoi(argv[1])};
  const char * filename{argv[2]};

  // usiamo il contenitore Vettore per immagazzinare double !
  Vettore <double> v{Read<double>(ndata, filename)};

  Print(v);

  cout << "media = " << CalcolaMedia<double>(v) << endl;
  cout << "varianza = " << CalcolaVarianza<double>(v) << endl;
  cout << "mediana = " << CalcolaMediana<double>(v) << endl;

  Print(v);
}
```

## Commenti sulla compilazione

Nel caso si utilizzino classi o funzioni `template`, la dichiarazione e l'implementazione vanno codificate entrambe nell'*header file*. Come si potrebbe infatti compilare una classe template senza sapere con che tipi di dato verrà utilizzata? Di conseguenza la compilazione si riduce alla singola istruzione:

```makefile
CXXFLAGS = -g -Wall --pedantic -std=c++17

esercizio3.0: esercizio3.0.cpp funzioni.h Vettore.h
    g++ -o $@ esercizio3.0.cpp $(CXXFLAGS)

clean:
    rm -f esercizio3.0 *.o
```


# Esercizio 3.1 - Codice di analisi dati utilizzando la classe std::vector (da consegnare) {#esercizio-3.1}

-   Vediamo come possiamo ora fare uso di un contenitore “ufficiale” del c++, la classe `vector`. Questo particolare contenitore non è altro che una classe `template` sulla falsariga della nostra `Vettore`. La particolarità di questa classe sta nel fatto che la sua dimensione può non essere nota a priori: la costruzione del vettore può avvenire “aggiungendo in coda” con `push_back(x)` gli elementi `x` man mano che si rendono disponibili. Vedremo nel seguito alcuni esempi; è possibile trovare più materiale in [questa referenza](http://www.cplusplus.com/reference/vector/vector/).
-   Notate anche che per contenitori della STL (come `vector`) che stiamo andando ad utilizzare, esistono delle funzioni standard che possono essere utilizzate (vedi nel nostro esempio la funzione `sort`).


Vediamo passo passo come si può procedere.

## Adeguamento funzioni

Analogamente a quanto fatto sopra, adattiamo il file di funzioni in modo che ciascuna possa lavorare con contenitori `vector`. Come già ricordato, tutto deve essere codificato nell'*header file* della classe. Vediamo qualche funzione (quelle mancanti dovreste essere in grado di farle da soli):

```c++
#include <algorithm> // funzioni
#include <cassert>
#include <fstream>
#include <iostream>
#include <vector> // contenitore

using namespace std;

template <typename T> vector<T> Read(size_t N, const char* filename) {
  vector<T> v;
  ifstream in{filename};
  if(in) {
      cerr << "Impossibile aprire il file " << filename << "\n";
      exit(1);
  }

  for (size_t i{}; i < N; i++) {
      T val{};
      in >> val;
      v.push_back(val);
      if(in.eof()) {
          cerr << "Fine del file raggiunta prematuramente\n";
          exit(1);
      }
  }

  return v;
}

template <typename T> void Print(const vector<T> & v) {
  for (size_t i{}; i < v.size(); i++) {
      cout << v[i] << endl;
}

template <typename T> void Print(const vector<T> & v, const char * filename) {
  ofstream out(filename);

  if(! out) {
      cerr << "Non posso creare il file " << filename << "\n";
      return;
  }

  for (size_t i{}; i < v.size(); i++) {
      out << v[i] << endl;
  }
}
```

**Attenzione**: c'è una particolarità nell'invocazione del costruttore per oggetti `std::vector`:

-   La scrittura `std::vector<int> v(10)` (parentesi tonde) inizializza il vettore riservando spazio per 10 elementi.
-   La scrittura `std::vector<int> v{10}` (parentesi tonde) inizializza il vettore aggiungendo un elemento di valore 10.

In altre parole, le parentesi graffe usate con un `std::vector` indicano *l'elenco degli elementi da inserire*, e non il numero di elementi da allocare! Nelle future lezioni vedremo che ciò è molto utile, ma è importante ricordarsi della differenza!

Ecco l'esempio della funzione `CalcolaMediana`: notate l'utilizzo della funzione `sort()` della STL per ordinare gli elementi di un contenitore. Quando possibile, usiamo funzioni e algoritmi ufficiali! La funzione `sort()` lavora con un iteratore al primo elemento del contenitore (`v.begin()`) e uno all'ultimo (+1) (`v.end()`). I contenitori della STL come `vector` hanno i due metodi `begin()` e `end()`, e le funzioni STL in genere lavorano con iteratori: in questo modo la funzione può lavorare indifferentemente su ogni tipo di contenitore, indipendentemente dalla struttura interna del contenitore.

```c++
template <typename T> double CalcolaMediana(vector<T> v) {
  sort(v.begin(), v.end()) ;
  double mediana{};

  if (v.size() % 2 == 0) {
      mediana = (v[v.size() /2 - 1] + v[v.size(D) / 2]) / 2;
  } else {
      mediana = v[v.size() / 2];
  }

  return mediana;
}
```

## Il codice principale

Ecco l'aspetto che potrebbe avere il nostro nuovo codice:

```c++
#include "funzioni.h"
#include <fstream>
#include <iostream>
#include <string>

using namespace std;

int main(int argc, char * argv[]) {
  // Esegui i test sulle funzioni statistiche (v. slide di Tomasi)
  test_statistical_functions();

  if(argc < 3) {
      cerr << "Uso del programma: " << argv[0] << " <n_data> <filename>\n";;
      return 1;
  }

  vector<double> v{Read<double>(stoi(argv[1]), argv[2])};

  Print(v);

  cout << "media " << CalcolaMedia<double>(v) << endl;
  cout << "varianza " << CalcolaVarianza<double>(v) << endl;
  cout << "mediana " << CalcolaMediana<double>(v) << endl;

  Print(v);
}
```


## Il Makefile

Ecco il `Makefile`:

```makefile
CXXFLAGS = -g -Wall --pedantic -std=c++17

esercizio3.1: esercizio3.1.cpp funzioni.h
    g++ -o esercizio3.1 esercizio3.1.cpp $(CXXFLAGS)

clean:
    rm -f esercizio3.1
```

Notate che la classe `vector` ci libera completamente dalla necessità di conoscere in anticipo la quantità di dati da caricare. Questo ci permette per esempio di scrivere una funzione che legga automaticamente tutti i dati che trova in un file senza sapere a priori quanti sono.

## Riempire un vettore da file

In questa funzione creiamo un vettore, lo riempiamo con tutti i dati letti da un file aggiungendo di volta in volta una componente. Il processo si ferma al termine del file:

```c++
template <typename T> vector<T> Read(const char* filename) {
  vector<T> v;
  ifstream in{filename};

  if(! in) {
      cerr << "Impossibile aprire il file " << filename << "\n";
      exit(1);
  }
  
  while(! in.eof()) {
      T val;
      in >> val;
      v.push_back(val);
  }
  
  return v;
}
```

## Approfondimento sulla STL (facoltativo)

Proviamo a usare meglio le funzionalità offerte dalla Standard Template Library (STL): ecco [qui](http://labmaster.mi.infn.it/Laboratorio2/labTNDS/lectures_1819/funzioni_stlstyle.h) un esempio di come si potrebbe fare.


# Esercizio 3.2 - Analisi dati con vector e visualizzazione dei dati (da consegnare) {#esercizio-3.2}

Proviamo ora ad aggiungere all'esercizio precedente la possibilità di visualizzare i dati letti da file.

Un modo semplice per visualizzare graficamente la distribuzione di un set di dati è quello di usare un istogramma (`TH1F`) di ROOT. Le classi di ROOT sono molto comode da usare, perché possiamo facilmente utilizzarle in un codice C++. Per fare questo dobbiamo ricordarci di:

-   Includere l'header file (`.h`) di ogni oggetto di ROOT che pensiamo di utilizzare (`TApplication`, `TH1F`, `TGraph`, `TCanvas`).
-   Modificare il `Makefile` in modo che sia in grado da solo di trovare il path degli header files necessari (`$INCS`) e le librerie precompilate da linkare (`$LIBS`).


Per una rapida panoramica dei principali oggetti di ROOT che ci potranno interessare potete dare un'occhiata [qui](http://labmaster.mi.infn.it/Laboratorio2/labTNDS/lectures_1819/lezioneROOT_1819.html).

Vediamo come si potrebbe fare.

## Programma principale

Possiamo usare questo codice come esempio per l'utilizzo di un qualsiasi oggetto di ROOT:

```c++
#include "TApplication.h"
#include "TCanvas.h"
#include "TH1F.h"
#include "funzioni.h"
#include <fstream>
#include <iostream>
#include <string>

using namespace std;

int main(int argc, char * argv[]) {
  // Stessi test dell'esercizio 3.1, ma qui adattateli per std::vector
  test_statistical_functions();
  
  if(argc < 3) {
      cerr << "Uso del programma: " << argv[0] << " <n_data> <filename>\n";
      return 1;
  }

  // creo un processo "app" che lascia il programma attivo ( app.Run() ) in modo
  // da permettermi di vedere gli outputs grafici

  TApplication app{"app", 0, 0};

  // leggo dati da file
  vector<double> v{Read<double>(stoi(argv[1]), argv[2]};

  // creo e riempio il vettore. L'opzione StatOverflows permette di calcolalare
  // le informazioni statistiche anche se il dato sta fuori dal range di definizione
  // dell'istogramma

  TH1F histo{"histo", "histo", 100, -10, 100};
  histo.StatOverflows(true);

  for (size_t k{}; k < v.size(); k++) {
      histo.Fill(v[k]);
  }
  
  // accedo a informazioni statistiche
  cout << "Media dei valori caricati = " << histo.GetMean() << endl;

  // disegno
  TCanvas mycanvas{"Histo", "Histo"};

  histo.Draw();
  histo.GetXaxis()->SetTitle("measurement");

  app.Run();
}
```

## Makefile modificato

Ecco come dobbiamo modificare il `Makefile` per compilare includendo oggetti di ROOT:

```c++
LIBS := `root-config --libs`
CXXFLAGS := -g -Wall --pedantic -std=c++17 `root-config --cflags`

esercizio3.2: esercizio3.2.cpp funzioni.h
    g++ -o esercizio3.2 esercizio3.2.cpp ${CXXFLAGS} ${LIBS}

clean:
    rm -f esercizio3.2
```

Notate l'utilizzo dei comandi `root-config --libs` e `root-config --cflags`, che restituiscono rispettivamente il path per raggiungere le librerie di ROOT e il gli header files, come potete provare anche dalla linea di comando:

```
$ root-config --cflags
-pthread -std=c++14 -m64 -I/usr/include/root
$ root-config --libs
-L/usr/lib64/root -lCore -lImt -lRIO -lNet -lHist -lGraf -lGraf3d -lGpad -lROOTVecOps -lTree -lTreePlayer -lRint -lPostscript -lMatrix -lPhysics -lMathCore -lThread -lMultiProc -lROOTDataFrame -pthread -lm -ldl -rdynamic
```

(il risultato sui vostri computer potrebbe essere differente).

I path vengono memorizzati nelle variabili `LIBS` e `CXXFLAGS`. Queste due variabili vengono poi passate al comando `g++` in modo che il compilatore abbia a disposizione tutti gli ingredienti per una corretta compilazione.



# Errori comuni

Gli errori che gli studenti hanno fatto negli anni precedenti sono simili a quelli elencati per la [prima lezione](carminati-esercizi-01.html#errori-comuni).
