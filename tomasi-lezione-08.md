---
title: "Laboratorio di TNDS -- Lezione 8"
author: "Maurizio Tomasi"
date: "Martedì 6 Dicembre 2022"
theme: "white"
progress: true
slideNumber: true
background-image: "./media/background.png"
history: true
width: 1440
height: 810
css:
- ./css/custom.css
- ./css/asciinema-player.css
...

# Alcuni problemi di `std::vector`

# Caratteristiche di `std::vector`

-   Finora abbiamo sempre usato `std::vector` per memorizzare sequenze di valori

-   Gli esercizi sulle equazioni differenziali non fanno eccezione:

    ```c++
    struct FunzioneVettorialeBase {
      virtual vector<double> Eval(const vector<double> &x) = 0;
    };

    struct OscillatoreArmonico : FunzioneVettorialeBase {
      vector<double> Eval(const vector<double> &x) override {
        return vector<double>{x[1], -x[0]};
      }
    };
    ```

-   L'uso di `std::vector` ha però una serie di svantaggi in questo contesto

# Svantaggio #1: velocità

-   Creare un nuovo oggetto `std::vector` è un'operazione **lenta**! Internamente `std::vector` crea un puntatore a un array:

    ```c++
    // Possible implementation of std::vector
    template <typename T>
    class vector {
      T * m_data;
      size_t m_size;
    public:
      vector(size_t size) : m_size{size} { m_data = new T[m_size]; }
      ~vector() { delete[] m_data; }
      // ...
    };
    ```

-   Ma `new` richiede molto lavoro da parte del sistema operativo, che deve ogni volta individuare un'area di memoria non occupata da altre variabili.

# Svantaggio #2: controlli

-   È impossibile per il compilatore sapere se due variabili `std::vector` hanno lo stesso numero di elementi

-   Dobbiamo verificare noi a mano che le dimensioni di vettori siano compatibili:

    ```c++
    template <typename T>
    std::vector<T> operator+(const std::vector<T> &a, const std::vector<T> &b) {

      assert(a.size() == b.size());  // Don't forget to do this, or to throw some exception!

      // ...
    }
    ```

