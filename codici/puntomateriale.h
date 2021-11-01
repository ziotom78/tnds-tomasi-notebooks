#pragma once

#include "particella.h"
#include "posizione.h"

#include "campovettoriale.h"

class PuntoMateriale : public Particella, Posizione {

public:
  PuntoMateriale(double massa, double carica, const Posizione &);
  PuntoMateriale(double massa, double carica, double x, double y, double z);
  ~PuntoMateriale();

  CampoVettoriale CampoElettrico(const Posizione &) const;
  CampoVettoriale CampoGravitazionale(const Posizione &) const;
};
