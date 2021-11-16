---
title: "Lezione 8: Quadratura numerica"
author:
- "Leonardo Carminati"
- "Maurizio Tomasi"
date: "A.A. 2021−2022"
lang: it-IT
header-includes: <script src="./fmtinstall.js"></script>
...

[La pagina con la spiegazione originale degli esercizi si trova qui: [labmaster.mi.infn.it/Laboratorio2/labTNDS/lectures_1819/lezione8_1819.html](http://labmaster.mi.infn.it/Laboratorio2/labTNDS/lectures_1819/lezione8_1819.html).]

In questa lezione implementeremo alcuni algoritmi per la quadratura numerica, cioè per il calcolo di integrali definiti di funzioni in un intervallo chiuso e la valutazione dell'errore commesso nel calcolo dell'integrale stesso. Questo si rende necessario quando non sappiamo valutare analiticamente l'integrale in esame, quando non si riesce ad esprimere la primitiva in funzioni elementari, quando la soluzione analitica è molto complicata ed il calcolo numerico è molto più semplice, oppure quando la funzione è conosciuta in un numeri finito di punti.

# Esercizio 8.0 - Integrazione con la formula del mid-point {#esercizio-8.0}

Implementare un codice per il calcolo della funzione $\sin(x)$ su $[0, \pi]$ con il metodo del mid-point, con un numero di passi fissato passato da riga di comando. Per controllare la precisione ottenuta con un numero di passi fissato si richiede di stampare una tabella con la differenza tra il risultato numerico ed il valore esatto analitico in funzione del numero di passi (o della lunghezza del passo $h$).

In aggiunta alla tabella, si può rappresentare l'andamento dell'errore in funzione della lunghezza del passo $h$ con un `TGraph` di ROOT (una traccia su come visualizzare i dati usando un TGraph di ROOT si può trovare [qui](./codici/test_tgraph.cpp)).

## Il metodo del mid-point

Ricordiamo che in questo metodo l'approssimazione dell'integrale è definita dalla formula

$$
\int_a^b f(x)\,\mathrm{d}x = \bigl(f(x_0) + f(x_1) + \ldots + f(x_{N - 1})\bigl),\quad h = \frac{b - a}N, \quad x_k = a + \left(k + \frac12\right) h,
$$

che fornisce un'accuratezza dell'integrale di $O(h^2)$. Notate che questo metodo non richiede il calcolo della funzione negli estremi di integrazione.

## Cenni sull'implementazione

L'algoritmo è implementato all'interno di una classe che inizializza le variabili necessarie all'algoritmo. Qui ne vediamo l'esempio di un possibile *header*. Il costruttore prende in ingresso gli estremi di integrazione ed il numero di passi richiesto per eseguire l'integrale. Sono già dichiarati i metodi di integrazione del mid-point e di Simpson. Al costruttore è passata la funzione integranda usando la classe `FunzioneBase` definita nelle lezioni precedenti.

```c++
#pragma once

#include "funzioni.h"

class Integral {
public:
  Integral(double a, double b, const FunzioneBase * f);
  double Midpoint(unsigned int nstep);
  double Simpson(unsigned int nstep);
  
private:
  double m_a, m_b;
  double m_sum;
  double m_h;
  int m_sign;

  double m_integral;
  const FunzioneBase * m_f;
};
```

La classe invece è così implementata:

```c++
#include "integrale.h"
#include <algorithm>

using namespace std;

Integral::Integral(double a, double b, const FunzioneBase * f) :
    m_a{min(a, b)}, m_b{max(a, b)}, m_f{f} {
  // Assegna a `m_sign` il valore 1 se a > b, −1 altrimenti
  m_sign = a > b ? 1 : -1;
}

double Integral::Midpoint(unsigned int nstep) {
  m_h = (m_b - m_a) / nstep;
  m_sum = 0;

  for (unsigned int i{}; i < nstep; i++) {
      m_sum += m_f->Eval(m_a + (i + 0.5) * m_h);
  }
  m_integral = m_sign*m_sum*m_h;

  return m_integral;
}
```

dove gli estremi di integrazione vengono controllati, messi in ordine e viene poi implementato il metodo del mid-point secondo la formula appropriata.

**Caccia all'errore**: l'implementazione contiene un errore. Per metterlo in evidenza, provate ad integrare $f(x) = \sin x$ tra $\pi / 2$ e $\pi$: vedrete che la convergenza non è $O(h^2)$, ma solo $O(h)$. Se applicate correttamente l'algoritmo, dovete riscontrare il comportamento atteso.

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
      cerr << "Usage : ./esercizio8.0 nstep" << endl;

      return -1;
  }
  
  double a{};
  double b{M_PI};

  int nstep{atoi(argv[1])};

  Seno * mysin{new Seno()};
  Integral * integrator{new Integral(a, b, mysin)};

  fmt::print("midpoint: {:.12f}\n", integrator->Midpoint(nstep));
  fmt::print("Simpson : {:.12f}\n", integrator->Simpson(nstep));
  
  // Senza usare fmtlib.h:
  // cout << setprecision(12) << integrator->Midpoint(nstep) << endl;
  // cout << setprecision(12) << integrator->Simpson(nstep) << endl;
}
```

dove abbiamo utilizzato una classe `Seno` che eredita dalla classe astratta `FunzioneBase`.

# Esercizio 8.1 - Integrazione alla Simpson (da consegnare) {#esercizio-8.1}

Implementare l'integrazione con il metodo di Simpson con un numero di passi definito (è possibile farlo all'interno della classe già precedentemente costruita aggiungendo nuovi metodi e, se necessario, costruttori). Come nell'[Esercizio 8.0](#esercizio-8.0), stampare una tabella (o costruire un `TGraph` di ROOT) con la precisione raggiunta in funzione del numero di passi.

## Il metodo Simpson

Nel metodo di integrazione alla Simpson, la funzione integranda è approssimata, negli intervalli $[x_k, x_{k + 2}]$ (dove $k$ è un intero pari e $x_k = a + k h$) con un polinomio di secondo grado i cui nodi sono nei punti $\bigl(x_k, f(x_k)\bigr)$, $\bigl(x_{k + 1}, f(x_{k + 1})\bigr)$, $\bigl(x_{k + 2}, f(x_{k + 2})\bigr)$. Esso fornisce una valutazione dell'integrale con una precisione pari a $h^4$.
La sua applicazione richiede che il numero di passi sia pari e la formula che approssima l'integrale è

$$
\int_a^b f(x)\,\mathrm{d}x = h \cdot \left(
\frac13 f(x_o) + \frac43 f(x_1) + \frac23 f(x_2) + \frac43 f(x_3) + \ldots
+ \frac23 f(x_{N - 2}) + \frac43 f(x_{N - 1}) + \frac13 f(x_N)\bigl)
\right), \quad h = \frac{b - a}N, \quad x_k = a + k h.
$$


# Esercizio 8.2 - Integrazione con la formula dei trapezi con precisione fissata (da consegnare) {#esercizio-8.2}

Implementare l'integrazione della funzione $\sin(x)$ su $[0, \pi]$ con il metodo dei trapezi e con precisione fissata all'interno della classe definita in precedenza. Occorrerà definire un costruttore che prenda in ingresso gli estremi di integrazione e la precisione desiderata passata dalla riga di comando.

## Stima runtime dell'errore

Come possiamo fare a stimare l'errore che stiamo commettendo nel calcolo di un integrale se non conosciamo il valore vero I dell'integrale? Partendo dalla conoscenza dell'andamento teorico dell'errore in funzione del passo h possiamo trovare un modo semplice per la stima dell'errore che stiamo commettendo. Nel caso della regola dei trapezi, l'adamento dell'errore è $\epsilon = k h^2$. Calcolando l'integrale $I_N$ utilizzando un passo $h$ e successivamente l'intgrale $I_{2N}$ con un passo $h/2$ possiamo scrivere il seguente sistema di equazioni:
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

La condizione di uscita dell'algoritmo è basata sul confronto del risultato di due passaggi successivi. Se la differenza della stima dell'integrale tra due passaggi consecutivi è più piccola della precisione richiesta allora l'algoritmo si ferma. Questo poichè l'integrale calcolato con una partizione più fine è sempre una stima migliore dell'approssimazione con la partizione originaria.
Nel costruttore calcoliamo la prima approssimazione:

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

I valori dell'ultima approssimazione dell'integrale e dell'ultima somma calcolata sono memorizzati all'interno dell'oggetto. In questo modo, se viene richiesto di ricalcolare l'integrale, non è necessario ricominciare da capo.
