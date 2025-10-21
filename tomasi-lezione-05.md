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

-   Consultate [Wikipedia](https://en.wikipedia.org/wiki/Atan2) per comprendere la logica di `atan2`.


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

  println(cerr, "The coordinates work correctly! 🥳");
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
  PuntoMateriale particella{0.0, 5e-7, 5, 3, -2};
  Posizione p{-2, 4, 1};

  CampoVettoriale V{particella.CampoElettrico(p)};

  assert(are_close(V.getFx(), -69.41150052142065));
  assert(are_close(V.getFy(), 9.915928645917235));
  assert(are_close(V.getFz(), 29.747785937751708));

  println(cerr, "Coulomb's law works correctly! 🥳");
}

void test_newton_law(void) {
  // 10⁹ tonnes, without charge (irrelevant for the gravitational field)
  PuntoMateriale particella{1e12, 0, 5, 3, -2};
  Posizione p{-2, 4, 1};

  CampoVettoriale V{particella.CampoGravitazionale(p)};

  assert(are_close(V.getFx(), -1.0302576701177));
  assert(are_close(V.getFy(), 0.14717966715968));
  assert(are_close(V.getFz(), 0.44153900147903));

  println(cerr, "Newton's law works correctly! 🥳");
}
```

# Inizializzazione di variabili membro

# Inizializzazione

Per inizializzare i membri di una classe in C++ esistono **tre** possibilità:

```c++
class Prova {
public:
    Prova();
private:
    int a;
    double b;
    char c{'a'};        // The same as in a function
};

Prova::Prova() : a{1} { // Initializer: use ":" *before* the {
    b = 5.0;            // Old boring assignment
}
```

# Inizializzazione

-   Uno dei metodi è diverso dagli altri due!

-   Costruiamo una classe `DaylightPeriod` che contiene al suo interno tre variabili dello stesso tipo `Time` che sono inizializzate in modo diverso:

    ```c++
    class DaylightPeriod {
    public:
      DaylightPeriod() : dawn{"7:00"} { sunset = Time("21:00"); }

    private:
      Time noon{"12:00"};
      Time dawn, sunset;
    };
    ```

# Inizializzazione

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

# Inizializzazione

-   Compiliamo ora questo programma ed eseguiamolo:

    ```c++
    int main(void) {
      DaylightPeriod c{};
      return 0;
    }
    ```

-   L'output è il seguente:

    ```
    Call to Time constructor with time "12:00"
    Call to Time constructor with time "7:00"
    Time() called with no arguments
    Call to Time constructor with time "21:00"
    Call to Time::operator=
    ```

# Spiegazione

-   Ricordiamo come abbiamo definito la classe `DaylightPeriod`:

    ```c++
    class DaylightPeriod {
    public:
      DaylightPeriod() : dawn{"7:00"} { sunset = Time("21:00"); }
    private:
      Time noon{"12:00"};
      Time dawn, sunset;
    };
    ```

-   L’output rivela che `sunset` ha richiesto più lavoro delle altre due!

    ```
    Call to Time constructor with time "12:00"
    Call to Time constructor with time "7:00"
    Time() called with no arguments
    Call to Time constructor with time "21:00"
    Call to Time::operator=
    ```

# Regola generale

-   Se il valore iniziale non cambia mai, fate come `noon{"12:00"}`:

    ```c++
    class Point {
        double x{}, y{};
    };
    ```

-   Se il valore iniziale è un parametro o dovete chiamare il costruttore della classe base, fate come `: dawn{"7:00"}`:

    ```c++
    Point::Point(double new_x, new_y) : x{new_x}, y{new_y} {}
    ```

-   In ogni altro caso, usate il corpo del costruttore

# Costruttore di default

-   Se nella dichiarazione di una classe si scrive `= default` dopo il costruttore, si chiede al C++ di implementarlo nel modo migliore possibile:

    ```c++
    class Point {
      double m_x{1.0}, m_y{2.0}, m_z{3.0};
    public:
      Point() = default;
    };
    ```

-   Un costruttore definito in questo modo garantisce che `m_x`, `m_y` e `m_z` siano inizializzate ai valori `1.0, 2.0, 3.0` e in più abilita altre proprietà avanzate se si usano i template o i `constexpr`

# `default` e `delete`

-   Si può usare `= default` anche con i copy constructor, i move constructor, e i distruttori, e il significato è lo stesso

-   Si può anche specificare `= delete`, che dice al C++ di **non** definire un costruttore di default, o un copy constructor, o un move constructor:

    ```c++
    class Point {
    double m_x, m_y, m_z;
    public:
      Point() = delete;  // Prevent the default constructor from being used
      Point(double x, double y, double z);
      Point(const Point &) = delete; // Prevent copy constructors too
    };
    ```

# Editor

# Geany

-   Dopo le fatiche della scorsa lezione, mi sono documentato su alcune alternative a Visual Studio Code che non riempiano a tradimento le vostre home directory

-   Ho scoperto che Geany è installato sulle macchine del laboratorio, ed è una valida opzione a VSCode

-   Per chi usa il proprio portatile non c’è bisogno di cambiare, ma chi invece usa il computer del laboratorio dovrebbe prenderlo in considerazione

# Configurazione

-   Per permettere a Geany di usare il C++23, aprite un terminale ed eseguite questa riga:

    ```
    /home/comune/labTNDS_programmi/setup-geany
    ```

-   Ora potete far partire Geany ed usarlo per compilare codice ed eseguirlo

# Uso

-   Con `Shift+F9` eseguite `make`

-   Con `F5` eseguite `make esegui`, a patto che abbiate definito il target `esegui` nel vostro `Makefile`! (Questo funziona solo se state editando un file C++; se è aperto il `Makefile`, il tasto non funziona).

-   Scegliendo da menu “Build/Auto-format” e premendo Ctrl+R, viene riformattato il vostro codice C++

-   Potete attivare molti plug-in interessanti da “Tools / Plugin manager”; io vi consiglio Auto-close, Debugger e File Browser.

# Debugging

# Debugging

-   Da quest’anno ho reso disponibile il programma NND, un debugger semplice ma adatto agli scopi di queste esercitazioni

-   Potete installarlo nella vostra home con questo comando:

    ```
    /home/comune/labTNDS_programmi/install-ndd
    ```

-   Le istruzioni complete sono disponibili in [una pagina dedicata](debugging.html).

-   Potete scaricarlo da [qui](https://github.com/al13n321/nnd/releases) per i vostri portatili; purtroppo però funziona solo su Linux…

---
title: Laboratorio di TNDS -- Lezione 5
author: Maurizio Tomasi ([`maurizio.tomasi@unimi.it`](mailto:maurizio.tomasi@unimi.it))
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
