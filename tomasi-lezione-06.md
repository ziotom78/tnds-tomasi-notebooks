# Link alle risorse online

-   La spiegazione dettagliata degli esercizi si trova qui: [carminati-esercizi-06.html](carminati-esercizi-06.html).

-   Come al solito, queste slides, che forniscono suggerimenti addizionali rispetto alla lezione di teoria, sono disponibili all'indirizzo [ziotom78.github.io/tnds-tomasi-notebooks](https://ziotom78.github.io/tnds-tomasi-notebooks/).


# Esercizi per oggi

-   [Esercizio 6.0](./carminati-esercizi-06.html#esercizio-6.0): Metodi virtuali
-   [Esercizio 6.1](./carminati-esercizi-06.html#esercizio-6.1): Classe astratta `FunzioneBase`
-   [Esercizio 6.2](./carminati-esercizi-06.html#esercizio-6.2): Metodo della bisezione (**da consegnare**)
-   [Esercizio 6.3](./carminati-esercizi-06.html#esercizio-6.3): Equazioni non risolubili analiticamente (**da consegnare**)
-   [Esercizio 6.4](./carminati-esercizi-06.html#esercizio-6.4): Ricerca di zeri di una funzione senza uso del polimorfismo (facoltativo, ma **MOLTO IMPORTANTE**!)

# Metodi virtuali {#virtual-methods}

# Metodi virtuali

-   L'unico modo in cui il C++ implementa il polimorfismo durante l'esecuzione è attraverso i metodi `virtual`.

-   (I *template* permettono polimorfismo in fase di **compilazione**, e sono quindi usati in ambiti diversi).

-   Una classe derivata può ridefinire uno dei metodi della classe genitore se questo è indicato come `virtual`, usando la parola chiave [`override`](https://www.fluentcpp.com/2020/02/21/virtual-final-and-override-in-cpp/).

# Uso di metodi virtuali

```c++
#include <print>

struct Animal {
  // Dichiaro `greet` come un metodo che può essere sovrascritto
  virtual void greet() const { std::println("?"); }
};

struct Dog : public Animal {
  // Chiedo al C++ di sovrascrivere `greet` tramite `override`
  void greet() const override { std::println("Woof!"); }
};

struct Cat : public Animal {
  // Chiedo al C++ di sovrascrivere `greet` tramite `override`
  void greet() const override { std::println("Meow!"); }
};
```

# Funzionamento di virtual

```c++
#include <string>

int main(int argc, char *argv[]) {
  Animal *animal{}; // Qui abbiamo proprio bisogno di *

  // Legge il nome dell'animale dalla linea di comando
  std::string name{argc > 1 ? argv[1] : ""};
  if (name == "cat") {
    animal = new Cat();
  } else if (name == "dog") {
    animal = new Dog();
  }

  if (animal)
    animal->greet();
}
```

# Funzionamento di virtual

-   Nel `main`, la chiamata ad `animal->greet()` non permette di capire quale metodo `greet` verrà usato guardando solo il codice: la
scelta viene fatta a runtime, a seconda del valore di `argv`:

    ```text
    $ ./test cat
    Meow!
    $ ./test dog
    Woof!
    $ ./test bird
    $
    ```

-   Questo meccanismo si chiama *dynamic dispatch* (indirizzamento dinamico). Nel caso del C++ è un *dynamic* **single** *dispatch*, perché la chiamata viene decisa solo in funzione del tipo dell'oggetto puntato da `animal`. (Altri linguaggi come Julia usano tutti i tipi dei parametri della funzione, e sono quindi più versatili).


# `virtual` e `override` {#override-best-practices}

La parola `virtual` è obbligatoria solo all'interno della classe base:

```c++
struct Animal {
  virtual void greet() const { std::println("?"); }
};

struct Dog : public Animal {
  // I can repeat "virtual" here, but it's optional
  virtual void greet() const override { std::println("Woof!"); }
};

struct Cat : public Animal {
  // You usually avoid repeating "virtual", if there is "override"
  void greet() const override { std::println("Meow!"); }
};
```

# `virtual` e `override`

-   Per compatibilità con le vecchie versioni del C++, anche `override` può essere tralasciato:

    ```c++
    struct Dog : public Animal {
      // Ok, compila e funziona come atteso, ma NON FATELO!
      virtual void greet() const { std::println("Woof!"); }
    };

    struct Cat : public Animal {
      // Anche questo è ok e compila senza errori, ma NON FATELO!
      void greet() const { std::println("Meow!"); }
    };
    ```

-   Questo è comune in codici C++ particolarmente vecchi, ma oggigiorno è considerata una **pessima** pratica.


# Uso di puntatori

# Quando usare puntatori

-   Nell’[Esercizio 6.0](./carminati-esercizi-06.html#esercizio-6.0) di oggi si usano i puntatori nel seguente codice:

    ```c++
    Particella * p{new Particella{1., 2.}};
    Elettrone * b{new Elettrone{}};
    Particella * c{new Elettrone{}};
    ```

-   Si usano puntatori (o reference) quando avviene questo:

    1.   Si crea una variabile di un tipo base (`Particella`)…
    2.   …ma poi le si vuole assegnare una variabile di un tipo derivato (`Elettrone`), che **non è noto in fase di compilazione**.

# Quando usare puntatori

-   Usando un puntatore e `new`, si possono specificare i due tipi `Particella` ed `Elettrone` separatamente:

    ```c++
    //   Type 1            Type 2
       Particella * c{new Elettrone{}};
    ```

-   Senza puntatore, non ci sarebbe questa possibilità:

    ```c++
    Particella c{};  // How can I specify that I want "Elettrone"?
    ```

# Quando usare i puntatori

-   Se non ci si trova nella situazione descritta, è meglio evitare di usare i puntatori: il codice è più semplice da leggere, e non c'è possibilità di avere `segmentation fault` causati dall'accesso a puntatori nulli.

    ```c++
    // Far easier and safer!
    Particella a{1., 2.};
    Elettrone b{};
    Elettrone c{};
    ```

-   Notate che nel C++ moderno è **sempre** possibile evitare i puntatori e garantire il polimorfismo dell’esempio 6.1 usando i cosiddetti “[smart pointers](https://www.youtube.com/watch?v=e2LMAgoqY_k)” (vedi ad esempio [`make_unique`](https://en.cppreference.com/w/cpp/memory/unique_ptr/make_unique.html)), che mettono al riparo da crash e leak.

# Esercizio 6.2 (bisezione)

# Verifica dell'algoritmo

L'esercizio richiede di trovare gli zeri della funzione
$$
f(x) = 3x^2 + 5x - 2,
$$
che è un problema risolubile analiticamente:
$$
x_{1/2} = \frac{-5 \pm \sqrt{25 + 24}}6 = \begin{cases} -2,\\ \frac13.
\end{cases}
$$

# Verifica dell'algoritmo {#verifica-funzioni-ricerca-zeri}

```c++
// Note that this test is not optimal, because it does not verify that
// our zero is within the desired precision. How would you improve it?
void test_zeroes() {
  Bisezione s{};
  Parabola f{3, 5, -2}; // Zeroes for this function are known: x₁ = −2, x₂ = 1/3
  s.SetPrecisione(1e-8);

  assert(are_close(s.CercaZeri(-3.0, -1.0, f), -2.0)); // Zero is within (a, b)
  assert(are_close(s.CercaZeri(-2.0, 0.0, f), -2.0));  // Zero is at a
  assert(are_close(s.CercaZeri(-4.0, -2.0, f), -2.0)); // Zero is at b

  assert(are_close(s.CercaZeri(0.0, 1.0, f), 1.0 / 3)); // Do NOT write 1 / 3 !

  println(cerr, "Root finding works correctly! 🥳");
}
```

# Determinazione del segno

# Determinazione del segno

-   Nell'algoritmo di bisezione occorre verificare quando $f(a)$ e $f(b)$ sono di segno concorde.

-   La scrittura

    ```c++
    if (f(a) * f(b) < 0) { … }
    ```

    non è consigliabile, perché se `f(a)` o `f(b)` sono molto piccoli, il risultato potrebbe essere nullo. Meglio [usare una funzione `sign`](carminati-esercizi-06.html#la-funzione-segno)

    ```c++
    if (sign(f(a)) * sign(f(b)) < 0) { … }
    ```

# Gestione di errori {#gestione-errori}

# Condizioni d'errore

-   Il metodo di bisezione fallisce se le ipotesi del teorema degli zeri non valgono. Cosa fare in questo caso?

-   Ricordiamo che esistono [due tipi di errori](tomasi-lezione-03.html#tipi-di-errore):

    -   **Errori dell'utente**: è l'utente che ha sbagliato a usare il programma, e deve rimediare facendolo ripartire con gli input giusti;

    -   **Errori del programmatore**: è il programmatore che deve rimediare modificando il programma e ricompilandolo.

-   Oggi implementiamo due esercizi in cui il metodo di bisezione può fallire per colpa dell'utente ([esercizio 6.2](carminati-esercizi-06.html#esercizio-6.2)) o del programmatore ([esercizio 6.3](carminati-esercizi-06.html#esercizio-6.3)). Come facciamo?

# Condizioni di errore

```
$ ./esercizio-6.2 4 6
Errore, il teorema degli zeri non è valido nell'intervallo [4, 6]. Usa un altro intervallo

$ ./esercizio-6.3
fish: Job 1, './esercizio-6.3' terminated by signal SIGABRT (Abort)
```

(Se un programma termina invocando `abort()` ed è stato compilato con `-g3`, eseguendolo all'interno di [NND](debugging.html) o col debugger di [Geany](tomasi-lezione-05.html#geany) si può ispezionare il valore delle variabili al momento in cui è andato in crash: molto utile per correggere il bug!)

# Approcci possibili

1.   Scrivere un messaggio di errore e invocare `abort()`: bene se l'errore è del programmatore, male se l'errore è dell'utente! 😕

2.   Restituire un valore fissato (es., zero): molto ambiguo, come fa l'utente a sapere se la funzione si annulla veramente per $x = 0$ o se c'è stato un errore? 😕

3.   Accettare un parametro aggiuntivo `bool &found` (**reference**!) per `CercaZeri` 👍:

     ```c++
     double CercaZeri(double xmin, double xmax, const FunzioneBase * f, bool &found);
     ```

     (In alternativa si può dichiarare `found` variabile membro di `Solutore`).

# Segnalare l'errore

Con il terzo approccio è possibile differenziare il modo in cui gestiamo la condizione d’errore nel `main` dei due esercizi

```c++
// main() dell'esercizio 6.2 (errore dell'utente):

double xmin{stod(argv[1])}, xmax{stod(argv[2])};
bool found;
double x{bisezione.CercaZeri(xmin, xmax, f, found)};
if (! found) {
    println("Errore, il teorema degli zeri non è valido nell'intervallo "
            "[{}, {}]. Usa un altro intervallo", xmin, xmax);
    return 1;
}

// main() dell'esercizio 6.3 (errore dell'utente):

double xmin{ … };  // Formula matematica implementata dal programmatore;
double xmax{ … };  // Idem
bool found;
double x{bisezione.CercaZeri(xmin, xmax, f, found)};
if (! found) {
    abort();
}
```

# Uso di `std::expected` (1/5)

-   Con il C++23 è stato introdotto il tipo [`std::expected`](https://en.cppreference.com/w/cpp/utility/expected), che è stato mutuato da linguaggi come Rust e OCaml.

-   Il template `std::expected<T, U>` rappresenta il concetto “di solito questa variabile è del tipo `T`, ma se c'è un errore allora è del tipo `U`”:

    ```c++
    #include <expected>

    // If everything is ok, `val` is a `double`; if there is an error,
    // `val` is a string (presumably, an error message).
    std::expected<double, string> val;
    ```

# Uso di `std::expected` (2/5)

-   Una variabile `std::expected` può essere inizializzata usando un valore del **primo** tipo (`T`) senza bisogno di sintassi particolari:

    ```c++
    std::expected<double, string> val{3.5};  // Initialized with a double
    ```

-   Per inizializzarla al valore “erroneo”, bisogna usare la funzione `std::unexpected`:

    ```c++
    std::expected<double, string> val{std::unexpected("Errore!")};
    ```

# Uso di `std::expected` (3/5)

-   Nel `main()` è laborioso definire il tipo della variabile che riceve il risultato:

    ```c++
    std::expected<double, string> result{bisezione.CercaZeri(…)};
    ```

-   Il C++ fornisce (a partire dal C++11) la keyword `auto`, che dice al compilatore: “sai benissimo tu qual è il tipo di ritorno, quindi non farmelo specificare!”. Quindi possiamo scrivere:

    ```c++
    // Much easier!
    auto result{bisezione.CercaZeri(…)};
    ```

# Uso di `std::expected` (4/5)

-   Si controlla se la variabile è “giusta” o “sbagliata” col metodo `has_value()`:

    ```c++
    auto result{bisezione.CercaZeri(…)};
    if (result.has_value()) {
       // Everything is ok!
    } else {
       // ERROR!
    }
    ```

-   C'è anche la comoda scorciatoia di usare `result` come una variabile booleana:

    ```c++
    if (result) {
       // Everything is ok!
    }
    ```

# Uso di `std::expected` (5/5)

-   Il metodo `value()` estrae il valore giusto, il metodo `error()` il valore erroneo:

    ```c++
    if (result) {
       double true_value{result.value()};
       // …
    } else {
       println(cerr, "Error: {}", result.error());
    }
    ```

-   Invece di `value()` si può usare l'operatore di deferenziazione `*result`:

    ```c++
    double true_value{*result};
    ```

# `std::expected` nella bisezione

```c++
std::expected<double, string>  // Ideally we return a `double`, unless there are problems
Bisezione::CercaZeri(double xmin,
                     double xmax,
                     const FunzioneBase * f) {
    double signfa{sign(f->Eval(xmin))}, signfb{sign(f->Eval(xmax))};
    if(signfa == 0) return xmin;
    if(signfb == 0) return xmax;
    if(signfa * signfb > 0) {
        return std::unexpected(format("Invalid range [{}, {}]", xmin, xmax));
    }

    // ...
    return x;  // `x` is a boring `double`
}
```

# `std::expected` nel `main`

-   Nel `main` dell'[esercizio 6.2](carminati-esercizi-06.html#esercizio-6.2) stampiamo l'errore in maniera *user-frendly*:

    ```c++
    auto result{bisezione.CercaZeri(xmin, xmax, f)};
    if(! result) {
        println(cerr, "Error: {}", result.error());
        return 1;
    }
    double x{result.value()};
    ```
-   Nell'[esercizio 6.3](carminati-esercizi-06.html#esercizio-6.3) invece chiamiamo `abort()` (in `<cstdlib>`):

    ```c++
    auto result{bisezione.CercaZeri(xmin, xmax, f)};
    if(! result) { abort(); }
    double x{result.value()};
    ```

# Altro approccio

Potete sfruttare una caratteristica poco nota del C++: una classe che rappresenta il risultato… definita **nella classe `Bisezione`**!

```c++
class Solutore {
public:
  class Risultato {
  public:
    bool found{};     // `false` if some error occurred
    double value{};   // this is meaningful only if found==true
    // I could add other fields here, like `string error_message`,
    // or the precision of the result, or the extrema, or…
  };

  virtual Risultato CercaZeri(double xmin,
                              double xmax,
                              const FunzioneBase & f) = 0;
};
```

# Altro approccio

-   Nell’implementazione di `CercaZeri` potete scrivere

    ```c++
    double x; // Qui calcoleremo il risultato
    // ... Calcoliamo x
    return Risultato{true, x};
    ```

-   Nel `main` scriverete invece

    ```c++
    Solutore::Risultato ris{sol.CercaZeri(0.0, 2.0, fn)};
    ```

# Esercizio 6.4

-   Nell'[esercizio 6.4](carminati-esercizi-06.html#esercizio-6.4) si illustra un modo alternativo di implementare la bisezione, che *non* usa il polimorfismo.

-   Questo approccio è importante da imparare:

    #.  È applicabile al 99% dei casi della vita reale;
    #.  È usato in molte librerie di calcolo numerico moderne ([Armadillo](https://arma.sourceforge.net/), [Eigen](https://eigen.tuxfamily.org/index.php?title=Main_Page), …);
    #.  Il codice è più veloce da scrivere e semplice da leggere;
    #.  È anche più veloce da eseguire.


---
title: "Laboratorio di TNDS -- Lezione 6"
author: "Maurizio Tomasi"
date: "Martedì 28 ottobre 2025"
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
