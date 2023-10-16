---
title: "Lezione 4"
author:
- "Leonardo Carminati"
- "Maurizio Tomasi"
date: "A.A. 2023−2024"
lang: it-IT
...

[La pagina con la spiegazione originale degli esercizi si trova qui: <https://labtnds.docs.cern.ch/Lezione4/Lezione4/>.]

In questa lezione non ci sono esercizi da consegnare per l'esame. Vi
proponiamo alcuni temi specifici che si possono affrontare con gli
strumenti che abbiamo sviluppato sinora: l'analisi dei dati raccolti
in un tipico esperimento del laboratorio di fisica (esperimento di
Millikan e misura del rapporto $q/m$ per l'elettrone) e un semplice
problema di riordinamento, per fare qualche esercizio con gli
strumenti della STL.

# Esercizio 4.0 — Misura del rapporto $q/m$ per l'elettrone (analisi dati)  {#esercizio-4.0}

Un esperimento molto interessante che si svolge nel laboratorio di
fisica riguarda la misura del rapporto tra la carica e la massa di un
elettrone. Un fascio di elettroni di energia nota (determinata dal
potenziale $2\Delta V$ applicato ai capi di un condensatore) viene
deflesso da un campo magnetico opportunamente generato. Dalla misura
del raggio di deflessione $r$ si può ricavare una stima del rapporto
$q/m$. La misura in laboratorio è piuttosto complessa a causa degli
effetti sistematici sperimentali, ma il rapporto $q/m$ può essere
determinato sfruttando la relazione \[ (r B)^2 = \frac{m}q\,2\Delta V,
\] perché il rapporto è legato al coefficiente angolare della
relazione.

Nel file di dati sono riportate le misure prese in laboratorio: nella
prima colonna il valore di $2\Delta V$, nella seconda colonna il
valore di $(r B)^2$ e nella terza l'errore sulla determinazione di $(r
B)^2$. Provate a scrivere un codice che pemetta di visualizzare i dati
raccolti e determinare il rapporto $q/m$ ( in questo caso l'oggetto di
ROOT più indicato è
[TGraphErrors](https://labtnds.docs.cern.ch/Survival/root/).

-   Il file di dati si chiama
    [`data_millikan.dat`](https://labtnds.docs.cern.ch/Lezione4/data_millikan.dat).

-   Potete provare a scrivere il codice da soli. In caso potete
    prendere ispirazione dall'esempio qui sotto.

## Esempio di codice

```c++
#include <cmath>
#include <fstream>
#include <iostream>
#include <vector>

#include "TApplication.h"
#include "TAxis.h"
#include "TF1.h"
#include "TGraphErrors.h"
#include "TLegend.h"

using namespace std;

void ParseFile(string filename, vector<double> &myx, vector<double> &myy,
               vector<double> &myerry) {

  ifstream fin{filename.c_str()};

  double x, y, err;

  if (!fin) {
    cerr << "Cannot open file " << filename << endl;
    exit(1);
  }

  while (fin >> x >> y >> err) {
    myx.push_back(x);
    myy.push_back(y);
    myerry.push_back(err);
  }

  fin.close();
}

TGraphErrors DoPlot(vector<double> myx, vector<double> myy,
                    vector<double> myerry) {

  TGraphErrors mygraph;

  for (int k{}; k < (int) myx.size(); k++) {
    mygraph.SetPoint(k, myx[k], myy[k]);
    mygraph.SetPointError(k, 0, myerry[k]);
  }

  return mygraph;
}

int main() {

  TApplication app{"MyApp", 0, 0};

  vector<double> myx{};
  vector<double> myy{};
  vector<double> myerry{};

  // read data from file

  ParseFile("data_eom.dat", myx, myy, myerry);

  // create TGraphErrors

  TGraphErrors mygraph = DoPlot(myx, myy, myerry);

  // fit the TGraphErrors ( linear fit )

  TF1 *myfun = new TF1("fitfun", "[0]*x+[1]", 0, 1000);
  mygraph.Fit(myfun);
  double moe = myfun->GetParameter(0);
  double error = sqrt(pow(1. / moe, 4) * pow(myfun->GetParError(0), 2));

  cout << "Valore di e/m dal fit = " << 1. / moe << "+/-" << error << endl;
  cout << "Valore del chi2 del fit = " << myfun->GetChisquare() << endl;
  cout << "          prob del chi2 = " << myfun->GetProb() << endl;

  // customise the plot, cosmetics

  mygraph.Draw("AP");
  mygraph.SetMarkerStyle(20);
  mygraph.SetMarkerSize(1);
  mygraph.SetTitle("Misura e/m");
  mygraph.GetXaxis()->SetTitle("2#DeltaV (V)");
  mygraph.GetYaxis()->SetTitle("(B_{z}R)^{2} (T^{2}m^{2} )");
  TLegend leg(0.15, 0.7, 0.3, 0.85);
  leg.AddEntry(&mygraph, "data", "p");
  leg.AddEntry(myfun, "fit", "l");
  leg.Draw("same");

  app.Run();

  return 0;
}
```    

# Esercizio 4.1 — Misura della carica dell'elettrone (anslisi dati)  {#esercizio-4.1}

La carica dell'elettrone è stata misurata per la prima volta nel 1909
in uno storico esperimento dal fisico statunitense Robert Millikan.
Questo esperimento si effettua anche nel laboratorio di fisica e
consiste nel misurare la velocità di caduta o risalita di goccioline
d'olio elettrizzate per strofinio in una regione con campo elettrico
regolabile. Nel file di dati sono riportare le misure di carica
elettrica ($Q_i$) per un certo numero di goccioline osservate. Il
valore della carica può essere determinato come il minimo della
funzione
\[
S(q) = \sum \left[\frac{Q_i}{k_i} - q\right]^2,
\]
dove $k_i$ è il numero intero più vicino al rapporto $Q_i / q$.
Provate a scrivere un codice per rappresentare la funzione e
determinare il valore della carica dell'elettrone.

-   Il file di dati si chiama
    [`data_eom.dat`](https://labtnds.docs.cern.ch/Lezione4/data_eom.dat).
-   Potete provare a scrivere il codice da soli. In caso potete
    prendere ispirazione dall'esempio qui sotto.


## Esempio di codice

```c++
#include <cmath>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <vector>

#include "TApplication.h"
#include "TAxis.h"
#include "TCanvas.h"
#include "TF1.h"
#include "TGraph.h"
#include "TH1F.h"

using namespace std;

// ===========================================================
// Read data from file and store them in a vector
// ===========================================================

vector<double> ParseFile(string filename) {
  ifstream fin{filename.c_str()};

  vector<double> v;
  double val;

  if (!fin) {
    cerr << "Cannot open file " << filename << endl;
    exit(1);
  }

  while (fin >> val)
    v.push_back(val);

  fin.close();
  return v;
}

// ===========================================================
// Compute S(q)
// ===========================================================

double fun(double q, vector<double> params) {
  double sum{};
  
  for (int k{}; k < (int) params.size(); k++)
    sum += pow(q - params[k] / (round(params[k] / q)), 2);
  
  return sum;
}

// ===========================================================
// Compute qmin
// ===========================================================

double deriv(double qmin, vector<double> params) {
  double sum{};
  for (int k{}; k < (int) params.size(); k++)
    sum += (params[k] / round(params[k] / qmin));
  return sum / params.size();
}

// ===========================================================
// This can be used to actually minimse S(q)
// ===========================================================

/*
double funROOT (double * q , double * params) {
  double sum{};
  for (int k{} ; k < 64; k++)
    sum += pow(q[0] - params[k] / (round(params[k] / q[0])), 2);
  return sum;
}
*/

// ===========================================================
// This code estimates the best value of qe from a set of
// measurements (drop charges)
// ===========================================================

int main() {
  TApplication app{0, 0, 0};

  // read charges from file

  vector<double> charges{ParseFile("data_millikan.dat")};

  // show charges distribution

  TCanvas can1{};
  can1.cd();
  TH1F histo{"cariche", "Charges distribution", 100, 0, 20e-19};
  for (int i{}; i < (int) charges.size(); i++) {
	cout << charges[i] << endl;
    histo.Fill(charges[i]);
  }
  histo.Draw();
  histo.GetXaxis()->SetTitle("Charge [C]");

  TGraph g{};
  int counter{0};
  double qmin{0};
  double sqmin{DBL_MAX};

  for (double value{1.4e-19}; value < 1.8e-19; value += 0.001e-19) {
    g.SetPoint(counter, value, fun(value, charges));
    if (fun(value, charges) < sqmin) {
      sqmin = fun(value, charges);
      qmin = value;
    }
    counter++;
  }

  cout << "Found approximate minimum at q = " << qmin << endl;

  TCanvas can2{};
  can2.cd();
  g.Draw("ALP");
  g.SetMarkerStyle(20);
  g.SetMarkerSize(0.5);
  g.SetTitle("Best charge value");
  g.GetXaxis()->SetTitle("Charge (C)");
  g.GetYaxis()->SetTitle("S(q) (C^{2})");

  /*
  TF1 myfun( "charge",funROOT,1.5e-19 , 1.7E-19, 64);
  for ( int k{}; k < 64; k++ ) myfun.SetParameter(k, charges[k]);
  cout << myfun.GetMinimumX() << endl ;
  */

  double mycharge{deriv(qmin, charges)};
  double uncer{
	sqrt(fun(mycharge, charges) / (charges.size() * (charges.size() - 1)))};
  cout << "Measured charge = " << mycharge << " ± " << uncer << "(stat only)"
       << endl;

  app.Run();
}
```    

# Esercizio 4.2 — Determinazione del cammino minimo (approfondimento uso STL)  {#esercizio-4.2}

In questo esercizio possiamo provare ad approfondire l'uso di
contenitori e algoritmi della STL. Proviamo ad affrontare questo
problema: dato un set di punti nel piano cerchiamo il percorso che ci
permette (partendo dall'origine) di toccare tutti i punti percorrendo
la minor distanza possibile. Le coordinate dei punti si trovano in un
file. Eventualmente cercate di produrre un grafico del percorso
effettuato.

-   Il file di dati è
    [data_points.dat](https://labtnds.docs.cern.ch/Lezione4/data_points.dat)

-   Potete provare a scrivere il codice da soli. In caso potete
    prendere ispirazione dall'esempio qui sotto che implementa un
    algoritmo in stile *brute force* (nel codice si può anche trovare
    un esempio di overloading di `operator<<`, utile per semplificare
    la lettura da file).


## Esempio di codice
  
```c++
#include "TApplication.h"
#include "TAxis.h"
#include "TGraph.h"
#include <algorithm>
#include <cmath>
#include <fstream>
#include <iostream>
#include <string>
#include <vector>

using namespace std;

// implementazione di una classe posizione

class Posizione {
public:
  Posizione() : m_x{}, m_y{}, m_z{} {}

  Posizione(double x, double y, double z) : m_x{x}, m_y{y}, m_z{z} {}

  friend std::istream &operator>>(std::istream &is, Posizione &p) {
    string temp;
	
    getline(is, temp, ',');
    p.m_x = stod(temp);
	
    getline(is, temp, ',');
    p.m_y = stod(temp);
	
    getline(is, temp, '\n');
    p.m_z = stod(temp);
	
    return is;
  }

  double getDistance() const {
    return sqrt(m_x * m_x + m_y * m_y + m_z * m_z);
  }

  double GetX() const { return m_x; }
  double GetY() const { return m_y; }
  double GetZ() const { return m_z; }

  double getDistance(Posizione p) const {
    double dx{p.GetX() - m_x};
	double dy{p.GetY() - m_y};
	double dz{p.GetZ() - m_z};
    return sqrt(dx * dx + dy * dy + dz * dz);
  }

  bool operator<(const Posizione &b) const {
    return (getDistance() > b.getDistance());
  }

  void printPositions() {
    cout << "Posizione : x = " << m_x << " y = " << m_y << " z = " << m_z
         << endl;
  }

private:
  double m_x, m_y, m_z;
};

// algoritmo di riordinamento dei vettore di punti

template <typename T> void findBestPath(T start, T end) {

  Posizione ref{};
  for (auto it{start}; it != end; it++) {
    sort(it, end, [&](Posizione i, Posizione j) {
      return i.getDistance(ref) < j.getDistance(ref);
    });
    ref = *it;
  }
}

// main

int main() {
  TApplication app{"myapp", 0, 0};

  string filename{"data_points.dat"};
  ifstream f{filename};

  if (!f) {
	cerr << "Cannot open file " << filename << endl;
	exit(1);
  }
  
  vector<Posizione> vp{};

  Posizione p{};
  while (f.good()) {
    f >> p;
    vp.push_back(p);
  }

  for (auto it{vp.begin()}; it != vp.end(); it++)
    it->printPositions();

  findBestPath<vector<Posizione>::iterator>(vp.begin(), vp.end());

  for (auto it{vp.begin()}; it != vp.end(); it++)
    it->printPositions();

  TGraph mygraph{};
  mygraph.SetPoint(0, 0, 0);
  int counter{1};
  for (auto it{vp.begin()}; it != vp.end(); it++) {
    mygraph.SetPoint(counter, (*it).GetX(), (*it).GetY());
    counter++;
  }

  mygraph.GetXaxis()->SetLimits(-10, 10);
  mygraph.SetMinimum(-10);
  mygraph.SetMaximum(10);
  mygraph.GetXaxis()->SetTitle("X");
  mygraph.GetYaxis()->SetTitle("Y");
  mygraph.SetTitle("Percorso");
  mygraph.SetMarkerStyle(21);
  mygraph.SetMarkerSize(1);
  mygraph.SetLineColor(6);
  mygraph.Draw("ALP");

  app.Run();
}
```
