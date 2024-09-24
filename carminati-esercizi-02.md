[La pagina con la spiegazione originale degli esercizi si trova qui: <https://labtnds.docs.cern.ch/Lezione2/Lezione2/>.]

In questa seconda lezione affronteremo gli stessi problemi della prima (lettura di dati da un file, calcolo di media, varianza e mediana) utilizzando però un contenitore di dati di nostra invenzione, idealmente più evoluto del semplice array dinamico del C. A questo proposito nella prima parte della lezione costruiremo la nostra prima classe, la classe `Vettore`, che sostituirà l'array dinamico del C. Nella seconda parte adatteremo le funzioni già scritte nella lezione scorsa in modo che possano funzionare con oggetti di tipo `Vettore`. Quindi in sintesi:

-   Tipo di dato da leggere è constituito da numeri `double` immagazzinati in un file `data.dat`.
-   Tipo di contenitore di dati è la classe `Vettore` che scriveremo noi.
-   Operazioni sui dati vengono svolte mediante funzioni che lavorano su oggetti di tipo `Vettore`.


# Esercizio 2.0 - Creazione della classe Vettore {#esercizio-2.0}

In questo esercizio proviamo ad implementare una classe che abbia come data membri privati un intero (dimensione del vettore) ed un puntatore a `double` (puntatore alla zona di memoria dove sono immagazzinati i dati).

La classe dovrà poi implementare:

-   Un costruttore di default, che assegni valori nulli alla lunghezza del vettore ed al puntatore.
-   Un costruttore che abbia come argomento un intero: questo deve creare un vettore di lunghezza uguale al valore dell'intero e tutte le componenti nulle (usando un `new` per allocare la memoria necessaria).
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
// `__vettore_h__` due volte (spesso fonte di errore tra gli
// studenti, che fanno copia-e-incolla da un file all'altro!)

#include <iostream>

class Vettore {
public:
  Vettore();                     // costruttore di default
  Vettore(int N);                // costruttore con dimensione del vettore
  ~Vettore();                    // distruttore

  int GetN() const {          // restituisce la dimensione del vettore
      return m_N;
  }

  // Modifica la componente i-esima
  void SetComponent(int, double);

  // Accede alla componente i-esima
  double GetComponent(int) const;

  void Scambia(int, int);

private:
  int m_N;                               // dimensione del vettore
  double * m_v;                         // puntatore all'array dei dati
  void crashIfInvalidIndex(int) const;  // verifica che l'indice di un elemento sia corretto
}; // Necessario usare `;` dopo la parentesi graffa *solo* quando si chiude una classe!


```

-   L'utilizzo del costrutto `#ifndef`…`#define`…`#endif` al posto di `#pragma once` merita una spiegazione. Queste direttive di preprocessore sono normalmente utilizzate per evitare inclusioni multiple di uno stesso header file che, nel caso specifico, porterebbero ad una doppia dichiarazione della classe `Vettore`. Immaginate infatti di voler compilare un codice `main.cpp` che includa sia `vettore.h` che `funzioni.h`, e che quest'ultimo file abbia bisogno di `vettore.h`:

    ```c++
    ////////////////////////////////////////
    // File vettore.h, che implementa la classe `Vettore`

    class Vettore {
      // ...
    };

    ////////////////////////////////////////
    // File funzioni.h
    #include "vettore.h"

    double calcolaMedia(const Vettore & v);
    // ..

    ////////////////////////////////////////
    // File main.cpp
    #include "vettore.h"
    #include "funzioni.h"
    ```

    In fase di compilazione il compilatore si lamenterebbe per una doppia dichiarazione della classe `Vettore`, perché il contenuto di `vettore.h` viene **copiato due volte** in `main.cpp`:

    ```c++
    // File main.cpp come viene visto dal compilatore:
    // La riga #include "vettore.h" viene sostituita col
    // contenuto del file vettore.h:
    class Vettore {
      // ...
    };

    // Appena sotto, la riga #include "funzioni.h" viene
    // sostituita col suo contenuto…
    // …che però richiede nella prima riga di includere
    // di nuovo vettore.h:
    class Vettore {
      // ...
    };

    double calcolaMedia(const Vettore & v);

    // Ora continua col contenuto di `main.cpp`
    // ...
    ```

    Se si riporta lo stesso esempio sopra senza però i commenti, è chiaro dove sta il problema:

    ```c++
    class Vettore {
      // ...
    };

    class Vettore {
      // ...
    };

    double calcolaMedia(const Vettore & v);

    // ...
    ```

    La classe `Vettore` è stata inclusa due volte! La soluzione migliore a questo problema *non* è quella di rimuovere uno dei due `#include`, perché sono entrambi logicamente necessari: il primo in `main.cpp` serve perché nel `main` verosimilmente si deve usare `Vettore`, il secondo in `funzioni.h` serve per dare un senso alla definizione di `calcolaMedia`.

    Con il meccanismo basato su `#ifndef …`, alla prima inclusione di `vettore.h`, viene creata una “variabile” `__vettore_h__` (il termine esatto è *macro*). Al secondo tentativo di inclusione l'esistenza di `__vettore_h__` globale forza il compilatore a saltare tutte le righe tra `#define` ed `#endif`, di fatto evitando la seconda inclusione del file `vettore.h`.

    La scrittura `#pragma once` abbrevia la sequenza di `#ifndef`/`#define`/`#endif` in una sola riga; non è nello standard C++, ma è così comoda che è implementata su tutti i compilatori C++ in commercio.

    Questa parte è spiegata anche sulle [slides](tomasi-lezione-02.html#/uso-di-header-files).

-   Notate l'impementazione *in-line* del metodo `GetN()`: i metodi di una classe possono essere anche implementati direttamente nell'header file (`.h`) e non nel file `.cpp`. L'implementazione inline implica che il compilatore metta una copia della funzione ogni volta che questa viene chiamata, anziché mantenerne **una sola copia** ed invocarla da vari punti del codice. In questo modo il file eseguibile aumenta di dimensioni (ci sono ora N copie dell'implementazione di `GetN()`), ma le prestazioni sono migliori in quanto non si deve effettuare una chiamata alla funzione. In genere l'implementazione inline viene effettuata per funzioni brevi e invocate spesso.

-   Notate l'uso del qualificatore `const` nella definizione del metodo `GetN()`: in questo modo ogni istruzione dentro `GetN()` che tenti di modificare il contenuto della classe verrà segnalata come errore di compilazione. Il metodo `GetN()` è un metodo di accesso e logicamente non ci aspettiamo che effettui alcuna operazione di modifica del contenuto della classe: in questo caso è buona pratica dichiararlo `const` al fine di rendere l'utilizzo della nostra classe da parte di eventuali utenti più sicuro.


## Esempio di implementazione della classe

Il file di implementazione `vettore.cpp` potrebbe essere così:

```c++
#include "vettore.h"
#include <iomanip>
#include <cmath>
#include <cstdlib>
#include <cassert>

using namespace std;

// Costruttore senza argomenti
Vettore::Vettore() {
  m_N = 0;
  m_v = nullptr;
}

// Costruttore con dimensione
Vettore::Vettore(int N) {
  if (N < 0) {
      cerr << "Errore, la dimensione deve essere positiva anziché " << N << endl;
      exit(1);
  }

  m_N = N;
  m_v = new double[N];
  for(int k = 0; k < N; ++k) {
      m_v[k] = 0;
  }
}

Vettore::~Vettore() {
  delete[] m_v;
}

void Vettore::crashIfInvalidIndex(int i) const {
  // Se `i` non è un indice valido nell'array, stampa un messaggio
  // di errore e termina il programma
  if (i < 0 || i >= m_N) {
      cerr << "Errore, indice " << i << ", dimensione " << m_N << endl;
      exit(1);
  }
}

void Vettore::SetComponent(int i, double a) {
  crashIfInvalidIndex(i);

  m_v[i] = a;
}

double Vettore::GetComponent(int i) const {
  crashIfInvalidIndex(i);

  return m_v[i];
}

void Vettore::Scambia(int primo, int secondo) {
  // Verifica che entrambi gli indici siano corretti
  crashIfInvalidIndex(primo);
  crashIfInvalidIndex(secondo);

  double temp = m_v[primo];
  m_v[primo] = m_v[secondo];
  m_v[secondo] = temp;

  // Equivalente a:
  //
  //     double temp = GetComponent(primo);
  //     SetComponent(primo, GetComponent(secondo));
  //     SetComponent(secondo, temp);
}

double & Vettore::operator[](int i) const {
  crashIfInvalidIndex(i);
  return m_v[i];
}
```

Notate l'ultimo metodo implementato (dovete ovviamente aggiungerlo anche nell'header file della classe) che rappresenta l'overloading dell'operatore di accesso `[]` ad un elemento (eg. `double a = v[2]` se `v` è un oggetto di tipo `Vettore`). Questo è spiegato anche sulle [slide addizionali](tomasi-lezione-02.html#operator-array).

## Programma di test

Questo programma usa un copy constructor per creare il `Vettore c` ed un'assegnazione per il `Vettore b`.

```c++
#include "vettore.h"
#include <iostream>

using namespace std;

int main() {
  // costruttore senza argomenti → crea un vettore di dimensione nulla
  Vettore vnull;
  cout << "Vettore vnull: dimensione = " << vnull.GetN() << endl;
  for(int k = 0; k < vnull.getN(); k++) {
      cout << vnull.GetComponent(k) << " ";
  }
  cout << endl;

  // costruttore con intero: costruisco un vettore di lunghezza 10
  Vettore v(10);
  cout << "Vettore v: dimensione = " << v.GetN() << endl;
  for(int k = 0; k < v.GetN(); ++k) {
      cout << v.GetComponent(k) << " ";
  }
  cout << endl;

  int comp = 3;
  cout << "Componente " << comp << " = " << v.GetComponent(comp) << endl;

  // Cambio la componente alla posizione `comp`
  v.SetComponent(comp, -999);
  for(int k = 0; k < v.GetN(); ++k) {
      cout << v.GetComponent(k) << " ";
  }
  cout << endl;

  // Anche come puntatore a memoria dinamica
  Vettore * vp = new Vettore(10);
  cout << "Vettore vp: dimensione = " << vp->GetN() << endl;
  for(int k = 0; k < v.GetN(); ++k) {
      cout << vp->GetComponent(k) << " ";
  }
  cout << endl;

  delete vp;

  return 0;
}
```


# Esercizio 2.1 - Completamento della classe `Vettore` {#esercizio-2.1}

La classe `vettore` costruita sopra non è però ancora completa, anzi può essere addirittura pericolosa! In particolare vogliamo:

1.  Aggiungere la possibilità di costruire un `Vettore` a partire da un `Vettore` esistente (*costruttore di copia*)

2.  Aggiungere la possibilità di eguagliare due oggetti di tipo `vettore` (*operatore di assegnazione*)

3.  Aggiungere un operatore di accesso rapido alle componenti (`[]`).


## Copy constructor

Il *copy constructor* (o costruttore di copia) viene utilizzato per creare una copia di un `Vettore` esistente: esso deve accettare in input un `Vettore` e costruirne una copia del `Vettore` argomento.

Il *copy constructor* viene invocato implicitamente ogni volta che utilizziamo sintassi come:

```c++
Vettore a;       // costruttore standard senza argomenti
Vettore b = a;   // copy constructor
```

oppure la sintassi equivalente:

```c++
Vettore a;     // costruttore standard senza argomenti
Vettore b(a);  // copy constructor (idem al caso sopra)
```

ed in tutti i casi in cui si passa un oggetto per valore. Il compilatore mette a disposizione un costruttore di copia di default che eguaglia i data membri. In questo caso i due puntatori `m_v` dei due oggetti `Vettore` punterebbero alla stessa area di memoria generando possibili problemi di memoria. In questi casi si deve procedere a fornire al compilatore una implementazione esplicita del costruttore di copia, che si effettua seguendo questi passaggi:

-   Il *copy constructor* viene dichiarato nell'header con questo prototipo:

    ```c++
    Vettore(const Vettore&);
    ```

-   Nell'implementazione, dobbiamo assicurarci che l'oggetto costruito abbia la sua zona di memoria riservata:

    ```c++
    // overloading costruttore di copia

    Vettore::Vettore(const Vettore& V) {
      m_N = V.GetN();

      // Il vettore `V` ha già la sua memoria allocata, ma qui dobbiamo
      // richiedere nuova memoria per l'oggetto corrente
      m_v = new double[m_N];
      for (int i = 0; i < m_N; i++) {
          m_v[i] = V.GetComponent(i);
      }
    }
    ```


## Operatore di assegnazione

L' *operatore di assegnazione* viene utilizzato per eguagliare un vettore ad un altro (entrambi già esistenti); esso viene invocato implicitamente ogni volta che utilizziamo una sintassi come la seguente:

```c++
Vettore a ;
// ... riempimento delle componenti di a
Vettore b ;
// ... riempimento delle componenti di b

// Qui invoco l'operatore di assegnazione
a = b;
```

oppure la sintassi equivalente, ma più ostica:

```c++
Vettore a;
// ... riempimento delle componenti di a
Vettore b;
// ... riempimento delle componenti di b

a.operator=(b);
```

In questo caso `a` e `b` sono oggetti della stessa classe. Di fatto, un'assegnazione come `a = b` non è altro che una abbreviazione per indicare la chiamata ad un metodo della classe di nome `operator=`:

```c++
a.operator=(b);
```

Il compilatore fornisce un'implementazione di default di questo operatore, che corrisponde ad un assegnazione membro a membro di tutti i data membri. Nel caso di `Vettore`, il compilatore C++ genera quindi un costruttore di copia come il seguente:

```c++
// Il C++ genera automaticamente questo operatore di assegnazione
// (che però in questo caso particolare è sbagliato!)
Vettore & Vettore::operator=(const Vettore & v) {
  m_N = v.m_N;  // Questo andrebbe pure bene…
  m_v = v.m_v;  // …ma questo è sbagliato!

  // Se aggiungessimo altri membri alla Classe vettore, il C++
  // metterebbe automaticamente qui anche l'assegnazione di questi
  // nuovi membri
}
```

In casi come quello di `Vettore` però, questo operatore di assegnazione non è corretto: il puntatore `m_v` è ora condiviso tra l'oggetto `V` e il nuovo oggetto. Ecco un codice che mostra dove sta il problema:

```c++
Vettore a ;
// ... riempimento delle componenti di a
Vettore b ;
// ... riempimento delle componenti di b

// Qui invoco l'operatore di assegnazione, ma siccome
// sto usando quello di default del C++, il valore di
// a.m_v diventerà uguale a quello di b.m_v
a = b;

// A causa dell'errore sopra, SetElement modifica sia
// l'elemento n. 10 in `b` che quello in `a`: infatti
// a.m_v e b.m_v puntano alla stessa area di memoria!
b.SetElement(0, 10);
```


Dobbiamo quindi realizzare un'implementazione sicura dell'assegnazione, facendo una copia dei dati in una nuova locazione di memoria anziché copiare superficialmente il valore di `m_v`.

Nel nostro caso, l'header file `vettore.h` dovrà quindi contenere una dichiarazione:

```c++
Vettore& operator=(const Vettore&);
```

Una possibile implementazione è data qui sotto:

```c++
    // overloading operatore di assegnazione

    Vettore& Vettore::operator=(const Vettore& V) {
      m_N = V.GetN();
      if (m_v) {
          delete[] m_v;
      }

      // Qui richiediamo una nuova area di memoria
      m_v = new double[m_N];

      // Copiamo nella nuova area di memoria gli elementi di `V`
      for (int i = 0; i < m_N; i++) {
          m_v[i] = V.GetComponent(i);
      }
      return *this;
    }
```


## Il puntatore `this`

Il puntatore `this` indica un puntatore all'oggetto cui si sta applicando un metodo. È particolarmente utile in alcune occasioni, come nel caso dell'operatore di assegnazione, in cui si deve restituire una copia dell'oggetto corrente.

(Se conoscete Python, il valore `*this` dei metodi C++ è equivalente al `self` dei metodi Python: ma in Python è esplicito, mentre in C++ la sua presenza è implicita.)


## Operatore di accesso `[]`

Se vogliamo semplificare la codifica dell'accesso alle componenti di un `Vettore` (sia in lettura sia in scrittura ) potremmo pensare di fare un _overloading_ dell'operatore di accesso `operator[](int)`. Questo permetterebbe ad esempio di accedere alla seconda componente di un vettore v semplicemente scrivendo

```c++
double a = v[1]
```

Per aggiungere questa funzionalità alla nostra classe `Vettore` dobbiamo come al solito compiere queste azioni:

-   Aggiungere la dichiarazione del metodo nell'header file (`.h`):

    ```c++
    double& operator[](int) const;
    ```


-   Aggiungere l'implementazione del metodo nel file di implementazione (`.cpp`):

    ```c++
    double& Vettore::operator[] (int i) const {
      crashIfInvalidIndex(i);
      return m_v[i];
    }
    ```

## Esempio di codice

A questo punto possiamo utilizzare il seguente codice di test che include anche un esempio di utilizzo di *copy constructor* , *operatore di assegnazione* e *operatore di accesso*.

**Avvertenza**: Questo esempio di codice darebbe problemi di *memory corruption* senza l'implementazione corretta del copy constructor e dell'operatore di assegnazione ma basandosi su quelli generati automaticamente dal compilatore! Infatti avremmo ottenuto due vettori che condividono esattamente la stessa area di memoria: una modifica su un vettore implica che anche l'altro venga modificato. Avendo implementato esplicitamente ed in maniera corretta i due operatori questo problema non si presenta.

```c++
#include "Vettore.h"
#include <iostream>

using namespace std;

int main() {

  // costruttore senza argomenti → crea un vettore di dimensione nulla
  Vettore vnull;
  cout << "Vettore vnull: dimensione = " << vnull.GetN() << endl;
  for (int k = 0; k < vnull.GetN(); k++)
    cout << vnull.GetComponent(k) << " ";
  cout << endl;

  // construttore con intero: costruisco un OGGETTO di tipo vettore di
  // lunghezza 10
  Vettore v(10);
  cout << "Vettore v: = dimensione = " << v.GetN() << endl;
  for (int k = 0; k < v.GetN(); k++) {
    cout << v.GetComponent(k) << " ";
  }
  cout << endl;
  int comp = 3;
  cout << "Componente " << comp << " = " << v.GetComponent(comp) << endl;
  cout << "Componente " << comp << " = " << v[comp] << endl;

  v.SetComponent(comp, -999);
  v[comp] = -999;

  for (int k = 0; k < v.GetN(); k++) {
    cout << v.GetComponent(k) << " ";
  }
  cout << endl;

  // anche come puntatore

  Vettore *vp = new Vettore(10);
  cout << "Vettore vp: = dimensione = " << vp->GetN() << endl;
  for (int k = 0; k < vp->GetN(); k++) {
    cout << vp->GetComponent(k) << " ";
  }
  cout << endl;

  // copy constructor: w viene creato come copia di v

  Vettore w = v; //  oppure la sintassi equivalente: Vettore w(v);

  cout << "Vettore w: dimensione = " << w.GetN() << endl;
  for (int k = 0; k < w.GetN(); k++)
    cout << w.GetComponent(k) << " ";
  cout << endl;

  v.SetComponent(4, 99); // WARNING: senza copy constructor opportuno, un
                         // cambio di v cambia anche w !!!!!!

  cout << "Vettore v: dimensione = " << v.GetN() << endl;
  for (int k = 0; k < v.GetN(); k++) {
    cout << v.GetComponent(k) << " ";
  }
  cout << endl;

  cout << "Vettore w: dimensione = " << w.GetN() << endl;
  for (int k = 0; k < w.GetN(); k++) {
    cout << w.GetComponent(k) << " ";
  }
  cout << endl;

  // operatore di assegnazione: prima creo Z e poi lo eguagli a w

  Vettore z;
  z = w;

  cout << "Vettore z: dimensione = " << z.GetN() << endl;
  for (int k = 0; k < z.GetN(); k++) {
    cout << z.GetComponent(k) << " ";
  }
  cout << endl;

  delete vp;

  return 0;
}
```


# Esercizio 2.2 - Codice di analisi dati utilizzando la classe `Vettore` (da consegnare) {#esercizio-2.2}

Proviamo ora a riscrivere il codice della prima lezione utilizzando un contenitore di dati più raffinato: la classe `Vettore` ci permetterà di riempire il contenitore dati controllando per esempio che non stiamo sforando la dimensione allocata. La classe `Vettore` inoltre mantiene al suo interno anche la sua dimensione (nel campo `m_N`): se dobbiamo calcolare la media degli elementi di un `Vettore` **non dobbiamo più passare la dimensione come argomento esterno**! Per svolgere questo esercizio dobbiamo:

-   modificare tutte le funzioni in `funzioni.h` e `funzioni.cpp` in modo che lavorino con oggetti di tipo `Vettore` invece che con semplici array del C.
-   modificare il `main` in modo che utilizzi la nuova classe `Vettore` e le nuove funzioni.
-   modificare il `Makefile`

Se non ci riuscite da soli potete dare un'occhiata ai suggerimenti qui sotto.


## Struttura del programma

```c++
#include <cstdlib>
#include <string>
#include <iostream>

// includo la dichiarazione della classe Vettore

#include "Vettore.h"

// include la dichiarazione delle funzioni

#include "funzioni.h"

using namespace std;

int main(int argc, char *argv[]) {
  // Vedi le slide
  test_statistical_functions();

  if (argc != 3) {
    cout << "Uso del programma: " << argv[0] << " <n_data> <filename> " << endl;
    return 1;
  }

  int ndata = stoi(argv[1]);
  char *filename = argv[2];

  Vettore v = Read(ndata, filename);

  Print(v);

  cout << "media    = " << CalcolaMedia(v) << endl;
  cout << "varianza = " << CalcolaVarianza(v) << endl;
  cout << "mediana  = " << CalcolaMediana(v) << endl;

  Print(v);
  Print(v, "data_out.txt");

  return 0;
}
```

La funzione `test_statistical_functions()` è spiegata nelle [slide di Tomasi](tomasi-lezione-02.html#/scrittura-di-test).

## Implementazione delle funzioni

-   L'header file (`.h`) potrebbe risultare così:

    ```c++
    #pragma once
    #include <fstream>
    #include <iostream>

    #include "Vettore.h"

    Vettore Read(int, const char *);

    double CalcolaMedia(const Vettore &);
    double CalcolaVarianza(const Vettore &);
    double CalcolaMediana(Vettore);

    void Print(const Vettore &);
    void Print(const Vettore &, const char *);

    void selection_sort(Vettore &);
    ```

-   Il file di implementazione (`.cpp`) potrebbe risultare così per il calcolo della media (aggiungere tutte le funzioni restanti):

    ```c++
    #include "funzioni.h"

    double CalcolaMedia(const Vettore & v) {
      double accumulo = 0;
      for (int k = 0; k < v.GetN(); k++) {
        accumulo += v.GetComponent(k);
      }

      return accumulo / double (v.GetN()) ;
    }
    ```

-   Assicuratevi di implementare i test con `assert` come spiegato in [questa slide](tomasi-lezione-02.html#/esercizio-1.1-assert): il codice fornito nella slide va bene per gli esercizi della scorsa lezione, che richiedono di passare sia l'array che la lunghezza dell'array, ma è facile adattarli al caso di oggi. (Se non ci riuscite, chiedete al docente!)

## Passaggio dati *by reference* con qualificatore `const`

Nella funzione `CalcolaMedia`, il vettore di input viene passato con la sintassi `const Vettore & v`, quindi il passaggio avviene *by reference* evitando una inutile e pesante copia dell'oggetto vettore di input. Il passaggio *by reference* darebbe alla funzione la possibilità di modificare (per sbaglio) il contenuto del vettore del `main`: per questo motivo si aggiunge il qualificatore `const`, che non permette (pena un errore di compilazione) operazioni di modifica del contenuto del vettore da dentro la funzione.


## Il Makefile

Il makefile va modificato aggiungendo la compilazione della classe `Vettore`:

```
esercizio2.2: esercizio2.2.o Vettore.o funzioni.o
        g++ -o esercizio2.2 esercizio2.2.o Vettore.o funzioni.o
funzioni.o: funzioni.cpp funzioni.h Vettore.h
        g++ -c -o funzioni.o funzioni.cpp
esercizio2.2.o: esercizio2.2.cpp funzioni.h Vettore.h
        g++ -c -o esercizio2.2.o esercizio2.2.cpp
Vettore.o: Vettore.cpp Vettore.h
        g++ -c -o Vettore.o Vettore.cpp

clean:
        rm *.o
cleanall: clean
        rm esercizio2.2
```

## Tipo del parametro di `CalcolaMediana`

Perché `CalcolaMedia` richiede un parametro di tipo `const Vettore &`, mentre `CalcolaMediana` richiede semplicemente il tipo `Vettore`?:

-   Nel caso di `CalcolaMedia(...)` o `CalcolaVarianza(...)` il passaggio avviene *by reference* per ottimizzare l'uso della memoria. Con questa modalità di passaggio dati la funzione lavora sul `Vettore` del `main` e pertanto una modifica accidentale del `Vettore` di input all'interno della funzione ha un effetto anche nel `main`. Il qualificatore `const` vieta alla funzione di fare qualsiasi operazione di cambiamento del contenuto del vettore di input pena un errore di compilazione.

-   Nel caso invece di `CalcolaMediana(...)` il passaggio e' effettuato *by value* e senza il qualificatore `const`: in questo modo permettiamo che il metodo proceda al riodinamento del `Vettore`. Dal momento che con il passaggio by value il `Vettore` nella funzione è una copia del `Vettore` di input ogni cambiamento effettuato nella funzione non si ripercuote sul `main`.

## Approfondimenti

### Semantica di `move`

[Vedi anche le [slide di Tomasi](tomasi-lezione-02.html#/move-semantics)]

La *move semantic* è un nuovo modo (dal C++11) di spostare le risorse in un modo ottimale evitando di creare copie non necessarie di oggetti temporanei ed è basato sulle *r-value* references. La potenza della *move semantic* si può capire affrontando il caso in cui si voglia costruire un oggetto della classe `Vettore` a partire dall'output di una funzione:

```c++
Vettore v = Read(ndata, filename);
```

La funzione `Read()` restituirà un oggetto temporaneo di tipo ``Vettore` che poi verrà utilizzato come input del costruttore di copia per la creazione di `v`. Chiaramente questo riduce notevolmente le performance del nostro codice. Perché non realizzare un costruttore di copia (e un operatore di assegnazione) che siano in grado di rubare i data membri all'oggetto temporaneo senza dover copiare dati? Questo è lo spirito del *move constructor* e del *move assignment operator*:

```c++
// overloading del move constructor

Vettore::Vettore(Vettore &&V) {
  cout << "Calling move constructor" << endl;
  m_N = V.m_N;
  m_v = V.m_v;
  V.m_N = 0;
  V.m_v = nullptr;
  cout << "Move constructor called" << endl;
}

// overloading del move assignment operator

Vettore &Vettore::operator=(Vettore &&V) {
  cout << "Calling move assignment operator " << endl;
  delete[] m_v;

  m_N = V.m_N;
  m_v = V.m_v;

  V.m_N = 0;
  V.m_v = nullptr;
  cout << "Move assignment operator called" << endl;
  return *this;
}
```

-   Notare la presenza della doppia `&&` nel tipo del parametro `V` di input: si sta dicendo al C++ che è richiesto un *r-value*
-   Il *move constructor* e il *move assignment operator* semplicemente “rubano” i dati all'oggetto temporaneo (non c'è copia elemento per elemento)
-   Il puntatore dell'oggetto di input viene sganciato dai dati
-   Per vedere il *move constructor* all'opera potrebbe essere necessario aggiungere la flag `-fno-elide-constructors`, in modo da disattivare eventuali ottimizzazioni interne del compilatore che maschererebbero l'uso del move constructor (fate questo giusto come prova, però poi rimuovete quella flag!).


## Eccezioni in C++

Nei metodi della classe `Vettore` o nelle funzioni corrispondenti abbiamo spesso utilizzato la funzione `exit()` per interrompere l'esecuzione del programma in caso si incontri una condizione patologica (per esempio tentiamo
di accedere ad una componenete che non esiste). Questo approccio non è considerato buon conding: in generale non vogliamo che il comportamento di una funzione (magari scritta da altri) possa decidere la sorte del programma. Sarebbe meglio che la funzione potesse fornire al `main` l'informazione su eventuali errori di esecuzione e lasciare al `main` la possibilità di decidere della sorte del programa. In C++ esiste un meccanismo di gestione delle [eccezioni](https://cplusplus.com/doc/tutorial/exceptions/). Per capire meglio come utilizzare le eccezioni in C++ proviamo a tenere come esempio il metodo di accesso ad un elemento (`GetComponent()`). Con la modifica seguente:

```c++
class Vettore {

public:
  // ....

  double GetComponent(int k) const {
    if (k > m_N) {
      throw 99;
    }
    return m_v[k];
  }

private:
  int m_N;
  double *m_v;
};
```

il metodo `GetComponent()` può essere usato nel modo seguente dal `main()`:

```c++
#include "Vettore.h"

int main() {

  Vettore v(3);

  v.SetComponent(1, 99);

  try {
    v.GetComponent(4);
  } catch (int errcode) {
    cout << "Error code " << errcode << " exiting " << endl;
    exit(44);
  }

  return 0;
}
```

Come si può notare, quando si tenta di leggere la componente 4 (che non esiste) il metodo `GetComponent()` solleva un'eccezione che viene propagata al `main`. A questo punto si può decidere cosa fare direttamente nel `main()`.


# Errori comuni

Tra errori che gli studenti hanno fatto negli anni precedenti, ci sono ovviamente già quelli elencati per la [prima lezione](carminati-esercizi-01.html#errori-comuni). A questi se ne aggiungono i seguenti:

-   Stranamente, molti studenti che avevano consegnato esercizi della lezione 1 con un calcolo corretto di media, mediana e varianza consegnano per la lezione 2 esercizi che calcolano quegli stessi valori in modo sbagliato!

-   È capitato più di una volta che gli esercizi di alcuni studenti che implementavano il *move constructor* non compilavano neppure. Questo ha lasciato basiti noi docenti: idealmente, **tutti** gli esercizi che si consegnano devono compilare senza errori… Se non riuscite a trovare la causa dell'errore, contattate i docenti prima di consegnare!

---
title: "Lezione 2: Analisi dei dati (classe Vettore)"
author:
- "Leonardo Carminati"
- "Maurizio Tomasi"
date: "A.A. 2024−2025"
lang: it-IT
...
