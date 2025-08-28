#include "posizione.h"

#include <cstdlib>
#include <cstdio>
#include <print>

using namespace std;

// Questo programma vuole com input da riga di comando le coordinate
// x, y e z di un punto e ne restituisce le coordinate sferiche
// e cilindiriche.

int main(int argc, const char *argv[]) {

  // Controlla gli argomenti
  if (argc != 4) {
    println(stderr, "Usage: {} <x> <y> <z>", argv[0]);
    return 1;
  }

  double x{atof(argv[1])};
  double y{atof(argv[2])};
  double z{atof(argv[3])};

  // Crea un oggetto posizione ed accede ai vari metodi

  Posizione P{x, y, z};

  println("Coordinate cartesiane: [x = {}, y = {}, z = {}]", P.getX(),
             P.getY(), P.getZ());
  println("Coordinate cilindriche: [ρ = {}, φ = {}, z = {}]", P.getRho(),
             P.getPhi(), P.getZ());
  println("Coordinate sferiche: [R = {}, φ = {}, θ = {}]", P.getR(),
             P.getPhi(), P.getTheta());
}
