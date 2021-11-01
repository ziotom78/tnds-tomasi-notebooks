---
title: "Lezione 6: Ricerca di zeri"
author:
- "Leonardo Carminati"
- "Maurizio Tomasi"
date: "A.A. 2021−2022"
lang: it-IT
...

[La pagina con la spiegazione originale degli esercizi si trova qui: [labmaster.mi.infn.it/Laboratorio2/labTNDS/lectures_1819/lezione7_1819.html](http://labmaster.mi.infn.it/Laboratorio2/labTNDS/lectures_1819/lezione7_1819.html).]

In questa settima lezione affronteremo il problema della ricerca di zeri di una funzione. Per fare questo realizzeremo due classi astratte per rappresentare rispettivamente una generica funzione di una variabile, ed un metodo generico per la ricerca di zeri.

# Esercizio 7.0 - Metodi virtuali {#esercizio-7.0}

Considerare le classi `Particella` e la sue derivata `Elettrone` costruite nelle lezioni 4 e 5.

Implementare ed eseguite il seguente programma:

```c++
int main() {
  Particella *a{new Particella{1., 2.}};
  Elettrone  *e{new Elettrone{}};
  Particella *b{new Elettrone{}}; // puntatore a Particella punta a un Elettrone

  a->Print(); // metodo Print di Particella
  e->Print(); // metodo Print di Elettrone
  b->Print(); // ???

  delete a;
  delete b;
  delete e;
}
```

Si dovrebbe vedere che viene invocato il metodo `Print()` della classe madre, anche quando gli oggetti riferiti dai puntatori sono classi figlie.

Aggiungete ora negli *header file* della classe `Particella` il qualificatore `virtual` davanti alla dichiarazione del metodo `Print`, e aggiungere `override` nella classe `Elettrone`:

```c++
// Nella classe Particella:
virtual void Print() const;

// Nella classe Elettrone
override void Print() const;
```

[Il testo originale suggerisce: aggiungere ora negli header file delle classi il qualificatore `virtual` davanti alla dichiarazione del metodo `Print()`. Questo compila, ma non è più buona pratica col C++11].

Ricompilando e rigirando il programma si dovrebbe adesso vedere che per ciascun oggetto viene invocato il metodo corrispondente alla sua vera classe.

## Parola chiave virtual

La parola chiave `virtual` informa il compilatore che il metodo indicato potrà venire sovrascritto dalle classi figlie. Se essa viene fornita, durante l'esecuzione del programma, al momento di chiamare il metodo a partire da un puntatore alla classe madre, il programma valuterà se l'oggetto indirizzato è del tipo classe madre o una delle figlie. In quest'ultimo caso, invocherà il metodo appropriato della classe figlia reale.

Nelle classi figlie, se si ridefinisce un metodo che la classe madre aveva dichiarato `virtual`, occorre specificare `override` (=“sovrascrivi”).

Un metodo virtuale può anche essere posto a 0 (vedi prossimo esercizio), in tal caso è obbligatorio per le classi figlie implementarlo.


# Esercizio 7.1 - Classe astratta FunzioneBase {#esercizio-7.1}

In questo e nei prossimi esercizi avremo a che fare con diverse funzioni $y = f(x)$ di una sola variabile, magari dipendenti da parametri, e di effettuare delle operazioni generiche su queste funzioni (come trovarne gli zeri, o farne l'integrale).

In questo caso è utile definire una classe astratta che definisce le proprietà generali della classe, con metodi puramente virtuali, e poi lasciare alle classi derivate il compito di implementare tutti questi metodi e quelli aggiuntivi necessari.

#.  Definire la classe astratta FunzioneBase:

    ```c++
    // Classe astratta per una generica funzione
    class FunzioneBase {
    public:
        virtual double Eval(double x) const = 0;
    };
    ```

#.  Implementare una classe derivata `Parabola` che descriva una funzione del tipo $f(x) = a x^2 + b x + c$ (chiaramente questa classe dovrà avere i data membri per i parameteri $a$, $b$ e $c$, ed i metodi per definirli e accederci).

#.  Verificare il funzionamento della classe `Parabola` costruendo un programmino che, dati i parametri di una parabola, ne stampi il valore della $y$ nel vertice $x_v = -b / 2a$.


## Classi astratte

Quando dichiariamo nullo un metodo `virtual`, la classe difetta dell'implementazione di tale metodo, e quindi non si possono creare oggetti di quella classe. Solo le sue classi derivate implementeranno il metodo, e possono essere implementate. Siccome non si possono costruire oggetti di tale classe, non è necessario definire dei costruttori.

Se una classe astratta implementa solo metodi virtuali nulli, come in questo caso, non è neanche necessario realizzare un file di implementazione, né creare un file oggetto, dato che tutta l'informazione è contenuta nell'header.

## La classe Parabola

Questa è una possibile dichiarazione per la classe `Parabola`:

```c++
class Parabola : public FunzioneBase {
public:
  Parabola();
  Parabola(double a, double b, double c);
  ~Parabola();
  
  override double Eval(double x) const {
      return m_a*x*x+m_b*x+m_c;
  }
  
  void SetA(double a) { m_a = a; }
  void SetB(double b) { m_b = b; }
  void SetC(double c) { m_c = c; }
  
  double GetA() const { return m_a; }
  double GetB() const { return m_b; }
  double GetC() const { return m_c; }
  
private:
  double m_a, m_b, m_c;
};
```


# Esercizio 7.2 - Metodo della bisezione (da consegnare) {#esercizio-7.2}

Scrivere un programma che calcoli gli zeri della funzione
$$
f(x) = 3x^2 + 5x - 2.
$$

Il programma legge da riga di comando gli estremi dell'intervallo in cui cercare lo zero e la precisione richiesta.
Per calcolare gli zeri, implementare una classe astratta `Solutore` ed una classe concreta che realizza uno dei due metodi visti a lezione: quello della bisezione o quello della secante.
Si richiede obbligatoriamente che il programma stampi l'ascissa dello zero con un numero di cifre significative corrispondente alla precisione immessa.

## Il metodo della bisezione

Data una funzione $f(x)$, si dice zero, o radice, di $f$ un elemento $x_0$ del suo dominio tale che $f(x_0) = 0$.

Ci proponiamo di trovare gli zeri della funzione $f(x) = x^2 - 2$ utilizzando il metodo di bisezione. È l'algoritmo più semplice: consiste in una procedura iterativa che, ad ogni ciclo, dimezza l'intervallo in cui si trova lo zero.

Dal teorema di Bolzano (o degli zeri) sappiamo che, data una funzione $f$ continua sull'intervallo chiuso $[a,b]$ a valori reali tale che $f(a) \cdot f(b) < 0$, allora esiste un punto $x_0 \in [a, b]$ tale che $f(x_0) = 0$.

Definiamo intervallo di incertezza di $f$ un intervallo $[a,b]$ che soddisfa il Teorema di Bolzano. L'idea di base dell'algoritmo è che se esiste un intervallo di incertezza $[a,b]$ per una funzione $f$, allora ne esiste uno più piccolo (esattamente la metà).

L'algoritmo deve avere in input l'intervallo di incertezza di partenza $[a,b]$ ed una precisione (o tolleranza) $\epsilon$ con cui si vuole trovare lo zero di $f$ tale che $\left|b - a\right| < \epsilon$.

Si parte quindi dividendo in due l'intervallo trovando il punto medio $c = a + (b - a)/2$ per cui avremo due intervalli $[a,c]$ e $[c,b]$.
Ora, se $f(c) = 0$ siamo fortunati e abbiamo trovato lo zero;
altrimenti si deve valutare $f(a) \cdot f(c)$ e $f(c) \cdot f(b)$, e ripetere la procedura sull'intervallo in cui $f$ cambia di segno.
La procedura va ripetuta finchè la larghezza dell'intervallo finale non è minore di $\epsilon$.

Ci sono alcuni caveat:

-   Se l'intervallo contiene più di una radice il metodo della bisezione ne troverà solo una.

-   Nell'implementazione delle condizioni di ricerca dall'intervallo di incertezza occorre prestare attenzione alle operazioni tra floating point soprattutto in prossimità della radice.

    Ad esempio, le espressioni $f(a)\cdot f(c)$ e $f(c)\cdot f(b)$ hanno una buona probabilità di essere approssimate a zero, dal momento che entrambi gli argomenti convergono a una radice di $f$. Per evitare questa eventualità, è meglio valutare, il prodotto dei segni $\text{sign} f(a) \cdot \text{sign} f(c)$ e così via.
    
-   Un altro controllo utile è contare il numero di iterazioni dell'algoritmo e stampare un avviso nel caso queste siano troppo grandi (sopra il centinaio). In tal modo ci si accorge se ci sono possibili problemi nel ciclo (errori o richiesta di precisione troppo alta)

## Precisione sulle cifre significative

Poiché la precisione richiesta all'algoritmo è passata al programma runtime, abbiamo bisogno di determinare runtime quante cifre significative stampare nel nostro risultato. È facile rendersi conto che il numero di cifre significative è dato da

```c++
int cifre_significative = -log10(precision);
```

Per cui per impostare il numero di cifre significative nella scrittura a video il codice sarà

```c++
cout << "x = " << fixed << setprecision(cifre_significative) << zero << endl;
```

oppure, se usate la libreria `fmt`:

```c++
// {0} → zero, {1} → cifre_significative
fmt::print("x0 = {0:{1}f}", zero, cifre_significative);
```


## La funzione segno

La funzione `sign(x)` non è codificata nelle cstdlib, poiché l'informazione sul segno è già contenuta nella variabile di tipo `int`, `float`, `double`. [Nel C++11 è però disponibile la funzione `std::copysign`, definita in `<cmath>`, che copia il segno di una variabile `double` in un valore. Si può quindi usare questa definizione:]

```c++
double sign(double x) {
    // Questa chiamata a copysign ritorna ±1.0 a seconda
    // del segno di x
    return x != 0 ? std::copysign(1.0, x) : 0.0;
}
```

[Notare che la funzione restituisce zero se `x` è zero].

Una semplice implementazione della funzione segno è

```c++
int sign(double x){
  if(x < 0)
      return -1;
  else if (x > 0)
     return 1;

  return 0;
}
```

[Anche questa funzione restituisce zero se `x` è zero].

Una implementazione molto più compatta [però meno leggibile] è

```c++
double sign(double x){
  return (x == 0. ? 0. : (x > 0 ? 1. : -1));
};
```

Usando una qualsiasi di queste funzioni, la condizione richiesta dall'algoritmo di bisezione sarà

```c++
double sign_a{sign(f(a))};
double sign_b{sign(f(b))};
double sign_c{sign(f(c))};

// Verificare se sign_a, sign_b, o sign_c sono nulli: in quel
// caso abbiamo già trovato lo zero!
// ...

if(sign_a * sign_c < 0) {
    // ...
} else if(sign_b * sign_c < 0) {
    // ...
} else {
    // ...
}
```


## Classe astratta Solutore

#.  La classe astratta Solutore potrebbe avere un metodo virtuale, corrispondente alla chiamate dell'algoritmo che cercherà di determinare gli zeri di una generica `FunzioneBase`, passata come puntatore.
#.  Inoltre possiamo definire dei metodi per configurare la precisione richiesta: tale precisione può essere definita nel costruttore, tramite un metodo dedicato o direttamente nella chiamata al metodo CercaZeri. Lo stesso discorso vale per il numero massimo di iterazioni.
#.  Secondo il principio dell'incapsulamento possiamo anche copiare il puntatore a FunzioneBase in un puntatore interno alla classe m_f;
#.  Infine, in vista di potenziali sviluppi, possiamo definire dei data membri che contengono lo stato corrente dell'intervallo in cui si sono limitati gli zeri della funzione.

    ```c++
    class Solutore {
    public:
      virtual double CercaZeri(double xmin, double xmax, const FunzioneBase * f) = 0;
      void SetPrecisione(double epsilon) { m_prec = epsilon; }
      double GetPrecisione() const { return m_prec;}

    protected:
      double m_a, m_b; // estremi della regione di ricerca
      double m_prec; // precisione della soluzione
      const FunzioneBase * m_f;
    };
    ```

    L'implementazione dell'algoritmo di bisezione dovrà necessariamente avvenire costruendo una classe dedicata Bisezione che erediti da `Solutore` e implementi una versione concreta del metodo `CercaZeri`. 

    ```c++
    class Bisezione : public Solutore {
    public:
      Bisezione();
      ~Bisezione();
      override double CercaZeri(double xmin, double xmax, const FunzioneBase * f);
    };
    ```


# Esercizio 7.3 - Equazioni non risolubili analiticamente (da consegnare) {#esercizio-7.3}

In problemi di meccanica quantistica che verranno studiati nel prossimo anno, ci si può imbattere in equazioni del tipo:
$$
x = \tan x.
$$

È facile rendersi conto che tale equazione ha una soluzione in ciascuno degli intervalli $(n\pi, n\pi + \pi/2)$ con $n = 1, 2, 3\ldots$. Calcolare con una precisione di almeno $10^{-6}$ i valori delle soluzioni per $n = 1\ldots 20$.

Suggerimento: riscrivere l'equazione come $\sin x - x \cos x = 0$

# Esercizio 7.4 - Miglioramenti di Solutore {#esercizio-7.4}

Aggiungere a Solutore due nuovi metodi virtuali:

```c++
virtual bool Trovato() = 0;
virtual double Incertezza() = 0;
```

Il primo dovrà restituire vero o falso a seconda che lo zero sia stato effettivamente trovato o meno. Ad esempio se un algoritmo non riesce a convergere per via delle cattive condizioni iniziali, `Trovato()` dovrà restituire `false`.

Il secondo dovrà restituire l'incertezza effettiva sull'ascissa dello zero stimato, che di solito è migliore del minimo requisito sulla precisione immagazzinato in `_prec`.

Implementare questi metodi nelle classi concrete usate per gli altri esercizi di questa lezione.
