---
title: "Lezione 9: Equazioni differenziali"
author:
- "Leonardo Carminati"
- "Maurizio Tomasi"
date: "A.A. 2021−2022"
lang: it-IT
header-includes: <script src="./fmtinstall.js"></script>
...

[La pagina con la spiegazione originale degli esercizi si trova qui: [labmaster.mi.infn.it/Laboratorio2/labTNDS/lectures_1819/lezione9_1819_vector.html](http://labmaster.mi.infn.it/Laboratorio2/labTNDS/lectures_1819/lezione9_1819_vector.html).]

In questa lezione introdurremo alcuni metodi per la risoluzione di equazioni differenziali ordinarie. Implementeremo la risoluzione numerica di queste equazioni con i metodi di Eulero e di Runge-Kutta.

Per risolvere l'esercizio vedremo come è possibile definire le principali operazioni algebriche per i vector della STL. Questo ci permetterà di realizzare i metodi di integrazione di equazioni differenziali usando una notazione vettoriale, molto simile al formalismo matematico.

# Esercizio 9.0 - Algebra vettoriale {#esercizio-9.0}

Come prima cosa, proviamo a dotare i vector della STL di tutte le funzionalità algebriche che ci possono essere utili, definendo opportunamente gli operatori `+`, `*`, `/`, `+=`. Dal momento che non possiamo modificare gli header files e i files di implementazione della classe `vector`, implementiamo questi operatori come funzioni libere in un header file apposito da includere quando necessario. Potete trovarne un esempio qui.

Provate a scrivere un piccolo codice di test per verificare il corretto funzionamento delle operazioni tra vettori : potreste provate a realizzare un semplice programma che scriva a video le componenti della risultate di due forze (vettori tridimensionali) e le componenti del versore della risultante.

# Esercizio 9.1 - Risoluzione tramite metodo di Eulero {#esercizio-9.1}

Implementare un codice per la risoluzione numerica di un'equazione differenziale descrivente il moto di un oscillatore armonico tramite il metodo di Eulero. Graficare l'andamento della posizione in funzione del tempo al variare del passo di integrazione e confrontare l'errore commesso con la soluzione esatta.

Struttureremo la soluzione del problema in modo simile a quanto fatto nelle precedenti lezioni su ricerca degli zeri e integrazione numerica:

![](http://labmaster.mi.infn.it/Laboratorio2/labTNDS/lectures_1819/figure/EqDiffClassi.png)

-   Definiamo una classe astratta `FunzioneVettorialeBase` con un unico metodo `Eval`, puramente virtuale, che dato un `vector` ed un `double`, rappresentante il tempo, restituisce il valore della derivata prima nel punto e nell'istante considerati.
-   Da questa classe astratta, deriviamo una classe concreta che descriva le leggi del modo di un oscillatore armonico, permettendo di definirne la frequenza, o nel construttore o con degli opportuni metodi per leggere/definire dei parametri.
-   Definiamo una classe astratta `EquazioneDifferenzialeBase` che ha un unico metodo `Passo`, puramente virtuale, che dati il tempo $t$, un vettore $\vec x$, il passo di integrazione $h$ e un puntatore ad una `FunzioneVettorialeBase`, restituisca la una stima di del valore della posizione $\vec x$ al tempo $t + h$. Avere il tempo $t$ come argomento permetterà in esercizi futuri (come ad esempio il [9.4](carminati-esercizi-09.html#esercizio-9.4---oscillazione-forzate-e-risonanza-da-consegnare)) di avere forzanti esterne o parametri dipendenti dal tempo.
-   Da questa classe astratta, deriviamo una classe concreta che implementi il metodo di Eulero. 

Per testare il metodo, risolviamo l'equazione differenziale:

$$
\frac{\mathrm{d}}{\mathrm{d}t} \begin{pmatrix}x\\v\end{pmatrix} =
\begin{pmatrix}v\\-\omega_0^2 x\end{pmatrix},\quad x(0) = 0, \quad v(0) = 1, \quad \omega_0 = 1,
$$


con passi di integrazione da 0.1 a 0.001, mettendo in grafico il valore della $x$ in funzione del tempo $t$ ed anche il suo errore rispetto alla soluzione esatta del problema, che è $x(t) = \sin (t)$. Si consiglia di svolgere l'integrazione per un certo numero di periodi, in modo da vedere se l'ampiezza di oscillazione rimane costante. Integrare fino a $t = 70\,\text{s}$ permette di vedere circa 10 periodi.

## Il metodo di Eulero

Consideriamo la seconda legge della dimanica di Newton

$$
a = \frac{\mathrm{d}^2 x}{\mathrm{d}t^2} = \frac{F}m,
$$

che è un'equazione differenziale del secondo ordine che può essere ridotta ad un'equazione differenziale del prim'ordine introducendo la variabile velocità:

$$
\begin{aligned}
\frac{\mathrm{d} x}{\mathrm{d}t} &= v,
\frac{\mathrm{d} v}{\mathrm{d}t} &= \frac{F}m.
\end{aligned}
$$

Il metodo di Eulero consiste nel calcolare lo stato della soluzione al tempo $t + h$ dato quello ad un tempo $t$ tramite le espressioni:

$$
\begin{aligned}
x(t + h) &= x(t) + h \cdot \dot{x}(t) = x(t) + h \cdot v,\\
v(t + h) &= v(t) + h \cdot \dot{v}(t) = x(t) + h \cdot \frac{F}m.
\end{aligned}
$$

## Struttura del programma

Le classi astratte `FunzioneVettorialeBase` e `EquazioneDifferenzialeBase` contengono (almeno per ora) solo un metodo virtuale puro, rispettivamente `Eval` e `Passo`.

Per comodità possiamo mettere nello stesso file anche le classi concrete che, oltre ad avere l'implementazione dei metodi virtuali dovranno implementare un costruttore ed un distruttore.

L'header file contente le dichiarazioni delle classi è quindi:

```c++
#pragma once

#include "vectorops.h"

using namespace std;

class FunzioneVettorialeBase {
public:
  virtual vector<double> Eval(double t, const vector<double> & x) const = 0;
};

class OscillatoreArmonico : public FunzioneVettorialeBase {
public:
  OscillatoreArmonico(double omega0) : m_omega0(omega0) { }

  override vector<double> Eval(double t, const vector<double> & x) const;

private:
  double m_omega;
};

class EquazioneDifferenzialeBase {
public:
  virtual vector<double> Passo(double t, const vector<double>& x,
                               double h, FunzioneVettorialeBase * f) const = 0;
}; 

class Eulero : public EquazioneDifferenzialeBase {
public:
  override vector<double> Passo(double t, const vector<double> & x,
                                double h, FunzioneVettorialeBase *f) const;
};
```

Una volta implementate le classi (l'implementazione di Eulero è semplicissima se si usano le operazioni di algebra vettoriale), un possibile programma per risolvere l'esercizio è il seguente:

```c++
#include "equazionidifferenziali.h"

#include <iostream>
#include <string>

#include "fmtlib.h"

#include "TApplication.h"
#include "TAxis.h"
#include "TCanvas.h"
#include "TGraph.h"

int main (int argc, char** argv ) {
  if(argc != 2) {
      fmt::print(stderr, "Usage: {} <stepsize>\n", argv[0]);
      return -1;
  }
  
  TApplication myApp{"myApp", 0, 0};

  Eulero myEuler;

  OscillatoreArmonico *osc{new OscillatoreArmonico(1)};
  double tmax{70};

  double h{atof(argv[1])};

  vector<double> x{0., 1.};
  double t{0};

  TGraph *myGraph{new TGraph()};
  int nstep{int(tmax / h + 0.5)};

  for (int step{}; step < nstep; step++) {
      myGraph->SetPoint(step, t, x[0]);
      x = myEuler.Passo(t, x, h, osc);
      t += h;
  }
  
  TCanvas *c = new TCanvas();
  c->cd();
  string title{fmt::format("Oscillatore armonico (Eulero, h = {})", h)};

  myGraph->SetTitle(title.c_str());
  myGraph->GetXaxis()->SetTitle("Tempo [s]1");
  myGraph->GetYaxis()->SetTitle("Posizione x [m]");
  myGraph->Draw("AL");

  myApp.Run();
}
```

Si riveda il solito esempio ([qui](./codici/test_tgraph.cpp)) per l'uso dei `TGraph` di ROOT.

## Cosa ci aspettiamo?

Il metodo di Eulero non è molto preciso; in effetti, con un passo di integrazione modesto si vede come esso possa risultare instabile, mostrando oscillazioni la cui ampiezza varia con il tempo. La figura sotto mostra l'andamento di $x(t)$ con un passo di integrazione di 0.1&nbsp;s:

![](http://labmaster.mi.infn.it/Laboratorio2/labTNDS/lectures_1819/figure/armonico0.1_eulero.png)

Per avere qualcosa di anche solo visivamente accettabile, bisogna andare a passi di almeno 0.0002&nbsp;s:

![](http://labmaster.mi.infn.it/Laboratorio2/labTNDS/lectures_1819/figure/armonico0.0002_eulero.png)

**Caccia all'errore**: presentare due grafici come questi all'esame comporterebbe bocciatura immediata. Perché? (*Suggerimento: nel preparare i grafici per la presentazione ci si deve sempre ricordare di specificare cosa stiamo rappresentando sugli assi!*)

La figura seguente riporta l'errore accumulato dopo 70 s di integrazione per diversi valori del passo:

![](http://labmaster.mi.infn.it/Laboratorio2/labTNDS/lectures_1819/figure/errore_eulero.png)

Si noti come la pendenza della curva sia 1 in una scala log-log, mostrando come l'errore ottenuto sia proporzionale al passo $h$.


## Esercizio 9.2 - Risoluzione tramite Runge-Kutta (da consegnare) {#esercizio-9.2}

Ripetere l'esercizio 9.1 con il metodo di risoluzione di equazioni differenziali di Runge-Kutta (del quarto ordine) e confrontare quindi in condizioni analoghe ($t$ massimo e $h$) la stabilità dei due metodi.

Per svolgere l'esercizio, basterà realizzare una nuova classe concreta a partire da `EquazioneDifferenzialeBase`.

## Il metodo di Runge-Kutta

Il noto metodo di Runge-Kutta è un metodo del quarto ordine ed utilizza la seguente determinazione dell'incremento:

$$
\begin{aligned}
k_1 &= \dot{x}(t, x),\\
k_2 &= \dot{x}\left(t + h / 2, x + k_1 \cdot \frac{h}2\right),\\
k_3 &= \dot{x}\left(t + h / 2, x + k_2 \cdot \frac{h}2\right),\\
k_4 &= \dot{x}\left(t + h, x + k_3 \cdot h\right),\\
x(t+h) &= x(t) + (k_1 + 2k_2 + 2k_3 + k_4)\frac{h}6.
\end{aligned}
$$

## Cosa ci aspettiamo?

Il metodo di Runge-Kutte del quarto ordine è molto più preciso del metodo di Eulero: infatti produce oscillazioni molto stabili anche con un passo di integrazione di 0.1&nbsp;s:

![](http://labmaster.mi.infn.it/Laboratorio2/labTNDS/lectures_1819/figure/armonico0.1_RK4.png)

La figura seguente riporta l'errore accumulato dopo 70&nbsp;s di integrazione per diversi valori del passo:

![](http://labmaster.mi.infn.it/Laboratorio2/labTNDS/lectures_1819/figure/errore_RK4.png)

## Errore in funzione del passo

Si noti come la pendenza della curva nella sua parte iniziale sia 4 in una scala log-log, mostrando come l'errore ottenuto sia proporzionale a $h^4$.

Quando l'errore di troncamento del metodo diventa minore degli errori di arrotondamento della macchina si vede che non c'è più alcun miglioramento nel ridurre il passo, anzi, il maggior numero di calcoli richiesto risulta in un peggioramento globale dell'errore.


# Esercizio 9.3 - Moto del pendolo (da consegnare) {#esercizio-9.3}

Implementare la risoluzione dell'equazione del pendolo usando i metodi precedentemente implementati. Fare quindi un grafico del periodo di oscillazione e verificare che per angoli grandi le oscillazioni non sono più isocrone.

## Il moto del pendolo

L'equazione del pendolo è data dalla relazione

$$
\frac{\mathrm{d}^2\theta}{\mathrm{d}t^2} = -\frac{g}{l}\sin\theta,
$$

dove $g = 9.8\,\text{m/s}^2$ è l'accellerazione di gravità sulla superficie terreste, mentre $l$ è la lunghezza del pendolo.

L'equazione differenziale si può approssimare con quella di un oscillatore armonico per piccole oscillazioni, $\sin\theta\sim\theta$. In tal caso, le oscillazioni risultano isocrone, cioè con periodo indipendente dall'ampiezza delle oscillazioni.

Questa però è solo un'approssimazione, e per grandi oscillazioni bisogna usare l'equazione esatta. Essendo il moto non più armonico, il periodo di oscillazione dipende dall'ampiezza della stessa. La figura illustra il periodo al variare dell'ampiezza per un pendolo con $l = 1\,\text{m}$:

![](http://labmaster.mi.infn.it/Laboratorio2/labTNDS/lectures_1819/figure/periodo_pendoloreale.png)

Si noti come per piccole oscillazioni il periodo sia effettivamente quello atteso dall'approssimazione dell'oscillatore armonico:

$$
T = \frac{2\pi}{\sqrt{\frac{g}l}} \approx 2.007\,\text{s},
$$
ma aumenti significativamente per grandi ampiezze. 

## Calcolo del periodo

In questo caso l'integrazione numerica dell'equazione differenziale non si può effettuare per un tempo predefinito, ma deve essere portata avanti fino a quando non si raggiunge una condizione compatibile con l'aver terminato l'oscillazione.
Una possibile soluzione consiste in:

#.  dare come condizioni iniziali un valore di $\theta$ pari all'ampiezza di oscillazione e velocità angolare iniziale nulla;
#.  portare avanti l'integrazione fino a quando non si nota un cambiamento di segno della velocità angolare;
#.  siccome possiamo calcolare la velocità solo con granularità pari al passo di integrazione, possiamo stimare il passaggio dallo zero interpolando linearmente tra i due ultimi valori della velocità e calcolando quando la retta ottenuta passa per lo zero;
#.  il tempo così calcolato corrisponde al semiperiodo dell'oscillazione. 

Un esempio di pseudo-codice che implementa questo algoritmo è: 

```c++
// condizioni iniziali
double t{};
x.SetComponent(0, -A);
x.SetComponent(1, 0);

// con le condizioni iniziali date, la velocità sarà maggiore
// o uguale a zero fino al punto di inversione del modo
while(x.GetComponent(1) >= 0) {
    v = x.GetComponent(1); // salvo la velocità al passo precedente
    x = myRK4.Passo(t, x, h, osc);
    t += h;
}

// calcolo del passaggio dallo zero utilizzando l'interpolazione
// lineare tra il passo precedente (t - h, v) e quello finale
// (t, x.GetComponent(1))
T = t - v * h / (x.GetComponent(1) - v);

// il periodo è due volte il semi-periodo appena calcolato
T *= 2;
```

N.B.: controllate che la formula per l'interpolazione sia corretta!



# Esercizio 9.4 - Oscillazione forzate e risonanza (da consegnare) {#esercizio-9.4}

Implementare la risoluzione dell'equazione di un oscillatore armonico smorzato con forzante. Fare quindi un grafico della soluzione stazionaria in funzione della frequenza dell'oscillatore, ricostruendo la curva di risonanza.

## Oscillatore armonico con forzante

L'equazione dell'oscillatore armonico smorzato con forzante è data dalla relazione

$$
\frac{\mathrm{d}^2x}{\mathrm{d}t^2} = -\omega_0^2 x + \alpha \dot{x}(t) + \sin(\omega t).
$$

Nell'esercizio proposto, utilizzare i seguenti valori iniziali:
$$
\omega_0 = 10\,\text{rad/s}, \quad \alpha = \frac1{30}\,\text{s}.
$$

È bene ricordare che per determinare l'ampiezza bisogna aspettare che il transiente iniziale delle oscillazioni si esaurisca. Questo avviene con una costante di tempo pari a $1/\alpha$ (ovvero, dopo un tempo $1/\alpha$ l'ampiezza di oscillazione si riduce di un fattore $1/e$). Le seguenti figure illustrano la parte iniziale del transiente per condizioni iniziali $x(0)=0$, $\dot{x}(0) = 0$ e diversi valori di $\omega$:

| Frequenza                   | Andamento                                                                                    |
|-----------------------------|----------------------------------------------------------------------------------------------|
| $5\,\text{rad/s}$  | ![](http://labmaster.mi.infn.it/Laboratorio2/labTNDS/lectures_1819/figure/transiente_05.png) |
| $10\,\text{rad/s}$ | ![](http://labmaster.mi.infn.it/Laboratorio2/labTNDS/lectures_1819/figure/transiente_10.png) |
| $15\,\text{rad/s}$ | ![](http://labmaster.mi.infn.it/Laboratorio2/labTNDS/lectures_1819/figure/transiente_15.png) |

Si consiglia quindi di integrare l'equazione differenziale per un tempo pari ad almeno dieci volte $1/\alpha$, in modo da raggiungere una situazione in cui l'oscillazione è stabile, e poi valutare l'ampiezza. Anche in questo caso si può assumere di aver raggiunto il massimo dell'oscillazione nel momento in cui si trova un punto in cui la velocità cambia di segno.

Una curva di risonanza è illustrata in figura:

![](http://labmaster.mi.infn.it/Laboratorio2/labTNDS/lectures_1819/figure/risonanza.png)


# Esercizio 9.5 - Moto in campo gravitazionale {#esercizio-9.5}

Implementare la risoluzione dell'equazione del moto di un corpo in un campo gravitazionale. Verificare, nel caso del sistema Terra-Sole, che il periodo di rivoluzione della Terra intorno al Sole sia effettivamente di un anno e che l'orbita sia periodica. Calcolare quindi il rapporto tra perielio ed afelio.

Provare ad aggiungere una piccola perturbazione al potenziale gravitazionale (ad esempio un termine proporzionale ad $1/r^3$ nella forza) e verificare che le orbite non sono più chiuse ma formano una rosetta.

## Moto in campo gravitazionale

Nell'implementare il moto di un corpo in un campo gravitazionale utilizzare le seguenti condizioni:

- costante gravitazionale $G = 6.6742\times 10^{-11}\,\text{m}^3\,\text{kg}^{-1}\,\text{s}^{-2}$;
- massa del Sole $M_\odot = 1.98844\times 10^{30}\,\text{kg}$;
- distanza Terra-Sole al perielio $D_p = 1.47098074\times 10^{11}\,\text{m}$;
- velocità al perielio $v_p = 3.0287\times 10^4\,\text{m/s}$.

# Esercizio 9.6 - Moto di una particella carica in un campo elettrico e magnetico uniforme {#esercizio-9.6}

Implementare la risoluzione dell'equazione del moto di una particella carica in un campo elettrico e magnetico uniforme. Disegnare la traiettoria della particella e determinarne il diametro. Se si aggiunge un campo elettrico con componente lungo l'asse $x$ pari a $E_x = 10^4\,\text{V/m}$, in che direzione si muove ora la particella?

## Moto in campo elettrico e magnetico uniformi

Il moto di una particella carica in un campo elettrico e magnetico uniformi risente della forza di Lorentz e pertanto è descritto dall'equazione
$$
m\ddot{x}(t) = q E + q v\times B,
$$
che si può riscrivere in forma matriciale come
$$
\frac{\mathrm{d}}{\mathrm{d}t} \begin{pmatrix}
x\\ y\\ z\\ v_x\\ v_y\\ v_z
\end{pmatrix} =
\begin{pmatrix}
0& 0& 0& 1& 0& 0\\
0& 0& 0& 0& 1& 0\\
0& 0& 0& 0& 0& 1\\
0& 0& 0& 0& \frac{q}m B_z& -\frac{q}m B_y\\
0& 0& 0& -\frac{q}m B_z& 0& \frac{q}m B_x\\
0& 0& 0& \frac{q}m B_y& -\frac{q}m B_x& 0
\end{pmatrix}
\begin{pmatrix}
x\\ y\\ z\\ v_x\\ v_y\\ v_z
\end{pmatrix} +
\begin{pmatrix}
0\\ 0\\ 0\\ \frac{q}m E_x\\ \frac{q}m E_y\\ \frac{q}m E_z
\end{pmatrix}.
$$

Consideriamo il moto nel piano $(x, y)$ di un elettrone in un campo magnetico costante con i seguenti valori:

-   $q = -1.60217653\times 10^{-19}\,\text{C}$;
-   $m = 9.1093826\times10^{-31}\,\text{kg}$;
-   $v_x(0) = 8\times10^6\,\text{m/s}$;
-   $B_z = 5\times10^{-3}\,\text{T}$;
-   tutte le altre componenti di campi e velocità iniziali sono nulle. 

Questi parametri corrispondono grosso modo all'apparato sperimentale per la misura di $e/m$ del laboratorio del II anno.
