---
title: "Laboratorio di TNDS -- Lezione 6"
author: "Maurizio Tomasi"
date: "Martedì 9 Novembre 2021"
theme: "white"
progress: true
slideNumber: true
background-image: "./media/background.png"
width: 1440
height: 810
css:
- ./css/custom.css
- ./css/asciinema-player.css
...

# Link alle risorse online

-   La spiegazione dettagliata degli esercizi si trova qui: [carminati-esercizi-06.html](carminati-esercizi-06.html).

-   Come al solito, queste slides, che forniscono suggerimenti addizionali rispetto alla lezione di teoria, sono disponibili all'indirizzo [ziotom78.github.io/tnds-tomasi-notebooks](https://ziotom78.github.io/tnds-tomasi-notebooks/).

# Esercizi per oggi

-   [Esercizio 6.0](./carminati-esercizi-06.html#esercizio-6.0): Metodi virtuali
-   [Esercizio 6.1](./carminati-esercizi-06.html#esercizio-6.1): Classe astratta FunzioneBase
-   [Esercizio 6.2](./carminati-esercizi-06.html#esercizio-6.2): Metodo della bisezione (**da consegnare**)
-   [Esercizio 6.3](./carminati-esercizi-06.html#esercizio-6.3): Equazioni non risolubili analiticamente (**da consegnare**)
-   [Esercizio 6.4](./carminati-esercizi-06.html#esercizio-6.4): Miglioramenti di `Solutore`
-   [Esercizio 6.5](./carminati-esercizi-06.html#esercizio-6.5): Ricerca di zeri di una funzione senza uso del polimorfismo

# Metodi virtuali {#virtual-methods}

# Metodi virtuali

Al momento, l'unico modo in cui il C++ implementa il polimorfismo durante l'esecuzione è attraverso i metodi `virtual`. (I template permettono polimorfismo in fase di compilazione, e sono quindi usati in ambiti diversi).

Una classe derivata può ridefinire uno dei metodi della classe genitore se questo è indicato come `virtual`, usando la parola chiave [`override`](https://www.fluentcpp.com/2020/02/21/virtual-final-and-override-in-cpp/).

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

int main(int argc, const char *argv[]) {
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

La parola `virtual` è obbligatoria solo all'interno della classe base e facoltativa nei metodi derivati:

```c++
struct Animal {
  virtual void greet() const { std::cout << "?\n"; }
};

struct Dog : public Animal {
  // Posso ripetere "virtual" qui, anche se è superfluo…
  virtual void greet() const override { std::cout << "Woof!\n"; }
};


struct Cat : public Animal {
  // …ma di solito si evita di ripetere "virtual", perché c'è già "override"
  void greet() const override { std::cout << "Meow!\n"; }
};
```

# `virtual` e `override`

-   Analogamente, anche `override` può essere tralasciato:

    ```c++
    struct Animal {
      virtual void greet() const { std::cout << "?\n"; }
    };

    struct Dog : public Animal {
      // Ok, compila e funziona come atteso
      virtual void greet() const { std::cout << "Woof!\n"; }
    };


    struct Cat : public Animal {
      // Anche questo è ok e compila senza errori
      void greet() const { std::cout << "Meow!\n"; }
    };
    ```

-   Tralasciare sia `virtual` che `override` è però sconsigliato!

# `virtual` e `override`

-   Supponiamo di avere scritto una versione più primitiva del codice, senza indicare `greet` come `const`:

    ```c++
    struct Animal {
      virtual void greet() { std::cout << "?\n"; }
    };

    struct Dog : public Animal {
      // Sono pigro, evito di scrivere `virtual` e `override`
      void greet() { std::cout << "Woof!\n"; }
    };

    struct Cat : public Animal {
      void greet() { std::cout << "Meow!\n"; }
    };
    ```

-   Anche questo codice compila e funziona senza problemi, ma…

# `virtual` e `override`

-   Supponiamo ora di modificare il file `animal.h`:

    ```c++
    struct Animal {
      virtual void greet() const { std::cout << "?\n"; }  // Ho aggiunto "const"
    };
    ```

-   Il codice compila ancora, ma smette di funzionare:

    ```text
    $ ./test cat
    ?
    $ ./test dog
    ?
    $ ./test bird
    $
    ```
    
    (Notate che `cat` e `dog` producono `?`, mentre `bird` non produce nulla). Cos'è successo?
    
# `virtual` e `override`

```c++
// Questo è il "main" del programma
Animal *animal{};

std::string name{argc > 1 ? argv[1] : ""};
if (name == "cat") {
  animal = new Cat();        // Ok, crea un oggetto Cat…
} else if (name == "dog") {
  animal = new Dog();        // …o un oggetto Dog, ma…
}

if (animal)
  animal->greet();           // …qui invoca sempre Animal::greet(), che stampa "?"
```

# `virtual` e `override`

Abbiamo due modi per correggere il problema:

1.   Cercare in tutto il codice quali classi derivino da `Animal` e reimplementino `greet`, e aggiungere `const` (semplice in un programma così piccolo, ma difficile in un programma di media complessità!).
2.   Indicare **sempre** `override` nei metodi derivati, perché il questo modo il compilatore C++ può segnalare l'errore:

```
test.cpp:10:8: error: ‘void Dog::greet()’ marked ‘override’, but does not override
   10 |   void greet() override { std::cout << "Woof!\n"; }
      |        ^~~~~
test.cpp:15:8: error: ‘void Cat::greet()’ marked ‘override’, but does not override
   15 |   void greet() override { std::cout << "Meow!\n"; }
      |        ^~~~~
```

# Forma preferita

-   Nella classe base i metodi virtuali vanno indicati con `virtual`:

    ```c++
    class Animal {
      virtual void greet() const;
    };
    ```
    
-   Nella classe derivata ci sono invece più possibilità:

    ```c++
    // Prima possibilità: SCONSIGLIATA!
    void greet() const;
    // Seconda possibilità: SCONSIGLIATA!
    virtual void greet() const;
    // Terza possibilità: ok (protegge da errori), ma è verbosa
    virtual void greet() const override;
    // Quarta possibilità: la migliore! (concisa, protegge da errori)
    void greet() const override;
    ```


# Uso di puntatori

# Quando usare puntatori

-   Nell'[Esercizio 6.1](./carminati-esercizi-06.html#esercizio-6.0) di oggi si usano i puntatori nel seguente codice:

    ```c++
    Particella * a{new Particella{1., 2.}};
    Elettrone * b{new Elettrone{}};
    Particella * c{new Elettrone{}};
    ```

-   È indispensabile usare puntatori (o reference) quando avviene questo:

   1.   Si crea una variabile di un tipo base (`Particella`)…
   2.   …ma poi le si vuole assegnare una variabile di un tipo derivato (`Elettrone`).
   
# Quando usare puntatori

-   Usando un puntatore e `new`, si possono specificare i due tipi `Particella` ed `Elettrone` separatamente:

    ```c++
    //   Tipo 1            Tipo 2
       Particella * c{new Elettrone{}};
    ```

-   Senza puntatore, non ci sarebbe questa possibilità:

    ```c++
    Particella c{};  // Come specificare "Elettrone"?
    ```

# Quando usare i puntatori

Se non ci si trova nella situazione descritta, è meglio evitare di usare i puntatori: il codice è più semplice da leggere, e non c'è possibilità di avere `segmentation fault` causati dall'accesso a puntatori nulli.

```c++
// Molto più semplice e sicuro!
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
// Potreste addirittura passare un puntatore a `Solutore * s`, e invocare dal main
//     test_zeroes(new Bisezione{});
//     test_zeroes(new Secante{});
//     test_zeroes(new Newton{});
void test_zeroes() {
  Bisezione s{};
  Parabola f{3, 5, -2}; // Gli zeri di questa funzione sono noti, e sono x₁ = −2, x₂ = 1/3
  s.SetPrecisione(1e-8);

  assert(are_close(s.CercaZeri(-3.0, -1.0, f), -2.0)); // Lo zero è in mezzo ad [a, b]
  assert(are_close(s.CercaZeri(-2.0, 0.0, f), -2.0));  // Lo zero è nell'estremo a
  assert(are_close(s.CercaZeri(-4.0, -2.0, f), -2.0)); // Lo zero è nell'estremo b

  assert(are_close(s.CercaZeri(0.0, 1.0, f), 1.0 / 3));
}
```

# Determinazione del segno

# Determinazione del segno

-   Nell'algoritmo di bisezione occorre verificare quando $f(a)$ e $f(b)$ sono di segno concorde.

-   La scrittura

    ```c++
    f(a) * f(b) < 0
    ```
    
    non è consigliabile, perché se `f(a)` o `f(b)` sono molto piccoli, il risultato potrebbe essere nullo. Meglio usare un'espressione come
    
    ```c++
    sign(f(a)) * sign(f(b)) < 0
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
     `Solutore`, come suggerito nell'[Esercizio 6.4](carminati-esercizi-06.html#esercizio-6.4)).

# Condizioni di errore con NaN

-   Una possibile alternativa è l'uso di un valore *Not-a-number* (NaN) come risultato della chiamata:

    ```c++
    #include <cmath>

    if(something_is_invalid()) {
        return std::nan(""); // Restituisce un NaN
    }
    ```

-   È una implementazione dell'idea numero 2 (restituire un valore fissato in caso di errore) che non ha ambiguità.

-   Può essere implementata in parallelo con le modifiche suggerite nell'[Esercizio 7.4](carminati-esercizi-06.html#esercizio-6.4)).

# Controllo di NaN

-   Per controllare se il valore restituito è un NaN, si può usare la funzione `isnan` (in `<cmath>`):

    ```c++
    double x{CercaZeri(0., 1., f)};
    if(isnan(x)) {
        // Stampa un messaggio di errore
    }
    ```
    
-   Siccome i NaN hanno anche la proprietà che non sono uguali a se stessi (`NaN == NaN` è falso), si può usare anche questo test:

    ```c++
    if(x != x) {
        // Vero solo se x contiene un NaN
    }
    ```

# Vantaggi dei NaN

I numeri NaN sono vantaggiosi perché si «propagano»: operazioni con
numeri NaN restituiscono sempre NaN.

```c++
double x{nan("")};
cout << x + 1 << ", " << x * 2 << ", " << x / x << "\n";
// Output: nan, nan, nan
```

Inoltre hanno un comportamento molto particolare nelle operazioni di
confronto:

```c++
cout << (x < x) << ", ";
cout << (x > x) << ", ";
cout << (x == x) << ", ";
cout << (x != x) << "\n";  // Vedi slide precedente

// Output: 0, 0, 0, 1
```
