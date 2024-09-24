[La pagina con la spiegazione originale degli esercizi si trova qui: <https://labtnds.docs.cern.ch/Lezione6/lezione6/>.]

In questa sesta lezione affronteremo il problema della ricerca di zeri di una funzione. Per fare questo realizzeremo per prima cosa due classi astratte per rappresentare rispettivamente una generica funzione $y = f(x)$, ed un metodo generico per la ricerca di zeri. Affronteremo poi casi concreti (ricerca degli zeri per una parabola usando il metodo della bisezione) sfruttando *ereditarietà* e *polimorfismo*.

# Esercizio 6.0 - Metodi virtuali {#esercizio-6.0}

Prima di incominciare con la lezione vera e propria, proviamo a riflettere sul significato del polimorfismo attraverso l'uso del qualificatore `virtual`. Consideriamo le classi `Particella` e la sue derivata `Elettrone` costruite nella [lezione 5](./carminati-esercizi-05.html).

Implementare ed eseguite il seguente programma:

```c++
#include "particella.h"

int main() {
  Particella *p{new Particella{1., 2.}};
  Elettrone  *e{new Elettrone{}};
  Particella *b{new Elettrone{}}; // puntatore a Particella punta a un Elettrone

  p->Print(); // metodo Print di Particella
  e->Print(); // metodo Print di Elettrone
  b->Print(); // ???

  delete p;
  delete e;
  delete b;

  return 0;
}
```

Mentre le prime due chiamate `p->Print()` ed `e->Print()` sono immediate da capire, il caso più interessante è quello di `b`: la variabile `b` è di tipo puntatore a `Particella`, ma punta ad un oggetto di tipo `Elettrone`. Questa situazione è permessa in C++, e costituisce la base del *polimorfismo*.


*   Se utilizziamo le classi scritte nella lezione 5 senza modifiche, si dovrebbe constatare nell'istruzione `b->Print()` viene invocato il metodo `Print()` della classe madre (`Particella`), anche quando gli oggetti riferiti dai puntatori sono classi figlie (`Elettrone`, in questo caso).

*   Aggiungere ora negli header file della classe `Particella` il qualificatore `virtual` all'inizio della dichiarazione del metodo `Print()`, ed a quella della classe `Elettrone` il qualificatore `override` alla *fine*:

    ```c++
    // Nella classe Particella:
    virtual void Print() const;

    // Nella classe Elettrone; notare che "override" va alla fine!
    void Print() const override;
    ```

    Ricompilando e rigirando il programma si dovrebbe adesso vedere che per ciascun oggetto viene invocato il metodo corrispondente all'oggetto al quale il puntatore punta: nel caso specifico in `b->Print()` viene invocato il metodo `Print()` di Elettrone in quanto `b` punta ad un oggetto di tipo Elettrone.

*    Una classe che implementa o eredita un metodo virtuale si dice *polimorfica*: l'istruzione `b->Print()` darà esiti diversi a seconda della classe a cui `b` punta, nonstante `b` sia di tipo puntatore a Particella. Questa proprietà del linguaggio sarà molto utile per sviluppare il codice di ricerca degli zeri di una funzione.


## Metodi virtuali e classi astratte

La parola chiave `virtual` informa il compilatore che il metodo indicato potrà venire sovrascritto dalle classi figlie, mentre la parola chiave `override` si segnala che si sta “sovrascrivendo” un metodo all'interno di una classe figlia. Quando si usano queste due parole chiave, durante l'esecuzione del programma, al momento di chiamare il metodo a partire da un puntatore alla classe madre, il programma valuterà se l'oggetto indirizzato è del tipo classe madre o una delle figlie. In quest'ultimo caso, invocherà il metodo appropriato della classe figlia reale. Un metodo virtuale può anche essere posto uguale a `0` (vedi prossimo esercizio): in tal caso è *obbligatorio* per le classi figlie implementarlo con `override`. In questo caso il metodo si dice “virtuale puro” e una classe che implementa almeno un metodo virtuale puro si dice *classe astratta*.


# Esercizio 6.1 - Classe astratta FunzioneBase {#esercizio-6.1}

In questo e nei prossimi esercizi avremo a che fare con diverse funzioni $y = f(x)$ di una sola variabilee e dovremo effettuare delle operazioni generiche su queste funzioni (come trovarne gli zeri o calclarne l'integrale in un certo intervallo). Dovremo pertanto strutturare il codice in modo che ogni algoritmo possa lavorare allo stesso modo su funzioni che possono essere diverse. Per fare questo è utile definire una classe astratta che implementi le proprietà generali della classe attraverso metodi virtuali puri, e poi lasciare alle classi derivate il compito di implementare concretamente tutti questi metodi (ed eventualmente quelli aggiuntivi necessari). Notate in questo caso che è buona prassi definire il distruttore di una classe madre astratta come `virtual`, in modo che il distruttore della classe figlia venga invocato correttamente quando un oggetto di tipo classe figlia viene distrutto. Per capire meglio la struttura del codice procediamo per passi. In questo esercizio scriviamo un set di classi per modellizzare una generica funzione di una variabile:

#.  Definire la classe astratta FunzioneBase, che implementi un metodo `double Eval(double x) const` che modellizza l'effetto di applicare $f$ in $x$:

    ```c++
    // Classe astratta per una generica funzione
    class FunzioneBase {
    public:
        virtual double Eval(double x) const = 0;
        virtual ~FunzioneBase() {}
    };
    ```

#.  Implementare una classe derivata `Parabola` che descriva una funzione del tipo $f(x) = a x^2 + b x + c$ (chiaramente questa classe dovrà avere i data membri per i parameteri $a$, $b$ e $c$, ed i metodi per definirli e accederci):

    ```c++
    class Parabola : public FunzioneBase {
    public:

      Parabola() : m_a{}, m_b{}, m_c{1.0} {}
      Parabola(double a, double b, double c) : m_a{a}, m_b{b}, m_c{c} {}
      ~Parabola() {}
      double Eval(double x) const override {
          // Horner's method, see https://en.wikipedia.org/wiki/Horner%27s_method
          return (m_a * x + m_b) * x + m_c;
      }

      void SetA(double a) { m_a = a; }
      void SetB(double b) { m_b = b; }
      void SetC(double c) { m_c = c; }

      double GetA() const { return m_a; }
      double GetB() const { return m_b; }
      double GetC() const { return m_c; }

      double GetVertex() const { return -m_b / (2 * m_a); }

    private:
      double m_a, m_b, m_c;
    };
    ```

#.  Verificare il funzionamento della classe `Parabola` costruendo un programmino che, dati i parametri di una parabola, ne stampi il valore della $y$ nel vertice $x_v = -b / 2a$. A titolo di esempio, usate la parabola $f(x) = 3x^2 + 5x - 2$.


## Nota sulle classi astratte

Quando dichiariamo nullo un metodo `virtual`, la classe difetta dell'implementazione di tale metodo, e quindi non si possono creare oggetti di quella classe. Solo le sue classi derivate che implementano quel metodo possono essere instanziate. Siccome non si possono costruire oggetti di tale classe, non è necessario definire dei costruttori.

È da sottolineare però che non è *obbligatorio* che una classe derivata implementi i metodi virtuali puri della classe base: se non lo fa, anche la classe derivata è astratta e non può essere istanziata. Di solito, questo si fa quando la classe derivata è pensata per essere derivata successivamente, come nell'esempio seguente:

```c++
// Abstract base class
class Animal {
  // This is an abstract class, because there are
  // *two* pure virtual methods.
  virtual void Greet() = 0;
  virtual void Go() = 0;
};

// Abstract derived class
class Bird : public Animal {
  // This class is still abstract, because it
  // implements `Go` but does *not* implement `Greet`
  void Go() override {
    std::cout << "I'm flying!\n";
  }
};

// Concrete derived class
class Duck : public Bird {
  // This class is no longer abstract, as `Go()`
  // was defined in the ancestor class `Bird`,
  // and here we are defining `Greet`: there are
  // no pure virtual methods left.
  void Greet() override {
    std::cout << "Squawk!\n";
  }
};

int main() {
  Duck donald{};
  donald.Greet();  // Print "Squawk!"
  donald.Go();     // Print "I'm flying!"
}
```

Se una classe astratta implementa solo metodi virtuali nulli, come nel caso di `Animal`, non è neanche necessario realizzare un file di implementazione, né creare un file oggetto, dato che tutta l'informazione è contenuta nell'header.


# Esercizio 6.2 - Metodo della bisezione (da consegnare) {#esercizio-6.2}

Passiamo ora alla codifica della parte relativa agli algoritmi di ricerca degli zeri di una funzione: proviamo a scrivere un programma che calcoli gli zeri della funzione
$$
f(x) = 3x^2 + 5x - 2.
$$

Il programma dovrà leggere da riga di comando gli estremi dell'intervallo in cui cercare lo zero e la precisione richiesta. Per calcolare gli zeri, implementeremo una classe astratta `Solutore` ed una classe concreta che realizza il metodo della bisezione visto a lezione. Nulla vieta di implementare anche il metodo delle secanti usando lo stesso schema. Si richiede obbligatoriamente che il programma stampi l'ascissa dello zero con un numero di cifre significative corrispondente alla precisione immessa.


## La funzione segno

Ci sono vari modi di implementare una funzione segno da utilizzare nella codifica dell'algoritmo di bisezione:

#.  Una banale funzione libera:

    ```c++
    double sign(double x) {
        if(x < 0)
            return -1.0;
        else if (x > 0)
            return 1.0;
        else
            return 0.0;
    }
    ```

    oppure con l'implementazione più compatta ma meno leggibile

    ```c++
    double sign(double x) {
        return x == 0. ? 0.0 : (x > 0 ? 1.0 : -1.0);
    }
    ```

    (Notare che la funzione restituisce zero se `x == 0`).

#.  Una classe che erediti da `FunzioneBase`:

    ```c++
    class Segno : public FunzioneBase {
    public :
       double Eval(double x) const {
           return x == 0. ? 0.0 : (x > 0 ? 1.0 : -1.0);
       }
    }
    ```

#.  La libreria standard C++11 fornisce la funzione `std::copysign`, definita in `<cmath>`, che copia il segno di una variabile `double` in un valore, e la cui esecuzione è particolarmente ottimizzata (perché corrisponde a una singla istruzione sulle CPU x86_64). Si può quindi usare questa definizione:

    ```c++
    // Use "inline" if you're going to put this definition in a .h file!
    inline double sign(double x) {
        // Questa chiamata a copysign ritorna ±1.0 a seconda
        // del segno di x, oppure zero se x == 0
        return x != 0 ? std::copysign(1.0, x) : 0.0;
    }
    ```

Usando una delle versioni “libere” della funzione segno (ossia, non la classe derivata da `FunzioneBase`), la condizione richiesta dall'algoritmo di bisezione sarà

```c++
double sign_a{sign(f(a))};
double sign_b{sign(f(b))};
double sign_c{sign(f(c))};

// Check whether sign_a, sign_b, or sign_c are zero: in that case,
// we've already got the root!
// ...

if(sign_a * sign_c < 0) {
    // ...
} else if(sign_b * sign_c < 0) {
    // ...
} else {
    // ...
}
```


## Classe astratta `Solutore`

La classe astratta Solutore potrebbe avere un metodo virtuale puro, `CercaZeri`, corrispondente alla chiamate dell'algoritmo che cercherà di determinare gli zeri di una generica `FunzioneBase`, passata come puntatore o come referenza: nell'esempio sono presentati entrambi i casi, ma in generale è preferibile usare una **referenza**.

Possiamo definire dei metodi per configurare la precisione richiesta: tale precisione può essere definita nel costruttore, tramite un metodo dedicato o direttamente nella chiamata al metodo `CercaZeri`. Lo stesso discorso vale per il numero massimo di iterazioni.

Come nel caso di `FunzioneBase`, notate l'implementazione del distruttore come metodo virtuale e l'utilzzo della keyword `override`.

```c++
class Solutore {
public:
  Solutore();
  Solutore(double prec);
  virtual ~Solutore() {}

  // For pedagogical purposes, you find here two definitions: one
  // uses a pointer (*), the other one a reference (&). In your code
  // you just have to implement one of them. (The one with the reference
  // should be preferred).

  virtual double CercaZeriPointer(double xmin, double xmax, const FunzioneBase * f,
                                  double prec = 1e-3, int nmax = 100) = 0;
  virtual double CercaZeriReference(double xmin, double xmax, const FunzioneBase & f,
                                    double prec = 1e-3, int nmax = 100) = 0;

  void SetPrecisione(double epsilon) { m_prec = epsilon; }
  double GetPrecisione() const { return m_prec;}

  void SetNMaxIterations(unsigned int n) { m_nmax = n; }
  int GetNMaxIterations() const { return m_nmax; }

  unsigned int GetNiterations() const { return m_niterations; }

protected:
  double m_a, m_b; // range of the interval to explore
  double m_prec; // precision of the solution
  int m_nmax; // Maximum number of iterations
  int m_niterations; // Actual number of iterations
};
```

## La classe concreta `Bisezione`

L'implementazione dell'algoritmo di bisezione dovrà necessariamente avvenire costruendo una classe dedicata `Bisezione` che erediti da `Solutore` e implementi una versione concreta del metodo `CercaZeri`.

```c++
class Bisezione : public Solutore {
public:
  Bisezione();
  Bisezione(double prec);
  virtual ~Bisezione();

  // Here too we provide two definitions. You must only implement the one you
  // provided in `Solutore`!

  virtual double CercaZeriPointer(double xmin, double xmax, const FunzioneBase * f,
                                  double prec = 1e-3, int nmax = 100);

  virtual double CercaZeriReference(double xmin, double xmax, const FunzioneBase & f,
                                    double prec = 1e-3, int nmax = 100);
};
```

Per segnalare condizioni di errore potete usare i suggerimenti spiegati nelle [slide di approfondimento](./tomasi-lezione-06.html#use-of-nan).



## Il metodo della bisezione

Data una funzione $f(x)$, si dice zero, o radice, di $f$ un elemento $x_0$ del suo dominio tale che $f(x_0) = 0$.

Per trovare numericamente gli zeri della funzione $f(x) = x^2 - 2$ utilizzando il metodo di *bisezione*: è l'algoritmo più semplice, e consiste in una procedura iterativa che, ad ogni ciclo, dimezza l'intervallo in cui si trova lo zero. Dal teorema di Bolzano (o degli zeri) sappiamo che, data una funzione $f$ continua sull'intervallo chiuso $[a,b]$ a valori reali tale che $f(a) \cdot f(b) < 0$, allora esiste un punto $x_0 \in [a, b]$ tale che $f(x_0) = 0$.

Definiamo intervallo di incertezza di $f$ un intervallo $[a,b]$ che soddisfa il Teorema di Bolzano. L'idea dell'algoritmo è che se esiste un intervallo di incertezza $[a,b]$ per una funzione $f$, allora ne esiste uno più piccolo (esattamente la metà). L'algoritmo deve avere in input l'intervallo di incertezza di partenza $[a,b]$ ed una precisione (o tolleranza) $\epsilon$ con cui si vuole trovare lo zero di $f$ tale che $\left|b - a\right| < \epsilon$.

Si parte dividendo in due l'intervallo e trovando il punto medio $c = a + (b - a)/2$ per cui avremo due intervalli $[a,c]$ e $[c,b]$. Ora, se $f(c) = 0$ siamo fortunati e abbiamo trovato lo zero; altrimenti si deve valutare $f(a) \cdot f(c)$ e $f(c) \cdot f(b)$, e ripetere la procedura sull'intervallo in cui $f$ cambia di segno. La procedura va ripetuta finché la larghezza dell'intervallo finale non è minore di $\epsilon$.

Ci sono alcuni aspetti da tenere in considerazione:

-   Se l'intervallo contiene più di una radice il metodo della bisezione ne troverà solo una.

-   Nell'implementazione delle condizioni di ricerca dall'intervallo di incertezza occorre prestare attenzione alle operazioni tra *floating point* soprattutto in prossimità della radice.

    Ad esempio, le espressioni $f(a)\cdot f(c)$ e $f(c)\cdot f(b)$ hanno una buona probabilità di essere approssimate a zero, dal momento che entrambi gli argomenti convergono a una radice di $f$. Per evitare questa eventualità, è meglio valutare, il prodotto dei segni $\text{sign} f(a) \cdot \text{sign} f(c)$ e così via. (Ecco perché sopra abbiamo implementato la funzione `sign`).

-   Un altro controllo utile è contare il numero di iterazioni dell'algoritmo e stampare un avviso nel caso queste siano troppo grandi (sopra il centinaio). In tal modo ci si accorge se ci sono possibili errori nell'implementazione del ciclo o nelle caratteristiche della funzione $f$.


## Precisione sulle cifre significative

Poiché la precisione richiesta all'algoritmo è passata al programma runtime, abbiamo bisogno di determinare runtime quante cifre significative stampare nel nostro risultato. È facile rendersi conto che il numero di cifre significative è dato da

```c++
int cifre_significative = -log10(precision);
```

Per impostare il numero di cifre significative nella scrittura a video usando `fmtlib.h`, il codice da usare è questo:

```c++
#include "fmtlib.h"

// {0} → value of variable `zero`,
// {1} → value of variable `cifre_significative`.
// We must use a dot '.' before {1}, because we're specifying how many digits
// should be used for the decimal part
fmt::print("x0 = {0:.{1}f}", zero, cifre_significative);
```

Potete installare la libreria `fmtlib` eseguendo questo comando:

<input type="text" value="curl https://ziotom78.github.io/tnds-tomasi-notebooks/install_fmt_library | sh" id="installFmtCommand" readonly="1" size="60"><button onclick='copyFmtInstallationScript("installFmtCommand")'>Copia</button>

e seguite poi le istruzioni fornite a video.

In alternativa, scaricate manualmente lo script [`install_fmt_library`](./install_fmt_library) (click col tasto destro sul link e scegliere «Salva come…») ed avviatelo con `sh install_fmt_library`. Lo script funziona solo sotto Linux e Mac; se usate Windows, scaricate questo [file zip](./fmtlib.zip) nella directory dell'esercizio e decomprimetelo.

Le istruzioni dettagliate sono qui: [index.html#fmtinstall](index.html#fmtinstall).


Se invece usate `cout` e `<iomanip>`:

```c++
cout << "x0 = " << fixed << setprecision(cifre_significative) << zero << endl;
```


# Esercizio 6.3 - Equazioni non risolubili analiticamente (da consegnare) {#esercizio-6.3}

In problemi di meccanica quantistica che verranno studiati nel prossimo anno, ci si può imbattere in equazioni del tipo:
$$
x = \tan x.
$$

È facile rendersi conto che tale equazione ha una soluzione in ciascuno degli intervalli $(n\pi, n\pi + \pi/2)$ con $n = 1, 2, 3\ldots$. Calcolare con una precisione di almeno $10^{-6}$ i valori delle soluzioni per $n = 1\ldots 20$.

**Suggerimento**: riscrivere l'equazione come $\sin x - x \cos x = 0$


# Esercizio 6.4 - Ricerca di zeri di una funzione senza uso del polimorfismo {#esercizio-6.4}

Si provi ad implementare un algoritmo di ricerca degli zeri di una funzione senza utilizzare il polimorfismo. Prendere come spunto le soluzioni indicate nelle trasparenze finali della lezione teorica. Si potrebbe codificare il metodo della bisezione in una funzione che accetti in input una `std::function`, e modellizzare la funzione di cui si vuole cercare lo zero con una funzione lambda.


# Errori comuni

Come di consueto, elenco alcuni errori molto comuni che ho trovato negli anni passati correggendo gli esercizi che gli studenti hanno consegnato all'esame:

-   L'errore più diffuso in assoluto è quello di dimenticarsi di verificare se lo zero stia nell'estremo `a` o nell'estremo `b`. Per esempio, se si richiede di cercare uno zero della funzione

    $$
    f(x) = 3x^2 + 5x - 2
    $$

    nell'intervallo $[-4, -2]$, il programma dovrebbe riportare correttamente che c'è uno zero in $x = 4$, anche se è un punto all'estremità dell'intervallo. (Lo stesso vale ovviamente se si specifica l'intervallo $[-2, 0]$).

-   Un errore un po' più subdolo è quello di non individuare lo zero se si trova esattamente in mezzo all'intervallo: nell'esempio della funzione $f(x)$ vista sopra, il codice di alcuni studenti non trova una soluzione se si specifica l'intervallo $[-3, -1]$, perché lo zero cade esattamente a metà e il codice non si accorge che $f(c) = 0$ quando $c = (a + b)/2$.

-   Il codice di alcuni studenti non si accorge di aver raggiunto la precisione richiesta, e continua ad iterare fino al numero massimo di iterazioni `m_nmax`.

---
title: "Lezione 6: Ricerca di zeri"
author:
- "Leonardo Carminati"
- "Maurizio Tomasi"
date: "A.A. 2024−2025"
lang: it-IT
header-includes: <script src="./fmtinstall.js"></script>
...
