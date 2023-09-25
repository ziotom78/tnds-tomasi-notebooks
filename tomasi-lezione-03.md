---
title: Laboratorio di TNDS -- Lezione 3
author: Maurizio Tomasi
date: Martedì 10 Ottobre 2023
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
      Vettore<int> v{2};
      assert(v.GetN() == 2);
  
      v.SetComponent(0, 123);  // Test both SetComponent and operator[]=
      v[1] = 456;

      assert(v.GetComponent(0) == 123);
      assert(v.GetComponent(1) == 456);
  
      v.Scambia(0, 1);

      assert(v.GetComponent(0) == 456);
      assert(v[1] == 123);
  }
}
```

# Test per esercizio 3.1

Questo è il test per l'esercizio 3.1, che usa `std::vector`; adattatelo poi per l'esercizio 3.2.

```c++
bool are_close(double calculated, double expected, double epsilon = 1e-7) {
  return fabs(calculated - expected) < epsilon;
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
}
```


# ROOT

-   Nell'esercizio 3.2 è richiesto l'uso di ROOT, una libreria di funzioni per generare grafici.

-   Chi usa Repl.it o le macchine del laboratorio, dovrebbe averlo già installato.

-   Chi usa il proprio computer… Auguri! Sotto Linux e Mac dovrebbe essere relativamente facile installarlo, sotto Windows la cosa è più complessa.


# Avvertenza per utenti VSCode

# Avvertenza per utenti VSCode

-   Nella scorsa lezione, alcune persone che usavano VS Code hanno avuto problemi con il file system.

-   Il problema è che di default VS Code richiede 5 GB di spazio su disco per ottimizzare i suggerimenti di completamento della sintassi (vedi [discussione](https://github.com/microsoft/vscode-cpptools/issues/3347)).

-   È possibile disabilitare la cache o ridurla a un valore ragionevole modificando nelle impostazioni di VS Code la voce *Intellisense cache size* (vedi video seguente).

---

<iframe src="https://player.vimeo.com/video/630209637?h=fcc3022dd1&amp;badge=0&amp;autopause=0&amp;player_id=0&amp;app_id=58479" width="854" height="642" frameborder="0" allow="autoplay; fullscreen; picture-in-picture" allowfullscreen title="How to reduce the size of Intellisense cache"></iframe>


# `cout` e `cerr` {#cout-e-cerr}

# Scrittura a video

-   Quando si scrive a video, si può scegliere se usare `cout` o `cerr`.

-   Le regole da seguire **sempre** sono le seguenti:

    -   Usare `cerr` per scrivere messaggi.
    
    -   Usare `cout` per scrivere il risultato di conti.

-   La differenza è che quanto viene scritto su `cerr` finisce sempre sullo schermo, anche se da linea di comando si usano gli operatori di reindirizzamento `>` e `|`.

-   Ci sono anche altre differenze; vi basti sapere che per stampare un [*progress indicator*](https://en.wikipedia.org/wiki/Progress_indicator) sul terminale è sempre meglio usare `cerr`.


# Esempio di uso di `cout` e `cerr`

```c++
int main(void) {
    std::cerr << "1. Leggo i dati da file...\n";

    // ...

    std::cerr << "2. Stampo a video i risultati:\n";
    for (int i = 0; i < num; ++i) {
        std::cout << result[i] << "\n";
    }

    std::cerr << "3. Programma completato\n";
}
```

# Esempio di uso di `cout` e `cerr`

Con l'esempio seguente, è possibile usare il reindirizzamento:

<asciinema-player src="asciinema/cerr-cout-65×21.cast" cols="65" rows="21" font-size="medium"></asciinema-player>

# Esempio di uso di `cout` e `cerr`

-   Se non avessimo usato la distinzione tra `cout` e `cerr` ma avessimo scritto tutto su `cout`, comandi come `sort` avrebbero mescolato risultati e messaggi:

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

# Uso di `assert` e di `cerr`

-   Di solito gli studenti sono abbastanza confusi dal seguente codice:

    ```c++
    double Vettore::GetComponent(unsigned int i) const {
      // assert((m_N > 1) && "Errore: l'indice è troppo grande");
      if (i < m_N) {
          return m_v[i];
      } else {
          cerr << "Errore: indice" << i << ", dimensione " << m_N << endl;
          exit(-1);
      }
    }
    ```

-   Quando è meglio usare `assert`, e quando è meglio invece un messaggio di errore?

# Tipi di errore

-   Esistono due tipi di errori in un programma:

    1.  Errori del **programmatore**, che ha sbagliato a scrivere il codice;
    2.  Errori dell'**utente**, che ha invocato il programma in modo scorretto.
    
-   È importante gestire i due casi in modo diverso, perché l'azione più appropriata dipende dal contesto.

# Errore del programmatore

-   Questo codice ha un errore molto comune:

    ```c++
    // The `<=` is wrong! It should be `i < v.size()`
    for(size_t i = 0; i <= v.size(); ++i) {
        v.setComponent(i, 0.0);
    }
    ```
    
    Il fatto di leggere oltre la fine dell'array è un errore imputabile a chi ha scritto il programma, non a chi lo usa.

-   In questo caso `assert` è la soluzione migliore, perché dice al programmatore dove si trova la linea di codice da correggere ([se si compila con `-g`](https://ziotom78.github.io/tnds-tomasi-notebooks/tomasi-lezione-01.html#/flag-del-compilatore)).

---

```
$ ./myprog
vettore.hpp:34:void Vettore::setComponent(size_t pos, double value):
   Assertion `pos < n_N` failed
