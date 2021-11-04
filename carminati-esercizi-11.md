---
title: "Lezione 12: Metodi Monte Carlo"
author:
- "Leonardo Carminati"
- "Maurizio Tomasi"
date: "A.A. 2021−2022"
lang: it-IT
header-includes: <script src="./fmtinstall.js"></script>
...

[La pagina con la spiegazione originale dell'esercizio si trova qui: [labmaster.mi.infn.it/Laboratorio2/labTNDS/lectures_1819/lezione11_1819.html](http://labmaster.mi.infn.it/Laboratorio2/labTNDS/lectures_1819/lezione11_1819.html)]

In questa lezione vedremo una applicazione delle tecniche Monte Carlo per la simulazione di una delle esperienze dei laboratori di fisica.

# Esercizio 11.0 - Simulazione dell'esperienza dello spettrometro a prisma (da consegnare) {#esercizio-11.0}

La dipendenza dell'indice di rifrazione dalla lunghezza d'onda della luce incidente viene descritta dalla legge di Cauchy:

$$
n(\lambda) = \sqrt{A + \frac{B}{\lambda^2}}.
$$

L'esperienza dello spettrometro a prisma si propone di misurare l'indice di rifrazione del materiale di un prisma per le diverse lunghezze d'onda di una lampada al mercurio onde determinare i parametri A e B che caratterizzano tale materiale.

L'apparato sperimentale consiste in un goniometro sul quale viene posizionato il prisma. Una lampada a vapori di mercurio viene posizioneta da un lato del canocchiale con due collimatori per produrre un fascio luminoso che incide sul prisma. Il fascio di luce riflesso o rifratto viene osservato tramite un altro canocchiale. Gli angoli corrispondeni all'orientamento del supporto sul goniometro ed alla posizione dei canocchiali sono leggibili su di un nonio.

![](http://labmaster.mi.infn.it/Laboratorio2/labTNDS/lectures_1819/figure/SchemaPrisma.png)

La nostra simulazione consiste nell'assumere dei valori verosimili dei parametri della legge di Cauchy, vedere come questi si traducono in quantità osservabili e stimare se la nostra procedura di misura e di analisi dei dati ci permette di derivare correttamente i valori utilizzati come ingresso nella simulazione e con quale incertezza.

Nell'esperimento l'unico tipo di grandezze misurate sono gli angoli, per cui possiamo assumere un'incertezza uguale per tutte le misure angolari e pari a $\sigma_\theta = 0.3\,\text{mrad}$.

Nell'esperienza di laboratorio, l'angolo di apertura del prisma $\alpha = 60^\circ$ ed il materiale del prisma ha valori dei parametri di Cauchy $A = 2.7$, $B=6 \times 10^4\,\text{nm}^2$. Consideriamo le due lunghezze d'onda estreme della lampada al mercurio, il giallo, $\lambda_1 = 579.1\,\text{nm}$, ed il viola, $\lambda_2 = 404.7\,\text{nm}$.

La misura sperimentale consiste nella determinazione:

#.  dell'angolo $\theta_0$ corrispondente al fascio non deflesso in assenza del prisma;
#.  dell'angolo $\theta_m(\lambda_1)$ corrispondente alla deviazione minima della riga del giallo;
#.  dell'angolo $\theta_m(\lambda_2)$ corrispondente alla deviazione minima della riga del viola.

L'analisi dati consiste nella seguente procedura:

#.  determinazione degli angoli di deviazione minima:

    $$
    \begin{aligned}
    \delta_m(\lambda_1) &= \theta_m(\lambda_1) - \theta_0,\\
    \delta_m(\lambda_2) &= \theta_m(\lambda_2) - \theta_0.\\
    \end{aligned}
    $$
    
#.  calcolo degli indici di rifrazione $n(\lambda)$ dalla relazione

    $$
    n(\lambda) = \frac{\sin\frac{\delta_m(\lambda) + \alpha}2}{\sin\frac\alpha2}.
    $$

#.  calcolo dei parametri A e B dalle formule

    $$
    \begin{aligned}
    A &= \frac{\lambda_2^2 n^2(\lambda_2) - \lambda_1^2 n^2(\lambda_1)}{\lambda_2^2 - \lambda_1^2},\\
    B &= \frac{n^2(\lambda_2) - n^2(\lambda_1)}{\frac1{\lambda_2^2} - \frac1{\lambda_1^2}}.
    \end{aligned}
    $$

## Parte I

Costruire una classe `EsperimentoPrisma` con le seguenti caratteristiche:

-   come data membri deve avere sia i valori veri che i valori misurati di tutte le quantità ed in più un generatore di numeri casuali `RandomGen` (vedi [lezione 8](carminati-esercizi-10.html#esercizio-10.0---generatore-di-numeri-casuali-da-consegnare));

-   nel costruttore deve definire tutti i valori *di ingresso* delle quantità misurabili a partire dai parametri $A$, $B$, $\alpha$ e dalle lunghezze d'onda;

    N.B.: il valore di $\theta_0$ è arbitrario, ma, una volta definito, i $\theta_m$ sono fissati.
    
-   un metodo Esegui() che effettua la misura sperimentale e determina dei valori misurati di $\theta_0$, $\theta_m(\lambda_1)$, $\theta_m (\lambda_2)$;

    N.B.: il valore misurato di un angolo si ottiene estraendo un numero distribuito in maniera gaussiana intorno al suo valore di ingresso nella simulazione e deviazione standard $\sigma_\theta$.
    
-   i metodi necessari per accedere ai valori dei data membri, sia di ingresso che misurati..

Scrivere un programma che esegua 10000 volte l'esperimento, faccia un istogramma dei valori misurati, e calcoli media e deviazione standard di tali valori.

N.B.: Per il calcolo di medie e varianze potete decidere di immagazzinare i dati in un contenitore (`std::vector` o `Vettore`) e utilizzare le funzioni sviluppate nelle prime lezioni, oppure accedervi direttamente dagli istogrammi di ROOT come mostrato [qui](http://labmaster.mi.infn.it/Laboratorio2/labTNDS/lectures_1819/lezioneROOT_1819.html#testoROOT_a2) ma ricordandosi di aggiungere `histo.StatOverflows(kTRUE);` in modo da forzare l'utilizzo di eventuali underflow e overflow per calcoli statistici.

## Parte II

Aggiungere alla classe un metodo `Analizza()` che faccia i calcoli relativi all'analisi dati ed estendere il programma in modo da eseguire l'analisi dati dei 10000 esperimenti e fare istogrammi di:

#.  differenza tra i valori misurati e quelli attesi di $\delta m(\lambda_1)$$ e $\delta m(\lambda_2)$, quello bidimensionale delle differenze per le due lunghezze d'onda, e calcolare il coefficiente di correlazione.
#.  differenza tra i valori misurati e quelli attesi di $n(\lambda_1)$ e $n(\lambda_2)$, quello bidimensionale delle differenze per le due lunghezze d'onda, e calcolare il coefficiente di correlazione.
#.  differenza tra i valori misurati e quelli attesi di $A$ e $B$, quello bidimensionale delle differenze, e calcolare il coefficiente di correlazione. 

In tutti i casi, se possibile, confrontate il risultato della simulazione con quello ottenuto dalla propagazione degli errori.

## La classe EsperimentoPrisma

La classe `EsperimentoPrisma` deve contenere al suo interno un generatore di numeri casuali per la simulazione del processo di misura, tutti i parametri che definiscono l'esperimento e, per le quantità misurate, sia il valore assunto nella simulazione, che il valore ottenuto dal processo di esecuzione ed analisi dati dell'esperimento.

Il suo header file, potrà pertanto essere del tipo:

```c++
#pragma once

#include "randomgen.h"

class EsperimentoPrisma {
public:
  EsperimentoPrisma();
  ~EsperimentoPrisma();
  void Esegui();
  void Analizza();
  
private:
  // generatore di numeri casuali
  RandomGen m_rgen;
  
  // parametri dell'apparato sperimentale
  double m_lambdal, m_lambda2, m_alpha, m_sigmat;
  
  // valori delle quantita' misurabili :
  // _input    : valori assunti come ipotesi nella simulazione
  // _misurato : valore dopo la simulazione di misura
  double m_A_input, m_A_misurato;
  double m_B_input, m_B_misurato;
  double m_n1_input, m_n1_misurato;
  double m_n2_input, m_n2_misurato;
  double m_th0_input, m_th0_misurato;
  double m_thl_input, m_thl_misurato;
  double m_th2_input, m_th2_misurato;
};
```

N.B.: in questo header mancano i metodi `Get…` per accedere ai data membri.

La configurazione dell'esperimento, con il calcolo di tutti i valori assunti per le quantità misurabili, può venire fatta nel costruttore di default della classe, che in questo caso risulta più complicato del solito:

```c++
EsperimentoPrisma: :EsperimentoPrisma() :
  m_rgen{1},
  m_lambdal{579.1e-9},
  m_lambda2{404.7e-9},
  m_alpha{60 * M_PI / 180},
  m_sigmat{0.3e-3},
  m_A_input{2.7},
  m_B_input{60000E-18}
{
  // calcolo degli indici di rifrazione attesi
  
  m_nl_input = sqrt(m_A_input + m_B_input / (m_lambdal * m_lambdal));
  m_n2_input = sqrt(m_A_input + m_B_input / (m_lambda2 * m_lambda2));
  
  // theta0 è arbitrario, scelgo M_PI/2.
  m_th0_input = M_P1 / 2;
  
  // determino thetal e theta2
  double dm;
  dm = 2 * asin(m_nl_input * sin(0.5 * m_alpha)) - m_alpha;
  m_th1_input = m_th0_input + dm;
  dm = 2 * asin(m_n2_input * sin(0.5 * m_alpha)) - m_alpha;
  m_th2_input = m_th0_input + dm;
}
```

Notate l'uso della lista di inizializzazione nel costruttore: questa permette di inizializzare direttamente i valori dei data membri anziché procedere all'assegnazione dei valori nel costruttore dopo che i data membri siano stati costruiti. Nel nostro caso particolare diventa utile per inizializzare l'oggetto `m_rgen` invocando il costruttore opportuno (altrimenti avrebbe usato il costruttore senza argomenti, che nel nostro caso non esiste). Potete trovare una buona spiegazione dell'utilizzo delle liste di inizializzazione [qui](https://www.learncpp.com/cpp-tutorial/8-5a-constructor-member-initializer-lists/), ma erano state già spiegate durante le [esercitazioni](tomasi-lezione-04.html#inizializzazione-di-variabili-membro).

## Istrogrammi bidimensionali

Per verificare le correlazioni tra due variabili, è utile utilizzare istogrammi bidimensionali, in cui i canali sono definiti da range di valori sia di una variabile che dell'altra.

Per costruire questi istogrammi, si può usare la classe `TH2F` di ROOT.
Questa ha un costruttore che premette di dividere in canali sia la coordinata $x$ che la $y$ dell'istogramma:

```c++
TH2F::TH2F(char * nome, char * titolo,
           int canali_x, double xmin, double xmax,
           int canali_y, double ymin, double ymax);
```

La classe `TH2F` ha gli stessi metodi `Fill` e `Draw` della classe `TH1F`; l'unica differenza è che ora `Fill` ha bisogno della coppia completa di valori per decidere il canale in cui viene collocato l'evento:

```c++
TH2F::Fill(double x, double y);
```

## Calcolo del coefficiente di correlazione

Il coefficiente di correlazione $\rho(x, y)$ tra due variabili $x$ e $y$, può venire espresso come
$$
\rho(x, y) = \frac{\left<x y\right> - \left<x\right>\left<y\right>}{\sigma_x\cdot\sigma_y}.
$$
Si noti che dalla relazione:
$$
\sigma_x^2 = \left<x^2\right> - \left<x\right>^2
$$
risulta che può essere più conveniente nel ciclo di esperimenti calcolare le sommatorie di $x$, $y$, $x^2$, $y^2$ e $x\cdot y$, ed al termine del ciclo effettuare le medie e trovare incertezze e correlazioni. Il tutto non richiede strettamente di immagazinare tutti i dati dei 10000 esperimenti.

## Risultati attesi

Nella seguente tabella sono riportati i valori numerici attesi per le varie quantità ed i grafici ottenuti per una simulazione. Si noti come le varie quantità sono fortemente correlate.

<table>
<thead>
<tr>
<td width="25%">Parametri</td>
<td width="75%">Grafici</td>
</tr>
</thead>
<tbody>
<tr>
<td>
$$
\begin{aligned}
\theta_0 &= 1.5708\quad\text{(arbitrario)},\\
\theta_1 &= 2.5494,\\
\theta_2 &= 2.6567,\\
\sigma(\theta_i) &= 0.0003,\quad i = 0, 1, 2.
\end{aligned}
$$
</td>
<td>
![](http://labmaster.mi.infn.it/Laboratorio2/labTNDS/lectures_1819/figure/delta.png)
</td>
</tr>
<tr>
<td>
$$
\begin{aligned}
\delta_{m, 1} &= 0.97860\,\text{rad}\\
\delta_{m, 2} &= 1.08594\,\text{rad}\\
\sigma(\delta_{m, i}) &= 0.00043\,\text{rad},\\
\rho(\delta_{m, 1}, \delta_{m, 2}) &= 50\,\%
\end{aligned}
$$
</td>
<td>
![](http://labmaster.mi.infn.it/Laboratorio2/labTNDS/lectures_1819/figure/nrifr.png)
</td>
</tr>
<tr>
<td>
$$
\begin{aligned}
n_1 &= 1.69674\\
\sigma(n_1) &= 0.00022\\
n_2 &= 1.75110\\
\sigma(n_2) &= 0.00021\\
\rho(n_1, n_2) &= 50\,\%.
\end{aligned}
$$
</td>
<td>
![](http://labmaster.mi.infn.it/Laboratorio2/labTNDS/lectures_1819/figure/AB.png)
</td>
</tr>
<tr>
<td>
$$
\begin{aligned}
A &= 2.70002\\
\sigma(A) &= 0.0013\\
B &= 60000\,\text{nm}^2\\
\sigma(B) &= 240\,\text{nm}^2\\
\rho(A,B) &= -87\,\%.
\end{aligned}
$$
</td>
<td>
![](http://labmaster.mi.infn.it/Laboratorio2/labTNDS/lectures_1819/figure/AB.png)
</td>
</tr>
</tbody>
</table>


# Esercizio 11.1 - Attrito viscoso (facoltativo) {#esercizio-11.1}

Svolgere il tema d'esame sulla simulazione di un esperimento per la misura della viscosità di un materiale: [preappello del gennaio 2009, esercizio 6](http://labmaster.mi.infn.it/Laboratorio2/Compiti/Compito_lab2_pre09_6.pdf).