-   Dimenticarsi un `assert` da qualche parte nel codice potrebbe avere conseguenze disastrose (soprattutto durante l'esame!)

# Svantaggio #3: leggibilità

-   Siccome `std::vector` viene usato per vettori con un numero arbitrario di elementi, è difficile capire su quante dimensioni lavori una classe derivata da `FunzioneVettorialeBase`:

    ```c++
    struct FunzioneVettorialeBase {
      virtual vector<double> Eval(const vector<double> &x) = 0;
    };

    struct OscillatoreArmonico : FunzioneVettorialeBase {
      vector<double> Eval(const vector<double> &x) override {
        // This is a two-dimensional problem in phase space, because we're returning
        // a 2-element array. But it's not evident at all!
        return vector<double>{x[1], -x[0]};
      }
    };
    ```

# Uso di `std::array`

# La classe `std::array`

-   Fortunatamente, la libreria standard del C++ offre una classe perfetta per i nostri scopi: `std::array`.

-   Essa è equivalente ad un array con un numero **fissato** di elementi, che vengono controllati in fase di compilazione.

-   Una sua possibile implementazione è la seguente:

    ```c++
    template <typename T, size_t N>  // C++ accepts *types* as well as *values* in templates
    class array {
      T m_data[N];                   // No pointers, just an array of fixed size
      const size_t m_size = N;       // The size is constant, we cannot change it
    public:
      // ..
    };
    ```

# Uso di `std::array`

-   A differenza di `std::vector`, nel dichiarare una variabile di tipo `std::array` bisogna specificare non solo il tipo ma anche la dimensione:

    ```c++
    std::vector<double> v(4);  // The size is 4, but it can change later
    std::array<double, 4> a;   // The size is forced to be 4

    v.at(0) = 1.0;    // Both std::vector and std::array can be
    a.at(0) = 2.0;    // accessed using [] or .at()

    v.push_back(3.14159);  // Ok, the array will grow
    a.push_back(2.71828);  // ERROR, you cannot use push_back with an array
    ```

-   Si può inizializzare un array in maniera immediata:

    ```c++
    std::array<double, 4> a{1.0, 2.0, 3.0, 4.0};  // Ok, but if you use -std=c++17…
    std::array a{1.0, 2.0, 3.0, 4.0};             // …"double" and "4" are redundant!
    ```

# Uso in `FunzioneVettorialeBase`

-   La classe `std::array` è perfetta per `FunzioneVettorialeBase`

-   Se siete intimoriti da `std::array`, ignorate pure le slide seguenti. Se invece volete provare, dovete implementare queste modifiche:

    1. Modificare `FunzioneVettorialeBase` in modo che `Eval` usi `std::array`;
    2. Modificare `EqDiff` in modo che `Passo` usi `std::array`;
    3. Modificare `vector_operations.hpp` perché le funzioni usino `std::array`, togliendo i controlli sulla dimensione.

# `FunzioneVettorialeBase`

```c++
template <size_t N>   // Do *not* use «typename» here: it's a *value*, not a type
struct FunzioneVettorialeBase {
  // Note that we specify N both in the parameter `x` and in the return type.
  // This ensures that the dimension is the same for both
  virtual array<double N> Eval(const array<double N> &x) = 0;
};

struct OscillatoreArmonico : FunzioneVettorialeBase<2> {
  array<double, 2> Eval(const array<double, 2> &x) override {
    // If you use the flag -std=c++17 or -std=c++20, you can just write
    // return array{x[1], -x[0]};
    return array<double, 2>{x[1], -x[0]};
  }
};
```

# `EqDiff`

```c++
// Generica equazione differenziale a N dimensioni
template <std::size_t N> struct EqDiff {
  virtual array<double, N> Passo(double t, const array<double, N> &x, double h,
                                 FunzioneVettorialeBase<N> &fn) = 0;
};

// Generico solutore di Eulero a N dimensioni
template <std::size_t N> struct Eulero : public EqDiff<N> {
  array<double, N> Passo(double t, const array<double, N> &x, double h,
                         FunzioneVettorialeBase<N> &fn) override {
    array<double, N> result;
    // ...
    return result;
  }
};
```

# `vector_operations.hpp`

```c++
template <typename T, size_t N>
std::array<T, N> operator+(const std::array<T, N> &a, const std::array<T, N> &b) {
  std::array<T, N> result;

  // No check on the size of `a` and `b`, as they are guaranteed to be both N
  
  for (int i{}; i < N; i++)  // We could have used a.size() instead of N
    result[i] = a[i] + b[i];
    
  return result;
}

// Same for the other functions
```

# Vantaggi di `std::array`

La classe `std::array` risolve tutti i problemi di `std::vector`:

Velocità
: il codice è 5 volte più veloce

Controlli
: le dimensioni sono controllate in fase di compilazione

Leggibilità
: le dimensioni diventano esplicite


# Velocità

-   Se si riscrive la classe `FunzioneVettorialeBase` usando `std::array`, con GCC 12 il codice è circa 5 volte più veloce nel risolvere l'equazione del pendolo (esercizio 9.1).

-   Questo è possibile perché le variabili usate nel calcolo non sono allocate usando `new`, ma nello *stack* (un tipo di memoria molto più rapida della memoria *heap*, che è il tipo usato da `new`).

# Controlli

-   In `vector_operations.hpp` non è più necessario controllare la dimensione dei vettori e segnalare errori con `assert` o `throw`.

-   Il codice diventa infatti il seguente:

    ```c++
    template <typename T, size_t N>
    std::array<T, N> operator+(const std::array<T, N> &a, const std::array<T, N> &b) {
      std::array<T, N> result;
      for (int i{}; i < N; i++)
        result[i] = a[i] + b[i];
      return result
    }
    ```

    Notate che tutti gli array sono dichiarati come `std::array<T, N>`: il fatto che `N` sia la stessa ovunque obbliga il compilatore a verificare che sia così.
    
# Controlli

-   Se combino due array con lunghezza diversa

    ```c++
    std::array x{1.0, 2.0};      // An array with 2 elements
    std::array y{3.0, 4.0, 5.0}; // An array with 3 elements
    std::array z{x + y};         // Gosh, what's going to happen?
    ```
    
    il compilatore `g++` produce un errore di compilazione:

    ```
    test_arr.cpp:64:13: error: no match for ‘operator+’ (operand types are ‘std::array<double, 2>’ and ‘std::array<double, 3>’)
       64 |   array z{x + y};
          |           ~ ^ ~
          |           |   |
          |           |   array<[...],3>
          |           array<[...],2>
    ```
    
-   Nel caso di `std::vector`, il codice compilerebbe ma andrebbe poi in crash quando eseguito (a patto che mi sia ricordato di implementare tutti i controlli)

# Leggibilità

-   Con tutte le dimensioni esplicitate, il codice diventa più leggibile

-   Ad esempio, nel derivare la classe `OscillatoreArmonico` bisogna specificare `<2>` per `FunzioneVettorialeBase`:
    
    ```c++
    struct OscillatoreArmonico : FunzioneVettorialeBase<2> {
      // ...
    };
    ```
    
-   Similmente, nel `main` dell'esercizio 9.1 definirei l'istanza della classe `Eulero` così:

    ```c++
    Eulero<2> myEuler;  // I am going to apply Euler's method to a 2D problem
    ```

# Seminario di fine semestre

# Seminario su C++, Python e Julia

-   Negli scorsi anni ho proposto un seminario di approfondimento su C++, Assembler, Python e Julia, una volta terminata la sessione di esami di Febbraio.

-   Nel seminario spiego le differenze tra di loro, mostro come sono progettati i rispettivi compilatori, e do indicazioni su come scegliere lo strumento di lavoro migliore.

-   Se siete interessati, compilate il Google Form all'indirizzo <https://forms.gle/99kR6ZADstXEJZZaA>: alla fine del semestre contatterò chi l'ha compilato per decidere la data migliore per tutti.
