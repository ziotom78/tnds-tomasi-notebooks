% Laboratorio di TNDS -- Lezione 2
% Maurizio Tomasi
% Martedì 12 Ottobre 2021

# Esercizi per oggi

# Link alle risorse online

-   Gli esercizi di oggi sono disponibili sul sito del corso [labmaster.mi.infn.it/Laboratorio2/labTNDS/lectures_1819/lezione2_1819.html](http://labmaster.mi.infn.it/Laboratorio2/labTNDS/lectures_1819/lezione2_1819.html).

-   Come al solito, queste slides, che forniscono suggerimenti addizionali rispetto alla lezione di teoria, sono disponibili all'indirizzo [ziotom78.github.io/tnds-tomasi-notebooks](https://ziotom78.github.io/tnds-tomasi-notebooks/).

# Esercizi

-   Esercizio 2.0: creazione di una classe `Vettore`.

-   Esercizio 2.1 (da consegnare per l'esame scritto): è lo stesso tipo di esercizio della scorsa lezione, ma ora occorre usare la classe `Vettore` dell'esercizio 2.0.


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
    std::cout << "Insert two numbers: ";

    int a, b;
    std::cin >> a >> b;

    std::cout << "The result is "
              << calc(a, b) << "\n";
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

-   Si può verificare automaticamente la correttezza del codice, usando la macro `assert`:

    ```c++
    #include <cassert>
    
    void test_sum() {
        // No need to write std::assert, as it is a macro
        assert(sum(4, 6) == 10);
        assert(sum(-1, 3) == 2);
    }
    
    …
    ```

-   Il resto del codice resta uguale, ma nel `main` si deve invocare `test_sum()` prima di ogni altra cosa.


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

-   C'è però un problema con gli esercizi di queste prime lezioni, legato a qualcosa che alcuni di voi hanno osservato già la scorsa volta.

-   Considerate il risultato atteso per la varianza nel caso `N = 100000`, che è `282326.76577`. Se avete usato `std::cout <<` per stampare la varianza, avete probabilmente ottenuto `282327` (risultato arrotondato).

-   Non si può in questo caso scrivere un test per la varianza fatto così:

    ```c++
    assert(CalcolaVarianza(mydata, 100_000) == 282326.76577)
    ```
    
    perché al minimo errore di arrotondamento l'uguaglianza fallisce.



# Esercizio 1.1: assert

```c++
bool are_close(double x, double y,
    double eps = 1e-7) { return fabs(x - y) < eps; }

void test_statistical_functions(void) {
  double mydata[] = {1, 2, 3, 4};

  assert(are_close(CalcolaMedia(mydata, 4), 2.5));
  // Variance: σ²
  assert(are_close(CalcolaVarianza(mydata, 4), 1.25));

  // Test for an even/odd number of elements
  assert(are_close(CalcolaMediana(mydata, 4), 2.5));
  assert(are_close(CalcolaMediana(mydata, 3), 2));

  // Continue from here …
}
```

Questi `assert` vanno bene anche per gli esercizi successivi, con opportuni aggiustamenti (es., usare `Vettore` anziché `double *`).



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

# Uso di `operator[]`

-   Nella classe `Vettore` è utile fare in modo che si possa accedere ai dati dell'array con la solita scrittura `[]`, es.:

    ```c++
    Vettore miovett(10);
    
    // Inizializzo l'array
    // ...
    
    std::cout << "Il terzo elemento è " << miovett[3] << "\n";
    ```

-   Ma `miovett` non è un array, bensì un oggetto, quindi il C++ non sa cosa significhi `miovett[3]`.


# Uso di `operator[]`

-   Per rendere valida la scrittura `miovett[3]` occorre implementare un oggetto `operator[]`:

    ```c++
    double Vettore::operator[](int index) {
        assert(index >= 0 && index < m_size);
        return m_arr[index];
    }
    ```

-   In questo modo la linea di codice
    ```c++
    std::cout << miovett[5] << "\n";
    ```

    sarà equivalente a

    ```c++
    assert(5 >= 0 && 5 < miovett.m_size);
    std::cout << miovett.m_arr[5] << "\n";
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

-   Così la scrittura seguente diventa legale:

    ```c++
    miovett[5] = 6.0;
    ```

# Uso di header files

-   Avete già visto a lezione l'utilità degli *header files*, ossia dei file con estensione `.h`, `.hh` o `.hpp`.

-   Capita spesso che un file sia incluso più volte nel corso di una stessa compilazione.

-   Consideriamo questo esempio:

    ```c++
    // File main.cpp
    
    #include "vettore.hpp"
    #include "statistiche.hpp"
    
    int main() {
        // ...
    }
    ```

-   Nel `main` si usano sia le funzioni dichiarate in `vettore.hpp` che quelle dichiarate in `statistiche.hpp`, quindi ci vogliono entrambi gli `#include`.


# Uso di header files

-   Supponiamo che questo sia il contenuto di `vettore.hpp`:

    ```c++
    // File vettore.hpp
    
    class Vettore {
        // ...
    };
    ```

    e questo sia il contenuto di `statistiche.hpp`:

    ```c++
    // File statistiche.hpp
    
    #include "vettore.hpp"
    
    double CalcolaMedia(const Vettore & vett);
    ```

# Uso di header files

Compilare il programma `main.cpp` provocherebbe un errore di compilazione:

1.  Il primo `#include` definisce la classe `Vettore`;
2.  Il secondo `#include` carica `statistiche.hpp`…
3.  …che a sua volta definisce di nuovo la classe `Vettore`: ma il C++ non ammette di definire due classi con lo stesso nome (neppure se sono identiche!).


# Uso di header files

In pratica, `g++` è come se vedesse questo codice:

```c++
// Questo viene da #include "vettore.hpp"
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

-   Questo è un problema che risale ai primordi del linguaggio C (fine anni '60), ed è stato storicamente risolto con l'uso di *header guards*.

-   Una *header guard* è un trucchetto che usa `#ifdef` per evitare una compilazione doppia:

    ```c++
    // File vettore.hpp
    #ifndef __VETTORE_HPP__
    #define __VETTORE_HPP__
    
    class Vettore {
        // ...
    };
    
    #endif
    ```

    In questo modo la seconda volta che il file viene incluso, verrà saltato. L'identificatore `__VETTORE_HPP__` è arbitrario, e si può scegliere ciò che si vuole.


# `#pragma once`

-   I recenti compilatori C++, incluso il `g++`, permettono un'alternativa più semplice alle *header guards*.

-   la seguente scrittura è più agile e mette al riparo da errori:

    ```c++
    #pragma once  // Questo file sarà incluso una volta sola
    
    class Vettore {
        // ...
    };
    ```

    È più comoda perché si deve aggiungere una sola riga, non si deve inventare un identificatore e mette al riparo da pericolosi copia-e-incolla (che gli studenti fanno **sempre**!).


# Costruttori, move semantics, etc.

# Analogia

![](images/empty_room.jpg){ width=40% }
![](images/furnished_room.jpg){ width=40% }

Immaginiamo che una variabile appena creata dal compilatore C++ sia
una stanza. *Prima* che sia invocato il costruttore è vuota, quando è
stato invocato è invece arredata.



# Costruttori

![](images/empty_room.jpg){ width=40% }
![](images/furnished_room.jpg){ width=40% }

```c++
Vettore::Vettore(unsigned int n) : m_N(n) {
    m_v = new double[m_N];
}

int main() {
    Vettore v(10);
    // …
}
```



# Costruttori di copia

![](images/empty_room.jpg){ width=40% }
![](images/furnished_room.jpg){ width=40% }

Un *copy constructor* corrisponde all'azione di costruire una stanza
vuota identica alla prima (ossia, di tipo `Vettore`), e riempirla con
gli stessi identici mobili (ossia, assegnando lo stesso valore a `m_v`
e `m_N`).



# Costruttori di copia

![](images/empty_room.jpg){ width=40% }
![](images/furnished_room.jpg){ width=40% }

```c++
Vettore::Vettore(const Vettore &vett) : m_N(vett.m_N) {
    m_v = new double[m_N];
    for(int i = 0; i < m_N; ++i)
        m_v[i] = vett.m_v[i];
}
```



# Operazione di assegnamento

![](images/empty_room.jpg){ width=40% }
![](images/furnished_room.jpg){ width=40% }

Con una operazione di assegnamento (`operator=`), abbiamo due stanze
già arredate (variabili già inizializzate), che vogliamo rendere
identiche. Dobbiamo quindi prima *svuotare* una delle due stanze, e
poi arredarla allo stesso modo dell'altra.



# Operazione di assegnamento

![](images/empty_room.jpg){ width=40% }
![](images/furnished_room.jpg){ width=40% }

```c++
Vettore::operator=(const Vettore &vett) {
    m_N = vett.m_N;
    if(m_v) delete m_v;  // Liberati dei mobili vecchi!
    m_v = new double[m_N];
    for(int i = 0; i < m_N; ++i) {
        m_v[i] = vett.m_v[i];
    }
}
```



# Operazione di assegnamento

![](images/empty_room.jpg){ width=40% }
![](images/furnished_room.jpg){ width=40% }

```c++
Vettore v1(10), v2(30);
// …qui inizializzo v1 e v2 e le uso per un po'

v1 = v2; // Assegnamento, tramite Vettore::operator=
```



# Move constructor

![](images/empty_room.jpg){ width=40% }
![](images/furnished_room.jpg){ width=40% }

Il *move constructor* è stato introdotto nel C++11, e corrisponde a un
trasloco: ho una stanza già arredata e una vuota, e voglio spostare i
mobili dalla prima alla seconda, senza comprarne di nuovi!


# Move constructor

![](images/empty_room.jpg){ width=40% }
![](images/furnished_room.jpg){ width=40% }

```c++
Vettore::Vettore(const Vettore && vett) : m_n(vett.m_N) {
    // Nessun "delete vett.m_v": voglio tenere i vecchi mobili
    m_v = vett.m_v;  // Velocissimo!
    // Nessun ciclo "for" per copiare gli elementi
}
```


# Move constructor

![](images/empty_room.jpg){ width=40% }
![](images/furnished_room.jpg){ width=40% }

```c++
// La funzione "Read" crea un vettore e lo riempie con i dati
// letti da un file

Vettore v = Read(ndata, filename);
```

