# Esercizi per oggi

# Link alle risorse online

-   La spiegazione dettagliata degli esercizi si trova qui: [carminati-esercizi-03.html](carminati-esercizi-03.html).

-   Come al solito, queste slides, che forniscono suggerimenti addizionali rispetto alla lezione di teoria, sono disponibili all'indirizzo [ziotom78.github.io/tnds-tomasi-notebooks](https://ziotom78.github.io/tnds-tomasi-notebooks/).

# Esercizi

-   [Esercizio 3.0](carminati-esercizi-03.html#esercizio-3.0): Evoluzione della classe `Vettore` in una classe `template` (da consegnare)
-   [Esercizio 3.1](carminati-esercizi-03.html#esercizio-3.1): Codice di analisi dati utilizzando la classe `vector` (da consegnare)
-   [Esercizio 3.2](carminati-esercizi-03.html#esercizio-3.2): Analisi dati con `vector` e visualizzazione dei dati (da consegnare)


# Test con `assert`

# Test per esercizio 3.0

Dobbiamo verificare che la classe `Vettore` funzioni come atteso:

```c++
void test_vettore() {
  {  // New scope
      Vettore<char> v{};       // Default constructor, no elements
      assert(v.GetN() == 0);   // The vector must be empty
  }

  { // New scope: I can declare again a variable called `v`
      Vettore<int> v(2);
      assert(v.GetN() == 2);

      v.SetComponent(0, 123);  // Test both SetComponent and operator[]=
      v[1] = 456;

      assert(v.GetComponent(0) == 123);
      assert(v.GetComponent(1) == 456);

      v.Scambia(0, 1);

      assert(v.GetComponent(0) == 456);
      assert(v[1] == 123);
  }

  println(cerr, "Vettore works as expected! 🥳");
}
```

# Test per esercizio 3.1

Questo è il test per l'esercizio 3.1, che usa `std::vector`; adattatelo poi per l'esercizio 3.2.

```c++
[[nodiscard]] bool are_close(double calculated,
                             double expected,
                             double epsilon = 1e-7) {
  return fabs(calculated - expected) < epsilon * fabs(expected);
}

void test_statistical_functions(void) {
  {  // New scope
      std::vector<double> mydata{1, 2, 3, 4};  // Use these instead of data.dat

      assert(are_close(CalcolaMedia<double>(mydata), 2.5));
      assert(are_close(CalcolaVarianza<double>(mydata), 1.25));
      assert(are_close(CalcolaMediana<double>(mydata), 2.5));  // Even
  }

  { // New scope: I can declare again a variable named `mydata`
      std::vector<double> mydata{1, 2, 3};     // Shorter

      assert(are_close(CalcolaMediana<double>(mydata), 2));    // Odd
  }

  println(cerr, "Statistical functions work as expected! 🥳");
}
```


# ROOT

-   Nell'esercizio 3.2 è richiesto l'uso di ROOT.

-   Chi usa le macchine del laboratorio, dovrebbe averlo già installato.

-   Chi usa il proprio computer… Auguri! Sotto Linux e Mac dovrebbe essere relativamente facile installarlo, sotto Windows la cosa è più complessa.

-   Di tutti gli esercizi che farete questo semestre, solo il 3.2 richiede obbligatoriamente di usare ROOT. (Neppure i temi d'esami dello scritto hanno mai imposto, né imporranno, l'uso di ROOT).

-   Nelle prossime lezioni vi mostrerò una libreria per produrre plot ([Gplot++](https://github.com/ziotom78/gplotpp)), che è semplice da installare sia su Windows che Linux che Mac e che funziona bene con VSCode.

# Uso di `cerr` {#cerr}

# Scrittura a video

-   Quando si usa `std::print` o `std::println`, si può scegliere se scrivere su `cerr` o no.

-   Le regole da seguire **sempre** sono le seguenti:

    -   Usare `cerr` per scrivere messaggi a video.

    -   **Non** usare `cerr` per scrivere il risultato di conti.

-   Quanto scritto su `cerr` finisce sullo schermo anche se da linea di comando si usano gli operatori `>` e `|`.

-   Ci sono anche altre differenze; vi basti sapere che per stampare un [*progress indicator*](https://en.wikipedia.org/wiki/Progress_indicator) sul terminale è sempre meglio usare `cerr`.


# Esempio di uso di `cerr`

```c++
#include <iostream>  // `cerr` is defined here
#include <print>

int main(void) {
    std::println(cerr, "1. Leggo i dati da file...");

    // ...

    std::println(cerr, "2. Stampo a video i risultati:");
    for (int i = 0; i < num; ++i) {
        std::println("{}", result[i]);
    }

    std::println(cerr, "3. Programma completato");
}
```

# Esempio di uso di `cerr`

Con l'esempio seguente, è possibile usare il reindirizzamento:

<div id="cerr-cout-asciinema"></div>
<script>
AsciinemaPlayer.create(
    "asciinema/cerr-cout-65×21.cast",
    document.getElementById("cerr-cout-asciinema"), {
        cols: 65,
        rows: 21,
        fit: false,
        terminalFontSize: "medium"
    });
</script>

# Esempio di uso di `cerr`

-   Se non avessimo usato `cerr`, comandi come `sort` avrebbero mescolato risultati e messaggi:

    ```
    $ esempio | sort -g
    1.75123
    1. Leggo i dati da file...
    2.78534
    2. Stampo a video i risultati:
    3. Programma completato
    5.91573
    ```

-   In generale, stampate su `cerr` tutto ciò che bisogna mostrare all'utente *subito*, e non ha senso salvare in un file per essere eventualmente guardato dopo.

# Tipi di errore {#tipi-di-errore}

# Tipi di errore

-   Esistono due tipi di errori in un programma:

    1.  Errori del **programmatore**, che ha sbagliato a scrivere il codice: per correggerli, bisogna modificare il programma e ricompilare;
    2.  Errori dell'**utente**, che ha invocato il programma in modo scorretto: per correggerli, l'utente deve sistemare gli input.

-   È importante gestire i due casi in modo diverso, perché l'azione più appropriata dipende dal contesto.

# Errore del programmatore

-   Questo codice ha un errore molto comune:

    ```c++
    // The `<=` is wrong! It should be `i < ssize(v)`
    for(int i = 0; i <= ssize(v); ++i) {
        v.setComponent(i, 0.0);
    }
    ```

    Il fatto di leggere oltre la fine dell'array è un errore imputabile a chi ha scritto il programma, non a chi lo usa.

-   In questo caso `assert` è la soluzione migliore, perché dice al programmatore dove si trova la linea di codice da correggere ([se si compila con `-g3`](https://ziotom78.github.io/tnds-tomasi-notebooks/tomasi-lezione-01.html#/flag-del-compilatore)).

---

```
$ ./myprog
vettore.hpp:34:void Vettore::setComponent(int pos, double value):
   Assertion `pos < n_N` failed
Aborted (core dumped)
$ catchsegv ./myprog | c++filt
…
… (lots of output)
…
Backtrace:
/home/unimi/maurizio.tomasi/vettore.hpp:34(void Vettore::setComponent(int pos, double value))[0x40075f]
/home/unimi/maurizio.tomasi/vettore.hpp:79(void Vettore::set_array_to_zero())[0x40075f]
/home/unimi/maurizio.tomasi/test.cpp:15(main)[0x400796]
/lib64/libc.so.6(__libc_start_main+0xf3)[0x7fbb807d14a3]
??:?(_start)[0x40067e]
…
… (lots of output)
…
```

Queste informazioni sono inutili all'utente, ma molto preziose al programmatore!

# Errore dell'utente

-   Se l'errore è causato dall'utente, si dovrebbe stampare invece un messaggio d'errore chiaro, che gli consenta di riparare all'errore.

-   Primo esempio:

    ```
    $ ./myprog
    Inserisci il numero di iterazioni da compiere: -7
    Errore, il numero di iterazioni deve essere un numero positivo
    $
    ```

-   Secondo esempio:

    ```
    $ ./myprog data.dat
    Errore, non riesco ad aprire il file "data.dat"
    $
    ```

# Distinguere tra i due tipi

-   Non è sempre immediato distinguere tra i due tipi di errore.

-   Ad esempio, come facciamo a sapere se nella funzione `Vettore::setComponent` un indice fuori dall'intervallo stabilito è colpa del programmatore o dell'utente?

-   È sempre bene documentare che tipo di parametri vuole una funzione, e usare `assert`: in questo modo se si passano parametri sbagliati, la colpa è per forza del programmatore!

-   Gli errori diretti all'utente andrebbero stampati solo nel `main` o in pochi altri posti; *mai* in funzioni di basso livello, che potrebbero essere invocate all'interno di un'interfaccia grafica anziché da terminale.

---

In questo esempio, la documentazione di `setComponent` dice quali sono i valori accettabili per `i`, quindi se il parametro è sbagliato la colpa è di chi lo invoca.

```c++
// Set the value of an element in the array
//
// The index `i` *must* be in the range 0…size()-1
void Vettore::setComponent(int i, double value) {
    assert(i < size());
    m_v[i] = value;
}

int main() {
    int position;
    Vettore v(10);

    println(cerr, "Inserisci la posizione del vettore: ");
    cin >> position;
    if (position >= ssize(v)) {
        println(cerr, "Errore, la posizione deve essere < {}", ssize(v));
        exit(1);
    }
    v.setComponent(position, 1.0);
}
```

Di conseguenza, il programmatore è «costretto» a verificare la correttezza del numero passato dall'utente nel `main` prima di invocare `v.setComponent`.


# *Uniform initialization*

# Inizializzazione di variabili

-   Storicamente, il C++ ha permesso da sempre di dichiarare e contemporaneamente inizializzare le variabili usando `=` e le parentesi `()` per i costruttori:

    ```c++
    // Dichiara "ndata" e la inizializza
    int ndata = stoi(argv[1]);

    Vettore v(10);

    Vettore w = v;
    ```

-   Questa sintassi è stata mutuata dal linguaggio C, ma ne esiste una più recente e più sicura.


# Uniform initialization

-   Il C++11 implementa la *uniform initialization*, che si usa impiegando le parentesi graffe `{}` anziché l'uguale `=` e le parentesi tonde `()`:

    ```c++
    int a{};     // Same as   int a = 0;
    int b{10};   // Same as   int b = 10;
    ```

-   Analogamente, nei cicli `for` si può scrivere così:

    ```c++
    for(int k{0}; k < 10; ++k) {
        // Writing k{} would be the same, as the default value is 0
    }
    ```


# Vantaggi (1/2)

-   Inizializza una variabile al valore di default con `{}`:

    ```c++
    int a{};            // Same as: int a = 0;
    float b{};          // Same as: float b = 0.0;
    std::string s{};    // Same as: std::string s = "";
    ```

-   Sono vietate le conversioni di tipo, spesso fonti di errori:

    ```c++
    const double pi = 3.1415926535897932384626433;
    // Allowed, but probably wrong
    int a = pi;
    // The compiler prints an error message
    int c{pi};
    ```

# Vantaggi (2/2)

-   È possibile inizializzare array dinamici usando una sola riga:

    ```c++
    double * data{new double[]{ 1.0, 2.0, 3.0 }};
    ```

-   La sintassi può essere usata anche per invocare costruttori di classi (che abbiamo già visto nella lezione precedente):

    ```c++
    Vettore v{};   // Costruttore senza parametri
    Vettore w{10};
    ```

-   Questi vantaggi sono evidenti solo se ci si abitua ad usare la *uniform initialization* ovunque. Abituatevi quindi da subito!

# «Most vexing parse»

-   La *uniform initialization* previene il problema del [*most vexing parse*](https://en.wikipedia.org/wiki/Most_vexing_parse):

    ```c++
    // I want to invoke a constructor that has no parameters
    Vettore v();         // The compiler prints an error here!
    ```

-   Usando le parentesi graffe il problema sparisce, e c'è anche simmetria con l'inizializzazione di tipi base del C++:

    ```c++
    Vettore v{}; // Default constructor
    int a{};     // Same
    ```

-   Questo è **uno dei più comuni errori degli studenti di TNDS**.



# Esempio di vita vera (1/2)

-   In uno degli esercizi che faremo nelle prossime settimane, il codice richiedeva da linea di comando i valori $a$ e $b$ degli estremi di un intervallo $[a, b]$, nonché la precisione $\varepsilon$ richiesta per un calcolo.

-   Uno studente aveva implementato il codice nel `main` così:

    ```c++
    double a = stoi(argv[1]);
    double b = stoi(argv[2]);
    double prec = stod(argv[3]);
    ```

    non accorgendosi di aver usato `atoi` (che restituisce un *intero*) anziché `atod`.

# Esempio di vita vera (2/2)

-   Il programma quindi andava in crash quando lo si invocava con la linea `./esercizio 0.1 0.2`, perché sia `0.1` che `0.2` erano arrotondati a `0` e l'intervallo aveva quindi ampiezza nulla!

-   Se lo studente avesse usato la *uniform initialization* in questo modo:

    ```c++
    double a{stoi(argv[1])};
    double b{stoi(argv[2])};
    double prec{stod(argv[3])};
    ```

    il compilatore avrebbe segnalato che nelle prime due righe c'era un errore, perché `atoi` restituisce un intero ma sia `a` che `b` devono essere `double`!


# `int` e `unsigned int`

# Interi con e senza segno

-   In C++ esistono gli interi con segno (`char`, `short`, `int`, `long`, `long long`) e quelli senza segno (in cui si mette `unsigned` davanti al tipo).

-   Ovviamente la differenza sta nel fatto che gli interi con segno (`int`) ammettono anche numeri negativi:

    | Tipo       | Minimo      | Massimo    |
    |:-----------|------------:|-----------:|
    | `int`      | −2147483648 | 2147483647 |
    | `unsigned` |           0 | 4294967295 |

# `int` e `unsigned int`

-   Usando interi con segno, molti algoritmi diventano più semplici.

-   Citazione da [Google Coding Guidelines](https://google.github.io/styleguide/cppguide.html#Integer_Types):

    > You should not use the unsigned integer types […], unless there is a valid reason such as representing a bit pattern rather than a number, or you need defined overflow modulo 2^N. In particular, do not use unsigned types to say a number will never be negative. Instead, use assertions for this.

-   Anche il creatore del C++ ([Bjarne Stroustrup](https://en.wikipedia.org/wiki/Bjarne_Stroustrup)) [è d’accordo](https://youtu.be/pnaZ0x9Mmm0&t=209). Preferite quindi sempre `int` a `unsigned`!


# Cicli `for` su array

-   La classe `std::vector` (esercizio 3.1) implementa un metodo `.size()` che restituisce la dimensione degli array come un intero **senza segno** di tipo `int`.

-   L'uso di `unsigned` per le dimensione degli array produce però più problemi di quanti ne risolva! Per questo motivo, linguaggi più moderni scoraggiano l'uso di `unsigned` (Kotlin 2.0, Nim, Julia…), quando addirittura non lo vietano (Kotlin 1.0).

-   In giro per Internet ci sono ancora moltissimi esempi di codice che usano `vector::size()`.

# Il C++20 {#ssize-cpp}

-   Fortunatamente, dal C++20 è disponibile la funzione `ssize()`, che funziona su vettori e altri tipi della STL e restituisce sempre un `int`:

    ```c++
    std::vector<double> v(3);

    // Nota: ssize(v) anziché v.size() perché `ssize` è una FUNZIONE e non un METODO
    for(int i{}; i < ssize(v); ++i) {
        v[i] = 0.0;
    }
    ```

-   Di conseguenza, in questo corso non usate **mai** numeri `unsigned` per iterare sugli elementi dei vettori. Usate sempre `int` e la funzione `ssize()`! (Ma ovviamente dovete [usare un compilatore recente](tomasi-lezione-01.html#config-latest-gcc)…)

# Approfondimento

-   Ho scritto tempo fa un articolo (in inglese) sull’uso di `unsigned int`: <https://ziotom78.github.io/c++/2025/02/02/unsigned-and-c++.html>

-   L’articolo mostra alcuni esempi pratici in cui l’uso di tipi senza segno rende il codice più complicato

# Iteratori nella STL

# Funzioni nella STL

-   La classe `std::vector` è un tipo di *container*, ossia un «contenitore» di altri oggetti.

-   Oltre alla classe `std::vector`, la libreria standard C++ fornisce una serie di funzioni come [`sort`](https://www.cplusplus.com/reference/algorithm/sort/?kw=sort), [`find_first_of`](https://www.cplusplus.com/reference/algorithm/find_first_of/) e [`min`](https://www.cplusplus.com/reference/algorithm/min/) che possono operare su un vettore o un altro tipo di *container* (es., [`std::array`](https://www.cplusplus.com/reference/array/array/), [`std::list`](https://www.cplusplus.com/reference/list/list/), [`std::stack`](https://www.cplusplus.com/reference/stack/stack/), [`std::set`](https://www.cplusplus.com/reference/set/set/), etc.)

-   In tutti questi casi, non si deve passare alla funzione la variabile di tipo `std::vector`, ma una coppia di **iteratori**.

# Iteratori

-   Gli iteratori si trovano sempre in coppia, e rappresentano un'intervallo di elementi consecutivi. Se il primo elemento è $x$ e l'elemento dopo l'ultimo è $y$, la coppia di iteratori $x, y$ corrisponde all'intervallo

    $$
    [x, \ldots, y)
    $$

-   Il primo elemento di un `std::vector` si ottiene mediante il metodo [`std::vector::begin()`](https://www.cplusplus.com/reference/vector/vector/begin/), che restituisce un *iteratore* (per ottenere il primo elemento, usare [`std::vector::front()`](https://www.cplusplus.com/reference/vector/vector/front/)).

-   Per l'ultimo elemento si usa [`std::vector::end()`](https://www.cplusplus.com/reference/vector/vector/end/) (*iteratore*) e [`std::vector::back()`](https://www.cplusplus.com/reference/vector/vector/back/) (l'elemento stesso).


---
title: Laboratorio di TNDS -- Lezione 3
author: Maurizio Tomasi ([`maurizio.tomasi@unimi.it`](mailto:maurizio.tomasi@unimi.it))
date: Martedì 7 ottobre 2025
theme: white
progress: true
slideNumber: true
background-image: ./media/background.png
history: true
width: 1440
height: 810
css:
- ./css/custom.css
- ./css/asciinema-player.css
...