Aborted (core dumped)
$ catchsegv ./myprog | c++filt
…
… (lots of output)
…
Backtrace:
/home/unimi/maurizio.tomasi/vettore.hpp:34(void Vettore::setComponent(size_t pos, double value))[0x40075f]
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
void Vettore::setComponent(size_t i, double value) {
    assert(i < size());
    m_v[i] = value;
}

int main() {
    size_t position;
    Vettore v(10);
    
    cerr << "Inserisci la posizione del vettore: ";
    cin >> position;
    if (position >= v.size()) {
        cerr << "Errore, la posizione deve essere < " << v.size() << endl;
        exit(1);
    }
    v.setComponent(position, 1.0);
}
```

Di conseguenza, il programmatore è «costretto» a verificare la correttezza del numero passato dall'utente nel `main` prima di invocare `v.setComponent`.


# *Uniform initialization*

# Inizializzazione di variabili

-   Le pagine web su `labmaster` usano la sintassi tradizionale C++ per dichiarare e inizializzare variabili:

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

-   La sintassi può essere usata anche per invocare costruttori di classi (che vedremo a partire da questa lezione):

    ```c++
    Vettore v{};   // Costruttore senza parametri
    Vettore w{10};
    ```

-   Questi vantaggi sono evidenti solo se ci si abitua ad usare la *uniform initialization* ovunque. Abituatevi quindi da subito!

# «Most vexing parse»

-   Il fatto che la *uniform initialization* possa essere usata anche per invocare i costruttori previene il problema del cosiddetto [*most vexing parse*](https://en.wikipedia.org/wiki/Most_vexing_parse):

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


# `int` e `unsigned int`

# Interi con e senza segno

-   In C++ esistono gli interi con segno (`char`, `short`, `int`,
    `long`, `long long`) e quelli senza segno (in cui si mette
    `unsigned` davanti al tipo).

-   Ovviamente la differenza sta nel fatto che gli interi con segno
    (`int`) ammettono anche numeri negativi:
    
    | Tipo       | Minimo      | Massimo    |
    |:-----------|------------:|-----------:|
    | `int`      | −2147483648 | 2147483647 |
    | `unsigned` |           0 | 4294967295 |

-   Vediamo alcune differenze.


# Cicli `for` su array

-   La classe `std::vector` (esercizio 3.1) restituisce la dimensione degli array come un intero senza segno di tipo `size_t`: un vettore non può avere un numero negativo di elementi!
-   Questo codice fornisce un *warning* ([se usate
    `-Wall --pedantic`](https://ziotom78.github.io/tnds-tomasi-notebooks/tomasi-lezione-01.html#/flag-del-compilatore)):

    ```c++
    std::vector<double> v(…);

    for(int i{}; i < v.size(); ++i) {  // What happens if v.size() is 3 billions?
        v[i] = 0.0;
    }
    ```

    perché nella condizione `i < v.size()` si confronta un intero con
    segno (`i`) e uno senza segno (`v.size()`).

# Cicli `for` su array

-   Per togliere il warning è sufficiente dichiarare `i` di tipo `size_t`:

    ```c++
    std::vector<double> v(3);

    for(size_t i{}; i < v.size(); ++i) {  // No more warnings
        v[i] = 0.0;
    }
    ```

-   In linguaggi più rigorosi del C++ (es., Ada) confrontare tipi con e senza segno è un *errore* anziché un warning. Prendete quindi sul serio questi warning!

# Cicli a ritroso

-   Attenzione ai cicli a ritroso, in cui si parte dall'ultimo elemento e si torna indietro al primo! Questo codice **non funziona**:

    ```c++
    for(size_t i{v.size() - 1}; i >= 0; --i) {
        // Do stuff
    } // This loop never ends
    ```

-   Il modo giusto per scrivere il ciclo è il seguente:

    ```c++
    for(size_t i{v.size() - 1};; --i) {
        // Do stuff

        // If we have reached the last iteration, stop here
        if (i == 0) break;
    }
    ```

# Perché usare `unsigned`?

- Tutti questi problemi verrebbero risolti se si definisse `size_t` un intero **con segno**.

- Alcuni membri del comitato di standardizzazione del C++ hanno dichiarato che il restituire la dimensione degli array come valori *unsigned* è stato uno dei peggiori errori che potessero fare.

- Il nuovo standard C++23 (che sarà rilasciato l'anno prossimo) introduce `ssize_t`, che è come `size_t` ma ha il segno.

- Linguaggi più moderni, come [Nim](https://nim-lang.org/) e [Julia](https://julialang.org/), usano sempre interi con segno per iterare sugli array.

# Cicli `for` e `while`

# `for`, `while`, `do … while`

-   Non sempre i cicli `for` sono la cosa migliore da usare. Ci sono anche `while` e `do … while`

-   Non è immediato capire quale sia meglio:

    -   Il `for` itera finché una condizione non viene verificata alla **fine** di ogni loop
    -   Il `while` itera finché una condizione non viene verificata all'**inizio** di ogni loop
    -   Il `do … while` itera finché una condizione non viene verificata alla **fine** di ogni loop


# Il ciclo `while(true)`

-   Vi insegno un trucco per decidere quale usare: usate `while(true)`!

    ```c++
    while(true) {
        if (some condition 1) break;   // *1*
        // … do stuff …
        if (some condition 2) break;   // *2*
        // … do other stuff …
        if (some condition 3) break;   // *3*
    }
    ```

-   Se vi serve solo `*1*`, potete usare `while(some condition 1)`.
-   Se vi serve solo `*3*`, potete usare `do … while(some condition 3)` oppure `for`.
-   Nel caso `*2*`, lasciate `while(true)` con `if(…) break` in mezzo.


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
