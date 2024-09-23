# Link alle risorse online

-   La spiegazione dettagliata degli esercizi si trova qui: [carminati-esercizi-06.html](carminati-esercizi-06.html).

-   Come al solito, queste slides, che forniscono suggerimenti addizionali rispetto alla lezione di teoria, sono disponibili all'indirizzo [ziotom78.github.io/tnds-tomasi-notebooks](https://ziotom78.github.io/tnds-tomasi-notebooks/).


# Esercizi per oggi

-   [Esercizio 6.0](./carminati-esercizi-06.html#esercizio-6.0): Metodi virtuali
-   [Esercizio 6.1](./carminati-esercizi-06.html#esercizio-6.1): Classe astratta `FunzioneBase`
-   [Esercizio 6.2](./carminati-esercizi-06.html#esercizio-6.2): Metodo della bisezione (**da consegnare**)
-   [Esercizio 6.3](./carminati-esercizi-06.html#esercizio-6.3): Equazioni non risolubili analiticamente (**da consegnare**)
-   [Esercizio 6.4](./carminati-esercizi-06.html#esercizio-6.4): Ricerca di zeri di una funzione senza uso del polimorfismo

# Metodi virtuali {#virtual-methods}

# Metodi virtuali

-   L'unico modo in cui il C++ implementa il polimorfismo durante l'esecuzione è attraverso i metodi `virtual`.

-   (I *template* permettono polimorfismo in fase di **compilazione**, e sono quindi usati in ambiti diversi).

-   Una classe derivata può ridefinire uno dei metodi della classe genitore se questo è indicato come `virtual`, usando la parola chiave [`override`](https://www.fluentcpp.com/2020/02/21/virtual-final-and-override-in-cpp/).

# Uso di metodi virtuali

```c++
#include <iostream>

struct Animal {
  // Dichiaro `greet` come un metodo che può essere sovrascritto
  virtual void greet() const { std::cout << "?\n"; }
};

struct Dog : public Animal {
  // Chiedo al C++ di sovrascrivere `greet` tramite `override`
  void greet() const override { std::cout << "Woof!\n"; }
};

struct Cat : public Animal {
  // Chiedo al C++ di sovrascrivere `greet` tramite `override`
  void greet() const override { std::cout << "Meow!\n"; }
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
  virtual void greet() const { std::cout << "?\n"; }
};

struct Dog : public Animal {
  // I can repeat "virtual" here, but it's optional
  virtual void greet() const override { std::cout << "Woof!\n"; }
};

struct Cat : public Animal {
  // You usually avoid repeating "virtual", if there is "override"
  void greet() const override { std::cout << "Meow!\n"; }
};
```

# `virtual` e `override`

-   Per compatibilità con le vecchie versioni del C++, anche `override` può essere tralasciato:

    ```c++
    struct Dog : public Animal {
      // Ok, compila e funziona come atteso, ma NON FATELO!
      virtual void greet() const { std::cout << "Woof!\n"; }
    };

    struct Cat : public Animal {
      // Anche questo è ok e compila senza errori, ma NON FATELO!
      void greet() const { std::cout << "Meow!\n"; }
    };
    ```

-   Questo è comune in codici C++ particolarmente vecchi, ma oggigiorno è considerata una **pessima** pratica.


# Uso di puntatori

# Quando usare puntatori

-   Nell'[Esercizio 6.1](./carminati-esercizi-06.html#esercizio-6.0) di oggi si usano i puntatori nel seguente codice:

    ```c++
    Particella * p{new Particella{1., 2.}};
    Elettrone * b{new Elettrone{}};
    Particella * c{new Elettrone{}};
    ```

-   Si usano puntatori (o reference) quando avviene questo:

    1.   Si crea una variabile di un tipo base (`Particella`)…
    2.   …ma poi le si vuole assegnare una variabile di un tipo derivato (`Elettrone`).

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

Se non ci si trova nella situazione descritta, è meglio evitare di usare i puntatori: il codice è più semplice da leggere, e non c'è possibilità di avere `segmentation fault` causati dall'accesso a puntatori nulli.

```c++
// Far easier and safer!
Particella a{1., 2.};
Elettrone b{};
Elettrone c{};
```

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

# Verifica dell'algoritmo

```c++
// You might even pass a reference to `Solutore & s` and call in `main`
//     test_zeroes(Bisezione{});
//     test_zeroes(Secante{});
//     test_zeroes(Newton{});
void test_zeroes() {
  Bisezione s{};
  Parabola f{3, 5, -2}; // Zeroes for this function are known: x₁ = −2, x₂ = 1/3
  s.SetPrecisione(1e-8);

  assert(are_close(s.CercaZeri(-3.0, -1.0, f), -2.0)); // Zero is within (a, b)
  assert(are_close(s.CercaZeri(-2.0, 0.0, f), -2.0));  // Zero is at a
  assert(are_close(s.CercaZeri(-4.0, -2.0, f), -2.0)); // Zero is at b

  assert(are_close(s.CercaZeri(0.0, 1.0, f), 1.0 / 3)); // Do NOT write 1 / 3 !
}
```

# Determinazione del segno

# Determinazione del segno

-   Nell'algoritmo di bisezione occorre verificare quando $f(a)$ e $f(b)$ sono di segno concorde.

-   La scrittura

    ```c++
    if (f(a) * f(b) < 0) { … }
    ```

    non è consigliabile, perché se `f(a)` o `f(b)` sono molto piccoli, il risultato potrebbe essere nullo. Meglio usare un'espressione come

    ```c++
    if (sign(f(a)) * sign(f(b)) < 0) { … }
    ```


# Uso di NaN {#use-of-nan}

# Condizioni d'errore

Il metodo di bisezione fallisce se le ipotesi del teorema degli zeri non valgono. Cosa fare in questo caso?

1.   Scrivere un messaggio di errore e invocare `abort()`;

2.   Restituire un valore fissato (es., zero). Questo è però ambiguo!

3.   Accettare un parametro aggiuntivo `bool &found` per `CercaZeri`:

     ```c++
     double CercaZeri(double xmin, double xmax, const FunzioneBase * f, bool &found);
     ```

     (In alternativa si può dichiarare `found` variabile membro di
     `Solutore`).

# Condizioni di errore con NaN

-   Una possibile alternativa è l'uso di un valore *Not-a-number* (NaN) come risultato della chiamata:

    ```c++
    #include <cmath>

    double my_function(…) {
      if(something_is_invalid()) {
          return std::nan(""); // Return a NaN
      }

      // Continue
    }
    ```

-   È una implementazione dell'idea numero 2 (restituire un valore fissato in caso di errore) che non ha ambiguità.

# Controllo di NaN

-   Per controllare se il valore restituito è un NaN, si può usare la funzione `isnan` (in `<cmath>`):

    ```c++
    // Codice nel `main`
    double x{CercaZeri(0., 1., f)};
    if(isnan(x)) {
        // Print a error message to std::cerr
    }
    ```

-   I NaN hanno anche la proprietà che non sono uguali a se stessi:

    ```c++
    if(x != x) {
        // This is true only if `x` is a NaN
    }
    ```

# Vantaggi dei NaN

I numeri NaN sono vantaggiosi perché si «propagano»: operazioni con numeri NaN restituiscono sempre NaN.

```c++
double x{nan("")};
cout << x + 1 << ", " << x * 2 << ", " << x / x << "\n";
// Output: nan, nan, nan
```

Inoltre hanno un comportamento molto particolare nelle operazioni di confronto:

```c++
cout << (x < x) << ", ";
cout << (x > x) << ", ";
cout << (x == x) << ", ";
cout << (x != x) << "\n";  // See previous slide

// Output: 0, 0, 0, 1
```

# Un po' di curiosità

-   [Walter Bright](https://en.wikipedia.org/wiki/Walter_Bright), sviluppatore dello storico compilatore [Zortech C/C++](https://en.wikipedia.org/wiki/Digital_Mars) (1988), ha creato il [linguaggio D](https://dlang.org/) nel 2001.

-   Bright adora il C ma detesta il C++, e ha creato D per superarne alcune limitazioni (come gli header files, che lui detesta!)

-   Molte idee del linguaggio D sono state poi incorporate nelle ultime versioni del C++ ([moduli](https://en.wikipedia.org/wiki/Module_(programming)), [range](https://en.wikipedia.org/wiki/Range_(computer_programming)), [funzioni anonime](https://en.wikipedia.org/wiki/Anonymous_functions)…)

-   In D, variabili `double` non inizializzate sono poste dal compilatore uguali a `NaN`: in questo modo, è immediato accorgersi quando ci si dimentica di inizializzarle (Vedere [questo thread](https://forum.dlang.org/thread/dowtxwcvlsunqugffcnp@forum.dlang.org) per maggiore contesto).


# Esempio di codice D (sbagliato)

```d
import std.stdio;  // No header files in D: hurrah!

double mean(double[] values) {
    double accum;  // Ooops, I forgot to initialize this!

    foreach(value; values) {
        accum += value;
    }

    return accum / values.length;
}

void main() {
    double[] vec = [1.0, 5.0, 4.0, 3.0];
    writeln(mean(vec));
    // This prints "nan" because of the forgotten initialization
}
```

---
title: "Laboratorio di TNDS -- Lezione 6"
author: "Maurizio Tomasi"
date: "Martedì 29 Ottobre 2024"
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
