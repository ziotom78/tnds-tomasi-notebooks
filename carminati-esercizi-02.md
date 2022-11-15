---
title: "Lezione 2: Analisi dei dati (classe Vettore)"
author:
- "Leonardo Carminati"
- "Maurizio Tomasi"
date: "A.A. 2021−2022"
lang: it-IT
...

[La pagina con la spiegazione originale degli esercizi si trova qui: [labmaster.mi.infn.it/Laboratorio2/labTNDS/lectures_1819/lezione2_1819.html](http://labmaster.mi.infn.it/Laboratorio2/labTNDS/lectures_1819/lezione2_1819.html).]

In questa seconda lezione affronteremo gli stessi problemi della prima lezione (lettura di dati da un file, calcolo di media, varianza e mediana) utilizzando un contenitore di dati più evoluto del semplice array del C. A questo proposito nella prima parte della lezione costruiremo la nostra prima classe, la classe `Vettore`. Nella seconda parte adatteremo le funzioni già scritte nella lezione scorsa in modo che possano funzionare con oggetti di tipo `Vettore`. Quindi in sintesi:

-   Tipo di dato da leggere è constituito da numeri `double`.
-   Tipo di contenitore di dati è una classe `Vettore` che scriveremo noi.
-   Operazioni sui dati vengono svolte mediante funzioni che lavorano su oggetti di tipo `Vettore`.


# Esercizio 2.0 - Creazione della classe Vettore {#esercizio-2.0}

Implementare una classe che abbia come data membri (privati) un intero (dimensione del vettore) ed un puntatore a `double` (puntatore alla zona di memoria dove sono immagazzinati i dati).
Implementare:

-   Un costruttore di default, che assegni valori nulli alla lunghezza del vettore ed al puntatore.
-   Un costruttore che abbia come argomento un intero: questo deve creare un vettore di lunghezza uguale all'intero e tutte le componenti nulle (usando un `new` per allocare la memoria necessaria).
-   Un distruttore: deve chiaramente deallocare con `delete[]` la zona di memoria allocata con new.
-   Dei metodi per inserire e leggere i valori della componenti: questi metodi devono controllare che l'indice delle componenti richieste sia compatibile con la lunghezza del vettore.

## Header file della classe

L'header file della classe iniziale (`vettore.h`) potrebbe essere così:

```c++
#pragma once

// La scrittura `#pragma once` è equivalente a scrivere:
//
//    #ifndef __vettore_h__
//    #define __vettore_h__
//    ...
//    #endif
//
// ma basta una riga anziché tre, ed evita di dover ricopiare
// `__vettore_h__` due volte

#include <iostream>

class Vettore {
public:
  Vettore();                     // costruttore di default
  Vettore(size_t N);             // costruttore con dimensione del vettore
  ~Vettore();                    // distruttore

  size_t GetN() const {          // restituisce la dimensione del vettore
      return m_N;
  }

  // Modifica la componente i-esima
  void SetComponent(size_t, double);

  // Accede alla componente i-esima
  double GetComponent(size_t) const;

  void Scambia(size_t, size_t);

private:
  size_t m_N;                    // dimensione del vettore
  double * m_v;                  // puntatore all'array dei dati
}; // Necessario usare `;` dopo la parentesi graffa *solo* quando si chiude una classe!


```

-   L'utilizzo del costrutto `#ifndef`…`#define`…`#endif` al posto di `#pragma once` merita una spiegazione. Queste direttive di preprocessore sono normalmente utilizzate per evitare inclusioni multiple di uno stesso header file che, nel caso specifico, porterebbero ad una doppia dichiarazione della classe `Vettore`. Immaginate infatti di voler compilare un codice `main.cpp` insieme ad un file `funzioni.cpp` e che entrambi i codici sorgente contengano una istruzione `#include "vettore.h"`: in fase di compilazione il compilatore si lamenterebbe per una doppia dichiarazione della classe `Vettore`. Con il meccanismo indicato, alla prima inclusione di `vettore.h`, viene creata una variabile globale `__vettore_h__` (meglio: una *macro*). Al secondo tentativo di inclusione l'esistenza di `__vettore_h__` globale forza il compilatore a saltare tutte le righe tra `#define` ed `#endif`, di fatto evitando la seconda inclusione del file `vettore.h`. La scrittura `#pragma once` non è nello standard C++, ma è così comoda che è implementata su tutti i compilatori C++ in commercio.
    Notate inoltre l'impementazione in-line del metodo `GetN()`: i metodi di una classe possono essere anche implementati direttamente nell'header file (`.h`) e non nel file `.cpp`. L'implementazione inline implica che il compilatore metta una copia della funzione ogni volta che questa viene chiamata: in questo modo il codice diventa più lungo ma vengono ottimizzate le performance in quanto non si deve effettuare una chiamata alla funzione. In genere l'implementazione inline viene effettuata per funzioni brevi.


## Esempio di implementazione della classe

```c++
#include "vettore.h"
#include <iomanip>
#include <cmath>
#include <cstdlib>
#include <cassert>

Vettore::Vettore() {
  cout << "Invocazione del costruttore di default" << endl;
  m_N = 0;
  m_v = nullptr;
}

Vettore::Vettore(size_t N) {
  cout << "Invocazione del costruttore con argomenti" << endl;
  m_N = N;
  m_v = new double[N];
  for(size_t k = 0; k < N; ++k) {
      m_v[k] = 0;
  }
}

Vettore::~Vettore() {
  cout << "Invocazione del distruttore" << endl;
  delete[] m_v;
}

void Vettore::SetComponent(size_t i, double a) {
  assert((i < m_N) && "Errore: l'indice è troppo grande");
  m_v[i] = a;
}

double Vettore::GetComponent(size_t i) const {
  assert((i < m_N) && "Errore: l'indice è troppo grande");
  return m_v[i];
}

void Vettore::Scambia(size_t primo, size_t secondo) {
  double temp = m_v[primo];
  m_v[primo] = m_v[secondo];
  m_v[secondo] = temp;

  // Equivalente a:
  //
  //     double temp = GetComponent(primo);
  //     SetComponent(primo, GetComponent(secondo));
  //     SetComponent(secondo, temp);
}

double & Vettore::operator[](size_t i) {
  assert((i < m_N) && "Errore: l'indice è troppo grande");
  return m_v[i];
}
```

-   Notate l'uso della macro `assert()`: questa macro (ricordarsi di includere la libreria `cassert`) può rivelarsi estremamente utile per scoprire errori nel nostro programma in fase di realizzazione del programma.

    ```
    assert((i < m_N) && "Errore : l'indice è troppo grande");
    ```

    farà abortire il programma se si verifica la condizione `m_N > i`, ovvero se si tenta di riempire una componente di indice maggiore della dimensione del Vettore. Prima della chiusura del programma viene mostrato a video il messaggio impostato:

    ```
    Assertion failed: (( m_N > i ) && "Errore : l'indice è troppo grande"), function SetComponent, file vettore.cpp, line 31.
    ```

    che indica molto chiaramente cosa ha esattamente causato il problema. Normalmente quando la fase di debugging è terminata tutti gli assert utilizzati possono essere disabilitati mediante la definizione di una macro `#define NDEBUG`: questa istruzione fa si che tutti gli assert dichiarati vengano ignorati e il flusso del programma ritorna ad essere quello normale. [*Nota: ma la «fase di debugging» termina quando si è certi che il proprio programma non contiene alcun errore. Si è mai certi di ciò?*]
-   Notate l'ultimo metodo implementato (dovete ovviamente aggiungerlo anche nell'header file della classe) che rappresenta l'overloading dell'operatore di accesso `[]` ad un elemento (eg. `double a = v[2]` se `v` è un oggetto di tipo `Vettore`). Questo è spiegato anche sulle [slide addizionali](tomasi-lezione-02.html#operator-array).

## Programma di test

Questo programma usa un copy constructor per creare il `Vettore c` ed un'assegnazione per il `Vettore b`.

```c++
#include "vettore.h"
#include <iostream>

int main() {
  // costruttore senza argomenti → crea un vettore di dimensione nulla
  Vettore vnull;
  cout << "Vettore vnull: dimensione = " << vnull.GetN() << endl;

  // costruttore con intero: costruisco un vettore di lunghezza 10
  Vettore v(10);
  cout << "Vettore v: dimensione = " << v.GetN() << endl;

  for(size_t k = 0; k < v.GetN(); ++k) {
      cout << v.GetComponent(k) << " ";
  }
  cout << endl;

  // cambio il contenuto di v
  for(size_t k = 0; k < v.GetN(); ++k) {
      v.SetComponent(k, k + 2);
  }
  cout << "Vettore v (dopo le modifiche): dimensione = " << v.GetN() << endl;

  for(size_t k = 0; k < v.GetN(); ++k) {
      cout << v.GetComponent(k) << " ";
  }
  cout << endl;

  // uso il copy constructor per costruire w
  Vettore w(v);  // Equivalente: Vettore w = v;

  cout << "Vettore w: dimensione = " << w.GetN() << endl;
  for(size_t k = 0; k < w.GetN(); ++k) {
      cout << w.GetComponent(k) << " ";
  }
  cout << endl;

  cout << "Cambio una componente di v" << endl;
  v.SetComponent(4, 99); // Cambio una componente di v

  cout << "Vettore v: dimensione = " << w.GetN() << endl;
  for(size_t k = 0; k < v.GetN(); ++k) {
      cout << v.GetComponent(k) << " ";
  }
  cout << endl;

  cout << "Vettore w: dimensione = " << w.GetN() << endl;
  for(size_t k = 0; k < w.GetN(); ++k) {
      cout << w.GetComponent(k) << " ";
  }
  cout << endl;

  // operatore di assegnazione
  Vettore z(10);
  z = w;
}
```

Se eseguito, questo programma mostrerà una sovrascrittura inattesa dei dati del Vettore a ed una corruzione di memoria.

Si verifichi che una classe realizzata in questo modo si comporta in modo strano se usiamo l'operatore di assegnazione. Questo è un problema generico quando abbiamo classi con puntatori come data membri: bisogna assicurarsi che ciascuna istanza della classe abbia la propria zona di memoria.
Affinché la classe si comporti in maniera consistente, è necessario implementare anche:

#.  un costruttore che abbia come argomento un altro vettore (*copy constructor*): deve creare una copia del vettore argomento.
#.  l'overloading dell'operatore di assegnazione, assicurandosi che i dati vengano copiati dal vettore di partenza a quello di arrivo.


## Modifiche all'header file

Per la seconda parte dell'esercizio, bisognerà aggiungere il *copy constructor* e l'operatore di assegnazione `operator=`:

```c++
Vettore(const Vettore &); // Copy constructor
Vettore& operator=(const Vettore &); // Operatore di assegnazione
```

Questo va chiaramente aggiunto all'header file della classe `vettore.h`.

## *Copy constructor*

Il *copy constructor* viene invocato ogni volta che utilizziamo sintassi come:

```c++
Vettore a;
Vettore b=a;
```

oppure la sintassi equivalente:

```
Vettore a;
Vettore b(a);
```

ed in tutti i casi in cui si passa un oggetto per valore.
Esso viene dichiarate nell'header con la sintassi:

```
Vettore(const Vettore&);
```

e nella sua implementazione dobbiamo assicurarci che l'oggetto costruito abbia la sua zone di memoria riservata:

```c++
// overloading operatore di copia

Vettore::Vettore(const Vettore & v) {
  m_N = v.GetN();
  m_v = new double[m_N];
  for(size_t i = 0; i < m_N; ++i) {
      m_v[i] = v.GetComponent(i);
  }
}
```

## Operatore di assegnazione

Quando scriviamo

```c++
a = b;
```

e `a` e `b` sono oggetti della stessa classe, di fatto l'assegnazione non è altro che un abbreviazione per indicare la chiamata ad un metodo della classe di nome `operator=`:

```c++
a.operator=(b);   // così è come il C++ vede l'istruzione `a = b`
```

Il compilatore fornisce un'implementazione di default di questo operatore, che corrisponde ad un assegnazione membro a membro di tutti i data membri. Ma questo non funziona se alcuni data membri sono puntatori, perché dopo l'assegnazione avremmo più oggetti che condividono la stessa area di memoria.
Dobbiamo quindi realizzare un'implementazione sicura dell'assegnazione, facendo una copia dei dati in una nuova locazione di memoria.

L'header file dovrà contenere una dichiarazione:

```c++
Vettore& operator=(const Vettore&);
```

Una possibile implementazione è data qui sotto:

```c++
// overloading operatore di assegnazione

Vettore& Vettore::operator=(const Vettore& v) {
  m_N = v.GetN();
  if (m_v) {
      delete[] m_v;
  }

  m_v = new double[m_N];

  for (size_t i = 0; i < m_N; i++) {
      m_v[i] = v.GetComponent(i);
  }

  return *this;
}
```


## Il puntatore this

Il puntatore `this` indica un puntatore all'oggetto cui si sta applicando un metodo. È particolarmente utile in alcune occasioni, come nel caso dell'operatore di assegnazione, in cui si deve restituire una copia dell'oggetto corrente.

# Esercizio 2.1 - Codice di analisi dati utilizzando la classe Vettore (da consegnare) {#esercizio-2.1}

Proviamo ora a riscrivere il codice della prima lezione utilizzando un contenitore di dati più raffinato: la classe `Vettore` ci permetterà di riempire il contenitore dati controllando per esempio che non stiamo sforando la dimensione allocata. Il `Vettore` inoltre contiene un campo con la sua dimensione: se dobbiamo calcolare la media degli elementi di un `Vettore` non dobbiamo quindi più passare la dimensione come argomento esterno.

Per svolgere questo esercizio dobbiamo :

#.  modificare tutte le funzioni in `funzioni.h` e `funzioni.cpp`, in modo che lavorino con oggetti di tipo `Vettore` invece che con semplici array del C.
#.  modificare il `main` in modo che utilizzi la nuova classe `Vettore` e le nuove funzioni.
#.  modificare il `Makefile`

Se non ci riuscite da soli potete dare un'occhiata ai suggerimenti qui sotto.

## Struttura del programma

Ecco l'aspetto che potrebbe avere il nostro nuovo codice:

```c++
// includo la dichiarazione della classe Vettore
#include "vettore.h"

// includo la dichiarazione delle funzioni
#include "funzioni.h"

#include <cstdlib>
#include <fstream>
#include <iostream>

int main (int argc, char* argv[]) {
  if(argc < 3) {
      cerr << "Uso del programma : " << argv[0] << " <ndata> <filename>" << endl;

      return 1;
  }

  int ndata = atoi(argv[1]);
  const char * filename = argv[2];

  Vettore v(Read(ndata, filename));
  cout << v[3] << endl;

  Print(v);

  cout << "media = " << CalcolaMedia(v) << endl;
  cout << "varianza = " << CalcolaVarianza(v) << endl;
  cout << "mediana = " << CalcolaMediana(v) << endl;
  
  Print(v);
  Print(v, "data_out.txt");

  return 0;
}
```


## Le funzioni

L'header file (`.h`) potrebbe risultare così:

```c++
#include <iostream>
#include <fstream>
#include "vettore.h"

using namespace std;

Vettore Read(int, const char*);

double CalcolaMedia(const Vettore &);
double CalcolaVarianza(const Vettore &);
double CalcolaMediana(Vettore);

void Print(const Vettore &) ;
void Print(const Vettore &, const char*);

void selection_sort(Vettore &);
```

Il file di implementazione delle funzioni (`.cpp`) potrebbe risultare così (qui è svolto solo il caso della media, l'estensione alle altre funzioni dovrebbe essere immediata):

```c++
#include "funzioni.h"

double CalcolaMedia( const Vettore & v ) {
  double accumulo = 0;
  if (v.GetN() == 0)
      return accumulo;
      
  for (size_t k = 0; k < v.GetN(); k++ ) {
      accumulo += v.GetComponent(k);
  }

  return accumulo / static_cast<double>(v.GetN());
}
```


## Makefile

Il makefile va modificato aggiungendo la compilazione della classe `Vettore`:

```makefile
CXXFLAGS = -g -Wall --pedantic -std=c++17

main: main.o vettore.o funzioni.o
    g++ -o $@ main.o vettore.o funzioni.o $(CXXFLAGS)

main.o: main.cpp funzioni.h
    g++ -c -o $@ main.cpp $(CXXFLAGS)

funzioni.o: funzioni.cpp funzioni.h
    g++ -c -o $@ funzioni.cpp $(CXXFLAGS)

vettore.o: vettore.cpp vettore.h
    g++ -c -o $@ vettore.cpp $(CXXFLAGS)

clean:
    rm -f *.o

cleanall: clean
    rm -f main
```


Perchè `CalcolaMedia` vuole in input un `const Vettore &`, mentre CalcolaMediana semplicemente un `Vettore`?

-   Nel caso di `CalcolaMedia(...)` o `CalcolaVarianza(...)`, il passaggio del parametro avviene *by reference* per ottimizzare l'uso della memoria. Con questa modalità di passaggio dati la funzione lavora direttamente sul `Vettore` del `main`, e pertanto una modifica accidentale del `Vettore` di input all'interno della funzione ha un effetto anche nel `main`. Il qualificatore `const` vieta alla funzione di fare qualsiasi operazione di cambiamento del contenuto del vettore di input, pena un errore di compilazione.
-   Nel caso invece di `CalcolaMediana(...)`, il passaggio è effettuato *by value* e senza il qualificatore `const`: in questo modo permettiamo che il metodo proceda al riodinamento del `Vettore`. Dal momento che con il passaggio *by value* il `Vettore` nella funzione è una copia del `Vettore` di input, ogni cambiamento effettuato nella funzione non si ripercuote sul `main`.

## Only for curious kids: the *move semantic*

*Move semantics* è un nuovo modo, introdotto col C++11, di spostare le risorse in un modo ottimale evitando di creare copie non necessarie di oggetti temporanei ed è basato sulle *r-value references*. La potenza della *move semantics* si può capire affrontando il caso in cui si voglia costruire un oggetto della classe `Vettore` a partire dall'output di una funzione:

```c++
Vettore v = Read(ndata, filename);
```

La funzione `Read()` restituirà un oggetto temporaneo di tipo `Vettore` che poi verrà utilizzato come input del costruttore di copia per la creazione di `v`. Chiaramente, questo riduce notevolmente le *performance* del nostro codice. Perché non realizzare un costruttore di copia (e un operatore di assegnazione) che siano in grado di «rubare» i data membri all'oggetto temporaneo senza dover copiare dati? Questo è lo spirito del *move constructor* e *move assignment operator*:

```c++
// move constructor

Vettore::Vettore(Vettore&& v) {
  cout << "Invocazione del move constructor" << endl;

  m_N = v.m_N;
  m_v = v.m_v;
  v.m_N = 0;
  v.m_v = nullptr;
  cout << "Move constructor chiamato" << endl;
}

// move assigment operator
Vettore& Vettore::operator=(Vettore&& v) {
  cout << "Invocazione del move assignment operator" << endl;
  delete [] m_v ;

  m_N = v.m_N;
  m_v = v.m_v;
  
  v.m_N = 0;
  v.m_v = nullptr;

  cout << "Move assignment operator invocato" << endl;
  return *this;
}
```

-   Notare la doppia `&&` al vettore in input: qui stiamo sfruttando la referenza ad un *rvalue*.
-   Il *move constructor* e *move assignment operator* semplicemente rubano i dati all'oggetto temporaneo (non c'è copia elemento per elemento).
-   Il puntatore dell'oggetto di input viene sganciato dai dati.
-   Per vedere il move constructor all'opera potrebbe essere necessario aggiungere la flag `-fno-elide-constructors` per disattivare eventuali ottimizzazioni interne del compilatore che maschererebbero l'uso del *move constructor*.
-   Per ulteriori spiegazioni, vedere anche le [slide addizionali](tomasi-lezione-02.html#move-semantics).
