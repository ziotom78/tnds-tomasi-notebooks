---
title: Laboratorio di TNDS -- Lezione 2
author: Maurizio Tomasi
date: Martedì 12 Ottobre 2021
css:
- css/custom.css
- css/asciinema-player.css
theme: white
progress: true
slideNumber: true
background-image: ./media/background.png
width: 1440
height: 810
...

# Esercizi per oggi

# Link alle risorse online

-   La spiegazione dettagliata degli esercizi si trova qui: [carminati-esercizi-02.html](carminati-esercizi-02.html).

-   Come al solito, queste slides, che forniscono suggerimenti addizionali rispetto alla lezione di teoria, sono disponibili all'indirizzo [ziotom78.github.io/tnds-tomasi-notebooks](https://ziotom78.github.io/tnds-tomasi-notebooks/).

# Esercizi

-   Lo scopo della lezione di oggi è introdurre il concetto di «classe», che è un tipo di dato complesso del linguaggio C++, creando una classe `Vettore` che implementa un array «intelligente» di valori `double`.

-   [Esercizio 2.0](carminati-esercizi-02.html#esercizio-2.0): creazione della classe `Vettore`.
-   [Esercizio 2.1](carminati-esercizi-02.html#esercizio-2.1) (da consegnare per l'esame scritto): è lo stesso tipo di esercizio della scorsa lezione, ma ora occorre usare la classe `Vettore` dell'esercizio 2.0.


# Scrittura di test

# Verificate il vostro codice!

```
N = 100000:
  - Mean               : 30.23231
  - Variance           : 282326.76577 (corrected: 282329.58906)
  - Standard deviation : 531.34430 (corrected: 531.34696)
  - Median             : 12.74255

N = 10:
  - Mean               : 13.91472
  - Variance           : 38.73156 (corrected: 43.03507)
  - Standard deviation : 6.22347 (corrected: 6.56011)
  - Median             : 10.58911

N = 9:
  - Mean               : 13.85262
  - Variance           : 42.99651 (corrected: 48.37107)
  - Standard deviation : 6.55717 (corrected: 6.95493)
  - Median             : 9.55072
```


# Verifica della correttezza dei codici

-   Quando si scrive un programma, è indispensabile verificare che funzioni.

-   La scorsa settimana vi avevo fornito i risultati attesi, che avete (**spero!**) confrontato con l'output dei vostri programmi.

-   Ma se nelle prossime settimane deciderete di mettere mano ai vecchi esercizi per migliorarli, dovrete ricontrollare da capo i numeri!

-   Non sarebbe meglio se fosse il calcolatore a fare questi controlli per voi?


# Un semplice esempio

```c++
#include <iostream>

int calc(int a, int b) { return a + b; }

int main() {
    std::cout << "Inserisci due numeri: ";

    int a, b;
    std::cin >> a >> b;

    std::cout << "Il risultato è " << calc(a, b) << "\n";
    return 0;
}
```

# Un semplice esempio

-   Per verificare la correttezza del codice, si può eseguire alcune volte il programma.

    ```text
    $ g++ test1.cpp -o test1
    $ ./test1
    Insert two numbers: 4 6
    The result is 10
    
    $ ./test1
    Insert two numbers: -1 3
    The result is 2
    
    $
    ```

-   Il conto però, come abbiamo visto, va verificato a mano ogni volta.


# Test automatici

-   Si può verificare automaticamente la correttezza del codice con `assert`:

    ```c++
    #include <cassert>
    
    void test_sum() {
        // No need to write std::assert, as it is a macro
        assert(sum(4, 6) == 10);
        assert(sum(-1, 3) == 2);
    }
    ```

-   Una chiamata ad `assert` viene tradotta più o meno così:

    ```c++
    // assert(sum(4, 6) == 10);
    if (! (sum(4, 6) == 10)) {
        make_the_program_crash();
    }
    ```


# Test automatici

-   Il resto del codice resta uguale, ma nel `main` si deve invocare `test_sum()` prima di ogni altra cosa:

    ```c++
    int main(int argc, const char *argv[]) {
        // This must be the very first thing!
        test_sum();
        
        // Now implement the exercise as requested
        …
    }
    ```

-   Potete implementare più funzioni `test_*()`, che poi chiamerete una di seguito all'altra nel `main`.


# Test automatici

-   Se c'è un errore, il programma si blocca con un messaggio:

    ```text
    $ ./test2
    test2.cpp:4:void test_sum():
       Assertion `sum(-1,3) == 2' failed
    Aborted (core dumped)
    $
    ```

-   **Avvertenza**: questo output si ottiene solo se avete implementato il [suggerimento della scorsa lezione](https://ziotom78.github.io/tnds-tomasi-notebooks/tomasi-lezione-01.html#/flag-del-compilatore) di usare il flag `-g` nel `Makefile`.


# Test automatici

-   È sempre buona cosa inserire all'inizio del `main` una serie di test che verifichino il funzionamento corretto delle funzioni implementate.

-   Il `main` dei vostri prossimi esercizi sembrerà questo:

    ```c++
    int main(int argc, const char *argv[]) {
        // Put the tests of the functions you're going to use
        test_bisection();
        test_simpson_integral();
        test_random_generator();
        test_hit_or_miss();
        …
    }
    ```

-   In questa e nelle lezioni successive vi fornirò una serie di comandi `assert` da inserire nei vostri codici: vi aiuteranno a verificare che l'esercizio sia corretto.


# Test sui floating-point

-   Se provate a scrivere dei test per gli esercizi di queste prime lezioni, vi imbatterete però in un problema legato ai numeri *floating-point*.

-   Considerate il risultato atteso per la varianza nel caso `N = 100000`, che è `282326.76577`. Se avete usato `std::cout <<` per stampare la varianza, avete probabilmente ottenuto `282327` (risultato arrotondato).

-   Non si può in questo caso scrivere un test per la varianza fatto così:

    ```c++
    assert(CalcolaVarianza(mydata, 100_000) == 282326.76577)
    ```
    
    perché al minimo errore di arrotondamento l'uguaglianza fallisce.



# Esercizio 1.1: assert

```c++
bool are_close(double calculated, double expected, double epsilon = 1e-7) {
  return fabs(calculated - expected) < epsilon;
}

void test_statistical_functions(void) {
  double mydata[] = {1, 2, 3, 4};  // Use these instead of data.dat

  assert(are_close(CalcolaMedia(mydata, 4), 2.5));
  assert(are_close(CalcolaVarianza(mydata, 4), 1.25));
  assert(are_close(CalcolaMediana(mydata, 4), 2.5));  // Even
  assert(are_close(CalcolaMediana(mydata, 3), 2));    // Odd

  // Continue from here …
}
```

Questi `assert` vanno bene anche per gli esercizi di oggi, con opportuni aggiustamenti (es., usare `Vettore` anziché `double *`).



# Esempio di output

-   Se avete sbagliato ad implementare una delle funzioni, questo è quello che accade quando eseguite il programma:

    ```text
    $ make
    esercizio01.1: esercizio01.1.cpp:53: int main(): ↲
        Assertion `are_close(CalcolaMediana(mydata, num), 2.5)' failed.
    Aborted (core dumped)
    $
    ```

-   Anche quando avete verificato che gli `assert` passano con successo, lasciateli al loro posto: non fanno male di certo, e nel caso in cui in futuro dobbiate modificare l'implementazione delle funzioni, continueranno a fungere da controllo.



# Assert negli esercizi

-   Le liste di `assert` che vi fornisco sono state costruite anno dopo anno, alla luce degli errori che solitamente hanno fatto i vostri precedenti colleghi.

-   Non presentatevi all'esame finché non riuscite a far passare **tutti** gli `assert` di **tutti** gli esercizi!

-   Molte volte degli studenti hanno presentato uno scritto in cui avevano usato librerie con errori! E quasi sempre ritrovavo commenti del genere nel codice:

    ```c++
    // Siccome non riuscivo a far passare i test, ho commentato gli assert.
    ```


# Implementazione di `Vettore`

# Accesso ai dati {#operator-array}

-   Il testo dell'esercizio richiede di implementare i metodi `GetComponent` e `SetComponent` per leggere e scrivere valori nell'array:

    ```c++
    Vettore v(2);
    v.SetComponent(0, 162.3);
    v.SetComponent(1, 431.7);
    std::cout << v.GetComponent(1) << endl;   // Print 431.7
    ```
    
-   Questo è però più scomodo rispetto ai semplici array:

    ```c++
    double v[2];
    v[0] = 162.3;
    v[1] = 431.7;
    std::cout << v[1] << endl;                // Print 431.7
    ```


# Uso di `operator[]`

-   Si può rendere valida la scrittura `miovett[3]` anche con oggetti di tipo `Vettore` implementando il metodo `operator[]`:

    ```c++
    double Vettore::operator[](int index) {
        assert(index >= 0 && index < m_size);
        return m_arr[index];
    }
    ```

-   In questo modo la linea di codice `std::cout << miovett[5] << "\n"` sarà equivalente a

    ```c++
    assert(5 >= 0 && 5 < miovett.m_size);
    std::cout << miovett.m_arr[5] << endl;
    ```


# Uso di `operator[]`

-   Se si ritorna un *reference*, è possibile anche fare assegnamenti:

    ```c++
    //     !
    double & Vettore::operator[](int index) {
        assert(index >= 0 && index < m_size);
        return m_arr[index];
    }
    ```

-   Così il programma seguente diventa legale:

    ```c++
    Vettore v(2);
    v[0] = 162.3;  // Assignment, works thanks to the reference
    v[1] = 431.7;  // Ditto
    std::cout << v[1] << endl;                // Print 431.7
    ```
    
# Uso di header files

# Uso di header files

-   Avete visto a lezione l'utilità degli *header files*, ossia dei file con estensione `.h`, `.hh` o `.hpp`.

-   Capita spesso che un file sia incluso più volte nel corso di una stessa compilazione.

-   Consideriamo questo esempio:

    ```c++
    // File main.cpp
    
    #include "vettore.h"
    #include "statistiche.h"
    
    int main() {
        // ...
    }
    ```

-   Nel `main` si usano sia le funzioni dichiarate in `vettore.h` che quelle dichiarate in `statistiche.h`, quindi ci vogliono entrambi gli `#include`.


# Uso di header files

-   Supponiamo che questo sia il contenuto di `vettore.h`:

    ```c++
    // File vettore.h
    
    class Vettore {
        // ...
    };
    ```

    e questo sia il contenuto di `statistiche.h`:

    ```c++
    // File statistiche.h
    
    #include "vettore.h"
    
    double CalcolaMedia(const Vettore & vett);
    ```

# Uso di header files

Compilare il programma `main.cpp` provocherebbe un errore di compilazione:

1.  Il primo `#include` definisce la classe `Vettore`;
2.  Il secondo `#include` carica `statistiche.h`…
3.  …che a sua volta definisce di nuovo la classe `Vettore`: ma il C++ non ammette di definire due classi con lo stesso nome (neppure se sono identiche!).

```c++
// File main.cpp
    
#include "vettore.h"
#include "statistiche.h"
    
int main() {
    // ...
}
```


# Uso di header files

In pratica, `g++` è come se vedesse questo codice:

```c++
// Questo viene da #include "vettore.h"
class Vettore {
    // ...
};

// Questo viene dal secondo #include
class Vettore {
    // ...
};

double CalcolaMedia(const Vettore & vett);

int main() {
    // ...
}
```

# *Header guards*

-   Questo è un problema che risale ai primordi del linguaggio C (fine anni '60), ed è stato storicamente risolto con l'uso di *header guards*:

    ```c++
    // File vettore.h
    #ifndef __VETTORE_H__
    #define __VETTORE_H__
    
    class Vettore {
        // ...
    };
    
    #endif
    ```

    In questo modo, la seconda volta che il file viene incluso verrà saltato. L'identificatore `__VETTORE_H__` è arbitrario.


# `#pragma once`

-   I recenti compilatori C++, incluso il `g++`, permettono un'alternativa più semplice alle *header guards*.

-   La seguente scrittura è più agile e mette al riparo da errori:

    ```c++
    #pragma once  // Questo file sarà incluso una volta sola
    
    class Vettore {
        // ...
    };
    ```

    È più comoda perché si deve aggiungere una sola riga senza dover inventare un identificatore (`__VETTORE_H__`), e mette al riparo da pericolosi copia-e-incolla (che gli studenti fanno molto spesso!).


# Costruttori, move semantics, etc. {#move-semantics}

# «Costruzione» di una variabile

-   Ci sono due passaggi che il compilatore C++ compie quando si introduce una variabile nel codice:

    1.  Allocazione della memoria necessaria;
    2.  Inizializzazione della memoria.
    
-   Esempio:

    ```c++
    int x;  // Allocation
    x = 15; // Initialization
    
    int y = 30; // Shortcut, but there are still *two* operations here.
    ```
    
# «Costruzione» di `Vettore`

-   Le classi, a differenza di `int`, richiedono l'invocazione di un costruttore.

-   Il costruttore va invocato quando si dichiara la variabile: non è possibile «differire» l'inizializzazione:

    ```c++
    int x;
    x = 15;         // Ok, first allocate then initialize
    
    Vettore v;
    v(10);          // Error, you cannot call the constructor here!
    
    Vettore w(10);  // Ok, allocate and initialize
    ```
    
-   I costruttori possono richiedere molto tempo per essere eseguiti, ad esempio se invocano `new` (com'è il caso di `Vettore`).


# Analogia

![](images/empty_room.jpg){ width=20% }
![](images/furnished_room.jpg){ width=20% }

Immaginiamo che una variabile sia un appartamento. Appena allocata è completamente spoglia: è l'edificio appena gli imbianchini e i piastrellisti hanno terminato il lavoro. Quando poi viene chiamato il costruttore della variabile, è come se la casa venisse arredata.


# Costruttori

![](images/empty_room.jpg){ width=20% }
![](images/furnished_room.jpg){ width=20% }

```c++
Vettore::Vettore(int n) : m_N(n) {
    m_v = new double[m_N];         // Allocate (build up the building)
    for(int i = 0; i < m_N; ++i)   // Initialize (add the furniture)
        m_v[i] = 0.0;
}
```


# Costruttori di copia

![](images/empty_room.jpg){ width=20% }
![](images/furnished_room.jpg){ width=20% }

Un *copy constructor* corrisponde all'azione di costruire una stanza
vuota identica alla prima (ossia, di tipo `Vettore`), e riempirla con
gli stessi identici mobili (ossia, assegnando lo stesso valore a `m_N` e agli elementi di `m_v`).


# Costruttori di copia

![](images/empty_room.jpg){ width=20% }
![](images/furnished_room.jpg){ width=20% }

```c++
Vettore::Vettore(const Vettore &vett) : m_N(vett.m_N) {
    m_v = new double[m_N];        // Allocate (build up the building)
    for(int i = 0; i < m_N; ++i)  // Initialize (add a copy of the furniture
        m_v[i] = vett.m_v[i];     // that was used in the old building)
}
```


# Operazione di assegnamento

![](images/empty_room.jpg){ width=20% }
![](images/furnished_room.jpg){ width=20% }

Con una operazione di assegnamento (`operator=`), abbiamo due stanze
già arredate (variabili già inizializzate), che vogliamo rendere
identiche. Dobbiamo quindi prima *svuotare* la stanza di destinazione perché è piena, e solo dopo arredarla allo stesso modo dell'altra.


# Operazione di assegnamento

![](images/empty_room.jpg){ width=20% }
![](images/furnished_room.jpg){ width=20% }

```c++
Vettore & Vettore::operator=(const Vettore &vett) {
    m_N = vett.m_N;
    if(m_v) delete m_v;             // Put the old building in the garbage!
    m_v = new double[m_N];          // Create a new building
    for(int i = 0; i < m_N; ++i) {  // Fill the rooms with a copy of the
        m_v[i] = vett.m_v[i];       // old furniture
    }
}
```


# Operazione di assegnamento

![](images/empty_room.jpg){ width=20% }
![](images/furnished_room.jpg){ width=20% }

```c++
Vettore v1(10), v2(30);
// …here I initialize v1 and v2, and I use them for some time.

v1 = v2; // Assignment through Vettore::operator=
```


# Move constructor

![](images/furnished_room.jpg){ width=20% }
![](images/empty_room.jpg){ width=20% }

Il *move constructor* è stato introdotto nel C++11, e corrisponde a un
**trasloco**: ho una stanza già arredata e una vuota, e voglio spostare i
mobili dalla prima alla seconda, senza comprarne di nuovi!


# Move constructor

![](images/empty_room.jpg){ width=20% }
![](images/furnished_room.jpg){ width=20% }

```c++
Vettore::Vettore(Vettore && vett) : m_n(vett.m_N) {
    // No need for "delete vett.m_v": I want to keep the old furniture!
    m_v = vett.m_v;  // No need to call "new": very fast!
    // No "for" loop to copy the elements: very fast!
}
```


# Move constructor

![](images/empty_room.jpg){ width=20% }
![](images/furnished_room.jpg){ width=20% }

```c++
// Function "Read" creates a Vector and fill it with data read from file
Vettore Read(int ndata, const char * filename) {
  Vettore result(ndata);
  // …
  return result;
}

Vettore v = Read(ndata, filename);
```


# Distinguere tra i casi

```c++
Vettore v1(10);                    // Constructor
Vettore v2(v1);                    // Copy constructor
Vettore v3 = v1;                   // Copy constructor

v3 = v1;                           // Assignment
Vettore v4 = Read(10, "data.dat"); // Move constructor
                                   // (at the end of the call to "Read")
```
