# Alcuni problemi di `std::vector`

# `std::vector`

-   Finora abbiamo sempre usato `std::vector` per memorizzare sequenze di valori

-   Gli esercizi sulle equazioni differenziali proposti da Carminati non fanno eccezione:

    ```c++
    struct FunzioneVettorialeBase {
      virtual vector<double> Eval(const vector<double> &x) const = 0;
    };

    struct OscillatoreArmonico : FunzioneVettorialeBase {
      vector<double> Eval(const vector<double> &x) const override {
        return vector<double>{x[1], -x[0]};
      }
    };
    ```

-   L'uso di `std::vector` ha però una serie di svantaggi in questo contesto.

# Svantaggio #1: velocità

-   Creare un nuovo oggetto `std::vector` è un'operazione **lenta**! Internamente `std::vector` crea un puntatore a un array:

    ```c++
    template <typename T>
    class vector {
      T * m_data;
      size_t m_size;
    public:
      vector(size_t size) : m_size{size} { m_data = new T[m_size]; }
      ~vector() { delete[] m_data; }
      size_t size() const { return m_size; }
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

      assert(a.size() == b.size());  // Don't forget to do this!

      // ...
    }
    ```

-   Dimenticarsi un `assert` da qualche parte nel codice potrebbe avere conseguenze disastrose (soprattutto durante l'esame!)

# Svantaggio #3: leggibilità

-   Siccome `std::vector` può contenere un numero variabile di elementi, è difficile capire su quante dimensioni lavori una classe derivata da `FunzioneVettorialeBase`:

    ```c++
    struct FunzioneVettorialeBase {
      virtual vector<double> Eval(const vector<double> &x) = 0;
    };

    struct OscillatoreArmonico : FunzioneVettorialeBase {
      vector<double> Eval(const vector<double> &x) override {
        // Lo spazio delle fasi è a 2 dimensioni, ma questo è chiaro solo
        // se si contano gli elementi del vettore restituito!
        return vector<double>{x[1], -x[0]};
      }
    };
    ```

# Uso di `std::array`

# La classe `std::array`

-   La libreria standard offre una classe perfetta per gli esercizi di oggi: `std::array`.

-   Essa è equivalente ad un array con un numero **fissato** di elementi, che vengono controllati in fase di compilazione.

-   Gli array sono allocati nella memoria *stack*, che è velocissima da usare ma limitata. Dovrebbero essere usati solo se il numero di elementi **non supera qualche decina**.


# Esempio di implementazione

-   Un'implementazione semplificata di `std::array` è la seguente, che **non** usa `new`:

    ```c++
    template <typename T, size_t N>      // I template C++ possono essere usati per tipi
    class array {                        // come `double` e valori come `size_t`
      T m_data[N];                       // Non è un puntatore, ma un array di dimensione nota
    public:
      size_t size() const { return N; }  // Ritorna il valore costante N
      // ...
    };
    ```

-   Se il valore `N` è ridotto a pochi elementi (due o tre), il compilatore può addirittura decidere di evitare di usare lo *stack* ed impiega invece i *registri* (che è il tipo di memoria usabile dalla CPU più veloce in assoluto)

---

-   Finora abbiamo sempre visto `typename T` nei template, dicendo che il tipo (`double`, `float`, `int`…) deve essere fornito quando si *istanzia* il template:

    ```c++
    template <typename T> class Vettore { T * arr; /* ... */ };

    Vettore<double> v;  // Vettore di double
    Vettore<int> w;     // Vettore di interi
    ```

-   Usare `size_t N` indica che nella definizione di `std::array`, il valore numerico di `N` è un intero senza segno da fornire quando si istanzia il template:

    ```c++
    template <size_t N> class Array { double arr[N]; /* ... */ };

    Array<3> v;  // Array di 3 elementi
    Array<4> w;  // Array di 4 elementi
    ```

# Uso di `std::array`

-   Quando si istanzia `std::array`, bisogna specificare anche la dimensione:

    ```c++
    std::vector<double> v(2);  // The size is 2, but it can change later
    std::array<double, 2> a;   // The size is 2 and *cannot* change

    v[0] = 0.5; v.at(1) = 1.0;    // Both std::vector and std::array can be
    a[0] = 0.7; a.at(1) = 2.0;    // accessed using [] or .at()

    v.push_back(3.14159);  // Ok, the array will grow
    a.push_back(2.71828);  // ERROR, you cannot use push_back with an array
    ```

-   Si può inizializzare un array in maniera immediata:

    ```c++
    std::array<double, 4> a{1.0, 2.0, 3.0, 4.0};  // Ok, but if you use -std=c++23…
    std::array a{1.0, 2.0, 3.0, 4.0};             // …"double" and "4" are redundant!
    ```

# Uso negli esercizi

-   L'anno scorso ho proposto agli alunni più volonterosi di usare `std::array`, per questi motivi:

    1.  Il codice è circa 10 volte più veloce, e questo è importante soprattutto se si devono fare Monte Carlo di problemi con equazioni differenziali;

    2.  In sede di esame vediamo a volte errori di dimensionalità, che `std::array` previene;

    3.  Non è necessario implementare controlli sulla dimensione degli array, perché ci pensa il compilatore.

-   Questo è il primo anno in cui ho aggiornato la pagina [carminati-esercizi-08.html](carminati-esercizi-08.html) perché usi `std::array`!


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

-   Nel caso di `std::vector`, il codice compilerebbe ma andrebbe poi in crash.

# Leggibilità

-   Con tutte le dimensioni esplicitate, il codice diventa più leggibile

-   Ad esempio, nel derivare la classe `OscillatoreArmonico` dell'[esercizio 8.1](carminati-esercizi-08.html#esercizio-8.1) bisogna specificare `<2>` per `FunzioneVettorialeBase`:

    ```c++
    struct OscillatoreArmonico : FunzioneVettorialeBase<2> {
      // ...
    };
    ```

-   Similmente, nel `main` dello stesso si definisce l'istanza di `Eulero` così:

    ```c++
    Eulero<2> myEuler;  // Metodo di Eulero per un'equazione di secondo grado
    ```

# Seminario di fine semestre

# Seminario su C++, Python e Julia

-   Negli scorsi anni ho proposto un seminario di approfondimento su C++, Assembler, Python e Julia, una volta terminata la sessione di esami di Febbraio.

-   Nel seminario spiego le differenze tra di loro, mostro come sono progettati i rispettivi compilatori, e do indicazioni su come scegliere lo strumento di lavoro migliore.

-   Se siete interessati, compilate il Google Form all'indirizzo <https://forms.gle/ZaDv5n6PjDEaNRoT8>: alla fine del semestre contatterò chi l'ha compilato per decidere la data migliore per tutti.

---
title: "Laboratorio di TNDS -- Lezione 8"
author: "Maurizio Tomasi"
date: "Martedì 14 Novembre 2023"
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
