---
title: "Lezione 7: Quadratura numerica"
author:
- "Leonardo Carminati"
- "Maurizio Tomasi"
date: "A.A. 2021−2022"
lang: it-IT
header-includes: <script src="./fmtinstall.js"></script>
...

[La pagina con la spiegazione originale degli esercizi si trova qui: [labmaster.mi.infn.it/Laboratorio2/labTNDS/lectures_1819/lezione7_2122.html](http://labmaster.mi.infn.it/Laboratorio2/labTNDS/lectures_1819/lezione7_2122.html).

In questa lezione implementeremo alcuni algoritmi per la quadratura numerica, cioè per il calcolo di integrali definiti di funzioni in un intervallo chiuso e la valutazione dell'errore commesso nel calcolo dell'integrale stesso. Questo si rende necessario quando non sappiamo valutare analiticamente l'integrale in esame, quando non si riesce ad esprimere la primitiva in funzioni elementari, quando la soluzione analitica è molto complicata ed il calcolo numerico è molto più semplice, oppure quando la funzione è conosciuta in un numeri finito di punti.

# Esercizio 7.0 - Integrazione con la formula del mid-point {#esercizio-7.0}

Implementare un codice per il calcolo della funzione $\sin(x)$ su $[0, \pi]$ con il metodo del mid-point, con un numero di passi fissato passato da riga di comando. Per controllare la precisione ottenuta con un numero di passi fissato si richiede di stampare una tabella con la differenza tra il risultato numerico ed il valore esatto analitico in funzione del numero di passi (o della lunghezza del passo $h$).

In aggiunta alla tabella, si può rappresentare l'andamento dell'errore in funzione della lunghezza del passo $h$ con un `TGraph` di ROOT (una traccia su come visualizzare i dati usando un TGraph di ROOT si può trovare [qui](./codici/test_tgraph.cpp)).

## Il metodo del mid-point

Ricordiamo che in questo metodo l'approssimazione dell'integrale è definita dalla formula

$$
\int_a^b f(x)\,\mathrm{d}x = h \cdot \bigl(f(x_0) + f(x_1) + \ldots + f(x_{N - 1})\bigl),\quad h = \frac{b - a}N, \quad x_k = a + \left(k + \frac12\right) h,
$$

che fornisce un'accuratezza dell'integrale di $O(h^2)$. Notate che questo metodo non richiede il calcolo della funzione negli estremi di integrazione.

## Cenni sull'implementazione

L'algoritmo può essere implementato in molti modi; una possibilità (non certo l'unica) sfrutta lo schema *classe madre astratta*/*classe derivata*. Qui vediamo l'esempio di un possibile header, in cui viene dichiarata una classe astratta `Integral` che rappresenta un generico algoritmo di integrazione. Il metodo privato `checkInterval` prende in ingresso gli estremi di integrazione e controlla il segno. La classe implementa (tra le varie cose) un metodo `integrate`, che si preoccupa di chiamare `checkInterval` e poi invoca il metodo virtuale puro `calculate`; esso accetta in input il numero di passi con cui si desira effettuare il calcolo e una referenza alla funzione da integrare. Il metodo di integrazione `Midpoint` viene concretamente implementato in una classe derivata sovrascrivendo il metodo `integrate`.

```c++
#pragma once

#include "funzioni.h"

class Integral {
public:
  Integral() : m_a{}, m_b{}, m_sign{} {}

  double integrate(double a, double b, unsigned int nstep, FunzioneBase &f) {
    checkInterval(a, b);
    return calculate(nstep, f);
  }

  double getA() const { return m_a; }
  double getB() const { return m_b; }
  double getSign() const { return m_sign; }

private:
  // Questa è la funzione da ridefinire con `override` nelle classi derivate
  // Si può ridefinire nelle classi base anche se è `private`
  virtual double calculate(unsigned int nstep, FunzioneBase &f) = 0;

  void checkInterval(double a, double b) {
    m_a = std::min(a, b);
    m_b = std::max(a, b);
    m_sign = (a < b) ? 1 : -1;
  }

  double m_a, m_b;
  double m_sign;
};

// Classe derivata, implementa il metodo mid-point
class Midpoint : public Integral {
public:
  Midpoint() : Integral() {}

private:
  double calculate(unsigned int nstep, FunzioneBase &f) override {
    // Attenzione, questa implementazione ha un errore!
    
    double h{(getB() - getA()) / nstep};
    double sum{};

    for (unsigned int i{1}; i < nstep; i++) {
      sum += f.Eval(getA() + (i + 0.5) * h);
    }

    return getSign() * sum * h;
  }
};
```

Notate in che modo il codice implementa il calcolo: il metodo pubblico è `Integral::integrate`, che **non** è virtuale: esso si preoccupa di invocare `Integral::checkInterval` (privato) per verificare gli estremi di integrazione, e poi invoca il metodo privato `Integral::calculate` che fa il conto vero e proprio:

```c++
double integrate(double a, double b, unsigned int nstep, FunzioneBase &f) {
  checkInterval(a, b);
  return calculate(nstep, f);
}
```

In questo modo il metodo `calculate` può usare gli estremi restituiti da `getA()`/`getB()` e il segno restituito da `getSign()` senza doversi preoccupare del caso $a < b$. Se vi stupisce che il metodo `calculate`, pur essendo dichiarato `private`, possa essere ridefinito nella classe derivata `Midpoint`, considerate che `private` indica chi può **chiamare** il metodo (solo la classe `Integrate` e non le sue derivate), ma non pone restrizioni su chi possa **ridefinirlo**.

**Caccia all'errore**: l'implementazione contiene un errore. Per metterlo in evidenza, provate ad integrare $f(x) = \sin x$ tra $\pi / 2$ e $\pi$: vedrete che la convergenza non è $O(h^2)$, ma solo $O(h)$. (Potete vedere l'errore anche confrontando i risultati del programma con i numeri riportati nel [notebook Julia](tomasi-lezione-07-quadratura-numerica.html)). Se applicate correttamente l'algoritmo, dovete riscontrare il comportamento atteso.

Viene ora fornito un codice per verificare il funzionamento di quanto implementato finora, che usa la libreria `fmtlib`. Come al solito, potete installarla usando lo script [`install_fmt_library.sh`](./install_fmt_library.sh): scaricatelo nella directory dell'esercizio ed eseguitelo, oppure eseguite direttamente questo comando:

<input type="text" value="curl https://ziotom78.github.io/tnds-tomasi-notebooks/install_fmt_library.sh | sh" id="installFmtCommand" readonly="1" size="60"><button onclick='copyFmtInstallationScript("installFmtCommand")'>Copia</button> 

In alternativa, scaricate questo [file zip](./fmtlib.zip) nella directory dell'esercizio e decomprimetelo, poi aggiungete il file `format.cc` nella riga in cui compilate l'eseguibile.

Ecco il codice di esempio:

```c++
#include <iostream>
#include <cmath>
#include <iomanip>

#include "fmtlib.h"
#include "funzioni.h"
#include "integrale.h"

using namespace std;

int main(int argc, const char * argv[]) {
  if(argc != 2) {
      cerr << "Usage : ./esercizio7.0 nstep" << endl;

      return 1;
  }
  
  double a{};
  double b{M_PI};

  int nstep{atoi(argv[1])};

  Seno mysin{};
  Midpoint midpoint{};

  fmt::print("midpoint: {:.12f}\n", midpoint.integrate(a, b, nstep, mysin));
  fmt::print("Simpson : {:.12f}\n", integrator->Simpson(a, b, nstep, mysin));
  
  // Senza usare fmtlib.h:
  // cout << setprecision(12) << midpoint.integrate(a, b, nstep, mysin) << endl;
  // cout << setprecision(12) << midpoint.integrate(a, b, nstep, mysin) << endl;
}
```

dove abbiamo utilizzato una classe `Seno` che eredita dalla classe astratta `FunzioneBase`.

# Esercizio 7.1 - Integrazione alla Simpson (da consegnare) {#esercizio-7.1}

Implementare l'integrazione con il metodo di Simpson con un numero di passi definito (è possibile farlo all'interno della classe già precedentemente costruita aggiungendo nuovi metodi e, se necessario, costruttori). Come nell'[Esercizio 7.0](#esercizio-7.0), stampare una tabella (o costruire un `TGraph` di ROOT) con la precisione raggiunta in funzione del numero di passi.

## Il metodo Simpson

Nel metodo di integrazione alla Simpson, la funzione integranda è approssimata, negli intervalli $[x_k, x_{k + 2}]$ (dove $k$ è un intero pari e $x_k = a + k h$) con un polinomio di secondo grado i cui nodi sono nei punti $\bigl(x_k, f(x_k)\bigr)$, $\bigl(x_{k + 1}, f(x_{k + 1})\bigr)$, $\bigl(x_{k + 2}, f(x_{k + 2})\bigr)$. Esso fornisce una valutazione dell'integrale con una precisione pari a $h^4$.
La sua applicazione richiede che il numero di passi sia pari e la formula che approssima l'integrale è

$$
\int_a^b f(x)\,\mathrm{d}x = h \cdot \left(
\frac13 f(x_o) + \frac43 f(x_1) + \frac23 f(x_2) + \frac43 f(x_3) + \ldots
+ \frac23 f(x_{N - 2}) + \frac43 f(x_{N - 1}) + \frac13 f(x_N)\bigl)
\right),
$$

dove vale che

$$
h = \frac{b - a}N, \quad x_k = a + k h.
$$


# Esercizio 7.2 - Integrazione con la formula dei trapezi con precisione fissata (da consegnare) {#esercizio-7.2}

Implementare l'integrazione della funzione $\sin(x)$ su $[0, \pi]$ con il metodo dei trapezi e con precisione fissata all'interno della classe definita in precedenza. Occorrerà definire un costruttore che prenda in ingresso gli estremi di integrazione e la precisione desiderata passata dalla riga di comando.

## Stima runtime dell'errore

Come possiamo fare a stimare l'errore che stiamo commettendo nel calcolo di un integrale se non conosciamo il valore vero $I$ dell'integrale? Partendo dalla conoscenza dell'andamento teorico dell'errore in funzione del passo $h$, possiamo trovare un modo semplice per la stima dell'errore che stiamo commettendo. Nel caso della regola dei trapezi, l'adamento dell'errore è $\epsilon = k h^2$. Calcolando l'integrale $I_N$ utilizzando un passo $h$ e successivamente l'intgrale $I_{2N}$ con un passo $h/2$, possiamo scrivere il seguente sistema di equazioni:
$$
\begin{cases}
I - I_N = k h^2,
I - I_{2N} = k\left(\frac{h}2\right)^2.
\end{cases}
$$

Sottraendo la prima equazione alla seconda, si ricava che una stima dell'errore è pari a
$$
\epsilon(N) = \frac43 \left|I_{2N} - I_N\right|.
$$

## Cenni sull'implementazione

La condizione di uscita dell'algoritmo è basata sul confronto del risultato di due passaggi successivi. Se la differenza della stima dell'integrale tra due passaggi consecutivi è più piccola della precisione richiesta allora l'algoritmo si ferma. Questo poichè l'integrale calcolato con una partizione più fine è sempre una stima migliore dell'approssimazione con la partizione originaria. Calcoliamo la prima approssimazione:

```c++
sum0 = (f[a] + f[b]) / 2;
I0 = sum0 * (b - a);
```

Al primo passaggio dell'algoritmo suddividiamo l'intervallo in due:

```c++
sum1 = sum0 + f[x11]; 
I1 = sum1 * (b - a) / 2;
```

e così secondo lo schema in figura:

![](http://labmaster.mi.infn.it/Laboratorio2/labTNDS/lectures_1819/figure/intervallo.png)

```c++
sum2 = sum1 + f[x21] + f[x22];
I2 = sum2 * (b - a) / 4;

sum3 = sum2 + f[x31] + f[x32] + f[x33] + f[x34];
I3 = sum3 * (b - a) / 8;
```

I valori dell'ultima approssimazione dell'integrale e dell'ultima somma calcolata sono memorizzati all'interno dell'oggetto. In questo modo, se è necessario ricalcolare l'integrale raddoppiando i passi, come nel caso della formula che usa $I_N$ e $I_{2N}$, non è necessario ricominciare da capo.
