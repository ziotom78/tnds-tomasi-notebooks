#include "fmtlib.h"
#include "posizione.h"

#include <cstdlib>
#include <iostream>

using namespace std;

// Questo programma vuole com input da riga di comando le coordinate
// x, y e z di un punto e ne restituisce le coordinate sferiche
// e cilindiriche.

int main(int argc, const char *argv[]) {

  // Controlla gli argomenti
  if (argc != 4) {
    fmt::print(stderr, "Usage: {} <x> <y> <z>\n", argv[0]);
    return 1;
  }

  double x{atof(argv[1])};
  double y{atof(argv[2])};
  double z{atof(argv[3])};

  // Crea un oggetto posizione ed accede ai vari metodi

  Posizione P{x, y, z};

  fmt::print("Coordinate cartesiane: [x = {}, y = {}, z = {}]\n", P.getX(),
             P.getY(), P.getZ());
  fmt::print("Coordinate cilindriche: [ρ = {}, φ = {}, z = {}]\n", P.getRho(),
             P.getPhi(), P.getZ());
  fmt::print("Coordinate sferiche: [R = {}, φ = {}, θ = {}]\n", P.getR(),
             P.getPhi(), P.getTheta());
}
