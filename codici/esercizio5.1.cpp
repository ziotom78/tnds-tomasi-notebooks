#include "fmtlib.h"
#include "particella.h"
#include <iostream>

using namespace std;

int main() {
  Particella *a{new Particella{1., 1.6E-19}};
  Elettrone *e{new Elettrone{}};

  // Metodi della classe base
  fmt::print("Particella con massa {} e carica {}\n", a->GetMassa(),
             a->GetCarica());
  a->Print();

  // Metodi della classe derivata
  fmt::print("Elettrone con massa {} e carica {}\n", e->GetMassa(),
             e->GetCarica());
  e->Print();

  Particella b{*a}; // costruisco una Particella a partire da una Particella
  Particella d{*e}; // costruisco una Particella a partire da un Elettrone
  Elettrone f{d};   // costruisco un Elettrone a partire da una Particella
}
