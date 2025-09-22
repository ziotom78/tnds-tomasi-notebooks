# Esercizi per oggi

# Link alle risorse online

-   La spiegazione dettagliata degli esercizi si trova qui: [carminati-esercizi-05.html](carminati-esercizi-05.html).

-   Come al solito, queste slides, che forniscono suggerimenti addizionali rispetto alla lezione di teoria, sono disponibili all'indirizzo [ziotom78.github.io/tnds-tomasi-notebooks](https://ziotom78.github.io/tnds-tomasi-notebooks/).

# Esercizi per oggi

-   [Esercizio 5.0](carminati-esercizi-05.html#5.0): Creazione della classe `Posizione`
-   [Esercizio 5.1](carminati-esercizi-05.html#5.1): Creazione della classe `Particella` ed `Elettrone`
-   [Esercizio 5.2](carminati-esercizi-05.html#5.2): Creazione delle classi `CampoVettoriale` e `PuntoMateriale`
-   [Esercizio 5.3](carminati-esercizi-05.html#5.3): Calcolo del campo elettrico generato da un dipolo (**da consegnare**)
-   [Esercizio 5.4](carminati-esercizi-05.html#5.4): Campo di multipolo (approfondimento)
-   [Esercizio 5.5](carminati-esercizi-05.html#5.5): Gravità dallo spazio (approfondimento)

# Suggerimenti per gli esercizi

# Esercizio 5.0

-   Alcune funzioni utili disponibili in `<cmath>`:

    ```c++
    double std::sin(double x);
    double std::cos(double x);
    double std::tan(double x);
    double std::atan(double x);
    double std::atan2(double y, double x);
    ```

-   Per maggiori informazioni, eseguire `man` da terminale

    ```sh
    $ man atan2
    ```

-   Consultate Wikipedia per comprendere la logica di [`atan2`](https://en.wikipedia.org/wiki/Atan2).


# Esercizio 5.0

```c++
[[nodiscard]] bool are_close(double calculated,
                             double expected,
                             double epsilon = 1e-7) {
  return fabs(calculated - expected) < epsilon * fabs(expected);
}

void test_coordinates(void) {
  Posizione p{1, 2, 3};

  assert(are_close(p.getX(), 1.0));
  assert(are_close(p.getY(), 2.0);
  assert(are_close(p.getZ(), 3.0);

  assert(are_close(p.getR(), 3.7416573867739));
  assert(are_close(p.getPhi(), 1.1071487177941);
  assert(are_close(p.getTheta(), 0.64052231267943);

  assert(are_close(p.getRho(), 2.2360679774998);

  println(stderr, "The coordinates work correctly! 🥳");
}
```


# Esercizio 5.2

-   L'esempio usa `new` per creare puntatori:

    ```c++
    Particella a{1., 1.6e-19};
    Elettrone *e{new Elettrone{}};
    CorpoCeleste *c{new CorpoCeleste{"Terra", 6.0e24, 6.4e6}};
    ```

    Questo è utile per lo scopo dell'esercizio (comprendere come funziona l'ereditarietà).

-   In un vero programma l'uso di `new` e `delete` espliciti andrebbe però limitato il più possibile (e in questi pochissimi casi, andrebbe comunque usato solamente in costruttori/distruttori di classi, mai nel `main`).

---

<center>
![](images/c++-advice-no-pointers.png){width=40%}
</center>

Estratto dall'articolo [C++ is the next C++](https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2022/p2657r0.html), che propone una nuova «modalità» di compilazione del C++ in cui disabilitare (quasi) del tutto i puntatori.


# Esercizio 5.3

```c++
void test_coulomb_law(void) {
  // 0.5 µC charge with no mass (irrelevant for the electric field)
  PuntoMateriale particella1{0.0, 5e-7, 5, 3, -2};
  Posizione p{-2, 4, 1};

  CampoVettoriale V{particella.CampoElettrico(p)};

  assert(are_close(V.getFx(), -69.41150052142065));
  assert(are_close(V.getFy(), 9.915928645917235));
  assert(are_close(V.getFz(), 29.747785937751708));

  println(stderr, "Coulomb's law works correctly! 🥳");
}

void test_newton_law(void) {
  // 10⁹ tonnes, without charge (irrelevant for the gravitational field)
  PuntoMateriale particella1{1e12, 0, 5, 3, -2};
  Posizione p{-2, 4, 1};

  CampoVettoriale V{particella.CampoElettrico(p)};

  assert(are_close(V.getFx(), -1.0302576701177));
  assert(are_close(V.getFy(), 0.14717966715968));
  assert(are_close(V.getFz(), 0.44153900147903));

  println(stderr, "Newton's law works correctly! 🥳");
}
```

# Inizializzazione di variabili membro

# Inizializzazione e assegnamento

Per inizializzare i membri di una classe in C++ esistono due possibilità:

```c++
class Prova {
public:
    Prova();
private:
    int a;
    double b;
};

Prova::Prova() : a{1} { // Initializer: use ":" *before* the {
    b = 5.0;            // Old boring assignment
}
```

# Inizializzazione e assegnamento

-   I due metodi non sono equivalenti!

-   Costruiamo una classe `DaylightPeriod` che contiene al suo interno due variabili dello stesso tipo `Time`, ma inizializzate in modo diverso:

    ```c++
    class DaylightPeriod {
    public:
      // Pass two strings as names to distinguish the two objects
      DaylightPeriod() : dawn{"7:00"} { sunset = Time("21:00"); }

    private:
      Time dawn, sunset;
    };
    ```

# Inizializzazione e assegnamento

Per capire cosa succede, definiamo `Time` in modo che stampi a video un messaggio ogni volta che viene invocato un suo metodo.

```c++
class Time {
public:
  Time() { std::println("Time() called with no arguments"); }
  Time(const char *time) {
    std::println("Call to Time constructor with time \"{}\"", time);
  }

  void operator=(const Time &) {
    std::println("Call to Time::operator=");
  }
};
```

# Inizializzazione e assegnamento

Se ora creiamo nel `main` una variabile `DaylightPeriod`, vedremo cosa
accade nel costruttore:

```c++
int main(void) {
  DaylightPeriod c{};
  return 0;
}
```

# Risultato

-   L'output del programma è il seguente:

    ```
    Call to Time constructor with time "7:00"
    Time() called with no arguments
    Call to Time constructor with time "21:00"
    Call to Time::operator=
    ```

-   Ricordiamo come abbiamo definito la classe `DaylightPeriod`, e in particolare il costruttore:

    ```c++
    class DaylightPeriod {
    public:
      DaylightPeriod() : dawn{"7:00"} { sunset = Time("21:00"); }

    private:
      Time dawn, sunset;
    };
    ```

# Regola generale

-   Si dovrebbe evitare di inizializzare gli oggetti nel corpo del costruttore, perché il C++ richiede che tutte le variabili membro siano inizializzate **prima** che il costruttore di una classe sia eseguito.

-   Di conseguenza, se si usano i «vecchi» assegnamenti gli oggetti con costruttore vengono inizializzati due volte.

-   Se avete scelta, l'inizializzazione con i due punti (`:`) è **sempre** da preferire:

    ```c++
    class DaylightPeriod {
    public:
      DaylightPeriod() : dawn{"7:00"}, sunset{"21:00"} { } // That's the way!

      // ...
    };
    ```


---
title: Laboratorio di TNDS -- Lezione 5
author: Maurizio Tomasi
date: "Martedì 21 ottobre 2025"
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
